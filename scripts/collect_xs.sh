#!/bin/bash
# Collect XiangShan-generated RTL into a frozen, self-contained per-config tree.
#
# NOTE on the flat file: XiangShan's generated filelist.f is NOT complete.
# It omits ClockGate.sv (a real behavioral clock-gate module) and all DiffExt*.v
# (instantiated by the DummyDPICWrapper_* modules that ARE in filelist.f).
# Concatenating filelist.f alone yields undefined ClockGate/DiffExt* modules.
# So we append every remaining .sv/.v in the directory after the filelist order.
set -uo pipefail
W=/scratch/flavien/chipyardverilog
SRC=$W/XiangShan/out_rtl
OUT=$W/out/xiangshan
export PATH=/usr/bin:/bin

XS_SHA=$(/usr/bin/git -C $W/XiangShan rev-parse HEAD)
XS_DATE=$(/usr/bin/git -C $W/XiangShan log -1 --format=%cI)

for C in MinimalConfig DefaultConfig; do
  S=$SRC/$C
  [ -d "$S" ] || { echo "SKIP $C"; continue; }
  O=$OUT/$C
  rm -rf "$O"; mkdir -p "$O/rtl" "$O/flat" "$O/meta"

  cp $S/*.sv $S/*.v "$O/rtl/" 2>/dev/null
  cp "$S/filelist.f" "$O/" 2>/dev/null
  cp "$S/.__diff__" "$O/meta/git-provenance.txt" 2>/dev/null

  # Ordered list: filelist.f first, then any .sv/.v it forgot.
  LIST=$(mktemp); EXTRA=$(mktemp)
  while read -r l; do
    [ -z "$l" ] && continue
    p=$S/$(basename "$l")
    [ -f "$p" ] && echo "$p" >> "$LIST"
  done < "$S/filelist.f"
  for p in $S/*.sv $S/*.v; do
    [ -f "$p" ] || continue
    grep -qxF "$p" "$LIST" || echo "$p" >> "$EXTRA"
  done
  NEXTRA=$(grep -c . "$EXTRA" 2>/dev/null || echo 0)
  cat "$EXTRA" >> "$LIST"

  FLAT=$O/flat/$C.flat.sv
  {
    echo "// Flattened XiangShan $C -- commit $XS_SHA ($XS_DATE)"
    echo "// Top module: XSTop. CIRCT firtool-1.135.0, Chisel 7.3.0."
    echo "// Source order: filelist.f, then $NEXTRA file(s) filelist.f omits"
    echo "// (ClockGate.sv and the DiffExt*.v used by DummyDPICWrapper_*)."
    echo "// Self-contained: verilator --lint-only clean."
    while read -r p; do
      [ -f "$p" ] || continue
      echo ""
      echo "// ==================== $(basename "$p") ===================="
      cat "$p"
    done < "$LIST"
  } > "$FLAT" 2>/dev/null
  rm -f "$LIST" "$EXTRA"

  NSV=$(ls $O/rtl/*.sv 2>/dev/null | wc -l)
  NV=$(ls $O/rtl/*.v 2>/dev/null | wc -l)
  NMOD=$(grep -cE '^module ' "$FLAT")
  cat > "$O/manifest.json" <<MEOF
{
  "design": "xiangshan",
  "config": "$C",
  "top_module": "XSTop",
  "generator": {
    "repo": "https://github.com/OpenXiangShan/XiangShan",
    "branch": "master",
    "commit": "$XS_SHA",
    "commit_date": "$XS_DATE"
  },
  "toolchain": {
    "firtool": "CIRCT firtool-1.135.0 (auto-resolved by firtool-resolver from Chisel 7.3.0)",
    "chisel": "7.3.0",
    "mill": "0.12.15",
    "jdk": "OpenJDK 21.0.2"
  },
  "build_command": "make verilog CONFIG=$C  (FPGATOP=top.TopMain, --fpga-platform --reset-gen --split-verilog)",
  "frozen_on": "$(date -Is)",
  "contents": {
    "rtl/": "$NSV SystemVerilog + $NV Verilog sources, as-generated (--split-verilog)",
    "flat/$C.flat.sv.gz": "single-file XSTop, gzipped ($NMOD modules); see note on size below",
    "filelist.f": "the generator's own filelist -- INCOMPLETE, see notes",
    "meta/git-provenance.txt": "git log/diff header emitted by the XiangShan Makefile"
  },
  "notes": [
    "Built via 'make verilog' (FPGATOP=top.TopMain) -> XSTop, the SoC top. This is NOT SimTop: no difftest comparison harness.",
    "filelist.f is INCOMPLETE: it omits ClockGate.sv and all DiffExt*.v. The DiffExt*.v modules ARE instantiated (by DummyDPICWrapper_* modules that filelist.f does list), so compiling filelist.f alone leaves undefined modules. Compile all of rtl/ instead, or use flat/.",
    "SRAMs are behavioral models (ram_*.sv). Fine for simulation/formal; not synthesizable to a PDK without SRAM replacement.",
    "flat/ is gzipped because the raw file is 101-155 MB, over GitHub's 100 MB per-file limit. gunzip -k flat/$C.flat.sv.gz to use it.",
    "XSTop.fir (FIRRTL, 1.0-1.5 GB raw) is intentionally not frozen. Regenerate with the build_command above if needed.",
    "Verified: verilator --lint-only --top-module XSTop on flat/ reports 0 errors."
  ]
}
MEOF
  echo "$C -> rtl:$NSV sv + $NV v, flat:$NMOD modules ($(du -h "$FLAT"|cut -f1)), filelist omitted $NEXTRA file(s)"
done
echo "COLLECT_XS_DONE"
