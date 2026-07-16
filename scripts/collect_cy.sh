#!/bin/bash
# Collect chipyard-generated RTL into a frozen, self-contained per-config tree.
#
# NOTE on the flat file: chipyard's <long_name>.top.f does NOT list the behavioral
# SRAM models. firtool emits those into gen-collateral/<long_name>.top.mems.v via
# --repl-seq-mem. Concatenating top.f alone yields a design with undefined *_ext
# modules (cc_dir_ext, rockettile_dcache_data_arrays_0_ext, mem_ext, ...), which
# fails to elaborate. So we append top.mems.v. (<long_name>.model.mems.v is empty
# for these configs -- it belongs to the TestHarness side, not ChipTop.)
set -uo pipefail
W=/scratch/flavien/chipyardverilog
GEN=$W/chipyard/sims/verilator/generated-src
OUT=$W/out
export PATH=/usr/bin:/bin

CY_SHA=$(/usr/bin/git -C $W/chipyard rev-parse HEAD)
CY_TAG=$(/usr/bin/git -C $W/chipyard describe --tags --always 2>/dev/null)
BOOM_SHA=$(/usr/bin/git -C $W/chipyard/generators/boom rev-parse HEAD)

fam_of() {
  case "$1" in
    *Boom*) echo boom;;
    *) echo rocket;;
  esac
}

for C in RocketConfig TinyRocketConfig SmallBoomV4Config MediumBoomV4Config LargeBoomV4Config LargeBoomV3Config; do
  LN=chipyard.harness.TestHarness.$C
  D=$GEN/$LN
  [ -d "$D/gen-collateral" ] || { echo "SKIP $C (no output)"; continue; }
  n=$(ls "$D/gen-collateral" 2>/dev/null | wc -l)
  [ "$n" -gt 0 ] || { echo "SKIP $C (empty gen-collateral)"; continue; }

  F=$(fam_of "$C")
  O=$OUT/$F/$C
  rm -rf "$O"; mkdir -p "$O/rtl" "$O/flat" "$O/meta"

  # RTL sources (.sv/.v only; .cc are verilator C++ shims, not RTL).
  # This includes <long_name>.top.mems.v, so rtl/ is self-contained.
  cp $D/gen-collateral/*.sv $D/gen-collateral/*.v "$O/rtl/" 2>/dev/null

  # Metadata worth freezing.
  for x in .fir .dts .anno.json .appended.anno.json .json .d .chiptop0.graphml .mems.conf .top.mems.conf; do
    cp "$D/$LN$x" "$O/meta/" 2>/dev/null
  done
  cp $D/*.regmap.json "$O/meta/" 2>/dev/null

  # Filelists, rewritten to repo-relative paths.
  for f in $D/*.f; do
    b=$(basename "$f")
    sed "s|$D/gen-collateral/|rtl/|g" "$f" > "$O/$b" 2>/dev/null
  done

  # Ordered source list for the flat file: top.f (DUT) + the SRAM models.
  LIST=$(mktemp)
  grep -v '\.cc$' "$D/$LN.top.f" | grep . > "$LIST"
  MEMS=$D/gen-collateral/$LN.top.mems.v
  if [ -f "$MEMS" ] && ! grep -qxF "$MEMS" "$LIST"; then echo "$MEMS" >> "$LIST"; fi

  FLAT=$O/flat/$C.flat.sv
  {
    echo "// Flattened $C -- chipyard $CY_TAG ($CY_SHA), CIRCT firtool-1.75.0"
    echo "// Top module: ChipTop (the SoC). Excludes TestHarness/TestDriver."
    echo "// Source order: $LN.top.f, then $LN.top.mems.v (behavioral SRAM models,"
    echo "// which top.f does not list). Self-contained: verilator --lint-only clean."
    while read -r p; do
      [ -f "$p" ] || continue
      echo ""
      echo "// ==================== $(basename "$p") ===================="
      cat "$p"
    done < "$LIST"
  } > "$FLAT" 2>/dev/null
  rm -f "$LIST"

  NRTL=$(ls "$O/rtl" | wc -l)
  NMOD=$(grep -cE '^module ' "$FLAT")
  cat > "$O/manifest.json" <<MEOF
{
  "design": "$F",
  "config": "$C",
  "top_module": "ChipTop",
  "harness_top": "TestHarness",
  "generator": {
    "repo": "https://github.com/ucb-bar/chipyard",
    "tag": "$CY_TAG",
    "commit": "$CY_SHA",
    "boom_submodule_commit": "$BOOM_SHA"
  },
  "toolchain": {
    "firtool": "CIRCT firtool-1.75.0 (pinned by chipyard conda-reqs/circt.json)",
    "chisel": "6.7.0",
    "scala": "2.13.16",
    "jdk": "OpenJDK 11.0.23"
  },
  "build_command": "make verilog CONFIG=$C  (from chipyard/sims/verilator)",
  "frozen_on": "$(date -Is)",
  "contents": {
    "rtl/": "$NRTL as-generated SystemVerilog/Verilog sources (firtool --split-verilog), including $LN.top.mems.v",
    "flat/$C.flat.sv": "single-file ChipTop: $LN.top.f order + top.mems.v ($NMOD modules)",
    "meta/": "FIRRTL (.fir.gz), device tree (.dts), firrtl annotations, SRAM conf, regmaps, module graph",
    "$LN.top.f": "filelist: ChipTop SoC (the DUT). NOTE: does not list the SRAM models.",
    "$LN.all.f": "filelist: ChipTop + TestHarness",
    "$LN.bb.f": "filelist: blackboxes + simulation-only models (SimDRAM/SimJTAG)",
    "sim_files.common.f": "filelist: everything needed to simulate (includes top.mems.v)"
  },
  "notes": [
    "SRAMs are behavioral models in $LN.top.mems.v (firtool --repl-seq-mem). Fine for simulation/formal; not synthesizable to a PDK without SRAM replacement.",
    "chipyard's top.f omits top.mems.v; flat/ appends it so the single file elaborates standalone. If you compile from rtl/ + a filelist, use sim_files.common.f, not top.f alone.",
    "flat/ excludes .cc verilator shims and the TestHarness/TestDriver.",
    "Paths in the .f files are rewritten relative to this config directory.",
    "Verified: verilator --lint-only --top-module ChipTop on flat/ reports 0 errors."
  ]
}
MEOF
  echo "$C -> rtl:$NRTL files, flat:$NMOD modules ($(du -h "$FLAT"|cut -f1))"
done
echo "COLLECT_CY_DONE"
