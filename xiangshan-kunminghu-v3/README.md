# XiangShan Kunminghu-V3 — 25 September 2026

These are stock XSTop snapshots from [upstream aa6b52033add528a504bdb2c2b726100d89f070a](https://github.com/OpenXiangShan/XiangShan/commit/aa6b52033add528a504bdb2c2b726100d89f070a), the `kunminghu-v3` default-branch head observed on 25 September 2026. Both configurations were generated from a clean checkout with pinned submodules.

| Configuration | HDL files / modules | Elaboration | Verilator 5.052 lint | Simulation |
| --- | --- | --- | --- | --- |
| MinimalConfig | 1896 | passed | passed, zero errors | not run |
| DefaultConfig | 2004 | passed | passed, zero errors | not run |

The toolchain is Chisel 7.13.0 with firtool 1.149.0. Mill 0.12.17 uses Scala 2.13.17 under Temurin JDK 21.0.8+9. Each manifest includes the exact build command. `meta/submodules.txt` records the complete recursive dependency set. `meta/rtl-sha256.json` records every emitted HDL file.

`files.f` lists all emitted HDL files using paths relative to the configuration directory. It includes collateral omitted from a generator file list. `filelist.f` is the original generator output. Behavioral SRAMs are included; this is the FPGA-platform XSTop with no standalone simulation harness.

Run from either configuration directory:

```sh
ulimit -s 65520
verilator --lint-only --timing -Wno-fatal --top-module XSTop -f files.f
```

Warnings are nonfatal in this command. Both recorded runs completed without diagnostic warnings. The retained logs contain Verilator's summary. The flat RTL is gzip-compressed; decompression is required before use. FIRRTL is omitted because of its size.

The July `xiangshan/` and `xiangshan-simtop/` snapshots remain unchanged. Their CoreMark results do not validate this revision. Existing `formal/` examples still refer to the historical RTL. No whole-core proof is claimed for this refresh.

To regenerate on a Linux build host with sufficient memory:

```sh
bash scripts/refresh_xiangshan_20260925.sh /absolute/path/to/new-build-root
```

The script prepares its pinned JDK and Mill launcher, then checks out the exact source revision. It emits each configuration into an isolated build directory. Run lint on each artifact's `rtl/` directory using a list of its `.sv` and `.v` files. Save the lint exit status in `artifacts/<Config>/lint.exit` with the output in `lint.log`. Collection requires successful generation and lint:

```sh
python3 scripts/collect_xiangshan_snapshot.py /absolute/path/to/new-build-root/artifacts /absolute/path/to/empty-output MinimalConfig
python3 scripts/collect_xiangshan_snapshot.py /absolute/path/to/new-build-root/artifacts /absolute/path/to/empty-output DefaultConfig
```

The collector rejects an existing destination. It creates the complete file list and compressed flat RTL without copying historical simulation claims. The upstream [Mulan PSL v2 license](LICENSE) accompanies these snapshots.
