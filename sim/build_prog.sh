#!/bin/bash
# Assemble prog.S and emit a hex file of 256-bit (32-byte) lines for $readmemh.
set -euo pipefail
W=/scratch/flavien/chipyardverilog
RVT=$W/mamba/envs/riscv-tools/riscv-tools
export PATH=$RVT/bin:/usr/bin:/bin
D=$W/xstop-tb
mkdir -p $D
cd $D

cat > link.ld <<'EOF'
OUTPUT_ARCH("riscv")
ENTRY(_start)
SECTIONS { . = 0x80000000; .text : { *(.text.init) *(.text) } }
EOF

riscv64-unknown-elf-gcc -march=rv64gc -mabi=lp64d -nostdlib -nostartfiles \
  -T link.ld -o prog.elf "$1"
riscv64-unknown-elf-objcopy -O binary prog.elf prog.bin
riscv64-unknown-elf-objdump -d prog.elf > prog.dis

# 32 bytes per line, little-endian within the line
python3 - <<'PY'
data = open('/scratch/flavien/chipyardverilog/xstop-tb/prog.bin','rb').read()
pad = (-len(data)) % 32
data += b'\x00' * pad
with open('/scratch/flavien/chipyardverilog/xstop-tb/prog.hex','w') as f:
    for i in range(0, len(data), 32):
        chunk = data[i:i+32]
        f.write(chunk[::-1].hex() + '\n')   # MSB-first for readmemh
print("lines:", len(data)//32, "bytes:", len(data))
PY

echo "--- first instructions ---"
head -12 prog.dis | tail -6
echo "--- hex head ---"
head -2 prog.hex
