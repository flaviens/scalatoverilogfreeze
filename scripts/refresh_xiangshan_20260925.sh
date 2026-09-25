#!/usr/bin/env bash
# Run on everest3 after reading ~/.agents/eda_tools_everest3.txt.
set -euo pipefail
root=${1:?usage: refresh_xiangshan.sh ABSOLUTE_WORK_DIRECTORY}
xs_commit=aa6b52033add528a504bdb2c2b726100d89f070a
mkdir -p "$root/tools" "$root/logs" "$root/artifacts"
exec > >(tee -a "$root/logs/refresh.log") 2>&1
trap 'rc=$?; echo "REFRESH_EXIT=$rc UTC=$(date -u +%FT%TZ)"; exit "$rc"' EXIT
echo "REFRESH_START UTC=$(date -u +%FT%TZ) HOST=$(hostname) PID=$$"
if [ ! -x "$root/tools/jdk-21.0.8+9/bin/java" ]; then
  curl -fL --retry 3 'https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.8%2B9/OpenJDK21U-jdk_x64_linux_hotspot_21.0.8_9.tar.gz' -o "$root/tools/jdk.tar.gz"
  tar -xzf "$root/tools/jdk.tar.gz" -C "$root/tools"
fi
if [ ! -x "$root/tools/mill" ]; then
  curl -fL --retry 3 https://raw.githubusercontent.com/com-lihaoyi/mill/0.12.17/mill -o "$root/tools/mill"
  chmod +x "$root/tools/mill"
fi
export JAVA_HOME="$root/tools/jdk-21.0.8+9"
export PATH="$JAVA_HOME/bin:$root/tools:$PATH"
export JAVA_TOOL_OPTIONS='-XX:ActiveProcessorCount=16'
if [ ! -d "$root/XiangShan/.git" ]; then
  git clone --filter=blob:none --no-checkout https://github.com/OpenXiangShan/XiangShan.git "$root/XiangShan"
fi
cd "$root/XiangShan"
git checkout --detach "$xs_commit"
git submodule update --init --recursive --depth 1 --jobs 8 rocket-chip utility difftest ready-to-run yunsuan ChiselAIA ChiselIOPMP XSCache
git status --porcelain > "$root/artifacts/source-status.txt"
git submodule status --recursive > "$root/artifacts/submodules.txt"
git show -s --format=fuller > "$root/artifacts/source-commit.txt"
java -version 2> "$root/artifacts/java-version.txt"
mill --version > "$root/artifacts/mill-version.txt" 2>&1
export NOOP_HOME="$root/XiangShan"
for cfg in MinimalConfig DefaultConfig; do
  out="$root/artifacts/$cfg"
  if [ -f "$out/SUCCESS" ]; then continue; fi
  mkdir -p "$out"
  echo "ELAB_START CONFIG=$cfg UTC=$(date -u +%FT%TZ)"
  if make verilog CONFIG="$cfg" BUILD_DIR="$root/build-$cfg" JVM_XMX=64G JVM_XSS=256m > "$out/elaboration.log" 2>&1; then
    cp -a "$root/build-$cfg/rtl" "$out/rtl"
    date -u +%FT%TZ > "$out/SUCCESS"
    echo "ELAB_OK CONFIG=$cfg UTC=$(date -u +%FT%TZ)"
  else
    echo "ELAB_FAILED CONFIG=$cfg UTC=$(date -u +%FT%TZ)"
    tail -60 "$out/elaboration.log"
    exit 1
  fi
done
echo REFRESH_OK
