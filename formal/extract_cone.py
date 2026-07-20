#!/usr/bin/env python3
"""Compute the module dependency cone of a root module from a directory of
Verilog/SystemVerilog sources (one-or-more modules per file), and report the
files needed. Used to carve a self-contained fileset for formal analysis of the
XiangShan core (XSCore / XSTile) out of the frozen XSTop rtl/.

Usage: extract_cone.py <rtl_dir> <root_module> [--copy <out_dir>]
"""
import sys, os, re, shutil

rtl_dir = sys.argv[1]
root = sys.argv[2]
out_dir = None
if "--copy" in sys.argv:
    out_dir = sys.argv[sys.argv.index("--copy") + 1]

files = [f for f in os.listdir(rtl_dir) if f.endswith((".sv", ".v"))]

# module name -> defining file ; and file -> list of instantiated module names
mod_def = {}                 # module -> file
file_mods = {}               # file -> set(modules defined)
file_insts = {}              # file -> set(candidate instantiated type names)

mod_re  = re.compile(r'^\s*module\s+([A-Za-z_][A-Za-z0-9_$]*)\b')
# instantiation in firtool-emitted Verilog: `<Indent><Type> <inst> (` ; also
# `<Type> #(...) <inst> (`. Capture the leading type token.
inst_re = re.compile(r'^\s+([A-Za-z_][A-Za-z0-9_$]*)\s+(?:#\([^;]*\)\s*)?[A-Za-z_][A-Za-z0-9_$]*\s*\(')

for f in files:
    mods, insts = set(), set()
    with open(os.path.join(rtl_dir, f), errors="replace") as fh:
        for line in fh:
            m = mod_re.match(line)
            if m:
                mods.add(m.group(1)); mod_def[m.group(1)] = f
                continue
            i = inst_re.match(line)
            if i:
                insts.add(i.group(1))
    file_mods[f] = mods
    file_insts[f] = insts

# SystemVerilog keywords that can appear in the "type name inst (" position but
# are not module instantiations.
KW = {"module","endmodule","input","output","inout","wire","reg","logic","assign",
      "always","always_ff","always_comb","always_latch","initial","begin","end",
      "if","else","for","case","casez","casex","endcase","function","endfunction",
      "task","endtask","generate","endgenerate","genvar","localparam","parameter",
      "typedef","struct","union","enum","packed","signed","unsigned","return",
      "posedge","negedge","or","and","not","wait","force","release","default"}

# BFS the cone from root over module instantiations.
seen, queue, missing = set(), [root], set()
while queue:
    mod = queue.pop()
    if mod in seen: continue
    seen.add(mod)
    f = mod_def.get(mod)
    if f is None:
        missing.add(mod); continue
    for cand in file_insts[f]:
        if cand in KW: continue
        if cand in mod_def and cand not in seen:
            queue.append(cand)
        # candidates not in mod_def are primitives/params/blackboxes -> ignore

cone_files = sorted({mod_def[m] for m in seen if m in mod_def})
# real missing = instantiated names that resolve nowhere (potential blackboxes)
real_missing = sorted(m for m in missing if m not in KW)

print(f"root                 : {root}")
print(f"modules in cone      : {len(seen)}")
print(f"files in cone        : {len(cone_files)} / {len(files)} total")
tot = sum(os.path.getsize(os.path.join(rtl_dir,f)) for f in cone_files)
print(f"cone size            : {tot/1048576:.1f} MB")
print(f"unresolved instances : {len(real_missing)}  {real_missing[:12]}")

if out_dir:
    os.makedirs(out_dir, exist_ok=True)
    for f in cone_files:
        shutil.copy(os.path.join(rtl_dir, f), os.path.join(out_dir, f))
    with open(os.path.join(out_dir, "cone.f"), "w") as fh:
        fh.write("\n".join(cone_files) + "\n")
    print(f"copied {len(cone_files)} files -> {out_dir}")
