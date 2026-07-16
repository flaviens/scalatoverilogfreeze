#!/bin/bash
set -euo pipefail
W=/scratch/flavien/chipyardverilog
export HOME=$W/home
export TMPDIR=$W/tmp
export PATH=/usr/bin:$PATH
cd $W
if [ ! -d XiangShan/.git ]; then
  /usr/bin/git clone https://github.com/OpenXiangShan/XiangShan.git XiangShan
fi
cd XiangShan
/usr/bin/git rev-parse HEAD > $W/logs/xs_head.txt
# make init = submodule update --init for rocket-chip, difftest, utility, yunsuan, ChiselAIA, ChiselIOPMP, XSCache
/usr/bin/git submodule update --init --recursive rocket-chip difftest utility yunsuan ChiselAIA ChiselIOPMP XSCache 2>&1 || \
  /usr/bin/git submodule update --init --recursive
echo "XS_SETUP_DONE"
