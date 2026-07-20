// BMC of XiangShan's rename FreeList with UNCONSTRAINED inputs.
//
// This is a teaching example: it shows the formal flow running end-to-end on a
// real core block, AND why real RTL needs environment assumptions. With io_free
// and io_doAllocate left free, the solver violates the freelist's usage contract
// (frees registers that were never allocated / allocates when empty), so the
// no-overflow property fails within a handful of steps and sby dumps a trace.
//
// Two facts about this block that any real proof must model:
//   * at reset the freelist is ALL-ALLOCATED (io_validCount = 0): the 16 physical
//     registers hold the initial architectural map, and become free as the
//     consumer frees committed registers.
//   * the free path is registered (1-cycle delay), so io_validCount lags io_free.
// A sound proof needs a ghost "outstanding" counter matching that timing.
module freelist_bmc (
  input        clock,
  input        reset,
  input        io_doAllocate_0,
  input        io_doAllocate_1,
  input [15:0] io_free
);
  wire [3:0] slot0, slot1;
  wire [4:0] io_validCount;
  FreeList dut (
    .clock(clock), .reset(reset),
    .io_allocateSlot_0(slot0), .io_allocateSlot_1(slot1),
    .io_doAllocate_0(io_doAllocate_0), .io_doAllocate_1(io_doAllocate_1),
    .io_free(io_free), .io_validCount(io_validCount)
  );
  initial assume (reset);
  always @(posedge clock)
    if (!reset)
      assert (io_validCount <= 5'd16);   // FAILS under unconstrained inputs -> real trace
endmodule
