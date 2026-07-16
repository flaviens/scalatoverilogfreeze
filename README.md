# Frozen Verilog: Rocket, BOOM, XiangShan

Pre-elaborated RTL for three RISC-V cores, so experiments can start from Verilog
instead of waiting on a Chisel/FIRRTL build every time.

Every config here has been checked with `verilator --lint-only` against its
**flat** file and reports **0 errors**, so each one parses and elaborates
standalone with no extra include paths. Checked twice: Verilator 5.049 on Linux
(where it was generated) and Verilator 5.046 on macOS (from the committed files).

## What's here

| Design | Config | Top | Modules (flat) | Notes |
|---|---|---|---|---|
| Rocket | `RocketConfig` | `ChipTop` | 432 | dual-core RV64GC |
| Rocket | `TinyRocketConfig` | `ChipTop` | 278 | smallest Rocket |
| BOOM | `SmallBoomV4Config` | `ChipTop` | 595 | BOOM **v4** |
| BOOM | `MediumBoomV4Config` | `ChipTop` | 598 | BOOM **v4** |
| BOOM | `LargeBoomV4Config` | `ChipTop` | 628 | BOOM **v4**, needs a patch (below) |
| BOOM | `LargeBoomV3Config` | `ChipTop` | 615 | BOOM **v3**, kept because much prior work targets v3 |
| XiangShan | `MinimalConfig` | `XSTop` | 1911 | |
| XiangShan | `DefaultConfig` | `XSTop` | 2009 | full Kunminghu-class core |

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
```

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

## The one patch we applied

`LargeBoomV4Config` **does not elaborate** at chipyard 1.14.0's pinned BOOM
(`5223e44c`). `IssueUnitBanked` forwards signals to its issue columns but never
connects `rob_head`/`rob_pnr_idx`, so firtool fails:

```
issue-unit-banked.scala:33:13: error: sink "col_0.io_rob_head" not fully initialized in "IssueUnitBanked"
```

Only the Large config uses the banked issue unit, which is why Small/Medium build
fine. We applied the upstream fix — riscv-boom
[`383f241c`](https://github.com/riscv-boom/riscv-boom/commit/383f241c), *"connect
SNI signals to inner issue units for correct elaboration of Large+BOOM"*, a 3-line
change — kept in [scripts/patches/boom-383f241c.patch](scripts/patches/boom-383f241c.patch).

So `LargeBoomV4Config` is **chipyard 1.14.0 + that one upstream BOOM patch**.
Every other config is stock 1.14.0.

## Reproducing

`scripts/` holds everything used to build this, in order: `setup_*.sh` (clone +
submodules), `elab_*.pbs` (elaboration on PBS), `collect_*.sh` (assemble these
trees), `verify2.sh` (byte-level completeness check), `lint*.sh` (the Verilator
check).

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
