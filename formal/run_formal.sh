#!/bin/bash
# Carve a module's dependency cone out of the frozen XiangShan core RTL, convert
# it to Verilog for the formal frontend, and drop you a yosys/sby-ready fileset.
#
# Usage: run_formal.sh <root_module> [rtl_dir] [out_dir]
#   e.g. run_formal.sh XSCore                 # whole core
#        run_formal.sh Rob                     # just the ROB + its cone
set -euo pipefail
ROOT="${1:?usage: run_formal.sh <root_module> [rtl_dir] [out_dir]}"
HERE="$(cd "$(dirname "$0")" && pwd)"
RTL="${2:-$HERE/../xiangshan/MinimalConfig/rtl}"
OUT="${3:-/tmp/formal_$ROOT}"
python3 "$HERE/extract_cone.py" "$RTL" "$ROOT" --copy "$OUT"
echo ">>> sv2v -DSYNTHESIS -> $OUT/$ROOT.v"
sv2v -DSYNTHESIS --write="$OUT/$ROOT.v" "$OUT"/*.sv "$OUT"/*.v 2>/dev/null || \
  sv2v -DSYNTHESIS --write="$OUT/$ROOT.v" "$OUT"/*.sv
echo ">>> done. Verilog: $OUT/$ROOT.v ($(grep -c '^module ' "$OUT/$ROOT.v") modules)"
echo ">>> next: write a wrapper asserting your property, then run sby (see examples/)."
