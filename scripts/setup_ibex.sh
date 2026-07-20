#!/usr/bin/env bash
# Set up the ibex build environment used to freeze the RTL in ibex/.
# Run on the login node (compute nodes have no git). Mirrors setup_cy.sh / setup_xs.sh.
set -euo pipefail
P=/scratch/projects/CFP04/CFP04-SF-105/chipyardverilog
export HOME=$P/home TMPDIR=$P/tmp
MM=$P/tools/micromamba
export MAMBA_ROOT_PREFIX=$P/mamba

# 1. ibex sources (frozen commit recorded in ibex/manifest.json)
cd $P
[ -d ibex ] || git clone https://github.com/lowRISC/ibex.git ibex
cd ibex && git checkout 8ed87e07e3331561bce93af1568d9b376948e701

# 2. Verilator + fusesoc + libelf toolchain (a conda env)
$MM create -y -p $P/mamba/envs/ibex -c conda-forge \
    python=3.11 verilator=5.048 gcc=13.2 gxx=13.2 elfutils make cmake pkg-config zlib
$P/mamba/envs/ibex/bin/pip install 'fusesoc==2.4.3' pyyaml mako

# 3. RISC-V 32-bit GCC for the test software.
#    The riscv-tools conda gcc is rv64-only (no rv32 multilib libgcc, so coremark
#    fails to link __ltdf2). lowRISC's prebuilt gcc-rv32imcb toolchain ships rv32
#    newlib + libgcc and builds everything cleanly.
cd $P/tools
curl -sL https://github.com/lowRISC/lowrisc-toolchains/releases/download/20250710-1/lowrisc-toolchain-gcc-rv32imcb-x86_64-20250710-1.tar.xz -o rv32gcc.tar.xz
tar xf rv32gcc.tar.xz && mv lowrisc-toolchain-gcc-rv32imcb-x86_64-20250710-1 rv32gcc

echo "setup_ibex done: verilator $($P/mamba/envs/ibex/bin/verilator --version | head -1)"
