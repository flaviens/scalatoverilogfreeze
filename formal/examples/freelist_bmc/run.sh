#!/bin/bash
# BMC (expected FAIL, produces a trace): FreeList no-overflow under free inputs.
set -e; cd "$(dirname "$0")"
sv2v -DSYNTHESIS --write=FreeList.v FreeList.sv
sby -f freelist_bmc.sby
