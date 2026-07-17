#!/bin/bash
# Confirm chipyard's gen-collateral is byte-identical to what we froze in the repo,
# so that simulating out of the chipyard tree is really simulating the repo's RTL.
export PATH=/usr/bin:/bin
W=/scratch/flavien/chipyardverilog
GEN=$W/chipyard/sims/verilator/generated-src

for C in RocketConfig TinyRocketConfig SmallBoomV4Config MediumBoomV4Config LargeBoomV4Config LargeBoomV3Config; do
  F=rocket; case $C in *Boom*) F=boom;; esac
  O=$W/out/$F/$C/rtl
  D=$GEN/chipyard.harness.TestHarness.$C/gen-collateral
  a=$(cd "$O" && find . -maxdepth 1 \( -name '*.sv' -o -name '*.v' \) -print0 | sort -z | xargs -0 cat | md5sum | cut -d' ' -f1)
  b=$(cd "$D" && find . -maxdepth 1 \( -name '*.sv' -o -name '*.v' \) -print0 | sort -z | xargs -0 cat | md5sum | cut -d' ' -f1)
  na=$(ls "$O"/*.sv "$O"/*.v 2>/dev/null | wc -l)
  nb=$(ls "$D"/*.sv "$D"/*.v 2>/dev/null | wc -l)
  if [ "$a" = "$b" ]; then r="IDENTICAL"; else r="*** DIFFERS ***"; fi
  printf "%-22s repo:%-4s tree:%-4s %s\n" "$C" "$na" "$nb" "$r"
done
