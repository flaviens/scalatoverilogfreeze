#!/usr/bin/env bash
# Prove the frozen ibex RTL parses+elaborates standalone with Verilator.
# Works from the committed ibex/ tree; no build environment needed beyond verilator.
# Usage: scripts/lint_ibex.sh [path-to-ibex-dir]   (default: ./ibex)
set -uo pipefail
IBEX=${1:-ibex}
cd "$IBEX"
verilator --version | head -1

# The RV32M/RV32B/RV32ZC/RegFile defines are the same source for every config
# (they only set parameters at the ibex_simple_system level, not ibex_top's body),
# so any config's -D defines lint the shared RTL. Use small.
DEFS=$(grep -E '^-D' configs/small.params)

echo "=================== flat DUT  (top=ibex_top, self-contained) ==================="
verilator --lint-only -sv --timing -Wno-UNOPTFLAT $DEFS \
    --top-module ibex_top flat/ibex_top.flat.sv 2>&1 | grep -cE '^%Error' | sed 's/^/  errors=/'

echo "=================== rtl DUT   (top=ibex_top, ibex_top.f) ==================="
verilator --lint-only -sv --timing -Wno-UNOPTFLAT $DEFS $(grep -E '^-G' configs/small.params) \
    rtl/lint/*.vlt -f ibex_top.f --top-module ibex_top 2>&1 | grep -cE '^%Error' | sed 's/^/  errors=/'

echo "=================== rtl sim harness (top=ibex_simple_system) ==================="
# the sim-only disassembly tracer (ibex_tracer.sv) has a benign MULTIDRIVEN
verilator --lint-only -sv --timing -Wno-UNOPTFLAT -Wno-MULTIDRIVEN $DEFS $(grep -E '^-G' configs/small.params) \
    rtl/lint/*.vlt -f ibex_simple_system.f --top-module ibex_simple_system 2>&1 | grep -cE '^%Error' | sed 's/^/  errors=/'

echo "LINT_IBEX_DONE"
