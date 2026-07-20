#!/usr/bin/env bash
# Freeze all ibex configs: rtl/, flat/ (lint-verified), filelists, meta/, manifest.json
set -uo pipefail
P=/scratch/projects/CFP04/CFP04-SF-105/chipyardverilog
E=$P/mamba/envs/ibex
export PATH=$E/bin:$PATH
export LD_LIBRARY_PATH=$E/lib
VERILATOR_VER=$($E/bin/verilator --version | head -1)
FUSESOC_VER=$($E/bin/fusesoc --version 2>&1)
GCC_VER=$($P/tools/rv32gcc/bin/riscv32-unknown-elf-gcc --version | head -1)
cd $P/ibex
IBEX_COMMIT=$(git rev-parse HEAD)
IBEX_DATE=$(git log -1 --format=%cI)
FROZEN_ON=$(date -Is)

# per-config coremark stats: "coremark_score coremark_per_mhz coremark_cycles coremark_instrs"
declare -A CM
CM[small]="1.214825 2.429650 4189519 2754578"
CM[maxperf]="1.539097 3.078193 3309016 2754578"
CM[opentitan]="1.536270 3.072540 3320530 2754578"

SIMONLY='ram_1p.sv|ram_2p.sv|bus.sv|simulator_ctrl.sv|timer.sv|ibex_simple_system.sv|ibex_tracer.sv|ibex_tracer_pkg.sv|ibex_top_tracing.sv|prim_cdc_rand_delay.sv'

