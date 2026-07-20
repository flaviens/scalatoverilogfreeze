# Formal analysis of the XiangShan core

Infrastructure to run formal (yosys + SymbiYosys) on the **XiangShan core** carved
out of the frozen `xiangshan/` (XSTop) RTL — excluding outer-layer blocks (L3,
NoC bridges, CLINT/peripherals, debug), as intended.

The whole core is proven to load into the formal toolchain: the `XSCore` cone
elaborates in yosys as **1,358,824 cells** with a fully resolved hierarchy
(Backend, Frontend, MemBlock, Dispatch, Rename, ROB, …) and zero unresolved
modules — see [results/xscore_elaboration.txt](results/xscore_elaboration.txt).
So you can run bounded model checking, property proofs, or equivalence on the
whole core or any sub-block.

## The core boundary

`XSTop` = `XSTile` (core + L2) + `OpenLLC` (L3) + `OpenNCB` (NoC) + `MemMisc`
(peripherals/CLINT/debug). Two clean roots, both excluding L3 and uncore:

| Root | What it is | Cone | Filelist |
|---|---|---|---|
| `XSCore` | the core: Frontend + Backend + MemBlock (L1 inside) | 1515 files, 80 MB, **0 unresolved** | [xscore.cone.f](xscore.cone.f) |
| `XSTile` | core + L2 (adds L2Top, IntBuffers) | 1681 files, 85 MB, 0 unresolved | [xstile.cone.f](xstile.cone.f) |

"0 unresolved" means fully self-contained — no DPI, no blackboxes, no difftest
leaked in (unlike SimTop, which is full of DPI and can't be formal-verified).

## The flow

Two gotchas make this non-obvious, both handled by the scripts here:

1. **yosys can't parse firtool's SystemVerilog** natively (casts like `8'(x)` →
   `syntax error, unexpected OP_CAST`). Convert with **`sv2v`** first.
2. **firtool emits `$random` register initializers** under `ENABLE_INITIAL_REG_`,
   which BMC rejects (`Failed to get a constant init value`). Build for formal the
   way you'd build for synthesis: **`sv2v -DSYNTHESIS`** drops those blocks; then
   drive the design from reset (`initial assume(reset)`).

```
sv2v -DSYNTHESIS --write=core.v <cone>/*.sv <cone>/*.v   # SV -> Verilog, no random init
# write a wrapper with your property, then:
sby -f your.sby                                           # yosys + smtbmc
```

`run_formal.sh <root>` does the extract + convert for any module:

```bash
./run_formal.sh XSCore        # whole core -> /tmp/formal_XSCore/XSCore.v
./run_formal.sh Rob           # just the ROB + its cone
./run_formal.sh StoreQueue    # any sub-block
```

`xscore_formal.pbs` is the cluster job that elaborates the whole core (heavy:
sv2v ~2 min, yosys ~90 s, needs ~a big-mem node).

## Worked examples

Each is self-contained — `./run.sh` does sv2v then sby.

- **[examples/adder_eq](examples/adder_eq)** — an **unbounded equivalence proof**
  that PASSES. A core arithmetic block (`Adder_2`, actually an 8-bit modular
  subtractor) is proven equal to a behavioural spec for all inputs by k-induction.
  This is the "miter" shape — the same one you'd use to equivalence-check two RTL
  versions. No environment model needed because it's combinational.

- **[examples/freelist_bmc](examples/freelist_bmc)** — **BMC on a real core block**
  (the rename `FreeList`) that finds a counterexample, illustrating why real RTL
  needs *environment assumptions*. With inputs left free, the solver violates the
  freelist's usage contract and overflows the free-count in 5 steps; sby dumps a
  trace. Two facts any sound proof of this block must model, discovered here:
  - at reset the freelist is **all-allocated** (`io_validCount = 0`) — the 16
    physical registers hold the initial architectural map;
  - the free path is **registered** (1-cycle delay), so `io_validCount` lags
    `io_free`. A real proof needs a ghost "outstanding" counter matching that timing.

Together they cover both outcomes you'll see doing formal on this core: a clean
proof, and a counterexample that's really a missing environment constraint.

## Files

```
extract_cone.py     compute a module's dependency cone from the frozen rtl/
run_formal.sh       extract + sv2v a chosen root into formal-ready Verilog
xscore.cone.f       the 1515 files that make up the core (repo-relative paths)
xstile.cone.f       core + L2
xscore_formal.pbs   cluster job: elaborate the whole core in yosys
examples/           adder_eq (PASS proof), freelist_bmc (CEX / env-modeling lesson)
results/            elaboration evidence
```

Built with `sv2v` and yosys/SymbiYosys from `oss-cad-suite`; the frozen RTL is
`xiangshan/MinimalConfig/rtl/` at XiangShan commit `7bf51a88`.
