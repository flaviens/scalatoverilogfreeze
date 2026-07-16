#!/bin/bash
# Lint XiangShan flat files. Handles either raw .sv or gzipped .sv.gz.
export PATH=/home/svu/flavien/compass-scale/oss-cad-suite/bin:/usr/bin:/bin
export HOME=/scratch/flavien/chipyardverilog/home
W=/scratch/flavien/chipyardverilog
T=$W/tmp/lint
mkdir -p $T

for C in MinimalConfig DefaultConfig; do
  RAW=$W/out/xiangshan/$C/flat/$C.flat.sv
  GZ=$RAW.gz
  F=""
  if [ -f "$RAW" ]; then
    F=$RAW
    src="raw"
  elif [ -f "$GZ" ]; then
    F=$T/$C.flat.sv
    gunzip -c "$GZ" > "$F"
    src="gunzipped"
  else
    echo "=== $C: NO FLAT FILE ==="; continue
  fi
  echo "=================== XiangShan $C (top=XSTop, $src) ==================="
  echo "  file bytes   : $(stat -c %s "$F")"
  echo "  XSTop decls  : $(grep -cE '^module XSTop' "$F")"
  timeout 2400 verilator --lint-only -Wno-fatal --timing --top-module XSTop "$F" > $T/xs_$C.lint 2>&1
  rc=$?
  errs=$(grep -c "^%Error" $T/xs_$C.lint)
  echo "  exit=$rc  errors=$errs"
  [ "$errs" -gt 0 ] && grep "^%Error" $T/xs_$C.lint | head -5
  [ "$src" = "gunzipped" ] && rm -f "$F"
done
echo "XS_LINT_DONE"