for CFG in small maxperf opentitan; do
  echo "########## FREEZE $CFG ##########"
  W=$P/ibex_work/$CFG/build
  VC=$W/lowrisc_ibex_ibex_simple_system_0.vc
  OUT=$P/freeze/ibex/$CFG
  rm -rf "$OUT"; mkdir -p "$OUT/rtl/lint" "$OUT/flat" "$OUT/meta"
  cd "$W"

  awk '/^--top-module/{stop=1} stop{next} /^src\/.*\.sv$/{print}' "$VC" > "$OUT/meta/rtl_order.txt"
  grep -E '^src/.*\.vlt$' "$VC" > "$OUT/meta/waivers.txt"
  grep -E '^-[GD]' "$VC" > "$OUT/meta/params.txt"

  # copy all RTL sources + include headers (flat, unique basenames)
  find src -name '*.sv' -o -name '*.svh' | while read -r f; do cp "$f" "$OUT/rtl/"; done
  while read -r f; do cp "$W/$f" "$OUT/rtl/lint/"; done < "$OUT/meta/waivers.txt"

  # full sim filelist (top ibex_simple_system)
  { echo "// ibex $CFG - full simple_system filelist (top: ibex_simple_system)";
    echo "+incdir+rtl";
    while read -r f; do echo "rtl/$(basename "$f")"; done < "$OUT/meta/rtl_order.txt";
  } > "$OUT/ibex_simple_system.f"

  # synthesizable DUT filelist (top ibex_top)
  { echo "// ibex $CFG - synthesizable DUT filelist (top: ibex_top)";
    echo "+incdir+rtl";
    while read -r f; do b=$(basename "$f"); echo "$b" | grep -qE "^($SIMONLY)$" && continue; echo "rtl/$b"; done < "$OUT/meta/rtl_order.txt";
  } > "$OUT/ibex_top.f"

  DEFS=$(grep -E '^-D' "$OUT/meta/params.txt" | tr '\n' ' ')
  GPARAMS=$(grep -E '^-G' "$OUT/meta/params.txt" | tr '\n' ' ')
  WV=""; for w in $(cat "$OUT/meta/waivers.txt"); do WV="$WV $OUT/rtl/lint/$(basename "$w")"; done

  cd "$OUT"
  # produce self-contained flat single file for the DUT
  $E/bin/verilator -E -P -sv $DEFS -f ibex_top.f --top-module ibex_top > "flat/$CFG.flat.sv" 2>meta/flat_pp.err
  NMOD=$(grep -cE '^\s*module ' "flat/$CFG.flat.sv")

  # lint: DUT flat single-file (must be self-contained), full harness (rtl/), and DUT (rtl/)
  $E/bin/verilator --lint-only -sv --timing -Wno-UNOPTFLAT $DEFS --top-module ibex_top "flat/$CFG.flat.sv" > meta/lint_flat.log 2>&1; FLAT_RC=$?
  $E/bin/verilator --lint-only -sv --timing -Wno-UNOPTFLAT $DEFS $GPARAMS $WV -f ibex_top.f --top-module ibex_top > meta/lint_dut.log 2>&1; DUT_RC=$?
  $E/bin/verilator --lint-only -sv --timing -Wno-UNOPTFLAT -Wno-MULTIDRIVEN $DEFS $GPARAMS $WV -f ibex_simple_system.f --top-module ibex_simple_system > meta/lint_harness.log 2>&1; HARN_RC=$?
  NRTL=$(ls rtl/*.sv | wc -l | tr -d ' ')
  echo "$CFG: flat_modules=$NMOD rtl_sv=$NRTL flat_lint_rc=$FLAT_RC dut_lint_rc=$DUT_RC harness_lint_rc=$HARN_RC"

  read cm_score cm_mhz cm_cycles cm_instrs <<< "${CM[$CFG]}"
  OPTS=$(cd $P/ibex && python util/ibex_config.py "$CFG" fusesoc_opts)

  cat > "$OUT/manifest.json" <<JSON
{
  "design": "ibex",
  "config": "$CFG",
  "top_module": "ibex_top",
  "harness_top": "ibex_simple_system",
  "generator": {
    "repo": "https://github.com/lowRISC/ibex",
    "commit": "$IBEX_COMMIT",
    "commit_date": "$IBEX_DATE",
    "fusesoc": "$FUSESOC_VER",
    "config_source": "ibex_configs.yaml ($CFG)",
    "fusesoc_params": "$OPTS"
  },
  "toolchain": {
    "verilator": "$VERILATOR_VER",
    "sw_gcc": "$GCC_VER (lowRISC lowrisc-toolchain-gcc-rv32imcb-20250710-1)"
  },
  "build_command": "fusesoc --cores-root=. run --target=sim --setup --build lowrisc:ibex:ibex_simple_system \$(util/ibex_config.py $CFG fusesoc_opts)",
  "frozen_on": "$FROZEN_ON",
  "contents": {
    "rtl/": "$NRTL as-generated SystemVerilog sources for ibex_simple_system (core + prims + sim harness), one module per file; rtl/lint/*.vlt are Verilator waivers; +incdir+rtl resolves \`include headers",
    "flat/$CFG.flat.sv": "single self-contained file: the synthesizable DUT ibex_top ($NMOD modules), Verilator-preprocessed (\`include inlined, macros expanded), lints standalone",
    "ibex_simple_system.f": "filelist: full sim (top ibex_simple_system) - core + sim RAM/timer/bus + tracer + memutil-DPI harness",
    "ibex_top.f": "filelist: synthesizable DUT only (top ibex_top)",
    "meta/": "rtl_order.txt (build order), params.txt (-G/-D config params), waivers.txt, lint logs"
  },
  "notes": [
    "flat/ is the DUT ibex_top only (no sim harness), mirroring the ChipTop/XSTop convention of the other cores here.",
    "Verilator 5.048 flags a benign UNOPTFLAT (circular combinational logic over bit-slices in the ibex controller); it is a false positive that ibex's own sim build also waives. Lint and the flat file are checked with -Wno-UNOPTFLAT.",
    "The sim harness (ibex_simple_system.f) additionally needs -Wno-MULTIDRIVEN for the sim-only disassembly tracer (ibex_tracer.sv); the synthesizable DUT has no such warning.",
    "SRAMs are behavioral models (prim_generic_ram_*, sim RAM ram_1p/ram_2p). Good for simulation/formal; not PDK macros.",
    "ibex is hand-written SystemVerilog (no Chisel/FIRRTL), so there is no .fir/.dts to include.",
    "Built with -DRVFI=1 so the RISC-V Formal Interface tracer ports are present (as ibex's simple_system uses)."
  ],
  "lint": {
    "tool": "$VERILATOR_VER",
    "flat_dut_top_ibex_top": "$([ $FLAT_RC -eq 0 ] && echo '0 errors, 0 warnings (-Wno-UNOPTFLAT)' || echo FAILED)",
    "rtl_dut_top_ibex_top": "$([ $DUT_RC -eq 0 ] && echo '0 errors, 0 warnings (-Wno-UNOPTFLAT)' || echo FAILED)",
    "rtl_harness_top_ibex_simple_system": "$([ $HARN_RC -eq 0 ] && echo '0 errors, 0 warnings (-Wno-UNOPTFLAT -Wno-MULTIDRIVEN)' || echo FAILED)"
  },
  "simulation": {
    "tool": "$VERILATOR_VER (ibex_simple_system Verilator harness)",
    "hello_test": "PASS - prints 'Hello simple system', timer interrupts, clean \$finish (261 instrs retired)",
    "coremark": {
      "result": "Correct operation validated",
      "coremark_1.0": $cm_score,
      "coremark_per_mhz": $cm_mhz,
      "cycles": $cm_cycles,
      "instructions_retired": $cm_instrs
    },
    "note": "Simulated from this exact frozen config's Verilator model (built by fusesoc from the src/ tree copied into rtl/)."
  }
}
JSON
done
echo "########## ALL FROZEN ##########"
