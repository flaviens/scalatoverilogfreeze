#!/bin/bash
set -euo pipefail
W=/scratch/flavien/chipyardverilog
export HOME=$W/home
export TMPDIR=$W/tmp
export PATH=/usr/bin:$PATH
cd $W
if [ ! -d chipyard/.git ]; then
  /usr/bin/git clone --branch 1.14.0 https://github.com/ucb-bar/chipyard.git chipyard
fi
cd chipyard
/usr/bin/git config --local advice.detachedHead false
./scripts/init-submodules-no-riscv-tools.sh
echo "CY_SETUP_DONE"
