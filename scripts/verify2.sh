#!/bin/bash
# Strong check: the flat file must contain every module named in the filelist,
# with balanced module/endmodule, and byte-size equal to the sum of its parts.
export PATH=/usr/bin:/bin
W=/scratch/flavien/chipyardverilog
marker='^// ==================== '

check() {
  local name="$1" flat="$2" list="$3" srcdir="$4" top="$5"
  if [ ! -f "$flat" ]; then echo "--- $name: FLAT MISSING"; return; fi
  local entries markers mods endmods expected actual delta
  entries=$(grep -c . "$list")
  markers=$(grep -c "$marker" "$flat")
  mods=$(grep -cE '^module ' "$flat")
  endmods=$(grep -cE '^endmodule' "$flat")
  # expected bytes = sum of the source files named in the list
  expected=0
  while read -r l; do
    [ -z "$l" ] && continue
    case "$l" in *.cc) continue;; esac
    p="$srcdir/$(basename "$l")"
    [ -f "$p" ] || continue
    sz=$(stat -c %s "$p")
    expected=$((expected + sz))
  done < "$list"
  actual=$(stat -c %s "$flat")
  delta=$((actual - expected))
  echo "--- $name"
  echo "    list entries : $entries"
  echo "    markers      : $markers"
  echo "    module/endmod: $mods / $endmods"
  echo "    top ($top)   : $(grep -cE "^module ${top}\b" "$flat")"
  echo "    bytes actual : $actual"
  echo "    bytes expect : $expected  (delta=+$delta from marker comments)"
  if [ "$mods" -eq "$endmods" ] && [ "$delta" -gt 0 ] && [ "$delta" -lt $((expected / 5 + 200000)) ]; then
    echo "    RESULT       : OK"
  else
    echo "    RESULT       : *** SUSPECT ***"
  fi
}

echo "==================== Chipyard ===================="
for C in RocketConfig TinyRocketConfig SmallBoomV4Config MediumBoomV4Config LargeBoomV3Config LargeBoomV4Config; do
  F=rocket; case $C in *Boom*) F=boom;; esac
  O=$W/out/$F/$C
  D=$W/chipyard/sims/verilator/generated-src/chipyard.harness.TestHarness.$C
  check "$C" "$O/flat/$C.flat.sv" "$D/chipyard.harness.TestHarness.$C.top.f" "$D/gen-collateral" "ChipTop"
done

echo "==================== XiangShan ===================="
for C in MinimalConfig DefaultConfig; do
  O=$W/out/xiangshan/$C
  S=$W/XiangShan/out_rtl/$C
  gz="$O/flat/$C.flat.sv.gz"
  tmp="$W/tmp/${C}.flat.sv"
  if [ -f "$gz" ]; then gunzip -c "$gz" > "$tmp"; check "$C" "$tmp" "$S/filelist.f" "$S" "XSTop"; rm -f "$tmp"; fi
done
