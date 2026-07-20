#!/bin/bash
# Unbounded equivalence proof (PASS): Adder_2 == 8-bit modular subtraction.
set -e; cd "$(dirname "$0")"
sv2v -DSYNTHESIS --write=Adder_2.v Adder_2.sv
sby -f adder_eq.sby
