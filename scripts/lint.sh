#!/bin/bash
# Prove the frozen RTL actually parses+elaborates standalone, using the flat file only.
export PATH=/home/svu/flavien/compass-scale/oss-cad-suite/bin:/usr/bin:/bin
export HOME=/scratch/flavien/chipyardverilog/home
W=/scratch/flavien/chipyardverilog
T=$W/tmp/lint
mkdir -p $T
cd $T

verilator --version

for spec in "rocket/RocketConfig:ChipTop" "rocket/TinyRocketConfig:ChipTop" \
            "boom/SmallBoomV4Config:ChipTop" "boom/MediumBoomV4Config:ChipTop" \
            "boom/LargeBoomV4Config:ChipTop" "boom/LargeBoomV3Config:ChipTop"; do
  path="${spec%%:*}"; top="${spec##*:}"
  C=$(basename "$path")
  F=$W/out/$path/flat/$C.flat.sv
  echo "=================== $C (top=$top) ==================="
  timeout 900 verilator --lint-only -Wno-fatal --timing --top-module "$top" "$F" > $T/$C.lint 2>&1
  rc=$?
  errs=$(grep -c "^%Error" $T/$C.lint)
  echo "  exit=$rc  errors=$errs"
  [ "$errs" -gt 0 ] && grep "^%Error" $T/$C.lint | head -4
done

for C in MinimalConfig DefaultConfig; do
  GZ=$W/out/xiangshan/$C/flat/$C.flat.sv.gz
  F=$T/$C.flat.sv
  gunzip -c "$GZ" > "$F"
  echo "=================== XiangShan $C (top=XSTop) ==================="
  timeout 1800 verilator --lint-only -Wno-fatal --timing --top-module XSTop "$F" > $T/xs_$C.lint 2>&1
  rc=$?
  errs=$(grep -c "^%Error" $T/xs_$C.lint)
  echo "  exit=$rc  errors=$errs"
  [ "$errs" -gt 0 ] && grep "^%Error" $T/xs_$C.lint | head -4
  rm -f "$F"
done
echo "LINT_DONE"
