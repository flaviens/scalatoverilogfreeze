#!/bin/bash
set -uo pipefail
W=/scratch/flavien/chipyardverilog
export HOME=$W/home
export TMPDIR=$W/tmp
export PATH=/usr/bin:/bin
cd $W/XiangShan
# mirror XiangShan `make init` exactly
/usr/bin/git submodule update --init
/usr/bin/git -C rocket-chip submodule update --init cde hardfloat
/usr/bin/git -C XSCache submodule update --init OpenNCB
echo "--- ready-to-run contents ---"
ls -la ready-to-run | head
echo "XS_INIT2_DONE"
