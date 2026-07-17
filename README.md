# Frozen Verilog: Rocket, BOOM, XiangShan

Pre-elaborated RTL for three RISC-V cores, so experiments can start from Verilog
instead of waiting on a Chisel/FIRRTL build every time.

Every config is checked two ways. **Lint:** `verilator --lint-only` on the flat
file reports **0 errors** — on Verilator 5.049 (Linux, where it was generated)
and again on 5.046 (macOS, from the committed files). **Simulation:** every
Rocket and BOOM config boots and passes 14/14 RISC-V ISA tests, and XiangShan
runs CoreMark and microbench to completion with every instruction checked against
NEMU. See [Simulation](#simulation). RTL that both lints and runs is a much
stronger guarantee than "it elaborated".

## What's here

| Design | Config | Top | Modules (flat) | ISA tests | Notes |
|---|---|---|---|---|---|
| Rocket | `RocketConfig` | `ChipTop` | 432 | 14/14 | dual-core RV64GC |
| Rocket | `TinyRocketConfig` | `ChipTop` | 278 | 14/14 | smallest Rocket |
| BOOM | `SmallBoomV4Config` | `ChipTop` | 595 | 14/14 | BOOM **v4** (+2 patches) |
| BOOM | `MediumBoomV4Config` | `ChipTop` | 598 | 14/14 | BOOM **v4** (+2 patches) |
| BOOM | `LargeBoomV4Config` | `ChipTop` | 628 | 14/14 | BOOM **v4** (+2 patches) |
| BOOM | `LargeBoomV3Config` | `ChipTop` | 615 | 14/14 | BOOM **v3**, kept because much prior work targets v3 |
| XiangShan | `MinimalConfig` | `XSTop` | 1911 | see note | FPGA-platform top; not runnable standalone |
| XiangShan | `DefaultConfig` | `XSTop` | 2009 | see note | full Kunminghu-class core |
| XiangShan | `MinimalConfig` (SimTop) | `SimTop` | — | CoreMark + microbench | in `xiangshan-simtop/`; **this is the one that runs** |

### Provenance

| | Rocket / BOOM | XiangShan |
|---|---|---|
| Source | [chipyard](https://github.com/ucb-bar/chipyard) **1.14.0** (`0acc1e1d`) | [XiangShan](https://github.com/OpenXiangShan/XiangShan) master `7bf51a88` (2026-07-16) |
| Chisel | 6.7.0 (Scala 2.13.16) | 7.3.0 |
| firtool | CIRCT **1.75.0** (chipyard's pin) | CIRCT **1.135.0** (resolved from Chisel 7.3.0) |
| Build | `make verilog CONFIG=<cfg>` | `make verilog CONFIG=<cfg>` (`FPGATOP=top.TopMain`) |

Exact versions, commits and flags are repeated per config in `manifest.json`.

## Layout

```
<design>/<Config>/
  rtl/                 as-generated sources (--split-verilog), one module per file
  flat/<Config>.flat.sv   everything concatenated into one file
  meta/                FIRRTL (.fir.gz), device tree (.dts), annotations, regmaps
  *.f                  the generator's own filelists
  manifest.json        versions, commits, toolchain, caveats

xiangshan-simtop/MinimalConfig/     <- the XiangShan variant that RUNS
  rtl/                 2024 sources for SimTop (core + difftest + sim MMIO/flash)
  filelist.f, DifftestMacros.svh
  manifest.json        includes the CoreMark verification evidence
```

`xiangshan-simtop/` has no `flat/`: SimTop imports DPI functions (`xs_assert_v2`,
`DifftestFlash`, …) that difftest's C++ provides, so a flat file can't lint or run
standalone anyway. Drive it with [sim/xs_simtop_verify.pbs](sim/xs_simtop_verify.pbs),
which copies `rtl/` into XiangShan's build tree and runs `make emu` **without
re-running Chisel** (verified: `chisel_runMain_invocations=0`).

Use `flat/` for a quick standalone run; use `rtl/` when you want to touch
individual modules.

```bash
verilator --lint-only --timing --top-module ChipTop rocket/RocketConfig/flat/RocketConfig.flat.sv

gunzip -k xiangshan/DefaultConfig/flat/DefaultConfig.flat.sv.gz
ulimit -s 65520   # see below
verilator --lint-only --timing --top-module XSTop xiangshan/DefaultConfig/flat/DefaultConfig.flat.sv
```

**Raise the stack limit for XiangShan.** The flat XiangShan files are ~105/161 MB
and Verilator's parser recurses deeply enough to blow the default 8 MB stack on
macOS, dying with `Verilator internal fault, sorry` (SIGSEGV) rather than a real
error. `ulimit -s 65520` fixes it. Linux is usually fine because Verilator's
wrapper script already does `ulimit -s unlimited`. The Rocket/BOOM files are
small enough not to care.

## Read this before using the filelists

Both generators emit filelists that are **incomplete**. Both bugs were caught by
linting, and `flat/` already works around them — but they matter if you compile
from `rtl/` yourself.

- **Chipyard**: `<long_name>.top.f` does **not** list the behavioral SRAM models,
  which firtool puts in `gen-collateral/<long_name>.top.mems.v`. Compiling `top.f`
  alone leaves `*_ext` modules undefined (`mem_ext`,
  `rockettile_dcache_data_arrays_0_ext`, …). Use **`sim_files.common.f`**, or add
  `top.mems.v` yourself. (`.model.mems.v` is empty for these configs.)
- **XiangShan**: `filelist.f` omits `ClockGate.sv` and all 22 `DiffExt*.v`. The
  `DiffExt*` modules *are* instantiated, by the `DummyDPICWrapper_*` modules that
  `filelist.f` does list. Compile all of `rtl/` rather than trusting `filelist.f`.

## Caveats

- **SRAMs are behavioral models** (Chipyard `*_ext` in `top.mems.v`; XiangShan
  `ram_*.sv`). Good for simulation and formal; they are not PDK macros, so this
  is not synthesis-ready without replacing them.
- **`flat/` is ChipTop/XSTop only** — no `TestHarness`, no `TestDriver`, no
  `SimDRAM`/`SimJTAG` shims. Those live in `rtl/` and the `.f` filelists.
- **XiangShan is `XSTop`, not `SimTop`** — built with `--fpga-platform`, so there
  is no difftest comparison harness.
- **XiangShan `flat/` files are gzipped.** Raw they are 105 MB and 161 MB, over
  GitHub's 100 MB per-file limit. `gunzip -k` to use them.
- **XiangShan FIRRTL is not included** (`XSTop.fir` is 1.0–1.5 GB raw). Chipyard's
  is, gzipped, in `meta/`.

## Simulation

Beyond linting, the frozen RTL was built into cycle-accurate Verilator simulators
and made to run real RISC-V code. Everything here — RISC-V toolchain, `libfesvr`,
the test binaries — is the conda `riscv-tools` stack that chipyard itself pins;
scripts are in [sim/](sim/) and raw logs in [sim/results/](sim/results/).

**Rocket and BOOM — 14/14 ISA tests each.** Each config was built with chipyard's
own Verilator TestHarness (which links `fesvr` and loads programs the normal way)
and run against 14 `riscv-tests` spanning every extension the cores implement:
base integer (`add`, `simple`, `lw`, `sw`, `beq`, `jal`), `M` (`mul`, `div`),
`A` (`amoadd_w`), `F`/`D` (`fadd`), machine- and supervisor-mode CSRs, and
compressed (`rvc`). All six configs pass all 14. Crucially, each simulator was
built from RTL whose `gen-collateral` was checksummed identical to this repo's
`rtl/` (see [sim/checksum_rtl.sh](sim/checksum_rtl.sh)), so the tests exercise the
*frozen* Verilog, not a fresh re-elaboration.

**XiangShan — runs real workloads, difftest-verified.** Use XiangShan's own
supported flow ([sim/xs_emu.pbs](sim/xs_emu.pbs)): `make emu` builds `SimTop`
(the core plus difftest and simulated MMIO/flash) and runs it against NEMU as a
golden reference, checking **every retired instruction**. On the frozen commit:

```
coremark-2-iteration : HIT GOOD TRAP @0x80001ca0 — 663,691 instrs, IPC 1.314, 469 iters/sec
microbench           : HIT GOOD TRAP @0x80003a4e — 326,376 instrs, IPC 0.960
Core 0's Commit SHA is: 7bf51a8805, dirty: 0
```

`xiangshan-simtop/` freezes that exact `SimTop` RTL, so experiments can verilate
known-good XiangShan Verilog without re-running Chisel. Logs:
[sim/results/](sim/results/).

> **Verilator version matters here.** XiangShan's difftest needs **≥ 5.048** —
> chipyard's 5.022 pin fails to compile it (`waveform.h` references
> `VerilatedTraceBaseC`, which didn't exist yet).

**XiangShan `XSTop` — the standalone story.** `XSTop` (in `xiangshan/`) is the
FPGA-platform top: raw AXI4 master ports, no test harness. A standalone testbench
([sim/tb_xstop.sv](sim/tb_xstop.sv)) wraps it in an AXI4 DRAM model and points the
reset vector at a small program. It elaborates, lints clean, comes out of reset
correctly, and issues correct instruction fetches:

```
[AR] mem #1 addr=0x80000000 len=1 size=5   (64-byte burst)
[AR] mem #2..#4 addr=0x80000040/80/c0
```

…but never retires an instruction. Waveform evidence confirms the setup is right:
`io_reset_vector` = `0x80000000` reaches the core, core reset deasserts at cycle
202 (frontend 228), and `hartResetReq` is 0 throughout — yet zero instructions
commit while the design stays highly active. Eliminated with evidence: trap to
`mtvec`=0 (zero peripheral reads), debug-module reset, JTAG/ndmreset wiring
(SimTop's exact connections replicated), DFT reset, PMA (init constants present —
DRAM is executable), test-program bugs (a marker-store program proves *no*
execution), the Smrnmi/Smdbltrp boot prologue (XiangShan's flash bootrom sets
`mnstatus.NMIE` and clears `mstatus.MDT`; replicated byte-exactly, no change),
Verilator defines, and `--ignore-read-enable-mem`.

`XSTop` is booted from flash at `0x10000000` by XiangShan's own harness, not
directly from DRAM; something in that bring-up isn't reproducible from a bare AXI
memory. **If you want to simulate XiangShan, use `xiangshan-simtop/` or
`sim/xs_emu.pbs`** — `xiangshan/` (XSTop) is the clean, difftest-free SoC top,
useful for reading, formal, and instrumentation, but not runnable standalone today.

## The two BOOM v4 patches

chipyard 1.14.0's pinned BOOM (`5223e44c`) has two bugs in the v4 issue unit that
had to be fixed for the v4 family to work. Both fixes are upstream commits, kept
in [scripts/patches/](scripts/patches/), and both were found here by actually
elaborating and *running* the RTL — the first by elaboration, the second only by
simulation.

1. **Doesn't elaborate** ([`383f241c`](https://github.com/riscv-boom/riscv-boom/commit/383f241c),
   *"connect SNI signals to inner issue units"*). `IssueUnitBanked` forwards
   signals to its issue columns but never connects `rob_head`/`rob_pnr_idx`, so
   firtool rejects `LargeBoomV4Config`:
   ```
   issue-unit-banked.scala:33:13: error: sink "col_0.io_rob_head" not fully initialized in "IssueUnitBanked"
   ```
   Only Large uses the banked path, so Small/Medium elaborate without it.

2. **Elaborates and lints, but hangs in simulation**
   ([`cf8e6d7a`](https://github.com/riscv-boom/riscv-boom/commit/cf8e6d7a),
   *"fall back to non-matrix issue for now"*). With only the first patch,
   `LargeBoomV4Config` builds and lints clean but every ISA test dies with
   `Assertion failed: Pipeline has hung` — the `IssueUnitAgeMatrix` unit
   (`useMatrixIssue=true` by default) is broken. Upstream flips the default to
   the `IssueUnitCollapsing` unit. This affects the whole v4 family, so all three
   v4 configs are frozen with it; they now use `IssueUnitCollapsing` and pass 14/14.

So the three **BOOM v4** configs are **chipyard 1.14.0 + these two upstream BOOM
patches**. `LargeBoomV3Config` and both Rocket configs are stock 1.14.0.

This is the case for running the RTL, not just elaborating it: bug #2 is invisible
to elaboration and to lint. It only showed up when the frozen RTL was made to
execute instructions.

## Reproducing

`scripts/` holds everything used to build this, in order: `setup_*.sh` (clone +
submodules), `elab_*.pbs` (elaboration on PBS), `collect_*.sh` (assemble these
trees), `verify2.sh` (byte-level completeness check), `lint*.sh` (the Verilator
check). `sim/` holds the simulation harness: `build_rvtools.pbs` (spike/`libfesvr`
+ `riscv-tests`), `sim_cy.pbs` (build+run the chipyard configs), `tb_xstop.sv` +
`sim_xs.pbs` (the XiangShan testbench), and `checksum_rtl.sh` (proves the sim ran
the frozen RTL). The two BOOM patches live in `scripts/patches/`.

Build environment notes, which cost some time to work out on `vanda`:

- OpenJDK takes `user.home` from `getpwuid()` and **ignores `$HOME`**. `/home` is
  at quota, so sbt and mill both need `-Duser.home=...` pointed at scratch, via
  `JAVA_TOOL_OPTIONS`.
- Chipyard runs `java -jar sbt-launch.jar $(SBT_OPTS)`, so `SBT_OPTS` are *program*
  args. Putting `-Xmx` there breaks the parse and silently discards chipyard's own
  boot-dir settings. Set heap via `JAVA_TOOL_OPTIONS`/`JAVA_HEAP_SIZE` instead.
- Compute nodes have **no `/usr/bin/git`** and no `dtc`. Use `module load git/2.40.0`;
  rocket-chip shells out to `dtc`, so it must be on `PATH`.
- `-q auto` routes to the charged `batch_cpu`, where jobs get preempted
  (`preempt_order = SCR`) and can land in a system hold. `-q auto_free`
  (→ `cpu_parallel`) was more reliable.
