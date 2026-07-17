// Testbench for the FROZEN XiangShan XSTop.
//
// XSTop is the FPGA-platform SoC top: it is an AXI4 *master* on both `memory`
// (48-bit addr, 256-bit data) and `peripheral` (31-bit addr, 64-bit data), and
// has no difftest instrumentation. To run real code we give it a behavioural
// AXI4 slave memory preloaded with a program, point io_riscv_rst_vec_0 at it,
// and use io_riscv_wfi_0 as the completion signal.
//
// The program only reaches its final WFI if every arithmetic/branch check
// passes, so wfi asserting is a positive proof of correct execution.

`timescale 1ns/1ps

module tb;

  // ---------------- clock / reset ----------------
  logic clk = 0;
  logic rst = 1;
  logic rtc = 0;
  always #1 clk = ~clk;      // 500 MHz nominal
  always #50 rtc = ~rtc;     // slow RTC for CLINT

  // ---------------- memory model ----------------
  // 64 MB of DRAM at 0x8000_0000, as 256-bit lines (32 B each).
  localparam longint MEM_BASE  = 64'h8000_0000;
  localparam int     MEM_LINES = 2*1024*1024;   // 2M * 32B = 64MB
  logic [255:0] mem [0:MEM_LINES-1];

  function automatic int line_of(input logic [47:0] addr);
    return int'((addr - MEM_BASE) >> 5);
  endfunction

  // Reads outside the modelled DRAM window return zeros rather than indexing
  // out of bounds; writes outside it are dropped and counted.
  function automatic logic [255:0] mem_read(input int idx);
    if (idx >= 0 && idx < MEM_LINES) return mem[idx];
    else return 256'h0;
  endfunction

  int unsigned oob_accesses = 0;

  // ---------------- XSTop AXI: memory ----------------
  wire         memory_awvalid, memory_wvalid, memory_bready;
  wire         memory_arvalid, memory_rready;
  wire [13:0]  memory_awid, memory_arid;
  wire [47:0]  memory_awaddr, memory_araddr;
  wire [7:0]   memory_awlen, memory_arlen;
  wire [2:0]   memory_awsize, memory_arsize;
  wire [255:0] memory_wdata;
  wire [31:0]  memory_wstrb;
  wire         memory_wlast;

  logic        memory_awready = 0, memory_wready = 0, memory_bvalid = 0;
  logic [13:0] memory_bid = 0;
  logic        memory_arready = 0, memory_rvalid = 0, memory_rlast = 0;
  logic [13:0] memory_rid = 0;
  logic [255:0] memory_rdata = 0;

  // ---------------- XSTop AXI: peripheral ----------------
  wire         peripheral_awvalid, peripheral_wvalid, peripheral_bready;
  wire         peripheral_arvalid, peripheral_rready;
  wire [1:0]   peripheral_awid, peripheral_arid;
  wire [30:0]  peripheral_awaddr, peripheral_araddr;
  wire [7:0]   peripheral_awlen, peripheral_arlen;
  wire [63:0]  peripheral_wdata;
  wire         peripheral_wlast;

  logic        peripheral_awready = 0, peripheral_wready = 0, peripheral_bvalid = 0;
  logic [1:0]  peripheral_bid = 0;
  logic        peripheral_arready = 0, peripheral_rvalid = 0, peripheral_rlast = 0;
  logic [1:0]  peripheral_rid = 0;
  logic [63:0] peripheral_rdata = 0;

  wire wfi;
  wire critical_error;

  // ---------------- DUT ----------------
  XSTop dut (
    .nmi_0_0(1'b0), .nmi_0_1(1'b0),

    .peripheral_awready(peripheral_awready), .peripheral_awvalid(peripheral_awvalid),
    .peripheral_awid(peripheral_awid), .peripheral_awaddr(peripheral_awaddr),
    .peripheral_awlen(peripheral_awlen), .peripheral_awsize(), .peripheral_awburst(),
    .peripheral_awlock(), .peripheral_awcache(), .peripheral_awprot(), .peripheral_awqos(),
    .peripheral_wready(peripheral_wready), .peripheral_wvalid(peripheral_wvalid),
    .peripheral_wdata(peripheral_wdata), .peripheral_wstrb(), .peripheral_wlast(peripheral_wlast),
    .peripheral_bready(peripheral_bready), .peripheral_bvalid(peripheral_bvalid),
    .peripheral_bid(peripheral_bid), .peripheral_bresp(2'b00),
    .peripheral_arready(peripheral_arready), .peripheral_arvalid(peripheral_arvalid),
    .peripheral_arid(peripheral_arid), .peripheral_araddr(peripheral_araddr),
    .peripheral_arlen(peripheral_arlen), .peripheral_arsize(), .peripheral_arburst(),
    .peripheral_arlock(), .peripheral_arcache(), .peripheral_arprot(), .peripheral_arqos(),
    .peripheral_rready(peripheral_rready), .peripheral_rvalid(peripheral_rvalid),
    .peripheral_rid(peripheral_rid), .peripheral_rdata(peripheral_rdata),
    .peripheral_rresp(2'b00), .peripheral_rlast(peripheral_rlast),

    .memory_awready(memory_awready), .memory_awvalid(memory_awvalid),
    .memory_awid(memory_awid), .memory_awaddr(memory_awaddr),
    .memory_awlen(memory_awlen), .memory_awsize(memory_awsize), .memory_awburst(),
    .memory_awlock(), .memory_awcache(), .memory_awprot(), .memory_awqos(),
    .memory_wready(memory_wready), .memory_wvalid(memory_wvalid),
    .memory_wdata(memory_wdata), .memory_wstrb(memory_wstrb), .memory_wlast(memory_wlast),
    .memory_bready(memory_bready), .memory_bvalid(memory_bvalid),
    .memory_bid(memory_bid), .memory_bresp(2'b00),
    .memory_arready(memory_arready), .memory_arvalid(memory_arvalid),
    .memory_arid(memory_arid), .memory_araddr(memory_araddr),
    .memory_arlen(memory_arlen), .memory_arsize(memory_arsize), .memory_arburst(),
    .memory_arlock(), .memory_arcache(), .memory_arprot(), .memory_arqos(),
    .memory_rready(memory_rready), .memory_rvalid(memory_rvalid),
    .memory_rid(memory_rid), .memory_rdata(memory_rdata),
    .memory_rresp(2'b00), .memory_rlast(memory_rlast),

    .io_clock(clk), .io_reset(rst),
    .io_sram_config(16'h0),
    .io_extIntrs(64'h0),
    .io_pll0_lock(1'b1), .io_pll0_ctrl_0(), .io_pll0_ctrl_1(), .io_pll0_ctrl_2(),
    .io_pll0_ctrl_3(), .io_pll0_ctrl_4(), .io_pll0_ctrl_5(),
    .io_systemjtag_jtag_TCK(1'b0), .io_systemjtag_jtag_TMS(1'b0), .io_systemjtag_jtag_TDI(1'b0),
    .io_systemjtag_jtag_TDO_data(), .io_systemjtag_jtag_TDO_driven(),
    .io_systemjtag_reset(1'b1),
    .io_systemjtag_mfr_id(11'h0), .io_systemjtag_part_number(16'h0), .io_systemjtag_version(4'h0),
    .io_debug_reset(),
    .io_rtc_clock(rtc),
    .io_cacheable_check_req_0_valid(1'b0), .io_cacheable_check_req_0_bits_addr(48'h0),
    .io_cacheable_check_req_0_bits_size(2'h0), .io_cacheable_check_req_0_bits_cmd(3'h0),
    .io_cacheable_check_req_1_valid(1'b0), .io_cacheable_check_req_1_bits_addr(48'h0),
    .io_cacheable_check_req_1_bits_size(2'h0), .io_cacheable_check_req_1_bits_cmd(3'h0),
    .io_cacheable_check_resp_0_ld(), .io_cacheable_check_resp_0_st(), .io_cacheable_check_resp_0_instr(),
    .io_cacheable_check_resp_0_mmio(), .io_cacheable_check_resp_0_atomic(),
    .io_cacheable_check_resp_1_ld(), .io_cacheable_check_resp_1_st(), .io_cacheable_check_resp_1_instr(),
    .io_cacheable_check_resp_1_mmio(), .io_cacheable_check_resp_1_atomic(),
    .io_riscv_wfi_0(wfi),
    .io_riscv_critical_error_0(critical_error),
    .io_riscv_rst_vec_0(48'h8000_0000),
    .io_traceCoreInterface_0_fromEncoder_enable(1'b0),
    .io_traceCoreInterface_0_fromEncoder_stall(1'b0),
    .io_traceCoreInterface_0_toEncoder_cause(), .io_traceCoreInterface_0_toEncoder_tval(),
    .io_traceCoreInterface_0_toEncoder_priv(), .io_traceCoreInterface_0_toEncoder_mstatus(),
    .io_traceCoreInterface_0_toEncoder_valid(), .io_traceCoreInterface_0_toEncoder_iaddr(),
    .io_traceCoreInterface_0_toEncoder_itype(), .io_traceCoreInterface_0_toEncoder_iretire(),
    .io_traceCoreInterface_0_toEncoder_ilastsize()
  );

  // ---------------- AXI4 slave: memory (single outstanding, INCR) ----------------
  int unsigned read_beats = 0, write_beats = 0;
  int first_fetch_line = -1;

  // read channel
  typedef enum {R_IDLE, R_RESP} rstate_e;
  rstate_e rstate = R_IDLE;
  logic [47:0] r_addr; logic [7:0] r_len; logic [13:0] r_id; int r_beat;

  always @(posedge clk) begin
    if (rst) begin
      rstate <= R_IDLE; memory_arready <= 0; memory_rvalid <= 0; memory_rlast <= 0;
    end else begin
      case (rstate)
        R_IDLE: begin
          memory_rvalid <= 0; memory_rlast <= 0; memory_arready <= 1;
          if (memory_arvalid && memory_arready) begin
            r_addr <= memory_araddr; r_len <= memory_arlen; r_id <= memory_arid;
            r_beat <= 0; memory_arready <= 0; rstate <= R_RESP;
            if (first_fetch_line == -1) first_fetch_line = line_of(memory_araddr);
            mem_ar_count++;
            if (mem_ar_count <= log_ar)
              $display("[AR] mem #%0d addr=0x%h len=%0d size=%0d @cyc %0d",
                       mem_ar_count, memory_araddr, memory_arlen, memory_arsize, cycle);
          end
        end
        R_RESP: begin
          memory_rvalid <= 1;
          memory_rid    <= r_id;
          memory_rdata  <= mem_read(line_of(r_addr) + r_beat);
          memory_rlast  <= (r_beat == int'(r_len));
          if (memory_rvalid && memory_rready) begin
            read_beats++;
            if (r_beat == int'(r_len)) begin
              memory_rvalid <= 0; memory_rlast <= 0; rstate <= R_IDLE;
            end else r_beat <= r_beat + 1;
          end
        end
      endcase
    end
  end

  // write channel
  typedef enum {W_IDLE, W_DATA, W_RESP} wstate_e;
  wstate_e wstate = W_IDLE;
  logic [47:0] w_addr; logic [13:0] w_id; int w_beat;

  always @(posedge clk) begin
    if (rst) begin
      wstate <= W_IDLE; memory_awready <= 0; memory_wready <= 0; memory_bvalid <= 0;
    end else begin
      case (wstate)
        W_IDLE: begin
          memory_bvalid <= 0; memory_awready <= 1; memory_wready <= 0;
          if (memory_awvalid && memory_awready) begin
            w_addr <= memory_awaddr; w_id <= memory_awid; w_beat <= 0;
            memory_awready <= 0; wstate <= W_DATA;
          end
        end
        W_DATA: begin
          memory_wready <= 1;
          if (memory_wvalid && memory_wready) begin
            if (line_of(w_addr) + w_beat >= 0 && line_of(w_addr) + w_beat < MEM_LINES) begin
              for (int b = 0; b < 32; b++)
                if (memory_wstrb[b]) mem[line_of(w_addr) + w_beat][b*8 +: 8] <= memory_wdata[b*8 +: 8];
            end else oob_accesses++;
            write_beats++;
            if (memory_wlast) begin
              memory_wready <= 0; wstate <= W_RESP;
            end else w_beat <= w_beat + 1;
          end
        end
        W_RESP: begin
          memory_bvalid <= 1; memory_bid <= w_id;
          if (memory_bvalid && memory_bready) begin memory_bvalid <= 0; wstate <= W_IDLE; end
        end
      endcase
    end
  end

  // ---------------- AXI4 slave: peripheral (accept-and-discard) ----------------
  int unsigned periph_writes = 0;
  logic [7:0] p_len; int p_beat;
  typedef enum {P_IDLE, P_RESP} pstate_e;
  pstate_e prstate = P_IDLE;

  always @(posedge clk) begin
    if (rst) begin
      peripheral_awready <= 0; peripheral_wready <= 0; peripheral_bvalid <= 0;
      peripheral_arready <= 0; peripheral_rvalid <= 0; peripheral_rlast <= 0;
      prstate <= P_IDLE;
    end else begin
      // writes: always accept
      peripheral_awready <= 1;
      peripheral_wready  <= 1;
      if (peripheral_wvalid && peripheral_wready) periph_writes++;
      peripheral_bvalid  <= peripheral_wvalid && peripheral_wlast;
      peripheral_bid     <= peripheral_awid;
      // reads: return zeros
      case (prstate)
        P_IDLE: begin
          peripheral_rvalid <= 0; peripheral_rlast <= 0; peripheral_arready <= 1;
          if (peripheral_arvalid && peripheral_arready) begin
            p_len <= peripheral_arlen; p_beat <= 0; peripheral_rid <= peripheral_arid;
            peripheral_arready <= 0; prstate <= P_RESP; periph_reads++;
            if (periph_reads <= log_ar)
              $display("[AR] periph read #%0d addr=0x%h @cyc %0d",
                       periph_reads, peripheral_araddr, cycle);
          end
        end
        P_RESP: begin
          peripheral_rvalid <= 1; peripheral_rdata <= 64'h0;
          peripheral_rlast <= (p_beat == int'(p_len));
          if (peripheral_rvalid && peripheral_rready) begin
            if (p_beat == int'(p_len)) begin
              peripheral_rvalid <= 0; peripheral_rlast <= 0; prstate <= P_IDLE;
            end else p_beat <= p_beat + 1;
          end
        end
      endcase
    end
  end

  // ---------------- run ----------------
  string hexfile;
  longint unsigned max_cycles;
  longint unsigned cycle = 0;
  int unsigned reset_cycles;
  int unsigned log_ar;
  int unsigned periph_reads = 0;
  int unsigned mem_ar_count = 0;

  initial begin
    if (!$value$plusargs("hex=%s", hexfile)) hexfile = "prog.hex";
    if (!$value$plusargs("max_cycles=%d", max_cycles)) max_cycles = 3_000_000;
    if (!$value$plusargs("reset_cycles=%d", reset_cycles)) reset_cycles = 200;
    if (!$value$plusargs("log_ar=%d", log_ar)) log_ar = 0;
    foreach (mem[i]) mem[i] = 256'h0;
    $readmemh(hexfile, mem);
    $display("[TB] loaded %s, rst_vec=0x80000000, max_cycles=%0d", hexfile, max_cycles);
    $display("[TB] mem[0]=%h", mem[0]);
    $fflush();

    repeat (reset_cycles) @(posedge clk);
    rst <= 0;
    $display("[TB] reset released at %0t", $time);
    $fflush();
  end

  // heartbeat, so a killed/slow run still shows how far it got
  always @(posedge clk) begin
    if (!rst && (cycle % 50000 == 0) && cycle > 0) begin
      $display("[TB] cycle %0d: mem_ar=%0d read_beats=%0d write_beats=%0d periph_rd=%0d periph_wr=%0d wfi=%0b",
               cycle, mem_ar_count, read_beats, write_beats, periph_reads, periph_writes, wfi);
      $fflush();
    end
  end

  always @(posedge clk) begin
    if (!rst) begin
      cycle <= cycle + 1;

      if (critical_error) begin
        $display("[TB] *** critical_error asserted at cycle %0d ***", cycle);
        $display("XSTOP_RESULT: FAIL (critical_error)");
        $fflush();
        $finish;
      end
      if (wfi) begin
        $display("[TB] WFI at cycle %0d", cycle);
        $display("[TB] memory read beats=%0d write beats=%0d, peripheral writes=%0d",
                 read_beats, write_beats, periph_writes);
        $display("[TB] first fetch line=%0d (expect 0 => 0x80000000)", first_fetch_line);
        if (read_beats > 0)
          $display("XSTOP_RESULT: PASS (executed to WFI after %0d cycles)", cycle);
        else
          $display("XSTOP_RESULT: FAIL (WFI but no instruction fetch seen)");
        $fflush();
        $finish;
      end
      if (cycle > max_cycles) begin
        $display("[TB] timeout at cycle %0d; read_beats=%0d write_beats=%0d first_fetch_line=%0d",
                 cycle, read_beats, write_beats, first_fetch_line);
        $display("XSTOP_RESULT: FAIL (timeout, no WFI)");
        $fflush();
        $finish;
      end
    end
  end

endmodule
