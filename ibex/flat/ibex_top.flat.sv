package ibex_pkg;
  typedef struct packed {
    logic [31:0] current_pc;
    logic [31:0] next_pc;
    logic [31:0] last_data_addr;
    logic [31:0] exception_pc;
    logic [31:0] exception_addr;
  } crash_dump_t;
  typedef struct packed {
    logic        dummy_instr_id;
    logic [4:0]  raddr_a;
    logic [4:0]  waddr_a;
    logic        we_a;
    logic [4:0]  raddr_b;
  } core2rf_t;
  typedef enum integer {
    RegFileFF    = 0,
    RegFileFPGA  = 1,
    RegFileLatch = 2
  } regfile_e;
  typedef enum integer {
    RV32MNone        = 0,
    RV32MSlow        = 1,
    RV32MFast        = 2,
    RV32MSingleCycle = 3
  } rv32m_e;
  typedef enum integer {
    RV32BNone       = 0,
    RV32BBalanced   = 1,
    RV32BOTEarlGrey = 2,
    RV32BFull       = 3
  } rv32b_e;
  typedef enum integer {
    RV32Zca        = 0,
    RV32ZcaZcb     = 1,
    RV32ZcaZcmp    = 2,
    RV32ZcaZcbZcmp = 3
  } rv32zc_e;
  typedef enum logic [6:0] {
    OPCODE_LOAD     = 7'h03,
    OPCODE_MISC_MEM = 7'h0f,
    OPCODE_OP_IMM   = 7'h13,
    OPCODE_AUIPC    = 7'h17,
    OPCODE_STORE    = 7'h23,
    OPCODE_OP       = 7'h33,
    OPCODE_LUI      = 7'h37,
    OPCODE_BRANCH   = 7'h63,
    OPCODE_JALR     = 7'h67,
    OPCODE_JAL      = 7'h6f,
    OPCODE_SYSTEM   = 7'h73
  } opcode_e;
  typedef enum logic [6:0] {
    ALU_ADD,
    ALU_SUB,
    ALU_XOR,
    ALU_OR,
    ALU_AND,
    ALU_XNOR,
    ALU_ORN,
    ALU_ANDN,
    ALU_SRA,
    ALU_SRL,
    ALU_SLL,
    ALU_SRO,
    ALU_SLO,
    ALU_ROR,
    ALU_ROL,
    ALU_GREV,
    ALU_GORC,
    ALU_SHFL,
    ALU_UNSHFL,
    ALU_XPERM_N,
    ALU_XPERM_B,
    ALU_XPERM_H,
    ALU_SH1ADD,
    ALU_SH2ADD,
    ALU_SH3ADD,
    ALU_LT,
    ALU_LTU,
    ALU_GE,
    ALU_GEU,
    ALU_EQ,
    ALU_NE,
    ALU_MIN,
    ALU_MINU,
    ALU_MAX,
    ALU_MAXU,
    ALU_PACK,
    ALU_PACKU,
    ALU_PACKH,
    ALU_SEXTB,
    ALU_SEXTH,
    ALU_CLZ,
    ALU_CTZ,
    ALU_CPOP,
    ALU_SLT,
    ALU_SLTU,
    ALU_CMOV,
    ALU_CMIX,
    ALU_FSL,
    ALU_FSR,
    ALU_BSET,
    ALU_BCLR,
    ALU_BINV,
    ALU_BEXT,
    ALU_BCOMPRESS,
    ALU_BDECOMPRESS,
    ALU_BFP,
    ALU_CLMUL,
    ALU_CLMULR,
    ALU_CLMULH,
    ALU_CRC32_B,
    ALU_CRC32C_B,
    ALU_CRC32_H,
    ALU_CRC32C_H,
    ALU_CRC32_W,
    ALU_CRC32C_W
  } alu_op_e;
  typedef enum logic [1:0] {
    MD_OP_MULL,
    MD_OP_MULH,
    MD_OP_DIV,
    MD_OP_REM
  } md_op_e;
  typedef enum logic [1:0] {
    CSR_OP_READ,
    CSR_OP_WRITE,
    CSR_OP_SET,
    CSR_OP_CLEAR
  } csr_op_e;
  typedef enum logic[1:0] {
    PRIV_LVL_M = 2'b11,
    PRIV_LVL_H = 2'b10,
    PRIV_LVL_S = 2'b01,
    PRIV_LVL_U = 2'b00
  } priv_lvl_e;
  typedef enum logic[3:0] {
    XDEBUGVER_NO     = 4'd0,  
    XDEBUGVER_STD    = 4'd4,  
    XDEBUGVER_NONSTD = 4'd15  
  } x_debug_ver_e;
  typedef enum logic[1:0] {
    WB_INSTR_LOAD,   
    WB_INSTR_STORE,  
    WB_INSTR_OTHER   
  } wb_instr_type_e;
  typedef enum logic[1:0] {
    OP_A_REG_A,
    OP_A_FWD,
    OP_A_CURRPC,
    OP_A_IMM
  } op_a_sel_e;
  typedef enum logic {
    IMM_A_Z,
    IMM_A_ZERO
  } imm_a_sel_e;
  typedef enum logic {
    OP_B_REG_B,
    OP_B_IMM
  } op_b_sel_e;
  typedef enum logic [2:0] {
    IMM_B_I,
    IMM_B_S,
    IMM_B_B,
    IMM_B_U,
    IMM_B_J,
    IMM_B_INCR_PC,
    IMM_B_INCR_ADDR
  } imm_b_sel_e;
  typedef enum logic {
    RF_WD_EX,
    RF_WD_CSR
  } rf_wd_sel_e;
  typedef enum logic [3:0] {
    RESET,
    BOOT_SET,
    WAIT_SLEEP,
    SLEEP,
    FIRST_FETCH,
    DECODE,
    FLUSH,
    IRQ_TAKEN,
    DBG_TAKEN_IF,
    DBG_TAKEN_ID
  } ctrl_fsm_e;
  typedef enum logic [2:0] {
    PC_BOOT,
    PC_JUMP,
    PC_EXC,
    PC_ERET,
    PC_DRET,
    PC_BP
  } pc_sel_e;
  typedef enum logic [1:0] {
    INSTR_NOT_EXPANDED,
    INSTR_EXPANDED,         
    INSTR_EXPANDED_COMMIT,  
    INSTR_EXPANDED_LAST     
  } instr_exp_e;
  typedef enum logic [1:0] {
    EXC_PC_EXC,
    EXC_PC_IRQ,
    EXC_PC_DBD,
    EXC_PC_DBG_EXC  
  } exc_pc_sel_e;
  typedef struct packed {
    logic        irq_software;
    logic        irq_timer;
    logic        irq_external;
    logic [14:0] irq_fast;  
  } irqs_t;
  typedef struct packed {
    logic       irq_int;
    logic       irq_ext;
    logic [4:0] lower_cause;
  } exc_cause_t;
  localparam exc_cause_t ExcCauseIrqSoftwareM =
    '{irq_ext: 1'b1, irq_int: 1'b0, lower_cause: 5'd03};
  localparam exc_cause_t ExcCauseIrqTimerM =
    '{irq_ext: 1'b1, irq_int: 1'b0, lower_cause: 5'd07};
  localparam exc_cause_t ExcCauseIrqExternalM =
    '{irq_ext: 1'b1, irq_int: 1'b0, lower_cause: 5'd11};
  localparam exc_cause_t ExcCauseIrqNm =
    '{irq_ext: 1'b1, irq_int: 1'b0, lower_cause: 5'd31};
  localparam exc_cause_t ExcCauseInsnAddrMisa =
    '{irq_ext: 1'b0, irq_int: 1'b0, lower_cause: 5'd00};
  localparam exc_cause_t ExcCauseInstrAccessFault =
    '{irq_ext: 1'b0, irq_int: 1'b0, lower_cause: 5'd01};
  localparam exc_cause_t ExcCauseIllegalInsn =
    '{irq_ext: 1'b0, irq_int: 1'b0, lower_cause: 5'd02};
  localparam exc_cause_t ExcCauseBreakpoint =
    '{irq_ext: 1'b0, irq_int: 1'b0, lower_cause: 5'd03};
  localparam exc_cause_t ExcCauseLoadAccessFault  =
    '{irq_ext: 1'b0, irq_int: 1'b0, lower_cause: 5'd05};
  localparam exc_cause_t ExcCauseStoreAccessFault =
    '{irq_ext: 1'b0, irq_int: 1'b0, lower_cause: 5'd07};
  localparam exc_cause_t ExcCauseEcallUMode =
    '{irq_ext: 1'b0, irq_int: 1'b0, lower_cause: 5'd08};
  localparam exc_cause_t ExcCauseEcallMMode =
    '{irq_ext: 1'b0, irq_int: 1'b0, lower_cause: 5'd11};
  typedef enum logic [4:0] {
    NMI_INT_CAUSE_ECC = 5'b0
  } nmi_int_cause_e;
  typedef enum logic [2:0] {
    DBG_CAUSE_NONE    = 3'h0,
    DBG_CAUSE_EBREAK  = 3'h1,
    DBG_CAUSE_TRIGGER = 3'h2,
    DBG_CAUSE_HALTREQ = 3'h3,
    DBG_CAUSE_STEP    = 3'h4
  } dbg_cause_e;
  parameter int unsigned ADDR_W           = 32;
  parameter int unsigned BUS_SIZE         = 32;
  parameter int unsigned BUS_BYTES        = BUS_SIZE/8;
  parameter int unsigned BUS_W            = $clog2(BUS_BYTES);
  parameter int unsigned IC_SIZE_BYTES    = 4096;
  parameter int unsigned IC_NUM_WAYS      = 2;
  parameter int unsigned IC_LINE_SIZE     = 64;
  parameter int unsigned IC_LINE_BYTES    = IC_LINE_SIZE/8;
  parameter int unsigned IC_LINE_W        = $clog2(IC_LINE_BYTES);
  parameter int unsigned IC_NUM_LINES     = IC_SIZE_BYTES / IC_NUM_WAYS / IC_LINE_BYTES;
  parameter int unsigned IC_LINE_BEATS    = IC_LINE_BYTES / BUS_BYTES;
  parameter int unsigned IC_LINE_BEATS_W  = $clog2(IC_LINE_BEATS);
  parameter int unsigned IC_INDEX_W       = $clog2(IC_NUM_LINES);
  parameter int unsigned IC_INDEX_HI      = IC_INDEX_W + IC_LINE_W - 1;
  parameter int unsigned IC_TAG_SIZE      = ADDR_W - IC_INDEX_W - IC_LINE_W + 1;  
  parameter int unsigned IC_OUTPUT_BEATS  = (BUS_BYTES / 2);  
  parameter int unsigned IC_DATA_ECC_SIZE = 7;
  parameter int unsigned IC_TAG_ECC_SIZE  = 6;
  parameter int unsigned SCRAMBLE_KEY_W   = 128;
  parameter int unsigned SCRAMBLE_NONCE_W = 64;
  parameter int unsigned PMP_MAX_REGIONS      = 16;
  parameter int unsigned PMP_CFG_W            = 8;
  parameter int unsigned PMP_ADDR_MSB         = 33;
  parameter int unsigned PMP_ADDR_LSB         = 2;
  parameter int unsigned PMP_I  = 0;
  parameter int unsigned PMP_I2 = 1;
  parameter int unsigned PMP_D  = 2;
  typedef enum logic [1:0] {
    PMP_ACC_EXEC    = 2'b00,
    PMP_ACC_WRITE   = 2'b01,
    PMP_ACC_READ    = 2'b10
  } pmp_req_e;
  typedef enum logic [1:0] {
    PMP_MODE_OFF   = 2'b00,
    PMP_MODE_TOR   = 2'b01,
    PMP_MODE_NA4   = 2'b10,
    PMP_MODE_NAPOT = 2'b11
  } pmp_cfg_mode_e;
  typedef struct packed {
    logic          lock;
    pmp_cfg_mode_e mode;
    logic          exec;
    logic          write;
    logic          read;
  } pmp_cfg_t;
  typedef struct packed {
    logic rlb;   
    logic mmwp;  
    logic mml;   
  } pmp_mseccfg_t;
  typedef enum logic[11:0] {
    CSR_MVENDORID  = 12'hF11,
    CSR_MARCHID    = 12'hF12,
    CSR_MIMPID     = 12'hF13,
    CSR_MHARTID    = 12'hF14,
    CSR_MCONFIGPTR = 12'hF15,
    CSR_MSTATUS   = 12'h300,
    CSR_MISA      = 12'h301,
    CSR_MIE       = 12'h304,
    CSR_MTVEC     = 12'h305,
    CSR_MCOUNTEREN= 12'h306,
    CSR_MSTATUSH  = 12'h310,
    CSR_MENVCFG   = 12'h30A,
    CSR_MENVCFGH  = 12'h31A,
    CSR_MSCRATCH  = 12'h340,
    CSR_MEPC      = 12'h341,
    CSR_MCAUSE    = 12'h342,
    CSR_MTVAL     = 12'h343,
    CSR_MIP       = 12'h344,
    CSR_PMPCFG0   = 12'h3A0,
    CSR_PMPCFG1   = 12'h3A1,
    CSR_PMPCFG2   = 12'h3A2,
    CSR_PMPCFG3   = 12'h3A3,
    CSR_PMPADDR0  = 12'h3B0,
    CSR_PMPADDR1  = 12'h3B1,
    CSR_PMPADDR2  = 12'h3B2,
    CSR_PMPADDR3  = 12'h3B3,
    CSR_PMPADDR4  = 12'h3B4,
    CSR_PMPADDR5  = 12'h3B5,
    CSR_PMPADDR6  = 12'h3B6,
    CSR_PMPADDR7  = 12'h3B7,
    CSR_PMPADDR8  = 12'h3B8,
    CSR_PMPADDR9  = 12'h3B9,
    CSR_PMPADDR10 = 12'h3BA,
    CSR_PMPADDR11 = 12'h3BB,
    CSR_PMPADDR12 = 12'h3BC,
    CSR_PMPADDR13 = 12'h3BD,
    CSR_PMPADDR14 = 12'h3BE,
    CSR_PMPADDR15 = 12'h3BF,
    CSR_SCONTEXT  = 12'h5A8,
    CSR_MSECCFG   = 12'h747,
    CSR_MSECCFGH  = 12'h757,
    CSR_TSELECT   = 12'h7A0,
    CSR_TDATA1    = 12'h7A1,
    CSR_TDATA2    = 12'h7A2,
    CSR_TDATA3    = 12'h7A3,
    CSR_MCONTEXT  = 12'h7A8,
    CSR_MSCONTEXT = 12'h7AA,
    CSR_DCSR      = 12'h7b0,
    CSR_DPC       = 12'h7b1,
    CSR_DSCRATCH0 = 12'h7b2,  
    CSR_DSCRATCH1 = 12'h7b3,  
    CSR_MCOUNTINHIBIT  = 12'h320,
    CSR_MHPMEVENT3     = 12'h323,
    CSR_MHPMEVENT4     = 12'h324,
    CSR_MHPMEVENT5     = 12'h325,
    CSR_MHPMEVENT6     = 12'h326,
    CSR_MHPMEVENT7     = 12'h327,
    CSR_MHPMEVENT8     = 12'h328,
    CSR_MHPMEVENT9     = 12'h329,
    CSR_MHPMEVENT10    = 12'h32A,
    CSR_MHPMEVENT11    = 12'h32B,
    CSR_MHPMEVENT12    = 12'h32C,
    CSR_MHPMEVENT13    = 12'h32D,
    CSR_MHPMEVENT14    = 12'h32E,
    CSR_MHPMEVENT15    = 12'h32F,
    CSR_MHPMEVENT16    = 12'h330,
    CSR_MHPMEVENT17    = 12'h331,
    CSR_MHPMEVENT18    = 12'h332,
    CSR_MHPMEVENT19    = 12'h333,
    CSR_MHPMEVENT20    = 12'h334,
    CSR_MHPMEVENT21    = 12'h335,
    CSR_MHPMEVENT22    = 12'h336,
    CSR_MHPMEVENT23    = 12'h337,
    CSR_MHPMEVENT24    = 12'h338,
    CSR_MHPMEVENT25    = 12'h339,
    CSR_MHPMEVENT26    = 12'h33A,
    CSR_MHPMEVENT27    = 12'h33B,
    CSR_MHPMEVENT28    = 12'h33C,
    CSR_MHPMEVENT29    = 12'h33D,
    CSR_MHPMEVENT30    = 12'h33E,
    CSR_MHPMEVENT31    = 12'h33F,
    CSR_MCYCLE         = 12'hB00,
    CSR_MINSTRET       = 12'hB02,
    CSR_MHPMCOUNTER3   = 12'hB03,
    CSR_MHPMCOUNTER4   = 12'hB04,
    CSR_MHPMCOUNTER5   = 12'hB05,
    CSR_MHPMCOUNTER6   = 12'hB06,
    CSR_MHPMCOUNTER7   = 12'hB07,
    CSR_MHPMCOUNTER8   = 12'hB08,
    CSR_MHPMCOUNTER9   = 12'hB09,
    CSR_MHPMCOUNTER10  = 12'hB0A,
    CSR_MHPMCOUNTER11  = 12'hB0B,
    CSR_MHPMCOUNTER12  = 12'hB0C,
    CSR_MHPMCOUNTER13  = 12'hB0D,
    CSR_MHPMCOUNTER14  = 12'hB0E,
    CSR_MHPMCOUNTER15  = 12'hB0F,
    CSR_MHPMCOUNTER16  = 12'hB10,
    CSR_MHPMCOUNTER17  = 12'hB11,
    CSR_MHPMCOUNTER18  = 12'hB12,
    CSR_MHPMCOUNTER19  = 12'hB13,
    CSR_MHPMCOUNTER20  = 12'hB14,
    CSR_MHPMCOUNTER21  = 12'hB15,
    CSR_MHPMCOUNTER22  = 12'hB16,
    CSR_MHPMCOUNTER23  = 12'hB17,
    CSR_MHPMCOUNTER24  = 12'hB18,
    CSR_MHPMCOUNTER25  = 12'hB19,
    CSR_MHPMCOUNTER26  = 12'hB1A,
    CSR_MHPMCOUNTER27  = 12'hB1B,
    CSR_MHPMCOUNTER28  = 12'hB1C,
    CSR_MHPMCOUNTER29  = 12'hB1D,
    CSR_MHPMCOUNTER30  = 12'hB1E,
    CSR_MHPMCOUNTER31  = 12'hB1F,
    CSR_MCYCLEH        = 12'hB80,
    CSR_MINSTRETH      = 12'hB82,
    CSR_MHPMCOUNTER3H  = 12'hB83,
    CSR_MHPMCOUNTER4H  = 12'hB84,
    CSR_MHPMCOUNTER5H  = 12'hB85,
    CSR_MHPMCOUNTER6H  = 12'hB86,
    CSR_MHPMCOUNTER7H  = 12'hB87,
    CSR_MHPMCOUNTER8H  = 12'hB88,
    CSR_MHPMCOUNTER9H  = 12'hB89,
    CSR_MHPMCOUNTER10H = 12'hB8A,
    CSR_MHPMCOUNTER11H = 12'hB8B,
    CSR_MHPMCOUNTER12H = 12'hB8C,
    CSR_MHPMCOUNTER13H = 12'hB8D,
    CSR_MHPMCOUNTER14H = 12'hB8E,
    CSR_MHPMCOUNTER15H = 12'hB8F,
    CSR_MHPMCOUNTER16H = 12'hB90,
    CSR_MHPMCOUNTER17H = 12'hB91,
    CSR_MHPMCOUNTER18H = 12'hB92,
    CSR_MHPMCOUNTER19H = 12'hB93,
    CSR_MHPMCOUNTER20H = 12'hB94,
    CSR_MHPMCOUNTER21H = 12'hB95,
    CSR_MHPMCOUNTER22H = 12'hB96,
    CSR_MHPMCOUNTER23H = 12'hB97,
    CSR_MHPMCOUNTER24H = 12'hB98,
    CSR_MHPMCOUNTER25H = 12'hB99,
    CSR_MHPMCOUNTER26H = 12'hB9A,
    CSR_MHPMCOUNTER27H = 12'hB9B,
    CSR_MHPMCOUNTER28H = 12'hB9C,
    CSR_MHPMCOUNTER29H = 12'hB9D,
    CSR_MHPMCOUNTER30H = 12'hB9E,
    CSR_MHPMCOUNTER31H = 12'hB9F,
    CSR_CYCLE          = 12'hC00,
    CSR_INSTRET        = 12'hC02,
    CSR_HPMCOUNTER3    = 12'hC03,
    CSR_HPMCOUNTER4    = 12'hC04,
    CSR_HPMCOUNTER5    = 12'hC05,
    CSR_HPMCOUNTER6    = 12'hC06,
    CSR_HPMCOUNTER7    = 12'hC07,
    CSR_HPMCOUNTER8    = 12'hC08,
    CSR_HPMCOUNTER9    = 12'hC09,
    CSR_HPMCOUNTER10   = 12'hC0A,
    CSR_HPMCOUNTER11   = 12'hC0B,
    CSR_HPMCOUNTER12   = 12'hC0C,
    CSR_HPMCOUNTER13   = 12'hC0D,
    CSR_HPMCOUNTER14   = 12'hC0E,
    CSR_HPMCOUNTER15   = 12'hC0F,
    CSR_HPMCOUNTER16   = 12'hC10,
    CSR_HPMCOUNTER17   = 12'hC11,
    CSR_HPMCOUNTER18   = 12'hC12,
    CSR_HPMCOUNTER19   = 12'hC13,
    CSR_HPMCOUNTER20   = 12'hC14,
    CSR_HPMCOUNTER21   = 12'hC15,
    CSR_HPMCOUNTER22   = 12'hC16,
    CSR_HPMCOUNTER23   = 12'hC17,
    CSR_HPMCOUNTER24   = 12'hC18,
    CSR_HPMCOUNTER25   = 12'hC19,
    CSR_HPMCOUNTER26   = 12'hC1A,
    CSR_HPMCOUNTER27   = 12'hC1B,
    CSR_HPMCOUNTER28   = 12'hC1C,
    CSR_HPMCOUNTER29   = 12'hC1D,
    CSR_HPMCOUNTER30   = 12'hC1E,
    CSR_HPMCOUNTER31   = 12'hC1F,
    CSR_CYCLEH         = 12'hC80,
    CSR_INSTRETH       = 12'hC82,
    CSR_HPMCOUNTER3H   = 12'hC83,
    CSR_HPMCOUNTER4H   = 12'hC84,
    CSR_HPMCOUNTER5H   = 12'hC85,
    CSR_HPMCOUNTER6H   = 12'hC86,
    CSR_HPMCOUNTER7H   = 12'hC87,
    CSR_HPMCOUNTER8H   = 12'hC88,
    CSR_HPMCOUNTER9H   = 12'hC89,
    CSR_HPMCOUNTER10H  = 12'hC8A,
    CSR_HPMCOUNTER11H  = 12'hC8B,
    CSR_HPMCOUNTER12H  = 12'hC8C,
    CSR_HPMCOUNTER13H  = 12'hC8D,
    CSR_HPMCOUNTER14H  = 12'hC8E,
    CSR_HPMCOUNTER15H  = 12'hC8F,
    CSR_HPMCOUNTER16H  = 12'hC90,
    CSR_HPMCOUNTER17H  = 12'hC91,
    CSR_HPMCOUNTER18H  = 12'hC92,
    CSR_HPMCOUNTER19H  = 12'hC93,
    CSR_HPMCOUNTER20H  = 12'hC94,
    CSR_HPMCOUNTER21H  = 12'hC95,
    CSR_HPMCOUNTER22H  = 12'hC96,
    CSR_HPMCOUNTER23H  = 12'hC97,
    CSR_HPMCOUNTER24H  = 12'hC98,
    CSR_HPMCOUNTER25H  = 12'hC99,
    CSR_HPMCOUNTER26H  = 12'hC9A,
    CSR_HPMCOUNTER27H  = 12'hC9B,
    CSR_HPMCOUNTER28H  = 12'hC9C,
    CSR_HPMCOUNTER29H  = 12'hC9D,
    CSR_HPMCOUNTER30H  = 12'hC9E,
    CSR_HPMCOUNTER31H  = 12'hC9F,
    CSR_CPUCTRLSTS     = 12'h7C0,
    CSR_SECURESEED     = 12'h7C1
  } csr_num_e;
  parameter logic [11:0] CSR_OFF_PMP_CFG  = 12'h3A0;  
  parameter logic [11:0] CSR_OFF_PMP_ADDR = 12'h3B0;  
  parameter int unsigned CSR_MSTATUS_MIE_BIT      = 3;
  parameter int unsigned CSR_MSTATUS_MPIE_BIT     = 7;
  parameter int unsigned CSR_MSTATUS_MPP_BIT_LOW  = 11;
  parameter int unsigned CSR_MSTATUS_MPP_BIT_HIGH = 12;
  parameter int unsigned CSR_MSTATUS_MPRV_BIT     = 17;
  parameter int unsigned CSR_MSTATUS_TW_BIT       = 21;
  parameter logic [1:0] CSR_MISA_MXL = 2'd1;  
  parameter int unsigned CSR_MSIX_BIT      = 3;
  parameter int unsigned CSR_MTIX_BIT      = 7;
  parameter int unsigned CSR_MEIX_BIT      = 11;
  parameter int unsigned CSR_MFIX_BIT_LOW  = 16;
  parameter int unsigned CSR_MFIX_BIT_HIGH = 30;
  parameter int unsigned CSR_MSECCFG_MML_BIT  = 0;
  parameter int unsigned CSR_MSECCFG_MMWP_BIT = 1;
  parameter int unsigned CSR_MSECCFG_RLB_BIT  = 2;
  localparam logic [31:0] CSR_MARCHID_VALUE = {1'b0, 31'd22};
  localparam logic [31:0] CSR_MCONFIGPTR_VALUE = 32'b0;
  parameter int LfsrWidth = 32;
  typedef logic [LfsrWidth-1:0] lfsr_seed_t;
  typedef logic [LfsrWidth-1:0][$clog2(LfsrWidth)-1:0] lfsr_perm_t;
  parameter lfsr_seed_t RndCnstLfsrSeedDefault = 32'hac533bf4;
  parameter lfsr_perm_t RndCnstLfsrPermDefault = {
    160'h1e35ecba467fd1b12e958152c04fa43878a8daed
  };
  parameter logic [SCRAMBLE_KEY_W-1:0]   RndCnstIbexKeyDefault =
      128'h14e8cecae3040d5e12286bb3cc113298;
  parameter logic [SCRAMBLE_NONCE_W-1:0] RndCnstIbexNonceDefault =
      64'hf79780bc735f3843;
  parameter int IbexMuBiWidth = 4;
  typedef logic [IbexMuBiWidth-1:0] ibex_mubi_t;
  parameter ibex_mubi_t IbexMuBiOn  = 4'b0101;
  parameter ibex_mubi_t IbexMuBiOff = 4'b1010;
  parameter pmp_cfg_t PmpCfgRst[PMP_MAX_REGIONS] = '{
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0},  
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0},  
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0},  
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0},  
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0},  
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0},  
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0},  
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0},  
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0},  
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0},  
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0},  
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0},  
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0},  
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0},  
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0},  
    '{lock: 1'b0, mode: PMP_MODE_OFF, exec: 1'b0, write: 1'b0, read: 1'b0}   
  };
  parameter logic [PMP_ADDR_MSB:0] PmpAddrRst[PMP_MAX_REGIONS] = '{
    34'h0,  
    34'h0,  
    34'h0,  
    34'h0,  
    34'h0,  
    34'h0,  
    34'h0,  
    34'h0,  
    34'h0,  
    34'h0,  
    34'h0,  
    34'h0,  
    34'h0,  
    34'h0,  
    34'h0,  
    34'h0   
  };
  parameter pmp_mseccfg_t PmpMseccfgRst = '{rlb : 1'b0, mmwp: 1'b0, mml: 1'b0};
endpackage
package prim_ram_1p_pkg;
  parameter int unsigned Ram1pReqWidth = 32'd12;
  parameter int unsigned Ram1pRspWidth = 32'd1;
  typedef struct packed {
    logic [Ram1pReqWidth-1:0] req;
  } ram_1p_cfg_req_t;
  typedef struct packed {
    logic [Ram1pRspWidth-1:0] rsp;
  } ram_1p_cfg_rsp_t;
  parameter ram_1p_cfg_req_t RAM_1P_CFG_REQ_DEFAULT = '0;
  parameter ram_1p_cfg_rsp_t RAM_1P_CFG_RSP_DEFAULT = '0;
endpackage  
package prim_ram_2p_pkg;
  parameter int unsigned Ram2pReqWidth = 32'd7;
  parameter int unsigned Ram2pRspWidth = 32'd1;
  typedef struct packed {
    logic [Ram2pReqWidth-1:0] req;
  } ram_2p_cfg_req_t;
  typedef struct packed {
    logic [Ram2pRspWidth-1:0] rsp;
  } ram_2p_cfg_rsp_t;
  parameter ram_2p_cfg_req_t RAM_2P_CFG_REQ_DEFAULT = '0;
  parameter ram_2p_cfg_rsp_t RAM_2P_CFG_RSP_DEFAULT = '0;
endpackage  
package prim_rom_pkg;
  typedef struct packed {
    logic       test;
    logic       cfg_en;
    logic [3:0] cfg;
  } rom_cfg_t;
  parameter rom_cfg_t ROM_CFG_DEFAULT = '0;
endpackage  
package prim_ram_1r1w_pkg;
  parameter int unsigned Ram1r1wReqWidth = prim_ram_2p_pkg::Ram2pReqWidth;
  parameter int unsigned Ram1r1wRspWidth = prim_ram_2p_pkg::Ram2pRspWidth;
  typedef prim_ram_2p_pkg::ram_2p_cfg_req_t ram_1r1w_cfg_req_t;
  typedef prim_ram_2p_pkg::ram_2p_cfg_rsp_t ram_1r1w_cfg_rsp_t;
  parameter ram_1r1w_cfg_req_t RAM_1R1W_CFG_REQ_DEFAULT = '0;
  parameter ram_1r1w_cfg_rsp_t RAM_1R1W_CFG_RSP_DEFAULT = '0;
endpackage  
package prim_cipher_pkg;
  parameter logic [15:0][3:0] PRINCE_SBOX4 = {4'h4, 4'hD, 4'h5, 4'hE,
                                              4'h0, 4'h8, 4'h7, 4'h6,
                                              4'h1, 4'h9, 4'hC, 4'hA,
                                              4'h2, 4'h3, 4'hF, 4'hB};
  parameter logic [15:0][3:0] PRINCE_SBOX4_INV = {4'h1, 4'hC, 4'hE, 4'h5,
                                                  4'h0, 4'h4, 4'h6, 4'hA,
                                                  4'h9, 4'h8, 4'hD, 4'hF,
                                                  4'h2, 4'h3, 4'h7, 4'hB};
  parameter logic [15:0][3:0] PRINCE_SHIFT_ROWS64  = '{4'hF, 4'hA, 4'h5, 4'h0,
                                                       4'hB, 4'h6, 4'h1, 4'hC,
                                                       4'h7, 4'h2, 4'hD, 4'h8,
                                                       4'h3, 4'hE, 4'h9, 4'h4};
  parameter logic [15:0][3:0] PRINCE_SHIFT_ROWS64_INV = '{4'hF, 4'h2, 4'h5, 4'h8,
                                                          4'hB, 4'hE, 4'h1, 4'h4,
                                                          4'h7, 4'hA, 4'hD, 4'h0,
                                                          4'h3, 4'h6, 4'h9, 4'hC};
  parameter logic [11:0][63:0] PRINCE_ROUND_CONST = {64'hC0AC29B7C97C50DD,
                                                     64'hD3B5A399CA0C2399,
                                                     64'h64A51195E0E3610D,
                                                     64'hC882D32F25323C54,
                                                     64'h85840851F1AC43AA,
                                                     64'h7EF84F78FD955CB1,
                                                     64'hBE5466CF34E90C6C,
                                                     64'h452821E638D01377,
                                                     64'h082EFA98EC4E6C89,
                                                     64'hA4093822299F31D0,
                                                     64'h13198A2E03707344,
                                                     64'h0000000000000000};
  parameter logic [63:0] PRINCE_ALPHA_CONST = 64'hC0AC29B7C97C50DD;
  parameter logic [15:0] PRINCE_SHIFT_ROWS_CONST0 = 16'h7BDE;
  parameter logic [15:0] PRINCE_SHIFT_ROWS_CONST1 = 16'hBDE7;
  parameter logic [15:0] PRINCE_SHIFT_ROWS_CONST2 = 16'hDE7B;
  parameter logic [15:0] PRINCE_SHIFT_ROWS_CONST3 = 16'hE7BD;
  function automatic logic [31:0] prince_shiftrows_32bit(logic [31:0]      state_in,
                                                         logic [15:0][3:0] shifts );
    logic [31:0] state_out;
    for (int k = 0; k < 32/2; k++) begin
      state_out[k*2  +: 2] = state_in[shifts[k]*2  +: 2];
    end
    return state_out;
  endfunction : prince_shiftrows_32bit
  function automatic logic [63:0] prince_shiftrows_64bit(logic [63:0]      state_in,
                                                         logic [15:0][3:0] shifts );
    logic [63:0] state_out;
    for (int k = 0; k < 64/4; k++) begin
      state_out[k*4  +: 4] = state_in[shifts[k]*4  +: 4];
    end
    return state_out;
  endfunction : prince_shiftrows_64bit
  function automatic logic [3:0] prince_nibble_red16(logic [15:0] vect);
    return vect[0 +: 4] ^ vect[4 +: 4] ^ vect[8 +: 4] ^ vect[12 +: 4];
  endfunction : prince_nibble_red16
  function automatic logic [31:0] prince_mult_prime_32bit(logic [31:0] state_in);
    logic [31:0] state_out;
    state_out[0  +: 4] = prince_nibble_red16(state_in[ 0 +: 16] & PRINCE_SHIFT_ROWS_CONST3);
    state_out[4  +: 4] = prince_nibble_red16(state_in[ 0 +: 16] & PRINCE_SHIFT_ROWS_CONST2);
    state_out[8  +: 4] = prince_nibble_red16(state_in[ 0 +: 16] & PRINCE_SHIFT_ROWS_CONST1);
    state_out[12 +: 4] = prince_nibble_red16(state_in[ 0 +: 16] & PRINCE_SHIFT_ROWS_CONST0);
    state_out[16 +: 4] = prince_nibble_red16(state_in[16 +: 16] & PRINCE_SHIFT_ROWS_CONST0);
    state_out[20 +: 4] = prince_nibble_red16(state_in[16 +: 16] & PRINCE_SHIFT_ROWS_CONST3);
    state_out[24 +: 4] = prince_nibble_red16(state_in[16 +: 16] & PRINCE_SHIFT_ROWS_CONST2);
    state_out[28 +: 4] = prince_nibble_red16(state_in[16 +: 16] & PRINCE_SHIFT_ROWS_CONST1);
    return state_out;
  endfunction : prince_mult_prime_32bit
  function automatic logic [63:0] prince_mult_prime_64bit(logic [63:0] state_in);
    logic [63:0] state_out;
    state_out[0  +: 4] = prince_nibble_red16(state_in[ 0 +: 16] & PRINCE_SHIFT_ROWS_CONST3);
    state_out[4  +: 4] = prince_nibble_red16(state_in[ 0 +: 16] & PRINCE_SHIFT_ROWS_CONST2);
    state_out[8  +: 4] = prince_nibble_red16(state_in[ 0 +: 16] & PRINCE_SHIFT_ROWS_CONST1);
    state_out[12 +: 4] = prince_nibble_red16(state_in[ 0 +: 16] & PRINCE_SHIFT_ROWS_CONST0);
    state_out[16 +: 4] = prince_nibble_red16(state_in[16 +: 16] & PRINCE_SHIFT_ROWS_CONST0);
    state_out[20 +: 4] = prince_nibble_red16(state_in[16 +: 16] & PRINCE_SHIFT_ROWS_CONST3);
    state_out[24 +: 4] = prince_nibble_red16(state_in[16 +: 16] & PRINCE_SHIFT_ROWS_CONST2);
    state_out[28 +: 4] = prince_nibble_red16(state_in[16 +: 16] & PRINCE_SHIFT_ROWS_CONST1);
    state_out[32 +: 4] = prince_nibble_red16(state_in[32 +: 16] & PRINCE_SHIFT_ROWS_CONST0);
    state_out[36 +: 4] = prince_nibble_red16(state_in[32 +: 16] & PRINCE_SHIFT_ROWS_CONST3);
    state_out[40 +: 4] = prince_nibble_red16(state_in[32 +: 16] & PRINCE_SHIFT_ROWS_CONST2);
    state_out[44 +: 4] = prince_nibble_red16(state_in[32 +: 16] & PRINCE_SHIFT_ROWS_CONST1);
    state_out[48 +: 4] = prince_nibble_red16(state_in[48 +: 16] & PRINCE_SHIFT_ROWS_CONST3);
    state_out[52 +: 4] = prince_nibble_red16(state_in[48 +: 16] & PRINCE_SHIFT_ROWS_CONST2);
    state_out[56 +: 4] = prince_nibble_red16(state_in[48 +: 16] & PRINCE_SHIFT_ROWS_CONST1);
    state_out[60 +: 4] = prince_nibble_red16(state_in[48 +: 16] & PRINCE_SHIFT_ROWS_CONST0);
    return state_out;
  endfunction : prince_mult_prime_64bit
  parameter logic [15:0][3:0] PRESENT_SBOX4 = {4'h2, 4'h1, 4'h7, 4'h4,
                                               4'h8, 4'hF, 4'hE, 4'h3,
                                               4'hD, 4'hA, 4'h0, 4'h9,
                                               4'hB, 4'h6, 4'h5, 4'hC};
  parameter logic [15:0][3:0] PRESENT_SBOX4_INV = {4'hA, 4'h9, 4'h7, 4'h0,
                                                   4'h3, 4'h6, 4'h4, 4'hB,
                                                   4'hD, 4'h2, 4'h1, 4'hC,
                                                   4'h8, 4'hF, 4'hE, 4'h5};
  parameter logic [31:0][4:0] PRESENT_PERM32 = {5'd31, 5'd23, 5'd15, 5'd07,
                                                5'd30, 5'd22, 5'd14, 5'd06,
                                                5'd29, 5'd21, 5'd13, 5'd05,
                                                5'd28, 5'd20, 5'd12, 5'd04,
                                                5'd27, 5'd19, 5'd11, 5'd03,
                                                5'd26, 5'd18, 5'd10, 5'd02,
                                                5'd25, 5'd17, 5'd09, 5'd01,
                                                5'd24, 5'd16, 5'd08, 5'd00};
  parameter logic [31:0][4:0] PRESENT_PERM32_INV = {5'd31, 5'd27, 5'd23, 5'd19,
                                                    5'd15, 5'd11, 5'd07, 5'd03,
                                                    5'd30, 5'd26, 5'd22, 5'd18,
                                                    5'd14, 5'd10, 5'd06, 5'd02,
                                                    5'd29, 5'd25, 5'd21, 5'd17,
                                                    5'd13, 5'd09, 5'd05, 5'd01,
                                                    5'd28, 5'd24, 5'd20, 5'd16,
                                                    5'd12, 5'd08, 5'd04, 5'd00};
  parameter logic [63:0][5:0] PRESENT_PERM64 = {6'd63, 6'd47, 6'd31, 6'd15,
                                                6'd62, 6'd46, 6'd30, 6'd14,
                                                6'd61, 6'd45, 6'd29, 6'd13,
                                                6'd60, 6'd44, 6'd28, 6'd12,
                                                6'd59, 6'd43, 6'd27, 6'd11,
                                                6'd58, 6'd42, 6'd26, 6'd10,
                                                6'd57, 6'd41, 6'd25, 6'd09,
                                                6'd56, 6'd40, 6'd24, 6'd08,
                                                6'd55, 6'd39, 6'd23, 6'd07,
                                                6'd54, 6'd38, 6'd22, 6'd06,
                                                6'd53, 6'd37, 6'd21, 6'd05,
                                                6'd52, 6'd36, 6'd20, 6'd04,
                                                6'd51, 6'd35, 6'd19, 6'd03,
                                                6'd50, 6'd34, 6'd18, 6'd02,
                                                6'd49, 6'd33, 6'd17, 6'd01,
                                                6'd48, 6'd32, 6'd16, 6'd00};
  parameter logic [63:0][5:0] PRESENT_PERM64_INV = {6'd63, 6'd59, 6'd55, 6'd51,
                                                    6'd47, 6'd43, 6'd39, 6'd35,
                                                    6'd31, 6'd27, 6'd23, 6'd19,
                                                    6'd15, 6'd11, 6'd07, 6'd03,
                                                    6'd62, 6'd58, 6'd54, 6'd50,
                                                    6'd46, 6'd42, 6'd38, 6'd34,
                                                    6'd30, 6'd26, 6'd22, 6'd18,
                                                    6'd14, 6'd10, 6'd06, 6'd02,
                                                    6'd61, 6'd57, 6'd53, 6'd49,
                                                    6'd45, 6'd41, 6'd37, 6'd33,
                                                    6'd29, 6'd25, 6'd21, 6'd17,
                                                    6'd13, 6'd09, 6'd05, 6'd01,
                                                    6'd60, 6'd56, 6'd52, 6'd48,
                                                    6'd44, 6'd40, 6'd36, 6'd32,
                                                    6'd28, 6'd24, 6'd20, 6'd16,
                                                    6'd12, 6'd08, 6'd04, 6'd00};
  function automatic logic [63:0] present_update_key64(logic [63:0] key_in,
                                                       logic [4:0]  round_idx);
    logic [63:0] key_out;
    key_out = {key_in[63-61:0], key_in[63:64-61]};
    key_out[63 -: 4] = PRESENT_SBOX4[key_out[63 -: 4]];
    key_out[19:15] ^= round_idx;
    return key_out;
  endfunction : present_update_key64
  function automatic logic [79:0] present_update_key80(logic [79:0] key_in,
                                                       logic [4:0]  round_idx);
    logic [79:0] key_out;
    key_out = {key_in[79-61:0], key_in[79:80-61]};
    key_out[79 -: 4] = PRESENT_SBOX4[key_out[79 -: 4]];
    key_out[19:15] ^= round_idx;
    return key_out;
  endfunction : present_update_key80
  function automatic logic [127:0] present_update_key128(logic [127:0] key_in,
                                                         logic [4:0]   round_idx);
    logic [127:0] key_out;
    key_out = {key_in[127-61:0], key_in[127:128-61]};
    key_out[127 -: 4] = PRESENT_SBOX4[key_out[127 -: 4]];
    key_out[123 -: 4] = PRESENT_SBOX4[key_out[123 -: 4]];
    key_out[66:62] ^= round_idx;
    return key_out;
  endfunction : present_update_key128
  function automatic logic [63:0] present_inv_update_key64(logic [63:0] key_in,
                                                           logic [4:0]  round_idx);
    logic [63:0] key_out = key_in;
    key_out[19:15] ^= round_idx;
    key_out[63 -: 4] = PRESENT_SBOX4_INV[key_out[63 -: 4]];
    key_out = {key_out[60:0], key_out[63:61]};
    return key_out;
  endfunction : present_inv_update_key64
  function automatic logic [79:0] present_inv_update_key80(logic [79:0] key_in,
                                                           logic [4:0]  round_idx);
    logic [79:0] key_out = key_in;
    key_out[19:15] ^= round_idx;
    key_out[79 -: 4] = PRESENT_SBOX4_INV[key_out[79 -: 4]];
    key_out = {key_out[60:0], key_out[79:61]};
    return key_out;
  endfunction : present_inv_update_key80
  function automatic logic [127:0] present_inv_update_key128(logic [127:0] key_in,
                                                             logic [4:0]   round_idx);
    logic [127:0] key_out = key_in;
    key_out[66:62] ^= round_idx;
    key_out[123 -: 4] = PRESENT_SBOX4_INV[key_out[123 -: 4]];
    key_out[127 -: 4] = PRESENT_SBOX4_INV[key_out[127 -: 4]];
    key_out = {key_out[60:0], key_out[127:61]};
    return key_out;
  endfunction : present_inv_update_key128
  function automatic logic [63:0] present_get_dec_key64(logic [63:0] key_in,
                                                        logic [4:0]  round_cnt);
    logic [63:0] key_out;
    key_out = key_in;
    for (int unsigned k = 0; k < round_cnt; k++) begin
      key_out = present_update_key64(key_out, 5'(k + 1));
    end
    return key_out;
  endfunction : present_get_dec_key64
  function automatic logic [79:0] present_get_dec_key80(logic [79:0] key_in,
                                                        logic [4:0]  round_cnt);
    logic [79:0] key_out;
    key_out = key_in;
    for (int unsigned k = 0; k < round_cnt; k++) begin
      key_out = present_update_key80(key_out, 5'(k + 1));
    end
    return key_out;
  endfunction : present_get_dec_key80
  function automatic logic [127:0] present_get_dec_key128(logic [127:0] key_in,
                                                          logic [4:0]   round_cnt);
    logic [127:0] key_out;
    key_out = key_in;
    for (int unsigned k = 0; k < round_cnt; k++) begin
      key_out = present_update_key128(key_out, 5'(k + 1));
    end
    return key_out;
  endfunction : present_get_dec_key128
  function automatic logic [7:0] sbox4_8bit(logic [7:0] state_in, logic [15:0][3:0] sbox4);
    logic [7:0] state_out;
    for (int k = 0; k < 8/4; k++) begin
      state_out[k*4  +: 4] = sbox4[state_in[k*4  +: 4]];
    end
    return state_out;
  endfunction : sbox4_8bit
  function automatic logic [15:0] sbox4_16bit(logic [15:0] state_in, logic [15:0][3:0] sbox4);
    logic [15:0] state_out;
    for (int k = 0; k < 2; k++) begin
      state_out[k*8  +: 8] = sbox4_8bit(state_in[k*8  +: 8], sbox4);
    end
    return state_out;
  endfunction : sbox4_16bit
  function automatic logic [31:0] sbox4_32bit(logic [31:0] state_in, logic [15:0][3:0] sbox4);
    logic [31:0] state_out;
    for (int k = 0; k < 4; k++) begin
      state_out[k*8  +: 8] = sbox4_8bit(state_in[k*8  +: 8], sbox4);
    end
    return state_out;
  endfunction : sbox4_32bit
  function automatic logic [63:0] sbox4_64bit(logic [63:0] state_in, logic [15:0][3:0] sbox4);
    logic [63:0] state_out;
    for (int k = 0; k < 8; k++) begin
      state_out[k*8  +: 8] = sbox4_8bit(state_in[k*8  +: 8], sbox4);
    end
    return state_out;
  endfunction : sbox4_64bit
  function automatic logic [7:0] perm_8bit(logic [7:0] state_in, logic [7:0][2:0] perm);
    logic [7:0] state_out;
    for (int k = 0; k < 8; k++) begin
      state_out[perm[k]] = state_in[k];
    end
    return state_out;
  endfunction : perm_8bit
    function automatic logic [15:0] perm_16bit(logic [15:0] state_in, logic [15:0][3:0] perm);
    logic [15:0] state_out;
    for (int k = 0; k < 16; k++) begin
      state_out[perm[k]] = state_in[k];
    end
    return state_out;
  endfunction : perm_16bit
  function automatic logic [31:0] perm_32bit(logic [31:0] state_in, logic [31:0][4:0] perm);
    logic [31:0] state_out;
    for (int k = 0; k < 32; k++) begin
      state_out[perm[k]] = state_in[k];
    end
    return state_out;
  endfunction : perm_32bit
  function automatic logic [63:0] perm_64bit(logic [63:0] state_in, logic [63:0][5:0] perm);
    logic [63:0] state_out;
    for (int k = 0; k < 64; k++) begin
      state_out[perm[k]] = state_in[k];
    end
    return state_out;
  endfunction : perm_64bit
endpackage : prim_cipher_pkg
module prim_and2 #(
  parameter int Width = 1
) (
  input        [Width-1:0] in0_i,
  input        [Width-1:0] in1_i,
  output logic [Width-1:0] out_o
);
  assign out_o = in0_i & in1_i;
endmodule
module prim_buf #(
  parameter int Width = 1
) (
  input        [Width-1:0] in_i,
  output logic [Width-1:0] out_o
);
  logic [Width-1:0] inv;
  assign inv = ~in_i;
  assign out_o = ~inv;
endmodule
module prim_clock_buf #(
  /*verilator lint_off UNUSED*/
  parameter bit NoFpgaBuf = 1'b0,  
  parameter bit RegionSel = 1'b0   
  /*verilator lint_on UNUSED*/
) (
  input clk_i,
  output logic clk_o
);
  logic inv;
  assign inv = ~clk_i;
  assign clk_o = ~inv;
endmodule  
module prim_clock_gating #(
  parameter bit NoFpgaGate = 1'b0,  
  parameter bit FpgaBufGlobal = 1'b1  
) (
  input        clk_i,
  input        en_i,
  input        test_en_i,
  output logic clk_o
);
  logic en_latch /*verilator clock_enable*/;
  always_latch begin
    if (!clk_i) begin
      en_latch = en_i | test_en_i;
    end
  end
  assign clk_o = en_latch & clk_i;
endmodule
module prim_flop #(
  parameter int               Width      = 1,
  parameter logic [Width-1:0] ResetValue = 0
) (
  input                    clk_i,
  input                    rst_ni,
  input        [Width-1:0] d_i,
  output logic [Width-1:0] q_o
);
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      q_o <= ResetValue;
    end else begin
      q_o <= d_i;
    end
  end
endmodule
module prim_flop_no_rst #(
  parameter int Width = 1
) (
  input                    clk_i,
  input        [Width-1:0] d_i,
  output logic [Width-1:0] q_o
);
  always_ff @(posedge clk_i) begin
    q_o <= d_i;
  end
endmodule
package prim_pkg;
  parameter PrimTechName = "Generic";
endpackage  
module prim_usb_diff_rx #(
  parameter int CalibW = 32
) (
  inout              input_pi,       
  inout              input_ni,       
  input              input_en_i,     
  input              core_pok_h_i,   
  input              pullup_p_en_i,  
  input              pullup_n_en_i,  
  input [CalibW-1:0] calibration_i,  
  output logic       usb_diff_rx_obs_o,  
  output logic       input_o         
);
  logic [CalibW-1:0] unused_calibration;
  logic unused_core_pok;
  assign unused_calibration = calibration_i;
  assign unused_core_pok = core_pok_h_i;
  wire input_p, input_n;
  assign input_p = input_pi;
  assign input_n = input_ni;
  logic unused_pullup_p_en, unused_pullup_n_en;
  assign unused_pullup_p_en = pullup_p_en_i;
  assign unused_pullup_n_en = pullup_n_en_i;
  assign input_o = (input_en_i) ? input_p & ~input_n : 1'b0;
  prim_buf obs_buf (
    .in_i  (input_o),
    .out_o (usb_diff_rx_obs_o)
  );
endmodule : prim_usb_diff_rx
module prim_xnor2 #(
  parameter int Width = 1
) (
  input        [Width-1:0] in0_i,
  input        [Width-1:0] in1_i,
  output logic [Width-1:0] out_o
);
  assign out_o = ~(in0_i ^ in1_i);
endmodule
module prim_xor2 #(
  parameter int Width = 1
) (
  input        [Width-1:0] in0_i,
  input        [Width-1:0] in1_i,
  output logic [Width-1:0] out_o
);
  assign out_o = in0_i ^ in1_i;
endmodule
package prim_pad_wrapper_pkg;
  typedef enum logic [2:0] {
    BidirStd = 3'h0,      
    BidirTol = 3'h1,      
    BidirOd = 3'h2,       
    InputStd = 3'h3,      
    AnalogIn0 = 3'h4,     
    AnalogIn1 = 3'h5,     
    DualBidirTol = 3'h6   
  } pad_type_e;
  typedef enum logic [1:0] {
    NoScan = 2'h0,
    ScanIn = 2'h1,
    ScanOut = 2'h2,
    ScanClock = 2'h3
  } scan_role_e;
  parameter int DriveStrDw = 4;
  parameter int SlewRateDw = 2;
  typedef struct packed {
    logic [DriveStrDw-1:0] drive_strength;  
    logic [SlewRateDw-1:0] slew_rate;       
    logic input_disable;                    
    logic od_en;                            
    logic schmitt_en;                       
    logic keep_en;                          
    logic pull_select;                      
    logic pull_en;                          
    logic virt_od_en;                       
    logic invert;                           
  } pad_attr_t;
  parameter int AttrDw = $bits(pad_attr_t);
  parameter int PokDw = 8;
  typedef logic [PokDw-1:0] pad_pok_t;
endpackage : prim_pad_wrapper_pkg
package prim_secded_pkg;
  typedef enum int {
    SecdedHsiao,
    SecdedHamming,
    SecdedInvHsiao,
    SecdedInvHamming
  } prim_secded_type_e;
  typedef enum int {
    SecdedNone,
    Secded_22_16,
    Secded_28_22,
    Secded_39_32,
    Secded_64_57,
    Secded_72_64,
    SecdedHamming_22_16,
    SecdedHamming_39_32,
    SecdedHamming_72_64,
    SecdedHamming_76_68,
    SecdedInv_22_16,
    SecdedInv_28_22,
    SecdedInv_39_32,
    SecdedInv_64_57,
    SecdedInv_72_64,
    SecdedInvHamming_22_16,
    SecdedInvHamming_39_32,
    SecdedInvHamming_72_64,
    SecdedInvHamming_76_68
  } prim_secded_e;
  function automatic bit is_width_valid(prim_secded_type_e sd_type, int width);
    unique case (sd_type)
      SecdedHsiao:
        unique case (width)
          16: return 1'b1;
          22: return 1'b1;
          32: return 1'b1;
          57: return 1'b1;
          64: return 1'b1;
          default: return 1'b0;
        endcase
      SecdedHamming:
        unique case (width)
          16: return 1'b1;
          32: return 1'b1;
          64: return 1'b1;
          68: return 1'b1;
          default: return 1'b0;
        endcase
      SecdedInvHsiao:
        unique case (width)
          16: return 1'b1;
          22: return 1'b1;
          32: return 1'b1;
          57: return 1'b1;
          64: return 1'b1;
          default: return 1'b0;
        endcase
      SecdedInvHamming:
        unique case (width)
          16: return 1'b1;
          32: return 1'b1;
          64: return 1'b1;
          68: return 1'b1;
          default: return 1'b0;
        endcase
      default: return 1'b0;
    endcase
  endfunction : is_width_valid
  function automatic int get_synd_width(prim_secded_type_e sd_type, int width);
    unique case (sd_type)
      SecdedHsiao:
        unique case (width)
          16: return 6;
          22: return 6;
          32: return 7;
          57: return 7;
          64: return 8;
          default: return 0;
        endcase
      SecdedHamming:
        unique case (width)
          16: return 6;
          32: return 7;
          64: return 8;
          68: return 8;
          default: return 0;
        endcase
      SecdedInvHsiao:
        unique case (width)
          16: return 6;
          22: return 6;
          32: return 7;
          57: return 7;
          64: return 8;
          default: return 0;
        endcase
      SecdedInvHamming:
        unique case (width)
          16: return 6;
          32: return 7;
          64: return 8;
          68: return 8;
          default: return 0;
        endcase
      default: return 0;
    endcase
  endfunction : get_synd_width
  function automatic int get_full_width(prim_secded_type_e sd_type, int width);
    return width + get_synd_width(sd_type, width);
  endfunction : get_full_width
  function automatic int get_ecc_data_width(prim_secded_e ecc_type);
    case (ecc_type)
      Secded_22_16: return 16;
      Secded_28_22: return 22;
      Secded_39_32: return 32;
      Secded_64_57: return 57;
      Secded_72_64: return 64;
      SecdedHamming_22_16: return 16;
      SecdedHamming_39_32: return 32;
      SecdedHamming_72_64: return 64;
      SecdedHamming_76_68: return 68;
      SecdedInv_22_16: return 16;
      SecdedInv_28_22: return 22;
      SecdedInv_39_32: return 32;
      SecdedInv_64_57: return 57;
      SecdedInv_72_64: return 64;
      SecdedInvHamming_22_16: return 16;
      SecdedInvHamming_39_32: return 32;
      SecdedInvHamming_72_64: return 64;
      SecdedInvHamming_76_68: return 68;
      default: return 32;
    endcase
  endfunction
  function automatic int get_ecc_parity_width(prim_secded_e ecc_type);
    case (ecc_type)
      Secded_22_16: return 6;
      Secded_28_22: return 6;
      Secded_39_32: return 7;
      Secded_64_57: return 7;
      Secded_72_64: return 8;
      SecdedHamming_22_16: return 6;
      SecdedHamming_39_32: return 7;
      SecdedHamming_72_64: return 8;
      SecdedHamming_76_68: return 8;
      SecdedInv_22_16: return 6;
      SecdedInv_28_22: return 6;
      SecdedInv_39_32: return 7;
      SecdedInv_64_57: return 7;
      SecdedInv_72_64: return 8;
      SecdedInvHamming_22_16: return 6;
      SecdedInvHamming_39_32: return 7;
      SecdedInvHamming_72_64: return 8;
      SecdedInvHamming_76_68: return 8;
      default: return 0;
    endcase
  endfunction
  parameter logic [5:0] Secded2216ZeroEcc = 6'h0;
  parameter logic [21:0] Secded2216ZeroWord = 22'h0;
  typedef struct packed {
    logic [15:0] data;
    logic [5:0] syndrome;
    logic [1:0]  err;
  } secded_22_16_t;
  parameter logic [5:0] Secded2822ZeroEcc = 6'h0;
  parameter logic [27:0] Secded2822ZeroWord = 28'h0;
  typedef struct packed {
    logic [21:0] data;
    logic [5:0] syndrome;
    logic [1:0]  err;
  } secded_28_22_t;
  parameter logic [6:0] Secded3932ZeroEcc = 7'h0;
  parameter logic [38:0] Secded3932ZeroWord = 39'h0;
  typedef struct packed {
    logic [31:0] data;
    logic [6:0] syndrome;
    logic [1:0]  err;
  } secded_39_32_t;
  parameter logic [6:0] Secded6457ZeroEcc = 7'h0;
  parameter logic [63:0] Secded6457ZeroWord = 64'h0;
  typedef struct packed {
    logic [56:0] data;
    logic [6:0] syndrome;
    logic [1:0]  err;
  } secded_64_57_t;
  parameter logic [7:0] Secded7264ZeroEcc = 8'h0;
  parameter logic [71:0] Secded7264ZeroWord = 72'h0;
  typedef struct packed {
    logic [63:0] data;
    logic [7:0] syndrome;
    logic [1:0]  err;
  } secded_72_64_t;
  parameter logic [5:0] SecdedHamming2216ZeroEcc = 6'h0;
  parameter logic [21:0] SecdedHamming2216ZeroWord = 22'h0;
  typedef struct packed {
    logic [15:0] data;
    logic [5:0] syndrome;
    logic [1:0]  err;
  } secded_hamming_22_16_t;
  parameter logic [6:0] SecdedHamming3932ZeroEcc = 7'h0;
  parameter logic [38:0] SecdedHamming3932ZeroWord = 39'h0;
  typedef struct packed {
    logic [31:0] data;
    logic [6:0] syndrome;
    logic [1:0]  err;
  } secded_hamming_39_32_t;
  parameter logic [7:0] SecdedHamming7264ZeroEcc = 8'h0;
  parameter logic [71:0] SecdedHamming7264ZeroWord = 72'h0;
  typedef struct packed {
    logic [63:0] data;
    logic [7:0] syndrome;
    logic [1:0]  err;
  } secded_hamming_72_64_t;
  parameter logic [7:0] SecdedHamming7668ZeroEcc = 8'h0;
  parameter logic [75:0] SecdedHamming7668ZeroWord = 76'h0;
  typedef struct packed {
    logic [67:0] data;
    logic [7:0] syndrome;
    logic [1:0]  err;
  } secded_hamming_76_68_t;
  parameter logic [5:0] SecdedInv2216ZeroEcc = 6'h2A;
  parameter logic [21:0] SecdedInv2216ZeroWord = 22'h2A0000;
  typedef struct packed {
    logic [15:0] data;
    logic [5:0] syndrome;
    logic [1:0]  err;
  } secded_inv_22_16_t;
  parameter logic [5:0] SecdedInv2822ZeroEcc = 6'h2A;
  parameter logic [27:0] SecdedInv2822ZeroWord = 28'hA800000;
  typedef struct packed {
    logic [21:0] data;
    logic [5:0] syndrome;
    logic [1:0]  err;
  } secded_inv_28_22_t;
  parameter logic [6:0] SecdedInv3932ZeroEcc = 7'h2A;
  parameter logic [38:0] SecdedInv3932ZeroWord = 39'h2A00000000;
  typedef struct packed {
    logic [31:0] data;
    logic [6:0] syndrome;
    logic [1:0]  err;
  } secded_inv_39_32_t;
  parameter logic [6:0] SecdedInv6457ZeroEcc = 7'h2A;
  parameter logic [63:0] SecdedInv6457ZeroWord = 64'h5400000000000000;
  typedef struct packed {
    logic [56:0] data;
    logic [6:0] syndrome;
    logic [1:0]  err;
  } secded_inv_64_57_t;
  parameter logic [7:0] SecdedInv7264ZeroEcc = 8'hAA;
  parameter logic [71:0] SecdedInv7264ZeroWord = 72'hAA0000000000000000;
  typedef struct packed {
    logic [63:0] data;
    logic [7:0] syndrome;
    logic [1:0]  err;
  } secded_inv_72_64_t;
  parameter logic [5:0] SecdedInvHamming2216ZeroEcc = 6'h2A;
  parameter logic [21:0] SecdedInvHamming2216ZeroWord = 22'h2A0000;
  typedef struct packed {
    logic [15:0] data;
    logic [5:0] syndrome;
    logic [1:0]  err;
  } secded_inv_hamming_22_16_t;
  parameter logic [6:0] SecdedInvHamming3932ZeroEcc = 7'h2A;
  parameter logic [38:0] SecdedInvHamming3932ZeroWord = 39'h2A00000000;
  typedef struct packed {
    logic [31:0] data;
    logic [6:0] syndrome;
    logic [1:0]  err;
  } secded_inv_hamming_39_32_t;
  parameter logic [7:0] SecdedInvHamming7264ZeroEcc = 8'hAA;
  parameter logic [71:0] SecdedInvHamming7264ZeroWord = 72'hAA0000000000000000;
  typedef struct packed {
    logic [63:0] data;
    logic [7:0] syndrome;
    logic [1:0]  err;
  } secded_inv_hamming_72_64_t;
  parameter logic [7:0] SecdedInvHamming7668ZeroEcc = 8'hAA;
  parameter logic [75:0] SecdedInvHamming7668ZeroWord = 76'hAA00000000000000000;
  typedef struct packed {
    logic [67:0] data;
    logic [7:0] syndrome;
    logic [1:0]  err;
  } secded_inv_hamming_76_68_t;
  function automatic logic [21:0]
      prim_secded_22_16_enc (logic [15:0] data_i);
    logic [21:0] data_o;
    data_o = 22'(data_i);
    data_o[16] = ^(data_o & 22'h00496E);
    data_o[17] = ^(data_o & 22'h00F20B);
    data_o[18] = ^(data_o & 22'h008ED8);
    data_o[19] = ^(data_o & 22'h007714);
    data_o[20] = ^(data_o & 22'h00ACA5);
    data_o[21] = ^(data_o & 22'h0011F3);
    return data_o;
  endfunction
  function automatic secded_22_16_t
      prim_secded_22_16_dec (logic [21:0] data_i);
    logic [15:0] data_o;
    logic [5:0] syndrome_o;
    logic [1:0]  err_o;
    secded_22_16_t dec;
    syndrome_o[0] = ^(data_i & 22'h01496E);
    syndrome_o[1] = ^(data_i & 22'h02F20B);
    syndrome_o[2] = ^(data_i & 22'h048ED8);
    syndrome_o[3] = ^(data_i & 22'h087714);
    syndrome_o[4] = ^(data_i & 22'h10ACA5);
    syndrome_o[5] = ^(data_i & 22'h2011F3);
    data_o[0] = (syndrome_o == 6'h32) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'h23) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h19) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h7) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'h2c) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h31) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h25) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h34) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h29) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'he) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'h1c) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h15) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h2a) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h1a) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'hb) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h16) ^ data_i[15];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [27:0]
      prim_secded_28_22_enc (logic [21:0] data_i);
    logic [27:0] data_o;
    data_o = 28'(data_i);
    data_o[22] = ^(data_o & 28'h03003FF);
    data_o[23] = ^(data_o & 28'h010FC0F);
    data_o[24] = ^(data_o & 28'h0271C71);
    data_o[25] = ^(data_o & 28'h03B6592);
    data_o[26] = ^(data_o & 28'h03DAAA4);
    data_o[27] = ^(data_o & 28'h03ED348);
    return data_o;
  endfunction
  function automatic secded_28_22_t
      prim_secded_28_22_dec (logic [27:0] data_i);
    logic [21:0] data_o;
    logic [5:0] syndrome_o;
    logic [1:0]  err_o;
    secded_28_22_t dec;
    syndrome_o[0] = ^(data_i & 28'h07003FF);
    syndrome_o[1] = ^(data_i & 28'h090FC0F);
    syndrome_o[2] = ^(data_i & 28'h1271C71);
    syndrome_o[3] = ^(data_i & 28'h23B6592);
    syndrome_o[4] = ^(data_i & 28'h43DAAA4);
    syndrome_o[5] = ^(data_i & 28'h83ED348);
    data_o[0] = (syndrome_o == 6'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'hd) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h15) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h25) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h19) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h29) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'h31) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'he) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h16) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h26) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h1a) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'h2a) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h32) ^ data_i[15];
    data_o[16] = (syndrome_o == 6'h1c) ^ data_i[16];
    data_o[17] = (syndrome_o == 6'h2c) ^ data_i[17];
    data_o[18] = (syndrome_o == 6'h34) ^ data_i[18];
    data_o[19] = (syndrome_o == 6'h38) ^ data_i[19];
    data_o[20] = (syndrome_o == 6'h3b) ^ data_i[20];
    data_o[21] = (syndrome_o == 6'h3d) ^ data_i[21];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [38:0]
      prim_secded_39_32_enc (logic [31:0] data_i);
    logic [38:0] data_o;
    data_o = 39'(data_i);
    data_o[32] = ^(data_o & 39'h002606BD25);
    data_o[33] = ^(data_o & 39'h00DEBA8050);
    data_o[34] = ^(data_o & 39'h00413D89AA);
    data_o[35] = ^(data_o & 39'h0031234ED1);
    data_o[36] = ^(data_o & 39'h00C2C1323B);
    data_o[37] = ^(data_o & 39'h002DCC624C);
    data_o[38] = ^(data_o & 39'h0098505586);
    return data_o;
  endfunction
  function automatic secded_39_32_t
      prim_secded_39_32_dec (logic [38:0] data_i);
    logic [31:0] data_o;
    logic [6:0] syndrome_o;
    logic [1:0]  err_o;
    secded_39_32_t dec;
    syndrome_o[0] = ^(data_i & 39'h012606BD25);
    syndrome_o[1] = ^(data_i & 39'h02DEBA8050);
    syndrome_o[2] = ^(data_i & 39'h04413D89AA);
    syndrome_o[3] = ^(data_i & 39'h0831234ED1);
    syndrome_o[4] = ^(data_i & 39'h10C2C1323B);
    syndrome_o[5] = ^(data_i & 39'h202DCC624C);
    syndrome_o[6] = ^(data_i & 39'h4098505586);
    data_o[0] = (syndrome_o == 7'h19) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'h54) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h61) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h34) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h1a) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'h15) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h2a) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h4c) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h45) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h38) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h49) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'hd) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h51) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h31) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h68) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'h7) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h1c) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'hb) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h25) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h26) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h46) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'he) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h70) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h32) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h2c) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h13) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h23) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h62) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h4a) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h29) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h16) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h52) ^ data_i[31];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [63:0]
      prim_secded_64_57_enc (logic [56:0] data_i);
    logic [63:0] data_o;
    data_o = 64'(data_i);
    data_o[57] = ^(data_o & 64'h0103FFF800007FFF);
    data_o[58] = ^(data_o & 64'h017C1FF801FF801F);
    data_o[59] = ^(data_o & 64'h01BDE1F87E0781E1);
    data_o[60] = ^(data_o & 64'h01DEEE3B8E388E22);
    data_o[61] = ^(data_o & 64'h01EF76CDB2C93244);
    data_o[62] = ^(data_o & 64'h01F7BB56D5525488);
    data_o[63] = ^(data_o & 64'h01FBDDA769A46910);
    return data_o;
  endfunction
  function automatic secded_64_57_t
      prim_secded_64_57_dec (logic [63:0] data_i);
    logic [56:0] data_o;
    logic [6:0] syndrome_o;
    logic [1:0]  err_o;
    secded_64_57_t dec;
    syndrome_o[0] = ^(data_i & 64'h0303FFF800007FFF);
    syndrome_o[1] = ^(data_i & 64'h057C1FF801FF801F);
    syndrome_o[2] = ^(data_i & 64'h09BDE1F87E0781E1);
    syndrome_o[3] = ^(data_i & 64'h11DEEE3B8E388E22);
    syndrome_o[4] = ^(data_i & 64'h21EF76CDB2C93244);
    syndrome_o[5] = ^(data_i & 64'h41F7BB56D5525488);
    syndrome_o[6] = ^(data_i & 64'h81FBDDA769A46910);
    data_o[0] = (syndrome_o == 7'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h43) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'hd) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h15) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h25) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h45) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h19) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h29) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'h49) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h31) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h51) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h61) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'he) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h16) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'h26) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h46) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h1a) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h2a) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'h4a) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h32) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h52) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h62) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h1c) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h2c) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h4c) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h34) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h54) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h64) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h38) ^ data_i[31];
    data_o[32] = (syndrome_o == 7'h58) ^ data_i[32];
    data_o[33] = (syndrome_o == 7'h68) ^ data_i[33];
    data_o[34] = (syndrome_o == 7'h70) ^ data_i[34];
    data_o[35] = (syndrome_o == 7'h1f) ^ data_i[35];
    data_o[36] = (syndrome_o == 7'h2f) ^ data_i[36];
    data_o[37] = (syndrome_o == 7'h4f) ^ data_i[37];
    data_o[38] = (syndrome_o == 7'h37) ^ data_i[38];
    data_o[39] = (syndrome_o == 7'h57) ^ data_i[39];
    data_o[40] = (syndrome_o == 7'h67) ^ data_i[40];
    data_o[41] = (syndrome_o == 7'h3b) ^ data_i[41];
    data_o[42] = (syndrome_o == 7'h5b) ^ data_i[42];
    data_o[43] = (syndrome_o == 7'h6b) ^ data_i[43];
    data_o[44] = (syndrome_o == 7'h73) ^ data_i[44];
    data_o[45] = (syndrome_o == 7'h3d) ^ data_i[45];
    data_o[46] = (syndrome_o == 7'h5d) ^ data_i[46];
    data_o[47] = (syndrome_o == 7'h6d) ^ data_i[47];
    data_o[48] = (syndrome_o == 7'h75) ^ data_i[48];
    data_o[49] = (syndrome_o == 7'h79) ^ data_i[49];
    data_o[50] = (syndrome_o == 7'h3e) ^ data_i[50];
    data_o[51] = (syndrome_o == 7'h5e) ^ data_i[51];
    data_o[52] = (syndrome_o == 7'h6e) ^ data_i[52];
    data_o[53] = (syndrome_o == 7'h76) ^ data_i[53];
    data_o[54] = (syndrome_o == 7'h7a) ^ data_i[54];
    data_o[55] = (syndrome_o == 7'h7c) ^ data_i[55];
    data_o[56] = (syndrome_o == 7'h7f) ^ data_i[56];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [71:0]
      prim_secded_72_64_enc (logic [63:0] data_i);
    logic [71:0] data_o;
    data_o = 72'(data_i);
    data_o[64] = ^(data_o & 72'h00B9000000001FFFFF);
    data_o[65] = ^(data_o & 72'h005E00000FFFE0003F);
    data_o[66] = ^(data_o & 72'h0067003FF003E007C1);
    data_o[67] = ^(data_o & 72'h00CD0FC0F03C207842);
    data_o[68] = ^(data_o & 72'h00B671C711C4438884);
    data_o[69] = ^(data_o & 72'h00B5B65926488C9108);
    data_o[70] = ^(data_o & 72'h00CBDAAA4A91152210);
    data_o[71] = ^(data_o & 72'h007AED348D221A4420);
    return data_o;
  endfunction
  function automatic secded_72_64_t
      prim_secded_72_64_dec (logic [71:0] data_i);
    logic [63:0] data_o;
    logic [7:0] syndrome_o;
    logic [1:0]  err_o;
    secded_72_64_t dec;
    syndrome_o[0] = ^(data_i & 72'h01B9000000001FFFFF);
    syndrome_o[1] = ^(data_i & 72'h025E00000FFFE0003F);
    syndrome_o[2] = ^(data_i & 72'h0467003FF003E007C1);
    syndrome_o[3] = ^(data_i & 72'h08CD0FC0F03C207842);
    syndrome_o[4] = ^(data_i & 72'h10B671C711C4438884);
    syndrome_o[5] = ^(data_i & 72'h20B5B65926488C9108);
    syndrome_o[6] = ^(data_i & 72'h40CBDAAA4A91152210);
    syndrome_o[7] = ^(data_i & 72'h807AED348D221A4420);
    data_o[0] = (syndrome_o == 8'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h43) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h83) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'hd) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h15) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h25) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h45) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h85) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h19) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h29) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h49) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h89) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h31) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h51) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h91) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h61) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'ha1) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'hc1) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'he) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h16) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h26) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h46) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h86) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'h1a) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'h2a) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'h4a) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'h8a) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'h32) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'h52) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'h92) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'h62) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha2) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'hc2) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'h1c) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'h2c) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'h4c) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'h8c) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'h34) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'h54) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'h94) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'h64) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'ha4) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hc4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'h38) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'h58) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'h98) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'h68) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'ha8) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hc8) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'h70) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hb0) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hd0) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'he0) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'h6d) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hd6) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'h3e) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hcb) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hb3) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hb5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hce) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'h79) ^ data_i[63];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [21:0]
      prim_secded_hamming_22_16_enc (logic [15:0] data_i);
    logic [21:0] data_o;
    data_o = 22'(data_i);
    data_o[16] = ^(data_o & 22'h00AD5B);
    data_o[17] = ^(data_o & 22'h00366D);
    data_o[18] = ^(data_o & 22'h00C78E);
    data_o[19] = ^(data_o & 22'h0007F0);
    data_o[20] = ^(data_o & 22'h00F800);
    data_o[21] = ^(data_o & 22'h1FFFFF);
    return data_o;
  endfunction
  function automatic secded_hamming_22_16_t
      prim_secded_hamming_22_16_dec (logic [21:0] data_i);
    logic [15:0] data_o;
    logic [5:0] syndrome_o;
    logic [1:0]  err_o;
    secded_hamming_22_16_t dec;
    syndrome_o[0] = ^(data_i & 22'h01AD5B);
    syndrome_o[1] = ^(data_i & 22'h02366D);
    syndrome_o[2] = ^(data_i & 22'h04C78E);
    syndrome_o[3] = ^(data_i & 22'h0807F0);
    syndrome_o[4] = ^(data_i & 22'h10F800);
    syndrome_o[5] = ^(data_i & 22'h3FFFFF);
    data_o[0] = (syndrome_o == 6'h23) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'h25) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h26) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h27) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'h29) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h2a) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h2b) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h2c) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h2d) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'h2e) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'h2f) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h31) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h32) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h33) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'h34) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h35) ^ data_i[15];
    err_o[0] = syndrome_o[5];
    err_o[1] = |syndrome_o[4:0] & ~syndrome_o[5];
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [38:0]
      prim_secded_hamming_39_32_enc (logic [31:0] data_i);
    logic [38:0] data_o;
    data_o = 39'(data_i);
    data_o[32] = ^(data_o & 39'h0056AAAD5B);
    data_o[33] = ^(data_o & 39'h009B33366D);
    data_o[34] = ^(data_o & 39'h00E3C3C78E);
    data_o[35] = ^(data_o & 39'h0003FC07F0);
    data_o[36] = ^(data_o & 39'h0003FFF800);
    data_o[37] = ^(data_o & 39'h00FC000000);
    data_o[38] = ^(data_o & 39'h3FFFFFFFFF);
    return data_o;
  endfunction
  function automatic secded_hamming_39_32_t
      prim_secded_hamming_39_32_dec (logic [38:0] data_i);
    logic [31:0] data_o;
    logic [6:0] syndrome_o;
    logic [1:0]  err_o;
    secded_hamming_39_32_t dec;
    syndrome_o[0] = ^(data_i & 39'h0156AAAD5B);
    syndrome_o[1] = ^(data_i & 39'h029B33366D);
    syndrome_o[2] = ^(data_i & 39'h04E3C3C78E);
    syndrome_o[3] = ^(data_i & 39'h0803FC07F0);
    syndrome_o[4] = ^(data_i & 39'h1003FFF800);
    syndrome_o[5] = ^(data_i & 39'h20FC000000);
    syndrome_o[6] = ^(data_i & 39'h7FFFFFFFFF);
    data_o[0] = (syndrome_o == 7'h43) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'h45) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h46) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h47) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h49) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'h4a) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h4b) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h4c) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h4d) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h4e) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h4f) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'h51) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h52) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h53) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h54) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'h55) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h56) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'h57) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h58) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h59) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h5a) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'h5b) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h5c) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h5d) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h5e) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h5f) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h61) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h62) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h63) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h64) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h65) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h66) ^ data_i[31];
    err_o[0] = syndrome_o[6];
    err_o[1] = |syndrome_o[5:0] & ~syndrome_o[6];
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [71:0]
      prim_secded_hamming_72_64_enc (logic [63:0] data_i);
    logic [71:0] data_o;
    data_o = 72'(data_i);
    data_o[64] = ^(data_o & 72'h00AB55555556AAAD5B);
    data_o[65] = ^(data_o & 72'h00CD9999999B33366D);
    data_o[66] = ^(data_o & 72'h00F1E1E1E1E3C3C78E);
    data_o[67] = ^(data_o & 72'h0001FE01FE03FC07F0);
    data_o[68] = ^(data_o & 72'h0001FFFE0003FFF800);
    data_o[69] = ^(data_o & 72'h0001FFFFFFFC000000);
    data_o[70] = ^(data_o & 72'h00FE00000000000000);
    data_o[71] = ^(data_o & 72'h7FFFFFFFFFFFFFFFFF);
    return data_o;
  endfunction
  function automatic secded_hamming_72_64_t
      prim_secded_hamming_72_64_dec (logic [71:0] data_i);
    logic [63:0] data_o;
    logic [7:0] syndrome_o;
    logic [1:0]  err_o;
    secded_hamming_72_64_t dec;
    syndrome_o[0] = ^(data_i & 72'h01AB55555556AAAD5B);
    syndrome_o[1] = ^(data_i & 72'h02CD9999999B33366D);
    syndrome_o[2] = ^(data_i & 72'h04F1E1E1E1E3C3C78E);
    syndrome_o[3] = ^(data_i & 72'h0801FE01FE03FC07F0);
    syndrome_o[4] = ^(data_i & 72'h1001FFFE0003FFF800);
    syndrome_o[5] = ^(data_i & 72'h2001FFFFFFFC000000);
    syndrome_o[6] = ^(data_i & 72'h40FE00000000000000);
    syndrome_o[7] = ^(data_i & 72'hFFFFFFFFFFFFFFFFFF);
    data_o[0] = (syndrome_o == 8'h83) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'h85) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h86) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h87) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h89) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h8a) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'h8b) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h8c) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h8d) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h8e) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h8f) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h91) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h92) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h93) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h94) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h95) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h96) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h97) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h98) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'h99) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'h9a) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'h9b) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h9c) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h9d) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h9e) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h9f) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'ha1) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'ha2) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'ha3) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'ha4) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'ha5) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'ha6) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'ha7) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'ha8) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha9) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'haa) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'hab) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'hac) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'had) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'hae) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'haf) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'hb0) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'hb1) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'hb2) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'hb3) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hb4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'hb5) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'hb6) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'hb7) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'hb8) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'hb9) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hba) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'hbb) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hbc) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hbd) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'hbe) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'hbf) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hc1) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'hc2) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hc3) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hc4) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hc5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hc6) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'hc7) ^ data_i[63];
    err_o[0] = syndrome_o[7];
    err_o[1] = |syndrome_o[6:0] & ~syndrome_o[7];
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [75:0]
      prim_secded_hamming_76_68_enc (logic [67:0] data_i);
    logic [75:0] data_o;
    data_o = 76'(data_i);
    data_o[68] = ^(data_o & 76'h00AAB55555556AAAD5B);
    data_o[69] = ^(data_o & 76'h00CCD9999999B33366D);
    data_o[70] = ^(data_o & 76'h000F1E1E1E1E3C3C78E);
    data_o[71] = ^(data_o & 76'h00F01FE01FE03FC07F0);
    data_o[72] = ^(data_o & 76'h00001FFFE0003FFF800);
    data_o[73] = ^(data_o & 76'h00001FFFFFFFC000000);
    data_o[74] = ^(data_o & 76'h00FFE00000000000000);
    data_o[75] = ^(data_o & 76'h7FFFFFFFFFFFFFFFFFF);
    return data_o;
  endfunction
  function automatic secded_hamming_76_68_t
      prim_secded_hamming_76_68_dec (logic [75:0] data_i);
    logic [67:0] data_o;
    logic [7:0] syndrome_o;
    logic [1:0]  err_o;
    secded_hamming_76_68_t dec;
    syndrome_o[0] = ^(data_i & 76'h01AAB55555556AAAD5B);
    syndrome_o[1] = ^(data_i & 76'h02CCD9999999B33366D);
    syndrome_o[2] = ^(data_i & 76'h040F1E1E1E1E3C3C78E);
    syndrome_o[3] = ^(data_i & 76'h08F01FE01FE03FC07F0);
    syndrome_o[4] = ^(data_i & 76'h10001FFFE0003FFF800);
    syndrome_o[5] = ^(data_i & 76'h20001FFFFFFFC000000);
    syndrome_o[6] = ^(data_i & 76'h40FFE00000000000000);
    syndrome_o[7] = ^(data_i & 76'hFFFFFFFFFFFFFFFFFFF);
    data_o[0] = (syndrome_o == 8'h83) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'h85) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h86) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h87) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h89) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h8a) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'h8b) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h8c) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h8d) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h8e) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h8f) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h91) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h92) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h93) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h94) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h95) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h96) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h97) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h98) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'h99) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'h9a) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'h9b) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h9c) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h9d) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h9e) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h9f) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'ha1) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'ha2) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'ha3) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'ha4) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'ha5) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'ha6) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'ha7) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'ha8) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha9) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'haa) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'hab) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'hac) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'had) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'hae) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'haf) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'hb0) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'hb1) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'hb2) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'hb3) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hb4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'hb5) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'hb6) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'hb7) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'hb8) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'hb9) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hba) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'hbb) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hbc) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hbd) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'hbe) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'hbf) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hc1) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'hc2) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hc3) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hc4) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hc5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hc6) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'hc7) ^ data_i[63];
    data_o[64] = (syndrome_o == 8'hc8) ^ data_i[64];
    data_o[65] = (syndrome_o == 8'hc9) ^ data_i[65];
    data_o[66] = (syndrome_o == 8'hca) ^ data_i[66];
    data_o[67] = (syndrome_o == 8'hcb) ^ data_i[67];
    err_o[0] = syndrome_o[7];
    err_o[1] = |syndrome_o[6:0] & ~syndrome_o[7];
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [21:0]
      prim_secded_inv_22_16_enc (logic [15:0] data_i);
    logic [21:0] data_o;
    data_o = 22'(data_i);
    data_o[16] = ^(data_o & 22'h00496E);
    data_o[17] = ^(data_o & 22'h00F20B);
    data_o[18] = ^(data_o & 22'h008ED8);
    data_o[19] = ^(data_o & 22'h007714);
    data_o[20] = ^(data_o & 22'h00ACA5);
    data_o[21] = ^(data_o & 22'h0011F3);
    data_o ^= 22'h2A0000;
    return data_o;
  endfunction
  function automatic secded_inv_22_16_t
      prim_secded_inv_22_16_dec (logic [21:0] data_i);
    logic [15:0] data_o;
    logic [5:0] syndrome_o;
    logic [1:0]  err_o;
    secded_inv_22_16_t dec;
    syndrome_o[0] = ^((data_i ^ 22'h2A0000) & 22'h01496E);
    syndrome_o[1] = ^((data_i ^ 22'h2A0000) & 22'h02F20B);
    syndrome_o[2] = ^((data_i ^ 22'h2A0000) & 22'h048ED8);
    syndrome_o[3] = ^((data_i ^ 22'h2A0000) & 22'h087714);
    syndrome_o[4] = ^((data_i ^ 22'h2A0000) & 22'h10ACA5);
    syndrome_o[5] = ^((data_i ^ 22'h2A0000) & 22'h2011F3);
    data_o[0] = (syndrome_o == 6'h32) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'h23) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h19) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h7) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'h2c) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h31) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h25) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h34) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h29) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'he) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'h1c) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h15) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h2a) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h1a) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'hb) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h16) ^ data_i[15];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [27:0]
      prim_secded_inv_28_22_enc (logic [21:0] data_i);
    logic [27:0] data_o;
    data_o = 28'(data_i);
    data_o[22] = ^(data_o & 28'h03003FF);
    data_o[23] = ^(data_o & 28'h010FC0F);
    data_o[24] = ^(data_o & 28'h0271C71);
    data_o[25] = ^(data_o & 28'h03B6592);
    data_o[26] = ^(data_o & 28'h03DAAA4);
    data_o[27] = ^(data_o & 28'h03ED348);
    data_o ^= 28'hA800000;
    return data_o;
  endfunction
  function automatic secded_inv_28_22_t
      prim_secded_inv_28_22_dec (logic [27:0] data_i);
    logic [21:0] data_o;
    logic [5:0] syndrome_o;
    logic [1:0]  err_o;
    secded_inv_28_22_t dec;
    syndrome_o[0] = ^((data_i ^ 28'hA800000) & 28'h07003FF);
    syndrome_o[1] = ^((data_i ^ 28'hA800000) & 28'h090FC0F);
    syndrome_o[2] = ^((data_i ^ 28'hA800000) & 28'h1271C71);
    syndrome_o[3] = ^((data_i ^ 28'hA800000) & 28'h23B6592);
    syndrome_o[4] = ^((data_i ^ 28'hA800000) & 28'h43DAAA4);
    syndrome_o[5] = ^((data_i ^ 28'hA800000) & 28'h83ED348);
    data_o[0] = (syndrome_o == 6'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'hd) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h15) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h25) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h19) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h29) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'h31) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'he) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h16) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h26) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h1a) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'h2a) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h32) ^ data_i[15];
    data_o[16] = (syndrome_o == 6'h1c) ^ data_i[16];
    data_o[17] = (syndrome_o == 6'h2c) ^ data_i[17];
    data_o[18] = (syndrome_o == 6'h34) ^ data_i[18];
    data_o[19] = (syndrome_o == 6'h38) ^ data_i[19];
    data_o[20] = (syndrome_o == 6'h3b) ^ data_i[20];
    data_o[21] = (syndrome_o == 6'h3d) ^ data_i[21];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [38:0]
      prim_secded_inv_39_32_enc (logic [31:0] data_i);
    logic [38:0] data_o;
    data_o = 39'(data_i);
    data_o[32] = ^(data_o & 39'h002606BD25);
    data_o[33] = ^(data_o & 39'h00DEBA8050);
    data_o[34] = ^(data_o & 39'h00413D89AA);
    data_o[35] = ^(data_o & 39'h0031234ED1);
    data_o[36] = ^(data_o & 39'h00C2C1323B);
    data_o[37] = ^(data_o & 39'h002DCC624C);
    data_o[38] = ^(data_o & 39'h0098505586);
    data_o ^= 39'h2A00000000;
    return data_o;
  endfunction
  function automatic secded_inv_39_32_t
      prim_secded_inv_39_32_dec (logic [38:0] data_i);
    logic [31:0] data_o;
    logic [6:0] syndrome_o;
    logic [1:0]  err_o;
    secded_inv_39_32_t dec;
    syndrome_o[0] = ^((data_i ^ 39'h2A00000000) & 39'h012606BD25);
    syndrome_o[1] = ^((data_i ^ 39'h2A00000000) & 39'h02DEBA8050);
    syndrome_o[2] = ^((data_i ^ 39'h2A00000000) & 39'h04413D89AA);
    syndrome_o[3] = ^((data_i ^ 39'h2A00000000) & 39'h0831234ED1);
    syndrome_o[4] = ^((data_i ^ 39'h2A00000000) & 39'h10C2C1323B);
    syndrome_o[5] = ^((data_i ^ 39'h2A00000000) & 39'h202DCC624C);
    syndrome_o[6] = ^((data_i ^ 39'h2A00000000) & 39'h4098505586);
    data_o[0] = (syndrome_o == 7'h19) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'h54) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h61) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h34) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h1a) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'h15) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h2a) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h4c) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h45) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h38) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h49) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'hd) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h51) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h31) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h68) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'h7) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h1c) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'hb) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h25) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h26) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h46) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'he) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h70) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h32) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h2c) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h13) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h23) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h62) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h4a) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h29) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h16) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h52) ^ data_i[31];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [63:0]
      prim_secded_inv_64_57_enc (logic [56:0] data_i);
    logic [63:0] data_o;
    data_o = 64'(data_i);
    data_o[57] = ^(data_o & 64'h0103FFF800007FFF);
    data_o[58] = ^(data_o & 64'h017C1FF801FF801F);
    data_o[59] = ^(data_o & 64'h01BDE1F87E0781E1);
    data_o[60] = ^(data_o & 64'h01DEEE3B8E388E22);
    data_o[61] = ^(data_o & 64'h01EF76CDB2C93244);
    data_o[62] = ^(data_o & 64'h01F7BB56D5525488);
    data_o[63] = ^(data_o & 64'h01FBDDA769A46910);
    data_o ^= 64'h5400000000000000;
    return data_o;
  endfunction
  function automatic secded_inv_64_57_t
      prim_secded_inv_64_57_dec (logic [63:0] data_i);
    logic [56:0] data_o;
    logic [6:0] syndrome_o;
    logic [1:0]  err_o;
    secded_inv_64_57_t dec;
    syndrome_o[0] = ^((data_i ^ 64'h5400000000000000) & 64'h0303FFF800007FFF);
    syndrome_o[1] = ^((data_i ^ 64'h5400000000000000) & 64'h057C1FF801FF801F);
    syndrome_o[2] = ^((data_i ^ 64'h5400000000000000) & 64'h09BDE1F87E0781E1);
    syndrome_o[3] = ^((data_i ^ 64'h5400000000000000) & 64'h11DEEE3B8E388E22);
    syndrome_o[4] = ^((data_i ^ 64'h5400000000000000) & 64'h21EF76CDB2C93244);
    syndrome_o[5] = ^((data_i ^ 64'h5400000000000000) & 64'h41F7BB56D5525488);
    syndrome_o[6] = ^((data_i ^ 64'h5400000000000000) & 64'h81FBDDA769A46910);
    data_o[0] = (syndrome_o == 7'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h43) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'hd) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h15) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h25) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h45) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h19) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h29) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'h49) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h31) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h51) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h61) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'he) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h16) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'h26) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h46) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h1a) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h2a) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'h4a) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h32) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h52) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h62) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h1c) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h2c) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h4c) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h34) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h54) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h64) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h38) ^ data_i[31];
    data_o[32] = (syndrome_o == 7'h58) ^ data_i[32];
    data_o[33] = (syndrome_o == 7'h68) ^ data_i[33];
    data_o[34] = (syndrome_o == 7'h70) ^ data_i[34];
    data_o[35] = (syndrome_o == 7'h1f) ^ data_i[35];
    data_o[36] = (syndrome_o == 7'h2f) ^ data_i[36];
    data_o[37] = (syndrome_o == 7'h4f) ^ data_i[37];
    data_o[38] = (syndrome_o == 7'h37) ^ data_i[38];
    data_o[39] = (syndrome_o == 7'h57) ^ data_i[39];
    data_o[40] = (syndrome_o == 7'h67) ^ data_i[40];
    data_o[41] = (syndrome_o == 7'h3b) ^ data_i[41];
    data_o[42] = (syndrome_o == 7'h5b) ^ data_i[42];
    data_o[43] = (syndrome_o == 7'h6b) ^ data_i[43];
    data_o[44] = (syndrome_o == 7'h73) ^ data_i[44];
    data_o[45] = (syndrome_o == 7'h3d) ^ data_i[45];
    data_o[46] = (syndrome_o == 7'h5d) ^ data_i[46];
    data_o[47] = (syndrome_o == 7'h6d) ^ data_i[47];
    data_o[48] = (syndrome_o == 7'h75) ^ data_i[48];
    data_o[49] = (syndrome_o == 7'h79) ^ data_i[49];
    data_o[50] = (syndrome_o == 7'h3e) ^ data_i[50];
    data_o[51] = (syndrome_o == 7'h5e) ^ data_i[51];
    data_o[52] = (syndrome_o == 7'h6e) ^ data_i[52];
    data_o[53] = (syndrome_o == 7'h76) ^ data_i[53];
    data_o[54] = (syndrome_o == 7'h7a) ^ data_i[54];
    data_o[55] = (syndrome_o == 7'h7c) ^ data_i[55];
    data_o[56] = (syndrome_o == 7'h7f) ^ data_i[56];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [71:0]
      prim_secded_inv_72_64_enc (logic [63:0] data_i);
    logic [71:0] data_o;
    data_o = 72'(data_i);
    data_o[64] = ^(data_o & 72'h00B9000000001FFFFF);
    data_o[65] = ^(data_o & 72'h005E00000FFFE0003F);
    data_o[66] = ^(data_o & 72'h0067003FF003E007C1);
    data_o[67] = ^(data_o & 72'h00CD0FC0F03C207842);
    data_o[68] = ^(data_o & 72'h00B671C711C4438884);
    data_o[69] = ^(data_o & 72'h00B5B65926488C9108);
    data_o[70] = ^(data_o & 72'h00CBDAAA4A91152210);
    data_o[71] = ^(data_o & 72'h007AED348D221A4420);
    data_o ^= 72'hAA0000000000000000;
    return data_o;
  endfunction
  function automatic secded_inv_72_64_t
      prim_secded_inv_72_64_dec (logic [71:0] data_i);
    logic [63:0] data_o;
    logic [7:0] syndrome_o;
    logic [1:0]  err_o;
    secded_inv_72_64_t dec;
    syndrome_o[0] = ^((data_i ^ 72'hAA0000000000000000) & 72'h01B9000000001FFFFF);
    syndrome_o[1] = ^((data_i ^ 72'hAA0000000000000000) & 72'h025E00000FFFE0003F);
    syndrome_o[2] = ^((data_i ^ 72'hAA0000000000000000) & 72'h0467003FF003E007C1);
    syndrome_o[3] = ^((data_i ^ 72'hAA0000000000000000) & 72'h08CD0FC0F03C207842);
    syndrome_o[4] = ^((data_i ^ 72'hAA0000000000000000) & 72'h10B671C711C4438884);
    syndrome_o[5] = ^((data_i ^ 72'hAA0000000000000000) & 72'h20B5B65926488C9108);
    syndrome_o[6] = ^((data_i ^ 72'hAA0000000000000000) & 72'h40CBDAAA4A91152210);
    syndrome_o[7] = ^((data_i ^ 72'hAA0000000000000000) & 72'h807AED348D221A4420);
    data_o[0] = (syndrome_o == 8'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h43) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h83) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'hd) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h15) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h25) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h45) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h85) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h19) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h29) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h49) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h89) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h31) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h51) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h91) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h61) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'ha1) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'hc1) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'he) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h16) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h26) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h46) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h86) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'h1a) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'h2a) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'h4a) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'h8a) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'h32) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'h52) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'h92) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'h62) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha2) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'hc2) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'h1c) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'h2c) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'h4c) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'h8c) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'h34) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'h54) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'h94) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'h64) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'ha4) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hc4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'h38) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'h58) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'h98) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'h68) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'ha8) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hc8) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'h70) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hb0) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hd0) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'he0) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'h6d) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hd6) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'h3e) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hcb) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hb3) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hb5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hce) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'h79) ^ data_i[63];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [21:0]
      prim_secded_inv_hamming_22_16_enc (logic [15:0] data_i);
    logic [21:0] data_o;
    data_o = 22'(data_i);
    data_o[16] = ^(data_o & 22'h00AD5B);
    data_o[17] = ^(data_o & 22'h00366D);
    data_o[18] = ^(data_o & 22'h00C78E);
    data_o[19] = ^(data_o & 22'h0007F0);
    data_o[20] = ^(data_o & 22'h00F800);
    data_o[21] = ^(data_o & 22'h1FFFFF);
    data_o ^= 22'h2A0000;
    return data_o;
  endfunction
  function automatic secded_inv_hamming_22_16_t
      prim_secded_inv_hamming_22_16_dec (logic [21:0] data_i);
    logic [15:0] data_o;
    logic [5:0] syndrome_o;
    logic [1:0]  err_o;
    secded_inv_hamming_22_16_t dec;
    syndrome_o[0] = ^((data_i ^ 22'h2A0000) & 22'h01AD5B);
    syndrome_o[1] = ^((data_i ^ 22'h2A0000) & 22'h02366D);
    syndrome_o[2] = ^((data_i ^ 22'h2A0000) & 22'h04C78E);
    syndrome_o[3] = ^((data_i ^ 22'h2A0000) & 22'h0807F0);
    syndrome_o[4] = ^((data_i ^ 22'h2A0000) & 22'h10F800);
    syndrome_o[5] = ^((data_i ^ 22'h2A0000) & 22'h3FFFFF);
    data_o[0] = (syndrome_o == 6'h23) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'h25) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h26) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h27) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'h29) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h2a) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h2b) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h2c) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h2d) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'h2e) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'h2f) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h31) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h32) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h33) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'h34) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h35) ^ data_i[15];
    err_o[0] = syndrome_o[5];
    err_o[1] = |syndrome_o[4:0] & ~syndrome_o[5];
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [38:0]
      prim_secded_inv_hamming_39_32_enc (logic [31:0] data_i);
    logic [38:0] data_o;
    data_o = 39'(data_i);
    data_o[32] = ^(data_o & 39'h0056AAAD5B);
    data_o[33] = ^(data_o & 39'h009B33366D);
    data_o[34] = ^(data_o & 39'h00E3C3C78E);
    data_o[35] = ^(data_o & 39'h0003FC07F0);
    data_o[36] = ^(data_o & 39'h0003FFF800);
    data_o[37] = ^(data_o & 39'h00FC000000);
    data_o[38] = ^(data_o & 39'h3FFFFFFFFF);
    data_o ^= 39'h2A00000000;
    return data_o;
  endfunction
  function automatic secded_inv_hamming_39_32_t
      prim_secded_inv_hamming_39_32_dec (logic [38:0] data_i);
    logic [31:0] data_o;
    logic [6:0] syndrome_o;
    logic [1:0]  err_o;
    secded_inv_hamming_39_32_t dec;
    syndrome_o[0] = ^((data_i ^ 39'h2A00000000) & 39'h0156AAAD5B);
    syndrome_o[1] = ^((data_i ^ 39'h2A00000000) & 39'h029B33366D);
    syndrome_o[2] = ^((data_i ^ 39'h2A00000000) & 39'h04E3C3C78E);
    syndrome_o[3] = ^((data_i ^ 39'h2A00000000) & 39'h0803FC07F0);
    syndrome_o[4] = ^((data_i ^ 39'h2A00000000) & 39'h1003FFF800);
    syndrome_o[5] = ^((data_i ^ 39'h2A00000000) & 39'h20FC000000);
    syndrome_o[6] = ^((data_i ^ 39'h2A00000000) & 39'h7FFFFFFFFF);
    data_o[0] = (syndrome_o == 7'h43) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'h45) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h46) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h47) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h49) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'h4a) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h4b) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h4c) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h4d) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h4e) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h4f) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'h51) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h52) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h53) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h54) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'h55) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h56) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'h57) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h58) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h59) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h5a) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'h5b) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h5c) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h5d) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h5e) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h5f) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h61) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h62) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h63) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h64) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h65) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h66) ^ data_i[31];
    err_o[0] = syndrome_o[6];
    err_o[1] = |syndrome_o[5:0] & ~syndrome_o[6];
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [71:0]
      prim_secded_inv_hamming_72_64_enc (logic [63:0] data_i);
    logic [71:0] data_o;
    data_o = 72'(data_i);
    data_o[64] = ^(data_o & 72'h00AB55555556AAAD5B);
    data_o[65] = ^(data_o & 72'h00CD9999999B33366D);
    data_o[66] = ^(data_o & 72'h00F1E1E1E1E3C3C78E);
    data_o[67] = ^(data_o & 72'h0001FE01FE03FC07F0);
    data_o[68] = ^(data_o & 72'h0001FFFE0003FFF800);
    data_o[69] = ^(data_o & 72'h0001FFFFFFFC000000);
    data_o[70] = ^(data_o & 72'h00FE00000000000000);
    data_o[71] = ^(data_o & 72'h7FFFFFFFFFFFFFFFFF);
    data_o ^= 72'hAA0000000000000000;
    return data_o;
  endfunction
  function automatic secded_inv_hamming_72_64_t
      prim_secded_inv_hamming_72_64_dec (logic [71:0] data_i);
    logic [63:0] data_o;
    logic [7:0] syndrome_o;
    logic [1:0]  err_o;
    secded_inv_hamming_72_64_t dec;
    syndrome_o[0] = ^((data_i ^ 72'hAA0000000000000000) & 72'h01AB55555556AAAD5B);
    syndrome_o[1] = ^((data_i ^ 72'hAA0000000000000000) & 72'h02CD9999999B33366D);
    syndrome_o[2] = ^((data_i ^ 72'hAA0000000000000000) & 72'h04F1E1E1E1E3C3C78E);
    syndrome_o[3] = ^((data_i ^ 72'hAA0000000000000000) & 72'h0801FE01FE03FC07F0);
    syndrome_o[4] = ^((data_i ^ 72'hAA0000000000000000) & 72'h1001FFFE0003FFF800);
    syndrome_o[5] = ^((data_i ^ 72'hAA0000000000000000) & 72'h2001FFFFFFFC000000);
    syndrome_o[6] = ^((data_i ^ 72'hAA0000000000000000) & 72'h40FE00000000000000);
    syndrome_o[7] = ^((data_i ^ 72'hAA0000000000000000) & 72'hFFFFFFFFFFFFFFFFFF);
    data_o[0] = (syndrome_o == 8'h83) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'h85) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h86) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h87) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h89) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h8a) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'h8b) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h8c) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h8d) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h8e) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h8f) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h91) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h92) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h93) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h94) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h95) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h96) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h97) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h98) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'h99) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'h9a) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'h9b) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h9c) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h9d) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h9e) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h9f) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'ha1) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'ha2) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'ha3) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'ha4) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'ha5) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'ha6) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'ha7) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'ha8) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha9) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'haa) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'hab) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'hac) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'had) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'hae) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'haf) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'hb0) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'hb1) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'hb2) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'hb3) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hb4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'hb5) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'hb6) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'hb7) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'hb8) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'hb9) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hba) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'hbb) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hbc) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hbd) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'hbe) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'hbf) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hc1) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'hc2) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hc3) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hc4) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hc5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hc6) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'hc7) ^ data_i[63];
    err_o[0] = syndrome_o[7];
    err_o[1] = |syndrome_o[6:0] & ~syndrome_o[7];
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
  function automatic logic [75:0]
      prim_secded_inv_hamming_76_68_enc (logic [67:0] data_i);
    logic [75:0] data_o;
    data_o = 76'(data_i);
    data_o[68] = ^(data_o & 76'h00AAB55555556AAAD5B);
    data_o[69] = ^(data_o & 76'h00CCD9999999B33366D);
    data_o[70] = ^(data_o & 76'h000F1E1E1E1E3C3C78E);
    data_o[71] = ^(data_o & 76'h00F01FE01FE03FC07F0);
    data_o[72] = ^(data_o & 76'h00001FFFE0003FFF800);
    data_o[73] = ^(data_o & 76'h00001FFFFFFFC000000);
    data_o[74] = ^(data_o & 76'h00FFE00000000000000);
    data_o[75] = ^(data_o & 76'h7FFFFFFFFFFFFFFFFFF);
    data_o ^= 76'hAA00000000000000000;
    return data_o;
  endfunction
  function automatic secded_inv_hamming_76_68_t
      prim_secded_inv_hamming_76_68_dec (logic [75:0] data_i);
    logic [67:0] data_o;
    logic [7:0] syndrome_o;
    logic [1:0]  err_o;
    secded_inv_hamming_76_68_t dec;
    syndrome_o[0] = ^((data_i ^ 76'hAA00000000000000000) & 76'h01AAB55555556AAAD5B);
    syndrome_o[1] = ^((data_i ^ 76'hAA00000000000000000) & 76'h02CCD9999999B33366D);
    syndrome_o[2] = ^((data_i ^ 76'hAA00000000000000000) & 76'h040F1E1E1E1E3C3C78E);
    syndrome_o[3] = ^((data_i ^ 76'hAA00000000000000000) & 76'h08F01FE01FE03FC07F0);
    syndrome_o[4] = ^((data_i ^ 76'hAA00000000000000000) & 76'h10001FFFE0003FFF800);
    syndrome_o[5] = ^((data_i ^ 76'hAA00000000000000000) & 76'h20001FFFFFFFC000000);
    syndrome_o[6] = ^((data_i ^ 76'hAA00000000000000000) & 76'h40FFE00000000000000);
    syndrome_o[7] = ^((data_i ^ 76'hAA00000000000000000) & 76'hFFFFFFFFFFFFFFFFFFF);
    data_o[0] = (syndrome_o == 8'h83) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'h85) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h86) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h87) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h89) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h8a) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'h8b) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h8c) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h8d) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h8e) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h8f) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h91) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h92) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h93) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h94) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h95) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h96) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h97) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h98) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'h99) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'h9a) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'h9b) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h9c) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h9d) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h9e) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h9f) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'ha1) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'ha2) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'ha3) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'ha4) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'ha5) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'ha6) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'ha7) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'ha8) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha9) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'haa) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'hab) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'hac) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'had) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'hae) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'haf) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'hb0) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'hb1) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'hb2) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'hb3) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hb4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'hb5) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'hb6) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'hb7) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'hb8) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'hb9) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hba) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'hbb) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hbc) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hbd) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'hbe) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'hbf) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hc1) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'hc2) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hc3) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hc4) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hc5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hc6) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'hc7) ^ data_i[63];
    data_o[64] = (syndrome_o == 8'hc8) ^ data_i[64];
    data_o[65] = (syndrome_o == 8'hc9) ^ data_i[65];
    data_o[66] = (syndrome_o == 8'hca) ^ data_i[66];
    data_o[67] = (syndrome_o == 8'hcb) ^ data_i[67];
    err_o[0] = syndrome_o[7];
    err_o[1] = |syndrome_o[6:0] & ~syndrome_o[7];
    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;
  endfunction
endpackage
module prim_secded_22_16_dec (
  input        [21:0] data_i,
  output logic [15:0] data_o,
  output logic [5:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^(data_i & 22'h01496E);
    syndrome_o[1] = ^(data_i & 22'h02F20B);
    syndrome_o[2] = ^(data_i & 22'h048ED8);
    syndrome_o[3] = ^(data_i & 22'h087714);
    syndrome_o[4] = ^(data_i & 22'h10ACA5);
    syndrome_o[5] = ^(data_i & 22'h2011F3);
    data_o[0] = (syndrome_o == 6'h32) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'h23) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h19) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h7) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'h2c) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h31) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h25) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h34) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h29) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'he) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'h1c) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h15) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h2a) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h1a) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'hb) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h16) ^ data_i[15];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
  end
endmodule : prim_secded_22_16_dec
module prim_secded_22_16_enc (
  input        [15:0] data_i,
  output logic [21:0] data_o
);
  always_comb begin : p_encode
    data_o = 22'(data_i);
    data_o[16] = ^(data_o & 22'h00496E);
    data_o[17] = ^(data_o & 22'h00F20B);
    data_o[18] = ^(data_o & 22'h008ED8);
    data_o[19] = ^(data_o & 22'h007714);
    data_o[20] = ^(data_o & 22'h00ACA5);
    data_o[21] = ^(data_o & 22'h0011F3);
  end
endmodule : prim_secded_22_16_enc
module prim_secded_28_22_dec (
  input        [27:0] data_i,
  output logic [21:0] data_o,
  output logic [5:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^(data_i & 28'h07003FF);
    syndrome_o[1] = ^(data_i & 28'h090FC0F);
    syndrome_o[2] = ^(data_i & 28'h1271C71);
    syndrome_o[3] = ^(data_i & 28'h23B6592);
    syndrome_o[4] = ^(data_i & 28'h43DAAA4);
    syndrome_o[5] = ^(data_i & 28'h83ED348);
    data_o[0] = (syndrome_o == 6'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'hd) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h15) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h25) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h19) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h29) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'h31) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'he) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h16) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h26) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h1a) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'h2a) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h32) ^ data_i[15];
    data_o[16] = (syndrome_o == 6'h1c) ^ data_i[16];
    data_o[17] = (syndrome_o == 6'h2c) ^ data_i[17];
    data_o[18] = (syndrome_o == 6'h34) ^ data_i[18];
    data_o[19] = (syndrome_o == 6'h38) ^ data_i[19];
    data_o[20] = (syndrome_o == 6'h3b) ^ data_i[20];
    data_o[21] = (syndrome_o == 6'h3d) ^ data_i[21];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
  end
endmodule : prim_secded_28_22_dec
module prim_secded_28_22_enc (
  input        [21:0] data_i,
  output logic [27:0] data_o
);
  always_comb begin : p_encode
    data_o = 28'(data_i);
    data_o[22] = ^(data_o & 28'h03003FF);
    data_o[23] = ^(data_o & 28'h010FC0F);
    data_o[24] = ^(data_o & 28'h0271C71);
    data_o[25] = ^(data_o & 28'h03B6592);
    data_o[26] = ^(data_o & 28'h03DAAA4);
    data_o[27] = ^(data_o & 28'h03ED348);
  end
endmodule : prim_secded_28_22_enc
module prim_secded_39_32_dec (
  input        [38:0] data_i,
  output logic [31:0] data_o,
  output logic [6:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^(data_i & 39'h012606BD25);
    syndrome_o[1] = ^(data_i & 39'h02DEBA8050);
    syndrome_o[2] = ^(data_i & 39'h04413D89AA);
    syndrome_o[3] = ^(data_i & 39'h0831234ED1);
    syndrome_o[4] = ^(data_i & 39'h10C2C1323B);
    syndrome_o[5] = ^(data_i & 39'h202DCC624C);
    syndrome_o[6] = ^(data_i & 39'h4098505586);
    data_o[0] = (syndrome_o == 7'h19) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'h54) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h61) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h34) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h1a) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'h15) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h2a) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h4c) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h45) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h38) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h49) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'hd) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h51) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h31) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h68) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'h7) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h1c) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'hb) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h25) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h26) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h46) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'he) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h70) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h32) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h2c) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h13) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h23) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h62) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h4a) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h29) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h16) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h52) ^ data_i[31];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
  end
endmodule : prim_secded_39_32_dec
module prim_secded_39_32_enc (
  input        [31:0] data_i,
  output logic [38:0] data_o
);
  always_comb begin : p_encode
    data_o = 39'(data_i);
    data_o[32] = ^(data_o & 39'h002606BD25);
    data_o[33] = ^(data_o & 39'h00DEBA8050);
    data_o[34] = ^(data_o & 39'h00413D89AA);
    data_o[35] = ^(data_o & 39'h0031234ED1);
    data_o[36] = ^(data_o & 39'h00C2C1323B);
    data_o[37] = ^(data_o & 39'h002DCC624C);
    data_o[38] = ^(data_o & 39'h0098505586);
  end
endmodule : prim_secded_39_32_enc
module prim_secded_64_57_dec (
  input        [63:0] data_i,
  output logic [56:0] data_o,
  output logic [6:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^(data_i & 64'h0303FFF800007FFF);
    syndrome_o[1] = ^(data_i & 64'h057C1FF801FF801F);
    syndrome_o[2] = ^(data_i & 64'h09BDE1F87E0781E1);
    syndrome_o[3] = ^(data_i & 64'h11DEEE3B8E388E22);
    syndrome_o[4] = ^(data_i & 64'h21EF76CDB2C93244);
    syndrome_o[5] = ^(data_i & 64'h41F7BB56D5525488);
    syndrome_o[6] = ^(data_i & 64'h81FBDDA769A46910);
    data_o[0] = (syndrome_o == 7'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h43) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'hd) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h15) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h25) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h45) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h19) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h29) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'h49) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h31) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h51) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h61) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'he) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h16) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'h26) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h46) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h1a) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h2a) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'h4a) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h32) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h52) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h62) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h1c) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h2c) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h4c) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h34) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h54) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h64) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h38) ^ data_i[31];
    data_o[32] = (syndrome_o == 7'h58) ^ data_i[32];
    data_o[33] = (syndrome_o == 7'h68) ^ data_i[33];
    data_o[34] = (syndrome_o == 7'h70) ^ data_i[34];
    data_o[35] = (syndrome_o == 7'h1f) ^ data_i[35];
    data_o[36] = (syndrome_o == 7'h2f) ^ data_i[36];
    data_o[37] = (syndrome_o == 7'h4f) ^ data_i[37];
    data_o[38] = (syndrome_o == 7'h37) ^ data_i[38];
    data_o[39] = (syndrome_o == 7'h57) ^ data_i[39];
    data_o[40] = (syndrome_o == 7'h67) ^ data_i[40];
    data_o[41] = (syndrome_o == 7'h3b) ^ data_i[41];
    data_o[42] = (syndrome_o == 7'h5b) ^ data_i[42];
    data_o[43] = (syndrome_o == 7'h6b) ^ data_i[43];
    data_o[44] = (syndrome_o == 7'h73) ^ data_i[44];
    data_o[45] = (syndrome_o == 7'h3d) ^ data_i[45];
    data_o[46] = (syndrome_o == 7'h5d) ^ data_i[46];
    data_o[47] = (syndrome_o == 7'h6d) ^ data_i[47];
    data_o[48] = (syndrome_o == 7'h75) ^ data_i[48];
    data_o[49] = (syndrome_o == 7'h79) ^ data_i[49];
    data_o[50] = (syndrome_o == 7'h3e) ^ data_i[50];
    data_o[51] = (syndrome_o == 7'h5e) ^ data_i[51];
    data_o[52] = (syndrome_o == 7'h6e) ^ data_i[52];
    data_o[53] = (syndrome_o == 7'h76) ^ data_i[53];
    data_o[54] = (syndrome_o == 7'h7a) ^ data_i[54];
    data_o[55] = (syndrome_o == 7'h7c) ^ data_i[55];
    data_o[56] = (syndrome_o == 7'h7f) ^ data_i[56];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
  end
endmodule : prim_secded_64_57_dec
module prim_secded_64_57_enc (
  input        [56:0] data_i,
  output logic [63:0] data_o
);
  always_comb begin : p_encode
    data_o = 64'(data_i);
    data_o[57] = ^(data_o & 64'h0103FFF800007FFF);
    data_o[58] = ^(data_o & 64'h017C1FF801FF801F);
    data_o[59] = ^(data_o & 64'h01BDE1F87E0781E1);
    data_o[60] = ^(data_o & 64'h01DEEE3B8E388E22);
    data_o[61] = ^(data_o & 64'h01EF76CDB2C93244);
    data_o[62] = ^(data_o & 64'h01F7BB56D5525488);
    data_o[63] = ^(data_o & 64'h01FBDDA769A46910);
  end
endmodule : prim_secded_64_57_enc
module prim_secded_72_64_dec (
  input        [71:0] data_i,
  output logic [63:0] data_o,
  output logic [7:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^(data_i & 72'h01B9000000001FFFFF);
    syndrome_o[1] = ^(data_i & 72'h025E00000FFFE0003F);
    syndrome_o[2] = ^(data_i & 72'h0467003FF003E007C1);
    syndrome_o[3] = ^(data_i & 72'h08CD0FC0F03C207842);
    syndrome_o[4] = ^(data_i & 72'h10B671C711C4438884);
    syndrome_o[5] = ^(data_i & 72'h20B5B65926488C9108);
    syndrome_o[6] = ^(data_i & 72'h40CBDAAA4A91152210);
    syndrome_o[7] = ^(data_i & 72'h807AED348D221A4420);
    data_o[0] = (syndrome_o == 8'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h43) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h83) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'hd) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h15) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h25) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h45) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h85) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h19) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h29) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h49) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h89) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h31) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h51) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h91) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h61) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'ha1) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'hc1) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'he) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h16) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h26) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h46) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h86) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'h1a) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'h2a) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'h4a) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'h8a) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'h32) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'h52) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'h92) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'h62) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha2) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'hc2) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'h1c) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'h2c) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'h4c) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'h8c) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'h34) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'h54) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'h94) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'h64) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'ha4) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hc4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'h38) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'h58) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'h98) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'h68) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'ha8) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hc8) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'h70) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hb0) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hd0) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'he0) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'h6d) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hd6) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'h3e) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hcb) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hb3) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hb5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hce) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'h79) ^ data_i[63];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
  end
endmodule : prim_secded_72_64_dec
module prim_secded_72_64_enc (
  input        [63:0] data_i,
  output logic [71:0] data_o
);
  always_comb begin : p_encode
    data_o = 72'(data_i);
    data_o[64] = ^(data_o & 72'h00B9000000001FFFFF);
    data_o[65] = ^(data_o & 72'h005E00000FFFE0003F);
    data_o[66] = ^(data_o & 72'h0067003FF003E007C1);
    data_o[67] = ^(data_o & 72'h00CD0FC0F03C207842);
    data_o[68] = ^(data_o & 72'h00B671C711C4438884);
    data_o[69] = ^(data_o & 72'h00B5B65926488C9108);
    data_o[70] = ^(data_o & 72'h00CBDAAA4A91152210);
    data_o[71] = ^(data_o & 72'h007AED348D221A4420);
  end
endmodule : prim_secded_72_64_enc
module prim_secded_hamming_22_16_dec (
  input        [21:0] data_i,
  output logic [15:0] data_o,
  output logic [5:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^(data_i & 22'h01AD5B);
    syndrome_o[1] = ^(data_i & 22'h02366D);
    syndrome_o[2] = ^(data_i & 22'h04C78E);
    syndrome_o[3] = ^(data_i & 22'h0807F0);
    syndrome_o[4] = ^(data_i & 22'h10F800);
    syndrome_o[5] = ^(data_i & 22'h3FFFFF);
    data_o[0] = (syndrome_o == 6'h23) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'h25) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h26) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h27) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'h29) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h2a) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h2b) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h2c) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h2d) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'h2e) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'h2f) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h31) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h32) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h33) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'h34) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h35) ^ data_i[15];
    err_o[0] = syndrome_o[5];
    err_o[1] = |syndrome_o[4:0] & ~syndrome_o[5];
  end
endmodule : prim_secded_hamming_22_16_dec
module prim_secded_hamming_22_16_enc (
  input        [15:0] data_i,
  output logic [21:0] data_o
);
  always_comb begin : p_encode
    data_o = 22'(data_i);
    data_o[16] = ^(data_o & 22'h00AD5B);
    data_o[17] = ^(data_o & 22'h00366D);
    data_o[18] = ^(data_o & 22'h00C78E);
    data_o[19] = ^(data_o & 22'h0007F0);
    data_o[20] = ^(data_o & 22'h00F800);
    data_o[21] = ^(data_o & 22'h1FFFFF);
  end
endmodule : prim_secded_hamming_22_16_enc
module prim_secded_hamming_39_32_dec (
  input        [38:0] data_i,
  output logic [31:0] data_o,
  output logic [6:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^(data_i & 39'h0156AAAD5B);
    syndrome_o[1] = ^(data_i & 39'h029B33366D);
    syndrome_o[2] = ^(data_i & 39'h04E3C3C78E);
    syndrome_o[3] = ^(data_i & 39'h0803FC07F0);
    syndrome_o[4] = ^(data_i & 39'h1003FFF800);
    syndrome_o[5] = ^(data_i & 39'h20FC000000);
    syndrome_o[6] = ^(data_i & 39'h7FFFFFFFFF);
    data_o[0] = (syndrome_o == 7'h43) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'h45) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h46) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h47) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h49) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'h4a) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h4b) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h4c) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h4d) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h4e) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h4f) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'h51) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h52) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h53) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h54) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'h55) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h56) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'h57) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h58) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h59) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h5a) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'h5b) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h5c) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h5d) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h5e) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h5f) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h61) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h62) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h63) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h64) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h65) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h66) ^ data_i[31];
    err_o[0] = syndrome_o[6];
    err_o[1] = |syndrome_o[5:0] & ~syndrome_o[6];
  end
endmodule : prim_secded_hamming_39_32_dec
module prim_secded_hamming_39_32_enc (
  input        [31:0] data_i,
  output logic [38:0] data_o
);
  always_comb begin : p_encode
    data_o = 39'(data_i);
    data_o[32] = ^(data_o & 39'h0056AAAD5B);
    data_o[33] = ^(data_o & 39'h009B33366D);
    data_o[34] = ^(data_o & 39'h00E3C3C78E);
    data_o[35] = ^(data_o & 39'h0003FC07F0);
    data_o[36] = ^(data_o & 39'h0003FFF800);
    data_o[37] = ^(data_o & 39'h00FC000000);
    data_o[38] = ^(data_o & 39'h3FFFFFFFFF);
  end
endmodule : prim_secded_hamming_39_32_enc
module prim_secded_hamming_72_64_dec (
  input        [71:0] data_i,
  output logic [63:0] data_o,
  output logic [7:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^(data_i & 72'h01AB55555556AAAD5B);
    syndrome_o[1] = ^(data_i & 72'h02CD9999999B33366D);
    syndrome_o[2] = ^(data_i & 72'h04F1E1E1E1E3C3C78E);
    syndrome_o[3] = ^(data_i & 72'h0801FE01FE03FC07F0);
    syndrome_o[4] = ^(data_i & 72'h1001FFFE0003FFF800);
    syndrome_o[5] = ^(data_i & 72'h2001FFFFFFFC000000);
    syndrome_o[6] = ^(data_i & 72'h40FE00000000000000);
    syndrome_o[7] = ^(data_i & 72'hFFFFFFFFFFFFFFFFFF);
    data_o[0] = (syndrome_o == 8'h83) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'h85) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h86) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h87) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h89) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h8a) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'h8b) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h8c) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h8d) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h8e) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h8f) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h91) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h92) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h93) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h94) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h95) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h96) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h97) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h98) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'h99) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'h9a) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'h9b) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h9c) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h9d) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h9e) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h9f) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'ha1) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'ha2) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'ha3) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'ha4) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'ha5) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'ha6) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'ha7) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'ha8) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha9) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'haa) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'hab) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'hac) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'had) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'hae) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'haf) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'hb0) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'hb1) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'hb2) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'hb3) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hb4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'hb5) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'hb6) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'hb7) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'hb8) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'hb9) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hba) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'hbb) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hbc) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hbd) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'hbe) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'hbf) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hc1) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'hc2) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hc3) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hc4) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hc5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hc6) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'hc7) ^ data_i[63];
    err_o[0] = syndrome_o[7];
    err_o[1] = |syndrome_o[6:0] & ~syndrome_o[7];
  end
endmodule : prim_secded_hamming_72_64_dec
module prim_secded_hamming_72_64_enc (
  input        [63:0] data_i,
  output logic [71:0] data_o
);
  always_comb begin : p_encode
    data_o = 72'(data_i);
    data_o[64] = ^(data_o & 72'h00AB55555556AAAD5B);
    data_o[65] = ^(data_o & 72'h00CD9999999B33366D);
    data_o[66] = ^(data_o & 72'h00F1E1E1E1E3C3C78E);
    data_o[67] = ^(data_o & 72'h0001FE01FE03FC07F0);
    data_o[68] = ^(data_o & 72'h0001FFFE0003FFF800);
    data_o[69] = ^(data_o & 72'h0001FFFFFFFC000000);
    data_o[70] = ^(data_o & 72'h00FE00000000000000);
    data_o[71] = ^(data_o & 72'h7FFFFFFFFFFFFFFFFF);
  end
endmodule : prim_secded_hamming_72_64_enc
module prim_secded_hamming_76_68_dec (
  input        [75:0] data_i,
  output logic [67:0] data_o,
  output logic [7:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^(data_i & 76'h01AAB55555556AAAD5B);
    syndrome_o[1] = ^(data_i & 76'h02CCD9999999B33366D);
    syndrome_o[2] = ^(data_i & 76'h040F1E1E1E1E3C3C78E);
    syndrome_o[3] = ^(data_i & 76'h08F01FE01FE03FC07F0);
    syndrome_o[4] = ^(data_i & 76'h10001FFFE0003FFF800);
    syndrome_o[5] = ^(data_i & 76'h20001FFFFFFFC000000);
    syndrome_o[6] = ^(data_i & 76'h40FFE00000000000000);
    syndrome_o[7] = ^(data_i & 76'hFFFFFFFFFFFFFFFFFFF);
    data_o[0] = (syndrome_o == 8'h83) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'h85) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h86) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h87) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h89) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h8a) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'h8b) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h8c) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h8d) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h8e) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h8f) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h91) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h92) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h93) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h94) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h95) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h96) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h97) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h98) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'h99) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'h9a) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'h9b) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h9c) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h9d) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h9e) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h9f) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'ha1) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'ha2) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'ha3) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'ha4) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'ha5) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'ha6) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'ha7) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'ha8) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha9) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'haa) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'hab) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'hac) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'had) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'hae) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'haf) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'hb0) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'hb1) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'hb2) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'hb3) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hb4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'hb5) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'hb6) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'hb7) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'hb8) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'hb9) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hba) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'hbb) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hbc) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hbd) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'hbe) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'hbf) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hc1) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'hc2) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hc3) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hc4) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hc5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hc6) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'hc7) ^ data_i[63];
    data_o[64] = (syndrome_o == 8'hc8) ^ data_i[64];
    data_o[65] = (syndrome_o == 8'hc9) ^ data_i[65];
    data_o[66] = (syndrome_o == 8'hca) ^ data_i[66];
    data_o[67] = (syndrome_o == 8'hcb) ^ data_i[67];
    err_o[0] = syndrome_o[7];
    err_o[1] = |syndrome_o[6:0] & ~syndrome_o[7];
  end
endmodule : prim_secded_hamming_76_68_dec
module prim_secded_hamming_76_68_enc (
  input        [67:0] data_i,
  output logic [75:0] data_o
);
  always_comb begin : p_encode
    data_o = 76'(data_i);
    data_o[68] = ^(data_o & 76'h00AAB55555556AAAD5B);
    data_o[69] = ^(data_o & 76'h00CCD9999999B33366D);
    data_o[70] = ^(data_o & 76'h000F1E1E1E1E3C3C78E);
    data_o[71] = ^(data_o & 76'h00F01FE01FE03FC07F0);
    data_o[72] = ^(data_o & 76'h00001FFFE0003FFF800);
    data_o[73] = ^(data_o & 76'h00001FFFFFFFC000000);
    data_o[74] = ^(data_o & 76'h00FFE00000000000000);
    data_o[75] = ^(data_o & 76'h7FFFFFFFFFFFFFFFFFF);
  end
endmodule : prim_secded_hamming_76_68_enc
module prim_secded_inv_22_16_dec (
  input        [21:0] data_i,
  output logic [15:0] data_o,
  output logic [5:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^((data_i ^ 22'h2A0000) & 22'h01496E);
    syndrome_o[1] = ^((data_i ^ 22'h2A0000) & 22'h02F20B);
    syndrome_o[2] = ^((data_i ^ 22'h2A0000) & 22'h048ED8);
    syndrome_o[3] = ^((data_i ^ 22'h2A0000) & 22'h087714);
    syndrome_o[4] = ^((data_i ^ 22'h2A0000) & 22'h10ACA5);
    syndrome_o[5] = ^((data_i ^ 22'h2A0000) & 22'h2011F3);
    data_o[0] = (syndrome_o == 6'h32) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'h23) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h19) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h7) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'h2c) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h31) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h25) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h34) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h29) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'he) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'h1c) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h15) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h2a) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h1a) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'hb) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h16) ^ data_i[15];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
  end
endmodule : prim_secded_inv_22_16_dec
module prim_secded_inv_22_16_enc (
  input        [15:0] data_i,
  output logic [21:0] data_o
);
  always_comb begin : p_encode
    data_o = 22'(data_i);
    data_o[16] = ^(data_o & 22'h00496E);
    data_o[17] = ^(data_o & 22'h00F20B);
    data_o[18] = ^(data_o & 22'h008ED8);
    data_o[19] = ^(data_o & 22'h007714);
    data_o[20] = ^(data_o & 22'h00ACA5);
    data_o[21] = ^(data_o & 22'h0011F3);
    data_o ^= 22'h2A0000;
  end
endmodule : prim_secded_inv_22_16_enc
module prim_secded_inv_28_22_dec (
  input        [27:0] data_i,
  output logic [21:0] data_o,
  output logic [5:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^((data_i ^ 28'hA800000) & 28'h07003FF);
    syndrome_o[1] = ^((data_i ^ 28'hA800000) & 28'h090FC0F);
    syndrome_o[2] = ^((data_i ^ 28'hA800000) & 28'h1271C71);
    syndrome_o[3] = ^((data_i ^ 28'hA800000) & 28'h23B6592);
    syndrome_o[4] = ^((data_i ^ 28'hA800000) & 28'h43DAAA4);
    syndrome_o[5] = ^((data_i ^ 28'hA800000) & 28'h83ED348);
    data_o[0] = (syndrome_o == 6'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'hd) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h15) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h25) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h19) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h29) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'h31) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'he) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h16) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h26) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h1a) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'h2a) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h32) ^ data_i[15];
    data_o[16] = (syndrome_o == 6'h1c) ^ data_i[16];
    data_o[17] = (syndrome_o == 6'h2c) ^ data_i[17];
    data_o[18] = (syndrome_o == 6'h34) ^ data_i[18];
    data_o[19] = (syndrome_o == 6'h38) ^ data_i[19];
    data_o[20] = (syndrome_o == 6'h3b) ^ data_i[20];
    data_o[21] = (syndrome_o == 6'h3d) ^ data_i[21];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
  end
endmodule : prim_secded_inv_28_22_dec
module prim_secded_inv_28_22_enc (
  input        [21:0] data_i,
  output logic [27:0] data_o
);
  always_comb begin : p_encode
    data_o = 28'(data_i);
    data_o[22] = ^(data_o & 28'h03003FF);
    data_o[23] = ^(data_o & 28'h010FC0F);
    data_o[24] = ^(data_o & 28'h0271C71);
    data_o[25] = ^(data_o & 28'h03B6592);
    data_o[26] = ^(data_o & 28'h03DAAA4);
    data_o[27] = ^(data_o & 28'h03ED348);
    data_o ^= 28'hA800000;
  end
endmodule : prim_secded_inv_28_22_enc
module prim_secded_inv_39_32_dec (
  input        [38:0] data_i,
  output logic [31:0] data_o,
  output logic [6:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^((data_i ^ 39'h2A00000000) & 39'h012606BD25);
    syndrome_o[1] = ^((data_i ^ 39'h2A00000000) & 39'h02DEBA8050);
    syndrome_o[2] = ^((data_i ^ 39'h2A00000000) & 39'h04413D89AA);
    syndrome_o[3] = ^((data_i ^ 39'h2A00000000) & 39'h0831234ED1);
    syndrome_o[4] = ^((data_i ^ 39'h2A00000000) & 39'h10C2C1323B);
    syndrome_o[5] = ^((data_i ^ 39'h2A00000000) & 39'h202DCC624C);
    syndrome_o[6] = ^((data_i ^ 39'h2A00000000) & 39'h4098505586);
    data_o[0] = (syndrome_o == 7'h19) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'h54) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h61) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h34) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h1a) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'h15) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h2a) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h4c) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h45) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h38) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h49) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'hd) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h51) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h31) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h68) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'h7) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h1c) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'hb) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h25) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h26) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h46) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'he) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h70) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h32) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h2c) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h13) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h23) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h62) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h4a) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h29) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h16) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h52) ^ data_i[31];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
  end
endmodule : prim_secded_inv_39_32_dec
module prim_secded_inv_39_32_enc (
  input        [31:0] data_i,
  output logic [38:0] data_o
);
  always_comb begin : p_encode
    data_o = 39'(data_i);
    data_o[32] = ^(data_o & 39'h002606BD25);
    data_o[33] = ^(data_o & 39'h00DEBA8050);
    data_o[34] = ^(data_o & 39'h00413D89AA);
    data_o[35] = ^(data_o & 39'h0031234ED1);
    data_o[36] = ^(data_o & 39'h00C2C1323B);
    data_o[37] = ^(data_o & 39'h002DCC624C);
    data_o[38] = ^(data_o & 39'h0098505586);
    data_o ^= 39'h2A00000000;
  end
endmodule : prim_secded_inv_39_32_enc
module prim_secded_inv_64_57_dec (
  input        [63:0] data_i,
  output logic [56:0] data_o,
  output logic [6:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^((data_i ^ 64'h5400000000000000) & 64'h0303FFF800007FFF);
    syndrome_o[1] = ^((data_i ^ 64'h5400000000000000) & 64'h057C1FF801FF801F);
    syndrome_o[2] = ^((data_i ^ 64'h5400000000000000) & 64'h09BDE1F87E0781E1);
    syndrome_o[3] = ^((data_i ^ 64'h5400000000000000) & 64'h11DEEE3B8E388E22);
    syndrome_o[4] = ^((data_i ^ 64'h5400000000000000) & 64'h21EF76CDB2C93244);
    syndrome_o[5] = ^((data_i ^ 64'h5400000000000000) & 64'h41F7BB56D5525488);
    syndrome_o[6] = ^((data_i ^ 64'h5400000000000000) & 64'h81FBDDA769A46910);
    data_o[0] = (syndrome_o == 7'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h43) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'hd) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h15) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h25) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h45) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h19) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h29) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'h49) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h31) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h51) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h61) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'he) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h16) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'h26) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h46) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h1a) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h2a) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'h4a) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h32) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h52) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h62) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h1c) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h2c) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h4c) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h34) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h54) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h64) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h38) ^ data_i[31];
    data_o[32] = (syndrome_o == 7'h58) ^ data_i[32];
    data_o[33] = (syndrome_o == 7'h68) ^ data_i[33];
    data_o[34] = (syndrome_o == 7'h70) ^ data_i[34];
    data_o[35] = (syndrome_o == 7'h1f) ^ data_i[35];
    data_o[36] = (syndrome_o == 7'h2f) ^ data_i[36];
    data_o[37] = (syndrome_o == 7'h4f) ^ data_i[37];
    data_o[38] = (syndrome_o == 7'h37) ^ data_i[38];
    data_o[39] = (syndrome_o == 7'h57) ^ data_i[39];
    data_o[40] = (syndrome_o == 7'h67) ^ data_i[40];
    data_o[41] = (syndrome_o == 7'h3b) ^ data_i[41];
    data_o[42] = (syndrome_o == 7'h5b) ^ data_i[42];
    data_o[43] = (syndrome_o == 7'h6b) ^ data_i[43];
    data_o[44] = (syndrome_o == 7'h73) ^ data_i[44];
    data_o[45] = (syndrome_o == 7'h3d) ^ data_i[45];
    data_o[46] = (syndrome_o == 7'h5d) ^ data_i[46];
    data_o[47] = (syndrome_o == 7'h6d) ^ data_i[47];
    data_o[48] = (syndrome_o == 7'h75) ^ data_i[48];
    data_o[49] = (syndrome_o == 7'h79) ^ data_i[49];
    data_o[50] = (syndrome_o == 7'h3e) ^ data_i[50];
    data_o[51] = (syndrome_o == 7'h5e) ^ data_i[51];
    data_o[52] = (syndrome_o == 7'h6e) ^ data_i[52];
    data_o[53] = (syndrome_o == 7'h76) ^ data_i[53];
    data_o[54] = (syndrome_o == 7'h7a) ^ data_i[54];
    data_o[55] = (syndrome_o == 7'h7c) ^ data_i[55];
    data_o[56] = (syndrome_o == 7'h7f) ^ data_i[56];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
  end
endmodule : prim_secded_inv_64_57_dec
module prim_secded_inv_64_57_enc (
  input        [56:0] data_i,
  output logic [63:0] data_o
);
  always_comb begin : p_encode
    data_o = 64'(data_i);
    data_o[57] = ^(data_o & 64'h0103FFF800007FFF);
    data_o[58] = ^(data_o & 64'h017C1FF801FF801F);
    data_o[59] = ^(data_o & 64'h01BDE1F87E0781E1);
    data_o[60] = ^(data_o & 64'h01DEEE3B8E388E22);
    data_o[61] = ^(data_o & 64'h01EF76CDB2C93244);
    data_o[62] = ^(data_o & 64'h01F7BB56D5525488);
    data_o[63] = ^(data_o & 64'h01FBDDA769A46910);
    data_o ^= 64'h5400000000000000;
  end
endmodule : prim_secded_inv_64_57_enc
module prim_secded_inv_72_64_dec (
  input        [71:0] data_i,
  output logic [63:0] data_o,
  output logic [7:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^((data_i ^ 72'hAA0000000000000000) & 72'h01B9000000001FFFFF);
    syndrome_o[1] = ^((data_i ^ 72'hAA0000000000000000) & 72'h025E00000FFFE0003F);
    syndrome_o[2] = ^((data_i ^ 72'hAA0000000000000000) & 72'h0467003FF003E007C1);
    syndrome_o[3] = ^((data_i ^ 72'hAA0000000000000000) & 72'h08CD0FC0F03C207842);
    syndrome_o[4] = ^((data_i ^ 72'hAA0000000000000000) & 72'h10B671C711C4438884);
    syndrome_o[5] = ^((data_i ^ 72'hAA0000000000000000) & 72'h20B5B65926488C9108);
    syndrome_o[6] = ^((data_i ^ 72'hAA0000000000000000) & 72'h40CBDAAA4A91152210);
    syndrome_o[7] = ^((data_i ^ 72'hAA0000000000000000) & 72'h807AED348D221A4420);
    data_o[0] = (syndrome_o == 8'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h43) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h83) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'hd) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h15) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h25) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h45) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h85) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h19) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h29) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h49) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h89) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h31) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h51) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h91) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h61) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'ha1) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'hc1) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'he) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h16) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h26) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h46) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h86) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'h1a) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'h2a) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'h4a) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'h8a) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'h32) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'h52) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'h92) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'h62) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha2) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'hc2) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'h1c) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'h2c) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'h4c) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'h8c) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'h34) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'h54) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'h94) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'h64) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'ha4) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hc4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'h38) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'h58) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'h98) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'h68) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'ha8) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hc8) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'h70) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hb0) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hd0) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'he0) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'h6d) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hd6) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'h3e) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hcb) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hb3) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hb5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hce) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'h79) ^ data_i[63];
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
  end
endmodule : prim_secded_inv_72_64_dec
module prim_secded_inv_72_64_enc (
  input        [63:0] data_i,
  output logic [71:0] data_o
);
  always_comb begin : p_encode
    data_o = 72'(data_i);
    data_o[64] = ^(data_o & 72'h00B9000000001FFFFF);
    data_o[65] = ^(data_o & 72'h005E00000FFFE0003F);
    data_o[66] = ^(data_o & 72'h0067003FF003E007C1);
    data_o[67] = ^(data_o & 72'h00CD0FC0F03C207842);
    data_o[68] = ^(data_o & 72'h00B671C711C4438884);
    data_o[69] = ^(data_o & 72'h00B5B65926488C9108);
    data_o[70] = ^(data_o & 72'h00CBDAAA4A91152210);
    data_o[71] = ^(data_o & 72'h007AED348D221A4420);
    data_o ^= 72'hAA0000000000000000;
  end
endmodule : prim_secded_inv_72_64_enc
module prim_secded_inv_hamming_22_16_dec (
  input        [21:0] data_i,
  output logic [15:0] data_o,
  output logic [5:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^((data_i ^ 22'h2A0000) & 22'h01AD5B);
    syndrome_o[1] = ^((data_i ^ 22'h2A0000) & 22'h02366D);
    syndrome_o[2] = ^((data_i ^ 22'h2A0000) & 22'h04C78E);
    syndrome_o[3] = ^((data_i ^ 22'h2A0000) & 22'h0807F0);
    syndrome_o[4] = ^((data_i ^ 22'h2A0000) & 22'h10F800);
    syndrome_o[5] = ^((data_i ^ 22'h2A0000) & 22'h3FFFFF);
    data_o[0] = (syndrome_o == 6'h23) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'h25) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h26) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h27) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'h29) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h2a) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h2b) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h2c) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h2d) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'h2e) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'h2f) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h31) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h32) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h33) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'h34) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h35) ^ data_i[15];
    err_o[0] = syndrome_o[5];
    err_o[1] = |syndrome_o[4:0] & ~syndrome_o[5];
  end
endmodule : prim_secded_inv_hamming_22_16_dec
module prim_secded_inv_hamming_22_16_enc (
  input        [15:0] data_i,
  output logic [21:0] data_o
);
  always_comb begin : p_encode
    data_o = 22'(data_i);
    data_o[16] = ^(data_o & 22'h00AD5B);
    data_o[17] = ^(data_o & 22'h00366D);
    data_o[18] = ^(data_o & 22'h00C78E);
    data_o[19] = ^(data_o & 22'h0007F0);
    data_o[20] = ^(data_o & 22'h00F800);
    data_o[21] = ^(data_o & 22'h1FFFFF);
    data_o ^= 22'h2A0000;
  end
endmodule : prim_secded_inv_hamming_22_16_enc
module prim_secded_inv_hamming_39_32_dec (
  input        [38:0] data_i,
  output logic [31:0] data_o,
  output logic [6:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^((data_i ^ 39'h2A00000000) & 39'h0156AAAD5B);
    syndrome_o[1] = ^((data_i ^ 39'h2A00000000) & 39'h029B33366D);
    syndrome_o[2] = ^((data_i ^ 39'h2A00000000) & 39'h04E3C3C78E);
    syndrome_o[3] = ^((data_i ^ 39'h2A00000000) & 39'h0803FC07F0);
    syndrome_o[4] = ^((data_i ^ 39'h2A00000000) & 39'h1003FFF800);
    syndrome_o[5] = ^((data_i ^ 39'h2A00000000) & 39'h20FC000000);
    syndrome_o[6] = ^((data_i ^ 39'h2A00000000) & 39'h7FFFFFFFFF);
    data_o[0] = (syndrome_o == 7'h43) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'h45) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h46) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h47) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h49) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'h4a) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h4b) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h4c) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h4d) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h4e) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h4f) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'h51) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h52) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h53) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h54) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'h55) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h56) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'h57) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h58) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h59) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h5a) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'h5b) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h5c) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h5d) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h5e) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h5f) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h61) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h62) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h63) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h64) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h65) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h66) ^ data_i[31];
    err_o[0] = syndrome_o[6];
    err_o[1] = |syndrome_o[5:0] & ~syndrome_o[6];
  end
endmodule : prim_secded_inv_hamming_39_32_dec
module prim_secded_inv_hamming_39_32_enc (
  input        [31:0] data_i,
  output logic [38:0] data_o
);
  always_comb begin : p_encode
    data_o = 39'(data_i);
    data_o[32] = ^(data_o & 39'h0056AAAD5B);
    data_o[33] = ^(data_o & 39'h009B33366D);
    data_o[34] = ^(data_o & 39'h00E3C3C78E);
    data_o[35] = ^(data_o & 39'h0003FC07F0);
    data_o[36] = ^(data_o & 39'h0003FFF800);
    data_o[37] = ^(data_o & 39'h00FC000000);
    data_o[38] = ^(data_o & 39'h3FFFFFFFFF);
    data_o ^= 39'h2A00000000;
  end
endmodule : prim_secded_inv_hamming_39_32_enc
module prim_secded_inv_hamming_72_64_dec (
  input        [71:0] data_i,
  output logic [63:0] data_o,
  output logic [7:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^((data_i ^ 72'hAA0000000000000000) & 72'h01AB55555556AAAD5B);
    syndrome_o[1] = ^((data_i ^ 72'hAA0000000000000000) & 72'h02CD9999999B33366D);
    syndrome_o[2] = ^((data_i ^ 72'hAA0000000000000000) & 72'h04F1E1E1E1E3C3C78E);
    syndrome_o[3] = ^((data_i ^ 72'hAA0000000000000000) & 72'h0801FE01FE03FC07F0);
    syndrome_o[4] = ^((data_i ^ 72'hAA0000000000000000) & 72'h1001FFFE0003FFF800);
    syndrome_o[5] = ^((data_i ^ 72'hAA0000000000000000) & 72'h2001FFFFFFFC000000);
    syndrome_o[6] = ^((data_i ^ 72'hAA0000000000000000) & 72'h40FE00000000000000);
    syndrome_o[7] = ^((data_i ^ 72'hAA0000000000000000) & 72'hFFFFFFFFFFFFFFFFFF);
    data_o[0] = (syndrome_o == 8'h83) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'h85) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h86) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h87) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h89) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h8a) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'h8b) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h8c) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h8d) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h8e) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h8f) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h91) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h92) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h93) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h94) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h95) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h96) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h97) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h98) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'h99) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'h9a) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'h9b) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h9c) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h9d) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h9e) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h9f) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'ha1) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'ha2) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'ha3) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'ha4) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'ha5) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'ha6) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'ha7) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'ha8) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha9) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'haa) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'hab) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'hac) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'had) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'hae) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'haf) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'hb0) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'hb1) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'hb2) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'hb3) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hb4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'hb5) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'hb6) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'hb7) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'hb8) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'hb9) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hba) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'hbb) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hbc) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hbd) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'hbe) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'hbf) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hc1) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'hc2) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hc3) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hc4) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hc5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hc6) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'hc7) ^ data_i[63];
    err_o[0] = syndrome_o[7];
    err_o[1] = |syndrome_o[6:0] & ~syndrome_o[7];
  end
endmodule : prim_secded_inv_hamming_72_64_dec
module prim_secded_inv_hamming_72_64_enc (
  input        [63:0] data_i,
  output logic [71:0] data_o
);
  always_comb begin : p_encode
    data_o = 72'(data_i);
    data_o[64] = ^(data_o & 72'h00AB55555556AAAD5B);
    data_o[65] = ^(data_o & 72'h00CD9999999B33366D);
    data_o[66] = ^(data_o & 72'h00F1E1E1E1E3C3C78E);
    data_o[67] = ^(data_o & 72'h0001FE01FE03FC07F0);
    data_o[68] = ^(data_o & 72'h0001FFFE0003FFF800);
    data_o[69] = ^(data_o & 72'h0001FFFFFFFC000000);
    data_o[70] = ^(data_o & 72'h00FE00000000000000);
    data_o[71] = ^(data_o & 72'h7FFFFFFFFFFFFFFFFF);
    data_o ^= 72'hAA0000000000000000;
  end
endmodule : prim_secded_inv_hamming_72_64_enc
module prim_secded_inv_hamming_76_68_dec (
  input        [75:0] data_i,
  output logic [67:0] data_o,
  output logic [7:0] syndrome_o,
  output logic [1:0] err_o
);
  always_comb begin : p_encode
    syndrome_o[0] = ^((data_i ^ 76'hAA00000000000000000) & 76'h01AAB55555556AAAD5B);
    syndrome_o[1] = ^((data_i ^ 76'hAA00000000000000000) & 76'h02CCD9999999B33366D);
    syndrome_o[2] = ^((data_i ^ 76'hAA00000000000000000) & 76'h040F1E1E1E1E3C3C78E);
    syndrome_o[3] = ^((data_i ^ 76'hAA00000000000000000) & 76'h08F01FE01FE03FC07F0);
    syndrome_o[4] = ^((data_i ^ 76'hAA00000000000000000) & 76'h10001FFFE0003FFF800);
    syndrome_o[5] = ^((data_i ^ 76'hAA00000000000000000) & 76'h20001FFFFFFFC000000);
    syndrome_o[6] = ^((data_i ^ 76'hAA00000000000000000) & 76'h40FFE00000000000000);
    syndrome_o[7] = ^((data_i ^ 76'hAA00000000000000000) & 76'hFFFFFFFFFFFFFFFFFFF);
    data_o[0] = (syndrome_o == 8'h83) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'h85) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h86) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h87) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h89) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h8a) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'h8b) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h8c) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h8d) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h8e) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h8f) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h91) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h92) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h93) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h94) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h95) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h96) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h97) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h98) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'h99) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'h9a) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'h9b) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h9c) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h9d) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h9e) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h9f) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'ha1) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'ha2) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'ha3) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'ha4) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'ha5) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'ha6) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'ha7) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'ha8) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha9) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'haa) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'hab) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'hac) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'had) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'hae) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'haf) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'hb0) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'hb1) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'hb2) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'hb3) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hb4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'hb5) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'hb6) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'hb7) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'hb8) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'hb9) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hba) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'hbb) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hbc) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hbd) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'hbe) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'hbf) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hc1) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'hc2) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hc3) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hc4) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hc5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hc6) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'hc7) ^ data_i[63];
    data_o[64] = (syndrome_o == 8'hc8) ^ data_i[64];
    data_o[65] = (syndrome_o == 8'hc9) ^ data_i[65];
    data_o[66] = (syndrome_o == 8'hca) ^ data_i[66];
    data_o[67] = (syndrome_o == 8'hcb) ^ data_i[67];
    err_o[0] = syndrome_o[7];
    err_o[1] = |syndrome_o[6:0] & ~syndrome_o[7];
  end
endmodule : prim_secded_inv_hamming_76_68_dec
module prim_secded_inv_hamming_76_68_enc (
  input        [67:0] data_i,
  output logic [75:0] data_o
);
  always_comb begin : p_encode
    data_o = 76'(data_i);
    data_o[68] = ^(data_o & 76'h00AAB55555556AAAD5B);
    data_o[69] = ^(data_o & 76'h00CCD9999999B33366D);
    data_o[70] = ^(data_o & 76'h000F1E1E1E1E3C3C78E);
    data_o[71] = ^(data_o & 76'h00F01FE01FE03FC07F0);
    data_o[72] = ^(data_o & 76'h00001FFFE0003FFF800);
    data_o[73] = ^(data_o & 76'h00001FFFFFFFC000000);
    data_o[74] = ^(data_o & 76'h00FFE00000000000000);
    data_o[75] = ^(data_o & 76'h7FFFFFFFFFFFFFFFFFF);
    data_o ^= 76'hAA00000000000000000;
  end
endmodule : prim_secded_inv_hamming_76_68_enc
module ibex_icache import ibex_pkg::*; #(
  parameter bit          ICacheECC       = 1'b0,
  parameter bit          ResetAll        = 1'b0,
  parameter int unsigned BusSizeECC      = BUS_SIZE,
  parameter int unsigned TagSizeECC      = IC_TAG_SIZE,
  parameter int unsigned LineSizeECC     = IC_LINE_SIZE,
  parameter bit          BranchCache     = 1'b0,
  parameter bit          TweakInfection  = 1'b0
) (
  input  logic                           clk_i,
  input  logic                           rst_ni,
  input  logic                           req_i,
  input  logic                           branch_i,
  input  logic [31:0]                    addr_i,
  input  logic                           ready_i,
  output logic                           valid_o,
  output logic [31:0]                    rdata_o,
  output logic [31:0]                    addr_o,
  output logic                           err_o,
  output logic                           err_plus2_o,
  output logic                           instr_req_o,
  input  logic                           instr_gnt_i,
  output logic [31:0]                    instr_addr_o,
  input  logic [BUS_SIZE-1:0]            instr_rdata_i,
  input  logic                           instr_err_i,
  input  logic                           instr_rvalid_i,
  output logic [IC_NUM_WAYS-1:0]         ic_tag_req_o,
  output logic                           ic_tag_write_o,
  output logic [IC_INDEX_W-1:0]          ic_tag_addr_o,
  output logic [TagSizeECC-1:0]          ic_tag_wdata_o,
  input  logic [TagSizeECC-1:0]          ic_tag_rdata_i [IC_NUM_WAYS],
  output logic [IC_NUM_WAYS-1:0]         ic_data_req_o,
  output logic                           ic_data_write_o,
  output logic [IC_INDEX_W-1:0]          ic_data_addr_o,
  output logic [LineSizeECC-1:0]         ic_data_wdata_o,
  input  logic [LineSizeECC-1:0]         ic_data_rdata_i [IC_NUM_WAYS],
  input  logic                           ic_scr_key_valid_i,
  output logic                           ic_scr_key_req_o,
  input  logic                           icache_enable_i,
  input  logic                           icache_inval_i,
  output logic                           busy_o,
  output logic                           ecc_error_o
);
  localparam int unsigned NUM_FB        = 4;
  localparam int unsigned FB_THRESHOLD  = NUM_FB - 2;
  logic [ADDR_W-1:0]                      lookup_addr_aligned;
  logic [ADDR_W-1:0]                      prefetch_addr_d, prefetch_addr_q;
  logic                                   prefetch_addr_en;
  logic                                   lookup_throttle;
  logic                                   lookup_req_ic0;
  logic [ADDR_W-1:0]                      lookup_addr_ic0;
  logic [IC_INDEX_W-1:0]                  lookup_index_ic0;
  logic                                   fill_req_ic0;
  logic [IC_INDEX_W-1:0]                  fill_index_ic0;
  logic [IC_TAG_SIZE-1:0]                 fill_tag_ic0;
  logic [IC_LINE_SIZE-1:0]                fill_wdata_ic0;
  logic                                   lookup_grant_ic0;
  logic                                   lookup_actual_ic0;
  logic                                   fill_grant_ic0;
  logic                                   tag_req_ic0;
  logic [IC_INDEX_W-1:0]                  tag_index_ic0;
  logic [IC_NUM_WAYS-1:0]                 tag_banks_ic0;
  logic                                   tag_write_ic0;
  logic [TagSizeECC-1:0]                  tag_wdata_ic0;
  logic                                   data_req_ic0;
  logic [IC_INDEX_W-1:0]                  data_index_ic0;
  logic [IC_NUM_WAYS-1:0]                 data_banks_ic0;
  logic                                   data_write_ic0;
  logic [LineSizeECC-1:0]                 data_wdata_ic0;
  logic [LineSizeECC-1:0]                 data_tweak_lw_ic0;
  logic [LineSizeECC-1:0]                 data_tweak_lw_ic1;
  logic [TagSizeECC-1:0]                  tag_tweak_lw_ic0;
  logic [TagSizeECC-1:0]                  tag_tweak_lw_ic1;
  logic [TagSizeECC-1:0]                  tag_rdata_ic1  [IC_NUM_WAYS];
  logic [LineSizeECC-1:0]                 hit_data_ecc_ic1;
  logic [IC_LINE_SIZE-1:0]                hit_data_ic1;
  logic                                   lookup_valid_ic1;
  logic [ADDR_W-1:IC_INDEX_HI+1]          lookup_addr_ic1;
  logic [IC_NUM_WAYS-1:0]                 tag_match_ic1;
  logic                                   tag_hit_ic1;
  logic [IC_NUM_WAYS-1:0]                 tag_invalid_ic1;
  logic [IC_NUM_WAYS-1:0]                 lowest_invalid_way_ic1;
  logic [IC_NUM_WAYS-1:0]                 round_robin_way_ic1, round_robin_way_q;
  logic [IC_NUM_WAYS-1:0]                 sel_way_ic1;
  logic                                   ecc_err_ic1;
  logic                                   ecc_write_req;
  logic [IC_NUM_WAYS-1:0]                 ecc_write_ways;
  logic [IC_INDEX_W-1:0]                  ecc_write_index;
  logic [$clog2(NUM_FB)-1:0]              fb_fill_level;
  logic                                   fill_cache_new;
  logic                                   fill_new_alloc;
  logic                                   fill_spec_req, fill_spec_done, fill_spec_hold;
  logic [NUM_FB-1:0][NUM_FB-1:0]          fill_older_d, fill_older_q;
  logic [NUM_FB-1:0]                      fill_alloc_sel, fill_alloc;
  logic [NUM_FB-1:0]                      fill_busy_d, fill_busy_q;
  logic [NUM_FB-1:0]                      fill_done;
  logic [NUM_FB-1:0]                      fill_in_ic1;
  logic [NUM_FB-1:0]                      fill_stale_d, fill_stale_q;
  logic [NUM_FB-1:0]                      fill_cache_d, fill_cache_q;
  logic [NUM_FB-1:0]                      fill_hit_ic1, fill_hit_d, fill_hit_q;
  logic [NUM_FB-1:0][IC_LINE_BEATS_W:0]   fill_ext_cnt_d, fill_ext_cnt_q;
  logic [NUM_FB-1:0]                      fill_ext_hold_d, fill_ext_hold_q;
  logic [NUM_FB-1:0]                      fill_ext_done_d, fill_ext_done_q;
  logic [NUM_FB-1:0][IC_LINE_BEATS_W:0]   fill_rvd_cnt_d, fill_rvd_cnt_q;
  logic [NUM_FB-1:0]                      fill_rvd_done;
  logic [NUM_FB-1:0]                      fill_ram_done_d, fill_ram_done_q;
  logic [NUM_FB-1:0]                      fill_out_grant;
  logic [NUM_FB-1:0][IC_LINE_BEATS_W:0]   fill_out_cnt_d, fill_out_cnt_q;
  logic [NUM_FB-1:0]                      fill_out_done;
  logic [NUM_FB-1:0]                      fill_ext_req, fill_rvd_exp, fill_ram_req, fill_out_req;
  logic [NUM_FB-1:0]                      fill_data_sel, fill_data_reg;
  logic [NUM_FB-1:0]                      fill_data_hit, fill_data_rvd;
  logic [NUM_FB-1:0][IC_LINE_BEATS_W-1:0] fill_ext_off, fill_rvd_off;
  logic [NUM_FB-1:0][IC_LINE_BEATS_W:0]   fill_ext_beat, fill_rvd_beat;
  logic [NUM_FB-1:0]                      fill_ext_arb, fill_ram_arb, fill_out_arb;
  logic [NUM_FB-1:0]                      fill_rvd_arb;
  logic [NUM_FB-1:0]                      fill_entry_en;
  logic [NUM_FB-1:0]                      fill_addr_en;
  logic [NUM_FB-1:0]                      fill_way_en;
  logic [NUM_FB-1:0][IC_LINE_BEATS-1:0]   fill_data_en;
  logic [NUM_FB-1:0][IC_LINE_BEATS-1:0]   fill_err_d, fill_err_q;
  logic [ADDR_W-1:0]                      fill_addr_q [NUM_FB];
  logic [IC_NUM_WAYS-1:0]                 fill_way_q  [NUM_FB];
  logic [IC_LINE_SIZE-1:0]                fill_data_d [NUM_FB];
  logic [IC_LINE_SIZE-1:0]                fill_data_q [NUM_FB];
  logic [ADDR_W-1:BUS_W]                  fill_ext_req_addr;
  logic [ADDR_W-1:0]                      fill_ram_req_addr;
  logic [IC_NUM_WAYS-1:0]                 fill_ram_req_way;
  logic [IC_LINE_SIZE-1:0]                fill_ram_req_data;
  logic [IC_LINE_SIZE-1:0]                fill_out_data;
  logic [IC_LINE_BEATS-1:0]               fill_out_err;
  logic                                   instr_req;
  logic [ADDR_W-1:BUS_W]                  instr_addr;
  logic                                   skid_complete_instr;
  logic                                   skid_ready;
  logic                                   output_compressed;
  logic                                   skid_valid_d, skid_valid_q, skid_en;
  logic [15:0]                            skid_data_d, skid_data_q;
  logic                                   skid_err_q;
  logic                                   output_valid;
  logic                                   addr_incr_two;
  logic                                   output_addr_en;
  logic [ADDR_W-1:1]                      output_addr_incr;
  logic [ADDR_W-1:1]                      output_addr_d, output_addr_q;
  logic [15:0]                            output_data_lo, output_data_hi;
  logic                                   data_valid, output_ready;
  logic [IC_LINE_SIZE-1:0]                line_data;
  logic [IC_LINE_BEATS-1:0]               line_err;
  logic [31:0]                            line_data_muxed;
  logic                                   line_err_muxed;
  logic [31:0]                            output_data;
  logic                                   output_err;
  typedef enum logic [1:0] {
    OUT_OF_RESET,
    AWAIT_SCRAMBLE_KEY,
    INVAL_CACHE,
    IDLE
  } inval_state_e;
  inval_state_e          inval_state_q, inval_state_d;
  logic                  inval_write_req;
  logic                  inval_block_cache;
  logic [IC_INDEX_W-1:0] inval_index_d, inval_index_q;
  logic                  inval_index_en;
  logic                  inval_active;
  assign lookup_addr_aligned = {lookup_addr_ic0[ADDR_W-1:IC_LINE_W], {IC_LINE_W{1'b0}}};
  assign prefetch_addr_d     =
      lookup_grant_ic0 ? (lookup_addr_aligned +
                          {{ADDR_W-IC_LINE_W-1{1'b0}}, 1'b1, {IC_LINE_W{1'b0}}}) :
                         addr_i;
  assign prefetch_addr_en    = branch_i | lookup_grant_ic0;
  if (ResetAll) begin : g_prefetch_addr_ra
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        prefetch_addr_q <= '0;
      end else if (prefetch_addr_en) begin
        prefetch_addr_q <= prefetch_addr_d;
      end
    end
  end else begin : g_prefetch_addr_nr
    always_ff @(posedge clk_i) begin
      if (prefetch_addr_en) begin
        prefetch_addr_q <= prefetch_addr_d;
      end
    end
  end
  assign lookup_throttle  = (fb_fill_level > FB_THRESHOLD[$clog2(NUM_FB)-1:0]);
  assign lookup_req_ic0   = req_i & ~&fill_busy_q & (branch_i | ~lookup_throttle) &
                            ~ecc_write_req;
  assign lookup_addr_ic0  = branch_i ? addr_i : prefetch_addr_q;
  assign lookup_index_ic0 = lookup_addr_ic0[IC_INDEX_HI:IC_LINE_W];
  assign fill_req_ic0   = (|fill_ram_req);
  assign fill_index_ic0 = fill_ram_req_addr[IC_INDEX_HI:IC_LINE_W];
  assign fill_tag_ic0   = {(~inval_write_req & ~ecc_write_req),
                           fill_ram_req_addr[ADDR_W-1:IC_INDEX_HI+1]};
  assign fill_wdata_ic0 = fill_ram_req_data;
  assign lookup_grant_ic0  = lookup_req_ic0;
  assign fill_grant_ic0    = fill_req_ic0 & ~lookup_req_ic0 & ~inval_write_req &
                             ~ecc_write_req;
  assign lookup_actual_ic0 = lookup_grant_ic0 & icache_enable_i & ~inval_block_cache;
  assign tag_req_ic0   = lookup_req_ic0 | fill_req_ic0 | inval_write_req | ecc_write_req;
  assign tag_index_ic0 = inval_write_req ? inval_index_q :
                         ecc_write_req   ? ecc_write_index :
                         fill_grant_ic0  ? fill_index_ic0 :
                                           lookup_index_ic0;
  assign tag_banks_ic0 = ecc_write_req  ? ecc_write_ways :
                         fill_grant_ic0 ? fill_ram_req_way :
                                          {IC_NUM_WAYS{1'b1}};
  assign tag_write_ic0 = fill_grant_ic0 | inval_write_req | ecc_write_req;
  assign data_req_ic0   = lookup_req_ic0 | fill_req_ic0;
  assign data_index_ic0 = tag_index_ic0;
  assign data_banks_ic0 = tag_banks_ic0;
  assign data_write_ic0 = tag_write_ic0;
  if (ICacheECC) begin : gen_ecc_wdata
    logic [21:0]             tag_ecc_input_padded;
    logic [27:0]             tag_ecc_output_padded;
    logic [22-IC_TAG_SIZE:0] unused_tag_ecc_output;
    assign tag_ecc_input_padded  = {{22-IC_TAG_SIZE{1'b0}},fill_tag_ic0};
    assign unused_tag_ecc_output = tag_ecc_output_padded[21:IC_TAG_SIZE-1];
    prim_secded_inv_28_22_enc tag_ecc_enc (
      .data_i (tag_ecc_input_padded),
      .data_o (tag_ecc_output_padded)
    );
    assign tag_wdata_ic0 = {tag_ecc_output_padded[27:22],tag_ecc_output_padded[IC_TAG_SIZE-1:0]};
    for (genvar bank = 0; bank < IC_LINE_BEATS; bank++) begin : gen_ecc_banks
      prim_secded_inv_39_32_enc data_ecc_enc (
        .data_i (fill_wdata_ic0[bank*BUS_SIZE+:BUS_SIZE]),
        .data_o (data_wdata_ic0[bank*BusSizeECC+:BusSizeECC])
      );
    end
  end else begin : gen_noecc_wdata
    assign tag_wdata_ic0  = fill_tag_ic0;
    assign data_wdata_ic0 = fill_wdata_ic0;
  end
  if (TweakInfection) begin : gen_tweak_infection
    logic [ADDR_W-1:0]           data_address_ic0;
    logic [ADDR_W-IC_LINE_W-1:0] data_tweak_ic0;
    assign data_address_ic0 = inval_write_req ? '0 :
                              ecc_write_req   ? '0 :
                              fill_grant_ic0  ? fill_ram_req_addr :
                                                lookup_addr_ic0;
    assign data_tweak_ic0 = data_address_ic0[ADDR_W-1:IC_LINE_W];
    logic unused_data_address_ic0;
    assign unused_data_address_ic0 = ^data_address_ic0[IC_LINE_W-1:0];
    if (ICacheECC) begin : gen_ecc_tweak
      always_comb begin
        data_tweak_lw_ic0 = '0;
        for (int i = 0; i < IC_LINE_BEATS; i++) begin
          data_tweak_lw_ic0 |= (LineSizeECC'({data_tweak_ic0, {IC_LINE_W{1'b0}}}) <<
                               (i * (ADDR_W + IC_DATA_ECC_SIZE)));
        end
      end
    end else begin: gen_no_ecc_tweak
      always_comb begin
        data_tweak_lw_ic0 = '0;
        for (int i = 0; i < IC_LINE_BEATS; i++) begin
          data_tweak_lw_ic0 |= (LineSizeECC'({data_tweak_ic0, {IC_LINE_W{1'b0}}}) <<
                               (i * ADDR_W));
        end
      end
    end
    logic [ADDR_W-IC_LINE_W-1:0] data_tweak_ic1;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        data_tweak_ic1 <= '0;
      end else if (data_req_ic0) begin
        data_tweak_ic1 <= data_tweak_ic0;
      end
    end
    if (ICacheECC) begin : gen_ecc_tweak_ic1
      always_comb begin
        data_tweak_lw_ic1 = '0;
        for (int i = 0; i < IC_LINE_BEATS; i++) begin
          data_tweak_lw_ic1 |= (LineSizeECC'({data_tweak_ic1, {IC_LINE_W{1'b0}}}) <<
                               (i * (ADDR_W + IC_DATA_ECC_SIZE)));
        end
      end
    end else begin : gen_no_ecc_tweak_ic1
      always_comb begin
        data_tweak_lw_ic1 = '0;
        for (int i = 0; i < IC_LINE_BEATS; i++) begin
          data_tweak_lw_ic1 |= (LineSizeECC'({data_tweak_ic1, {IC_LINE_W{1'b0}}}) << (i * ADDR_W));
        end
      end
    end
    if (ICacheECC) begin : gen_ecc_tag_tweak
      always_comb begin
        tag_tweak_lw_ic0 = '0;
        for (int i = 0; i < IC_LINE_BEATS; i++) begin
          tag_tweak_lw_ic0 |= (TagSizeECC'({tag_index_ic0}) <<
                              (i * (IC_INDEX_W + IC_TAG_ECC_SIZE)));
        end
      end
    end else begin: gen_no_ecc_tag_tweak
      always_comb begin
        tag_tweak_lw_ic0 = '0;
        for (int i = 0; i < IC_LINE_BEATS; i++) begin
          tag_tweak_lw_ic0 |= (TagSizeECC'({tag_index_ic0}) << (i * IC_INDEX_W));
        end
      end
    end
    logic [IC_INDEX_W-1:0] tag_index_ic1;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        tag_index_ic1 <= '0;
      end else if (tag_req_ic0) begin
        tag_index_ic1 <= tag_index_ic0;
      end
    end
    if (ICacheECC) begin : gen_ecc_tag_tweak_ic1
      always_comb begin
        tag_tweak_lw_ic1 = '0;
        for (int i = 0; i < IC_LINE_BEATS; i++) begin
          tag_tweak_lw_ic1 |= (TagSizeECC'({tag_index_ic1}) <<
                              (i * (IC_INDEX_W + IC_TAG_ECC_SIZE)));
        end
      end
    end else begin : gen_no_ecc_tag_tweak_ic1
      always_comb begin
        tag_tweak_lw_ic1 = '0;
        for (int i = 0; i < IC_LINE_BEATS; i++) begin
          tag_tweak_lw_ic1 |= (TagSizeECC'({tag_index_ic1}) << (i * IC_INDEX_W));
        end
      end
    end
  end else begin: gen_no_tweak_infection
    assign data_tweak_lw_ic0 = '0;
    assign data_tweak_lw_ic1 = '0;
    assign tag_tweak_lw_ic0 = '0;
    assign tag_tweak_lw_ic1 = '0;
  end
  assign ic_tag_req_o    = {IC_NUM_WAYS{tag_req_ic0}} & tag_banks_ic0;
  assign ic_tag_write_o  = tag_write_ic0;
  assign ic_tag_addr_o   = tag_index_ic0;
  assign ic_tag_wdata_o  = tag_wdata_ic0 ^ tag_tweak_lw_ic0;
  for (genvar way = 0; way < IC_NUM_WAYS; way++) begin : gen_tag_untweak
    assign tag_rdata_ic1[way] = ic_tag_rdata_i[way] ^ tag_tweak_lw_ic1;
  end
  assign ic_data_req_o   = {IC_NUM_WAYS{data_req_ic0}} & data_banks_ic0;
  assign ic_data_write_o = data_write_ic0;
  assign ic_data_addr_o  = data_index_ic0;
  assign ic_data_wdata_o = data_wdata_ic0 ^ data_tweak_lw_ic0;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      lookup_valid_ic1 <= 1'b0;
    end else begin
      lookup_valid_ic1 <= lookup_actual_ic0;
    end
  end
  if (ResetAll) begin : g_lookup_addr_ra
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        lookup_addr_ic1 <= '0;
        fill_in_ic1     <= '0;
      end else if (lookup_grant_ic0) begin
        lookup_addr_ic1 <= lookup_addr_ic0[ADDR_W-1:IC_INDEX_HI+1];
        fill_in_ic1     <= fill_alloc_sel;
      end
    end
  end else begin : g_lookup_addr_nr
    always_ff @(posedge clk_i) begin
      if (lookup_grant_ic0) begin
        lookup_addr_ic1 <= lookup_addr_ic0[ADDR_W-1:IC_INDEX_HI+1];
        fill_in_ic1     <= fill_alloc_sel;
      end
    end
  end
  for (genvar way = 0; way < IC_NUM_WAYS; way++) begin : gen_tag_match
    assign tag_match_ic1[way]   = (tag_rdata_ic1[way][IC_TAG_SIZE-1:0] ==
                                   {1'b1,lookup_addr_ic1[ADDR_W-1:IC_INDEX_HI+1]});
    assign tag_invalid_ic1[way] = ~tag_rdata_ic1[way][IC_TAG_SIZE-1];
  end
  assign tag_hit_ic1 = |tag_match_ic1;
  always_comb begin
    hit_data_ecc_ic1 = 'b0;
    for (int way = 0; way < IC_NUM_WAYS; way++) begin
      if (tag_match_ic1[way]) begin
        hit_data_ecc_ic1 |= ic_data_rdata_i[way] ^ data_tweak_lw_ic1;
      end
    end
  end
  assign lowest_invalid_way_ic1[0] = tag_invalid_ic1[0];
  assign round_robin_way_ic1[0]    = round_robin_way_q[IC_NUM_WAYS-1];
  for (genvar way = 1; way < IC_NUM_WAYS; way++) begin : gen_lowest_way
    assign lowest_invalid_way_ic1[way] = tag_invalid_ic1[way] & ~|tag_invalid_ic1[way-1:0];
    assign round_robin_way_ic1[way]    = round_robin_way_q[way-1];
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      round_robin_way_q <= {{IC_NUM_WAYS-1{1'b0}}, 1'b1};
    end else if (lookup_valid_ic1) begin
      round_robin_way_q <= round_robin_way_ic1;
    end
  end
  assign sel_way_ic1 = |tag_invalid_ic1 ? lowest_invalid_way_ic1 :
                                          round_robin_way_q;
  if (ICacheECC) begin : gen_data_ecc_checking
    logic [IC_NUM_WAYS-1:0]     tag_err_ic1;
    logic [IC_LINE_BEATS*2-1:0] data_err_ic1;
    logic                       ecc_correction_write_d, ecc_correction_write_q;
    logic [IC_NUM_WAYS-1:0]     ecc_correction_ways_d, ecc_correction_ways_q;
    logic [IC_INDEX_W-1:0]      lookup_index_ic1, ecc_correction_index_q;
    for (genvar way = 0; way < IC_NUM_WAYS; way++) begin : gen_tag_ecc
      logic [1:0]  tag_err_bank_ic1;
      logic [27:0] tag_rdata_padded_ic1;
      assign tag_rdata_padded_ic1 = {tag_rdata_ic1[way][TagSizeECC-1-:6],
                                     {22-IC_TAG_SIZE{1'b0}},
                                     tag_rdata_ic1[way][IC_TAG_SIZE-1:0]};
      prim_secded_inv_28_22_dec data_ecc_dec (
        .data_i     (tag_rdata_padded_ic1),
        .data_o     (),
        .syndrome_o (),
        .err_o      (tag_err_bank_ic1)
      );
      assign tag_err_ic1[way] = |tag_err_bank_ic1;
    end
    for (genvar bank = 0; bank < IC_LINE_BEATS; bank++) begin : gen_ecc_banks
      prim_secded_inv_39_32_dec data_ecc_dec (
        .data_i     (hit_data_ecc_ic1[bank*BusSizeECC+:BusSizeECC]),
        .data_o     (),
        .syndrome_o (),
        .err_o      (data_err_ic1[bank*2+:2])
      );
      assign hit_data_ic1[bank*BUS_SIZE+:BUS_SIZE] =
          hit_data_ecc_ic1[bank*BusSizeECC+:BUS_SIZE];
    end
    assign ecc_err_ic1 = lookup_valid_ic1 & (((|data_err_ic1) & tag_hit_ic1) | (|tag_err_ic1));
    assign ecc_correction_ways_d  = {IC_NUM_WAYS{|tag_err_ic1}} |
                                    (tag_match_ic1 & {IC_NUM_WAYS{|data_err_ic1}});
    assign ecc_correction_write_d = ecc_err_ic1;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        ecc_correction_write_q <= 1'b0;
      end else begin
        ecc_correction_write_q <= ecc_correction_write_d;
      end
    end
    if (ResetAll) begin : g_lookup_ind_ra
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          lookup_index_ic1 <= '0;
        end else if (lookup_grant_ic0) begin
          lookup_index_ic1 <= lookup_addr_ic0[IC_INDEX_HI-:IC_INDEX_W];
        end
      end
    end else begin : g_lookup_ind_nr
      always_ff @(posedge clk_i) begin
        if (lookup_grant_ic0) begin
          lookup_index_ic1 <= lookup_addr_ic0[IC_INDEX_HI-:IC_INDEX_W];
        end
      end
    end
    if (ResetAll) begin : g_ecc_correction_ra
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          ecc_correction_ways_q  <= '0;
          ecc_correction_index_q <= '0;
        end else if (ecc_err_ic1) begin
          ecc_correction_ways_q  <= ecc_correction_ways_d;
          ecc_correction_index_q <= lookup_index_ic1;
        end
      end
    end else begin : g_ecc_correction_nr
      always_ff @(posedge clk_i) begin
        if (ecc_err_ic1) begin
          ecc_correction_ways_q  <= ecc_correction_ways_d;
          ecc_correction_index_q <= lookup_index_ic1;
        end
      end
    end
    assign ecc_write_req   = ecc_correction_write_q;
    assign ecc_write_ways  = ecc_correction_ways_q;
    assign ecc_write_index = ecc_correction_index_q;
    assign ecc_error_o = ecc_err_ic1;
  end else begin : gen_no_data_ecc
    assign ecc_err_ic1     = 1'b0;
    assign ecc_write_req   = 1'b0;
    assign ecc_write_ways  = '0;
    assign ecc_write_index = '0;
    assign hit_data_ic1    = hit_data_ecc_ic1;
    assign ecc_error_o = 1'b0;
  end
  if (BranchCache) begin : gen_caching_logic
    localparam int unsigned CACHE_AHEAD = 2;
    localparam int unsigned CACHE_CNT_W = (CACHE_AHEAD == 1) ? 1 : $clog2(CACHE_AHEAD) + 1;
    logic                   cache_cnt_dec;
    logic [CACHE_CNT_W-1:0] cache_cnt_d, cache_cnt_q;
    assign cache_cnt_dec = lookup_grant_ic0 & (|cache_cnt_q);
    assign cache_cnt_d   = branch_i ? CACHE_AHEAD[CACHE_CNT_W-1:0] :
                                      (cache_cnt_q - {{CACHE_CNT_W-1{1'b0}},cache_cnt_dec});
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        cache_cnt_q <= '0;
      end else begin
        cache_cnt_q <= cache_cnt_d;
      end
    end
    assign fill_cache_new = (branch_i | (|cache_cnt_q)) & icache_enable_i & ~inval_block_cache;
  end else begin : gen_cache_all
    assign fill_cache_new = icache_enable_i & ~inval_block_cache;
  end
  always_comb begin
    fb_fill_level = '0;
    for (int i = 0; i < NUM_FB; i++) begin
      if (fill_busy_q[i] & ~fill_stale_q[i]) begin
        fb_fill_level += {{$clog2(NUM_FB) - 1{1'b0}}, 1'b1};
      end
    end
  end
  assign fill_new_alloc = lookup_grant_ic0;
  assign fill_spec_req  = (~icache_enable_i | branch_i) & ~|fill_ext_req;
  assign fill_spec_done = fill_spec_req & instr_gnt_i;
  assign fill_spec_hold = fill_spec_req & ~instr_gnt_i;
  for (genvar fb = 0; fb < NUM_FB; fb++) begin : gen_fbs
    if (fb == 0) begin : gen_fb_zero
      assign fill_alloc_sel[fb] = ~fill_busy_q[fb];
    end else begin : gen_fb_rest
      assign fill_alloc_sel[fb] = ~fill_busy_q[fb] & (&fill_busy_q[fb-1:0]);
    end
    assign fill_alloc[fb]      = fill_alloc_sel[fb] & fill_new_alloc;
    assign fill_busy_d[fb]     = fill_alloc[fb] | (fill_busy_q[fb] & ~fill_done[fb]);
    assign fill_older_d[fb]    = (fill_alloc[fb] ? fill_busy_q : fill_older_q[fb]) & ~fill_done;
    assign fill_done[fb]       = (fill_ram_done_q[fb] | fill_hit_q[fb] | ~fill_cache_q[fb] |
                                  (|fill_err_q[fb])) &
                                 (fill_out_done[fb] | fill_stale_q[fb] | branch_i) &
                                 fill_rvd_done[fb];
    assign fill_stale_d[fb]    = fill_busy_q[fb] & (branch_i | fill_stale_q[fb]);
    assign fill_cache_d[fb]    = (fill_alloc[fb] & fill_cache_new) |
                                 (fill_cache_q[fb] & fill_busy_q[fb] &
                                  icache_enable_i & ~icache_inval_i);
    assign fill_hit_ic1[fb]    = lookup_valid_ic1 & fill_in_ic1[fb] & tag_hit_ic1 & ~ecc_err_ic1;
    assign fill_hit_d[fb]      = fill_hit_ic1[fb] | (fill_hit_q[fb] & fill_busy_q[fb]);
    assign fill_ext_req[fb]    = fill_busy_q[fb] & ~fill_ext_done_d[fb];
    assign fill_ext_cnt_d[fb]  = fill_alloc[fb] ?
                                   {{IC_LINE_BEATS_W{1'b0}},fill_spec_done} :
                                   (fill_ext_cnt_q[fb] + {{IC_LINE_BEATS_W{1'b0}},
                                                          fill_ext_arb[fb] & instr_gnt_i});
    assign fill_ext_hold_d[fb] = (fill_alloc[fb] & fill_spec_hold) |
                                 (fill_ext_arb[fb] & ~instr_gnt_i);
    assign fill_ext_done_d[fb] = (fill_ext_cnt_q[fb][IC_LINE_BEATS_W] |
                                  fill_hit_ic1[fb] | fill_hit_q[fb] |
                                  (~fill_cache_q[fb] & (branch_i | fill_stale_q[fb] |
                                                        fill_ext_beat[fb][IC_LINE_BEATS_W]))) &
                                 ~fill_ext_hold_q[fb] & fill_busy_q[fb];
    assign fill_rvd_exp[fb]    = fill_busy_q[fb] & ~fill_rvd_done[fb];
    assign fill_rvd_cnt_d[fb]  = fill_alloc[fb] ? '0 :
                                                  (fill_rvd_cnt_q[fb] +
                                                   {{IC_LINE_BEATS_W{1'b0}},fill_rvd_arb[fb]});
    assign fill_rvd_done[fb]   = (fill_ext_done_q[fb] & ~fill_ext_hold_q[fb]) &
                                 (fill_rvd_cnt_q[fb] == fill_ext_cnt_q[fb]);
    assign fill_out_req[fb]    = fill_busy_q[fb] & ~fill_stale_q[fb] & ~fill_out_done[fb] &
                                 (fill_hit_ic1[fb] | fill_hit_q[fb] |
                                  (fill_rvd_beat[fb] > fill_out_cnt_q[fb]) | fill_rvd_arb[fb]);
    assign fill_out_grant[fb]  = fill_out_arb[fb] & output_ready;
    assign fill_out_cnt_d[fb]  = fill_alloc[fb] ? {1'b0,lookup_addr_ic0[IC_LINE_W-1:BUS_W]} :
                                                  (fill_out_cnt_q[fb] +
                                                   {{IC_LINE_BEATS_W{1'b0}},fill_out_grant[fb]});
    assign fill_out_done[fb]   = fill_out_cnt_q[fb][IC_LINE_BEATS_W];
    assign fill_ram_req[fb]    = fill_busy_q[fb] & fill_rvd_cnt_q[fb][IC_LINE_BEATS_W] &
                                 ~fill_hit_q[fb] & fill_cache_q[fb] & ~|fill_err_q[fb] &
                                 ~fill_ram_done_q[fb];
    assign fill_ram_done_d[fb] = fill_ram_arb[fb] | (fill_ram_done_q[fb] & fill_busy_q[fb]);
    assign fill_ext_beat[fb]   = {1'b0,fill_addr_q[fb][IC_LINE_W-1:BUS_W]} +
                                 fill_ext_cnt_q[fb][IC_LINE_BEATS_W:0];
    assign fill_ext_off[fb]    = fill_ext_beat[fb][IC_LINE_BEATS_W-1:0];
    assign fill_rvd_beat[fb]   = {1'b0,fill_addr_q[fb][IC_LINE_W-1:BUS_W]} +
                                 fill_rvd_cnt_q[fb][IC_LINE_BEATS_W:0];
    assign fill_rvd_off[fb]    = fill_rvd_beat[fb][IC_LINE_BEATS_W-1:0];
    assign fill_ext_arb[fb]    = fill_ext_req[fb] & ~|(fill_ext_req & fill_older_q[fb]);
    assign fill_ram_arb[fb]    = fill_ram_req[fb] & fill_grant_ic0 &
                                 ~|(fill_ram_req & fill_older_q[fb]);
    assign fill_data_sel[fb]   = ~|(fill_busy_q & ~fill_out_done & ~fill_stale_q &
                                    fill_older_q[fb]);
    assign fill_out_arb[fb]    = fill_out_req[fb] & fill_data_sel[fb];
    assign fill_rvd_arb[fb]    = instr_rvalid_i & fill_rvd_exp[fb] &
                                 ~|(fill_rvd_exp & fill_older_q[fb]);
    assign fill_data_reg[fb]   = fill_busy_q[fb] & ~fill_stale_q[fb] &
                                 ~fill_out_done[fb] & fill_data_sel[fb] &
                                 ((fill_rvd_beat[fb] > fill_out_cnt_q[fb]) | fill_hit_q[fb] |
                                  (|fill_err_q[fb]));
    assign fill_data_hit[fb]   = fill_busy_q[fb] & fill_hit_ic1[fb] & fill_data_sel[fb];
    assign fill_data_rvd[fb]   = fill_busy_q[fb] & fill_rvd_arb[fb] & ~fill_hit_q[fb] &
                                 ~fill_hit_ic1[fb] & ~fill_stale_q[fb] & ~fill_out_done[fb] &
                                 (fill_rvd_beat[fb] == fill_out_cnt_q[fb]) & fill_data_sel[fb];
    assign fill_entry_en[fb]   = fill_alloc[fb] | fill_busy_q[fb];
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        fill_busy_q[fb]     <= 1'b0;
        fill_older_q[fb]    <= '0;
        fill_stale_q[fb]    <= 1'b0;
        fill_cache_q[fb]    <= 1'b0;
        fill_hit_q[fb]      <= 1'b0;
        fill_ext_cnt_q[fb]  <= '0;
        fill_ext_hold_q[fb] <= 1'b0;
        fill_ext_done_q[fb] <= 1'b0;
        fill_rvd_cnt_q[fb]  <= '0;
        fill_ram_done_q[fb] <= 1'b0;
        fill_out_cnt_q[fb]  <= '0;
      end else if (fill_entry_en[fb]) begin
        fill_busy_q[fb]     <= fill_busy_d[fb];
        fill_older_q[fb]    <= fill_older_d[fb];
        fill_stale_q[fb]    <= fill_stale_d[fb];
        fill_cache_q[fb]    <= fill_cache_d[fb];
        fill_hit_q[fb]      <= fill_hit_d[fb];
        fill_ext_cnt_q[fb]  <= fill_ext_cnt_d[fb];
        fill_ext_hold_q[fb] <= fill_ext_hold_d[fb];
        fill_ext_done_q[fb] <= fill_ext_done_d[fb];
        fill_rvd_cnt_q[fb]  <= fill_rvd_cnt_d[fb];
        fill_ram_done_q[fb] <= fill_ram_done_d[fb];
        fill_out_cnt_q[fb]  <= fill_out_cnt_d[fb];
      end
    end
    assign fill_addr_en[fb]    = fill_alloc[fb];
    assign fill_way_en[fb]     = (lookup_valid_ic1 & fill_in_ic1[fb]);
    if (ResetAll) begin : g_fill_addr_ra
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          fill_addr_q[fb] <= '0;
        end else if (fill_addr_en[fb]) begin
          fill_addr_q[fb] <= lookup_addr_ic0;
        end
      end
    end else begin : g_fill_addr_nr
      always_ff @(posedge clk_i) begin
        if (fill_addr_en[fb]) begin
          fill_addr_q[fb] <= lookup_addr_ic0;
        end
      end
    end
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        fill_way_q[fb]  <= '0;
      end else if (fill_way_en[fb]) begin
        fill_way_q[fb]  <= sel_way_ic1;
      end
    end
    assign fill_data_d[fb] = fill_hit_ic1[fb] ? hit_data_ic1 :
                                                {IC_LINE_BEATS{instr_rdata_i}};
    for (genvar b = 0; b < IC_LINE_BEATS; b++) begin : gen_data_buf
      assign fill_err_d[fb][b]   = (fill_rvd_arb[fb] & instr_err_i &
                                    (fill_rvd_off[fb] == b[IC_LINE_BEATS_W-1:0])) |
                                   (fill_busy_q[fb] & fill_err_q[fb][b]);
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          fill_err_q[fb][b] <= '0;
        end else if (fill_entry_en[fb]) begin
          fill_err_q[fb][b] <= fill_err_d[fb][b];
        end
      end
      assign fill_data_en[fb][b] = fill_hit_ic1[fb] |
                                   (fill_rvd_arb[fb] & ~fill_hit_q[fb] &
                                    (fill_rvd_off[fb] == b[IC_LINE_BEATS_W-1:0]));
      if (ResetAll) begin : g_fill_data_ra
        always_ff @(posedge clk_i or negedge rst_ni) begin
          if (!rst_ni) begin
            fill_data_q[fb][b*BUS_SIZE+:BUS_SIZE] <= '0;
          end else if (fill_data_en[fb][b]) begin
            fill_data_q[fb][b*BUS_SIZE+:BUS_SIZE] <= fill_data_d[fb][b*BUS_SIZE+:BUS_SIZE];
          end
        end
      end else begin : g_fill_data_nr
        always_ff @(posedge clk_i) begin
          if (fill_data_en[fb][b]) begin
            fill_data_q[fb][b*BUS_SIZE+:BUS_SIZE] <= fill_data_d[fb][b*BUS_SIZE+:BUS_SIZE];
          end
        end
      end
    end
  end
  always_comb begin
    fill_ext_req_addr = '0;
    for (int i = 0; i < NUM_FB; i++) begin
      if (fill_ext_arb[i]) begin
        fill_ext_req_addr |= {fill_addr_q[i][ADDR_W-1:IC_LINE_W], fill_ext_off[i]};
      end
    end
  end
  always_comb begin
    fill_ram_req_addr = '0;
    fill_ram_req_way  = '0;
    fill_ram_req_data = '0;
    for (int i = 0; i < NUM_FB; i++) begin
      if (fill_ram_arb[i]) begin
        fill_ram_req_addr |= fill_addr_q[i];
        fill_ram_req_way  |= fill_way_q[i];
        fill_ram_req_data |= fill_data_q[i];
      end
    end
  end
  always_comb begin
    fill_out_data = '0;
    fill_out_err  = '0;
    for (int i = 0; i < NUM_FB; i++) begin
      if (fill_data_reg[i]) begin
        fill_out_data |= fill_data_q[i];
        fill_out_err  |= (fill_err_q[i] & ~{IC_LINE_BEATS{fill_hit_q[i]}});
      end
    end
  end
  assign instr_req  = ((~icache_enable_i | branch_i) & lookup_grant_ic0) |
                      (|fill_ext_req);
  assign instr_addr = |fill_ext_req ? fill_ext_req_addr :
                                      lookup_addr_ic0[ADDR_W-1:BUS_W];
  assign instr_req_o  = instr_req;
  assign instr_addr_o = {instr_addr[ADDR_W-1:BUS_W],{BUS_W{1'b0}}};
  assign line_data = |fill_data_hit ? hit_data_ic1 : fill_out_data;
  assign line_err  = |fill_data_hit ? {IC_LINE_BEATS{1'b0}} : fill_out_err;
  always_comb begin
    line_data_muxed = '0;
    line_err_muxed  = 1'b0;
    for (int unsigned i = 0; i < IC_LINE_BEATS; i++) begin
      if ((output_addr_q[IC_LINE_W-1:BUS_W] + {{IC_LINE_BEATS_W-1{1'b0}},skid_valid_q}) ==
          i[IC_LINE_BEATS_W-1:0]) begin
        line_data_muxed |= line_data[i*32+:32];
        line_err_muxed  |= line_err[i];
      end
    end
  end
  assign output_data = |fill_data_rvd ? instr_rdata_i : line_data_muxed;
  assign output_err  = |fill_data_rvd ? instr_err_i   : line_err_muxed;
  assign data_valid = |fill_out_arb;
  assign skid_data_d = output_data[31:16];
  assign skid_en     = data_valid & (ready_i | skid_ready);
  if (ResetAll) begin : g_skid_data_ra
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        skid_data_q <= '0;
        skid_err_q  <= '0;
      end else if (skid_en) begin
        skid_data_q <= skid_data_d;
        skid_err_q  <= output_err;
      end
    end
  end else begin : g_skid_data_nr
    always_ff @(posedge clk_i) begin
      if (skid_en) begin
        skid_data_q <= skid_data_d;
        skid_err_q  <= output_err;
      end
    end
  end
  assign skid_complete_instr = skid_valid_q & ((skid_data_q[1:0] != 2'b11) | skid_err_q);
  assign skid_ready = output_addr_q[1] & ~skid_valid_q & (~output_compressed | output_err);
  assign output_ready = (ready_i | skid_ready) & ~skid_complete_instr;
  assign output_compressed = (rdata_o[1:0] != 2'b11);
  assign skid_valid_d =
      branch_i ? 1'b0 :
      (skid_valid_q ? ~(ready_i & ((skid_data_q[1:0] != 2'b11) | skid_err_q)) :
                      (data_valid &
                       (((output_addr_q[1] & (~output_compressed | output_err)) |
                        (~output_addr_q[1] & output_compressed & ~output_err & ready_i)))));
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      skid_valid_q <= 1'b0;
    end else begin
      skid_valid_q <= skid_valid_d;
    end
  end
  assign output_valid = skid_complete_instr |
                        (data_valid & (~output_addr_q[1] | skid_valid_q |
                                       output_err | (output_data[17:16] != 2'b11)));
  assign output_addr_en = branch_i | (ready_i & valid_o);
  assign addr_incr_two = output_compressed & ~err_o;
  assign output_addr_incr = (output_addr_q[31:1] +
                             {29'd0, ~addr_incr_two, addr_incr_two});
  assign output_addr_d = branch_i ? addr_i[31:1] : output_addr_incr;
  if (ResetAll) begin : g_output_addr_ra
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        output_addr_q <= '0;
      end else if (output_addr_en) begin
        output_addr_q <= output_addr_d;
      end
    end
  end else begin : g_output_addr_nr
    always_ff @(posedge clk_i) begin
      if (output_addr_en) begin
        output_addr_q <= output_addr_d;
      end
    end
  end
  always_comb begin
    output_data_lo = '0;
    for (int unsigned i = 0; i < IC_OUTPUT_BEATS; i++) begin
      if (output_addr_q[BUS_W-1:1] == i[BUS_W-2:0]) begin
        output_data_lo |= output_data[i*16+:16];
      end
    end
  end
  always_comb begin
    output_data_hi = '0;
    for (int unsigned i = 0; i < IC_OUTPUT_BEATS - 1; i++) begin
      if (output_addr_q[BUS_W-1:1] == i[BUS_W-2:0]) begin
        output_data_hi |= output_data[(i+1)*16+:16];
      end
    end
    if (&output_addr_q[BUS_W-1:1]) begin
      output_data_hi |= output_data[15:0];
    end
  end
  assign valid_o     = output_valid;
  assign rdata_o     = {output_data_hi, (skid_valid_q ? skid_data_q : output_data_lo)};
  assign addr_o      = {output_addr_q, 1'b0};
  assign err_o       = (skid_valid_q & skid_err_q) | (~skid_complete_instr & output_err);
  assign err_plus2_o = skid_valid_q & ~skid_err_q;
  always_comb begin
    inval_state_d     = inval_state_q;
    inval_index_d     = inval_index_q;
    inval_index_en    = 1'b0;
    inval_write_req   = 1'b0;
    ic_scr_key_req_o  = 1'b0;
    inval_block_cache = 1'b1;
    unique case (inval_state_q)
      OUT_OF_RESET: begin
        inval_state_d = AWAIT_SCRAMBLE_KEY;
        if (~ic_scr_key_valid_i) begin
          ic_scr_key_req_o = 1'b1;
        end
      end
      AWAIT_SCRAMBLE_KEY: begin
        if (ic_scr_key_valid_i) begin
          inval_state_d  = INVAL_CACHE;
          inval_index_d  = '0;
          inval_index_en = 1'b1;
        end
      end
      INVAL_CACHE: begin
        inval_write_req = 1'b1;
        inval_index_d   = (inval_index_q + {{IC_INDEX_W-1{1'b0}},1'b1});
        inval_index_en  = 1'b1;
        if (icache_inval_i) begin
          ic_scr_key_req_o = 1'b1;
          inval_state_d = AWAIT_SCRAMBLE_KEY;
        end else if (&inval_index_q) begin
            inval_state_d = IDLE;
        end
      end
      IDLE: begin
        if (icache_inval_i) begin
          ic_scr_key_req_o = 1'b1;
          inval_state_d = AWAIT_SCRAMBLE_KEY;
        end else begin
          inval_block_cache = 1'b0;
        end
      end
      default: ;
    endcase
  end
  assign inval_active = inval_state_q != IDLE;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      inval_state_q <= OUT_OF_RESET;
    end else begin
      inval_state_q <= inval_state_d;
    end
  end
  if (ResetAll) begin : g_inval_index_ra
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        inval_index_q <= '0;
      end else if (inval_index_en) begin
        inval_index_q <= inval_index_d;
      end
    end
  end else begin : g_inval_index_nr
    always_ff @(posedge clk_i) begin
      if (inval_index_en) begin
        inval_index_q <= inval_index_d;
      end
    end
  end
  assign busy_o = inval_active | (|(fill_busy_q & ~fill_rvd_done));
endmodule
module prim_subst_perm #(
  parameter int DataWidth = 64,
  parameter int NumRounds = 31,
  parameter bit Decrypt   = 0     
) (
  input        [DataWidth-1:0] data_i,
  input        [DataWidth-1:0] key_i,
  output logic [DataWidth-1:0] data_o
);
  logic [NumRounds:0][DataWidth-1:0] data_state /*verilator split_var*/;
  assign data_state[0] = data_i;
  for (genvar r = 0; r < NumRounds; r++) begin : gen_round
    logic [DataWidth-1:0] data_state_sbox, data_state_flipped;
    if (Decrypt) begin : gen_dec
      always_comb begin : p_dec
        data_state_sbox = data_state[r] ^ key_i;
        data_state_flipped = data_state_sbox;
        for (int k = 0; k < DataWidth/2; k++) begin
          data_state_flipped[k * 2]     = data_state_sbox[k];
          data_state_flipped[k * 2 + 1] = data_state_sbox[k + DataWidth/2];
        end
        for (int k = 0; k < DataWidth; k++) begin
          data_state_sbox[DataWidth - 1 - k] = data_state_flipped[k];
        end
        for (int k = 0; k < DataWidth/4; k++) begin
          data_state_sbox[k*4 +: 4] = prim_cipher_pkg::PRESENT_SBOX4_INV[data_state_sbox[k*4 +: 4]];
        end
        data_state[r + 1] = data_state_sbox;
      end
    end else begin : gen_enc
      always_comb begin : p_enc
        data_state_sbox = data_state[r] ^ key_i;
        for (int k = 0; k < DataWidth/4; k++) begin
          data_state_sbox[k*4 +: 4] = prim_cipher_pkg::PRESENT_SBOX4[data_state_sbox[k*4 +: 4]];
        end
        for (int k = 0; k < DataWidth; k++) begin
          data_state_flipped[DataWidth - 1 - k] = data_state_sbox[k];
        end
        data_state_sbox = data_state_flipped;
        for (int k = 0; k < DataWidth/2; k++) begin
          data_state_sbox[k]               = data_state_flipped[k * 2];
          data_state_sbox[k + DataWidth/2] = data_state_flipped[k * 2 + 1];
        end
        data_state[r + 1] = data_state_sbox;
      end
    end  
  end  
  assign data_o = data_state[NumRounds] ^ key_i;
endmodule : prim_subst_perm
module prim_present #(
  parameter int DataWidth = 64,   
  parameter int KeyWidth  = 128,  
  parameter int NumRounds = 31,
  parameter int NumPhysRounds = NumRounds,
  parameter bit Decrypt   = 0     
) (
  input        [DataWidth-1:0] data_i,
  input        [KeyWidth-1:0]  key_i,
  input        [4:0]           idx_i,
  output logic [DataWidth-1:0] data_o,
  output logic [KeyWidth-1:0]  key_o,
  output logic [4:0]           idx_o
);
  logic [NumPhysRounds:0][DataWidth-1:0] data_state;
  logic [NumPhysRounds:0][KeyWidth-1:0]  round_key;
  logic [NumPhysRounds:0][4:0]           round_idx;
  assign data_state[0] = data_i;
  assign round_key[0]  = key_i;
  assign round_idx[0]  = idx_i;
  for (genvar k = 0; k < NumPhysRounds; k++) begin : gen_round
    logic [DataWidth-1:0] data_state_xor, data_state_sbox;
    assign data_state_xor  = data_state[k] ^ round_key[k][KeyWidth-1 : KeyWidth-DataWidth];
    if (Decrypt) begin : gen_dec
      assign round_idx[k+1] = round_idx[k] - 1'b1;
      if (DataWidth == 64) begin : gen_d64
        assign data_state_sbox = prim_cipher_pkg::perm_64bit(data_state_xor,
                                                             prim_cipher_pkg::PRESENT_PERM64_INV);
        assign data_state[k+1] = prim_cipher_pkg::sbox4_64bit(data_state_sbox,
                                                              prim_cipher_pkg::PRESENT_SBOX4_INV);
      end else begin : gen_d32
        assign data_state_sbox = prim_cipher_pkg::perm_32bit(data_state_xor,
                                                             prim_cipher_pkg::PRESENT_PERM32_INV);
        assign data_state[k+1] = prim_cipher_pkg::sbox4_32bit(data_state_sbox,
                                                              prim_cipher_pkg::PRESENT_SBOX4_INV);
      end
      if (KeyWidth == 128) begin : gen_k128
        assign round_key[k+1]  = prim_cipher_pkg::present_inv_update_key128(round_key[k],
                                                                            round_idx[k]);
      end else if (KeyWidth == 80) begin : gen_k80
        assign round_key[k+1]  = prim_cipher_pkg::present_inv_update_key80(round_key[k],
                                                                           round_idx[k]);
      end else begin : gen_k64
        assign round_key[k+1]  = prim_cipher_pkg::present_inv_update_key64(round_key[k],
                                                                           round_idx[k]);
      end
    end else begin : gen_enc
      assign round_idx[k+1] = round_idx[k] + 1'b1;
      if (DataWidth == 64) begin : gen_d64
        assign data_state_sbox = prim_cipher_pkg::sbox4_64bit(data_state_xor,
                                                              prim_cipher_pkg::PRESENT_SBOX4);
        assign data_state[k+1] = prim_cipher_pkg::perm_64bit(data_state_sbox,
                                                             prim_cipher_pkg::PRESENT_PERM64);
      end else begin : gen_d32
        assign data_state_sbox = prim_cipher_pkg::sbox4_32bit(data_state_xor,
                                                              prim_cipher_pkg::PRESENT_SBOX4);
        assign data_state[k+1] = prim_cipher_pkg::perm_32bit(data_state_sbox,
                                                             prim_cipher_pkg::PRESENT_PERM32);
      end
      if (KeyWidth == 128) begin : gen_k128
        assign round_key[k+1]  = prim_cipher_pkg::present_update_key128(round_key[k], round_idx[k]);
      end else if (KeyWidth == 80) begin : gen_k80
        assign round_key[k+1]  = prim_cipher_pkg::present_update_key80(round_key[k], round_idx[k]);
      end else begin : gen_k64
        assign round_key[k+1]  = prim_cipher_pkg::present_update_key64(round_key[k], round_idx[k]);
      end
    end  
  end  
  localparam int LastRoundIdx = (Decrypt != 0 || NumRounds == 31) ? 0 : NumRounds+1;
  assign data_o = (int'(idx_o) == LastRoundIdx) ?
      data_state[NumPhysRounds] ^
      round_key[NumPhysRounds][KeyWidth-1 : KeyWidth-DataWidth] :
      data_state[NumPhysRounds];
  assign key_o  = round_key[NumPhysRounds];
  assign idx_o  = round_idx[NumPhysRounds];
endmodule : prim_present
module prim_prince #(
  parameter int DataWidth     = 64,
  parameter int KeyWidth      = 128,
  parameter int NumRoundsHalf = 5,
  parameter bit UseOldKeySched = 1'b0,
  parameter bit HalfwayDataReg = 1'b0,
  parameter bit HalfwayKeyReg = 1'b0
) (
  input                        clk_i,
  input                        rst_ni,
  input                        valid_i,
  input        [DataWidth-1:0] data_i,
  input        [KeyWidth-1:0]  key_i,
  input                        dec_i,    
  output logic                 valid_o,
  output logic [DataWidth-1:0] data_o
);
  logic [DataWidth-1:0] k0, k0_prime_d, k1_d, k0_new_d, k0_prime_q, k1_q, k0_new_q;
  always_comb begin : p_key_expansion
    k0         = key_i[2*DataWidth-1 : DataWidth];
    k0_prime_d = {k0[0], k0[DataWidth-1:2], k0[DataWidth-1] ^ k0[1]};
    k1_d       = key_i[DataWidth-1:0];
    if (dec_i) begin
      k0          = k0_prime_d;
      k0_prime_d  = key_i[2*DataWidth-1 : DataWidth];
      k1_d       ^= prim_cipher_pkg::PRINCE_ALPHA_CONST[DataWidth-1:0];
    end
  end
  if (UseOldKeySched) begin : gen_legacy_keyschedule
    assign k0_new_d = k1_d;
  end else begin : gen_new_keyschedule
    always_comb begin : p_new_keyschedule_k0_alpha
      k0_new_d = key_i[2*DataWidth-1 : DataWidth];
      if (dec_i) begin
        k0_new_d ^= prim_cipher_pkg::PRINCE_ALPHA_CONST[DataWidth-1:0];
      end
    end
  end
  if (HalfwayKeyReg) begin : gen_key_reg
    always_ff @(posedge clk_i or negedge rst_ni) begin : p_key_reg
      if (!rst_ni) begin
        k1_q       <= '0;
        k0_prime_q <= '0;
        k0_new_q   <= '0;
      end else begin
        if (valid_i) begin
          k1_q       <= k1_d;
          k0_prime_q <= k0_prime_d;
          k0_new_q   <= k0_new_d;
        end
      end
    end
  end else begin : gen_no_key_reg
    assign k1_q       = k1_d;
    assign k0_prime_q = k0_prime_d;
    assign k0_new_q   = k0_new_d;
  end
  logic [NumRoundsHalf:0][DataWidth-1:0] data_state_lo;
  logic [NumRoundsHalf:0][DataWidth-1:0] data_state_hi;
  always_comb begin : p_pre_round_xor
    data_state_lo[0] = data_i ^ k0;
    data_state_lo[0] ^= k1_d;
    data_state_lo[0] ^= prim_cipher_pkg::PRINCE_ROUND_CONST[0][DataWidth-1:0];
  end
  for (genvar k = 1; k <= NumRoundsHalf; k++) begin : gen_fwd_pass
    logic [DataWidth-1:0] data_state_round;
    if (DataWidth == 64) begin : gen_fwd_d64
      always_comb begin : p_fwd_d64
        data_state_round = prim_cipher_pkg::sbox4_64bit(data_state_lo[k-1],
            prim_cipher_pkg::PRINCE_SBOX4);
        data_state_round = prim_cipher_pkg::prince_mult_prime_64bit(data_state_round);
        data_state_round = prim_cipher_pkg::prince_shiftrows_64bit(data_state_round,
            prim_cipher_pkg::PRINCE_SHIFT_ROWS64);
      end
    end else begin : gen_fwd_d32
      always_comb begin : p_fwd_d32
        data_state_round = prim_cipher_pkg::sbox4_32bit(data_state_lo[k-1],
            prim_cipher_pkg::PRINCE_SBOX4);
        data_state_round = prim_cipher_pkg::prince_mult_prime_32bit(data_state_round);
        data_state_round = prim_cipher_pkg::prince_shiftrows_32bit(data_state_round,
            prim_cipher_pkg::PRINCE_SHIFT_ROWS64);
      end
    end
    logic [DataWidth-1:0] data_state_xor;
    assign data_state_xor = data_state_round ^
                            prim_cipher_pkg::PRINCE_ROUND_CONST[k][DataWidth-1:0];
    if (k % 2 == 1) begin : gen_fwd_key_odd
      assign data_state_lo[k]  = data_state_xor ^ k0_new_d;
    end else begin : gen_fwd_key_even
      assign data_state_lo[k]  = data_state_xor ^ k1_d;
    end
  end
  logic [DataWidth-1:0] data_state_middle_d, data_state_middle_q, data_state_middle;
  if (DataWidth == 64) begin : gen_middle_d64
    always_comb begin : p_middle_d64
      data_state_middle_d = prim_cipher_pkg::sbox4_64bit(data_state_lo[NumRoundsHalf],
          prim_cipher_pkg::PRINCE_SBOX4);
      data_state_middle = prim_cipher_pkg::prince_mult_prime_64bit(data_state_middle_q);
      data_state_middle = prim_cipher_pkg::sbox4_64bit(data_state_middle,
          prim_cipher_pkg::PRINCE_SBOX4_INV);
    end
  end else begin : gen_middle_d32
    always_comb begin : p_middle_d32
      data_state_middle_d = prim_cipher_pkg::sbox4_32bit(data_state_middle[NumRoundsHalf],
          prim_cipher_pkg::PRINCE_SBOX4);
      data_state_middle = prim_cipher_pkg::prince_mult_prime_32bit(data_state_middle_q);
      data_state_middle = prim_cipher_pkg::sbox4_32bit(data_state_middle,
          prim_cipher_pkg::PRINCE_SBOX4_INV);
    end
  end
  if (HalfwayDataReg) begin : gen_data_reg
    logic valid_q;
    always_ff @(posedge clk_i or negedge rst_ni) begin : p_data_reg
      if (!rst_ni) begin
        valid_q <= 1'b0;
        data_state_middle_q <= '0;
      end else begin
        valid_q <= valid_i;
        if (valid_i) begin
          data_state_middle_q <= data_state_middle_d;
        end
      end
    end
    assign valid_o = valid_q;
  end else begin : gen_no_data_reg
    assign data_state_middle_q = data_state_middle_d;
    assign valid_o = valid_i;
  end
  assign data_state_hi[0] = data_state_middle;
  for (genvar k = 1; k <= NumRoundsHalf; k++) begin : gen_bwd_pass
    logic [DataWidth-1:0] data_state_xor0, data_state_xor1;
    if ((NumRoundsHalf + k + 1) % 2 == 1) begin : gen_bkwd_key_odd
      assign data_state_xor0 = data_state_hi[k-1] ^ k0_new_q;
    end else begin : gen_bkwd_key_even
      assign data_state_xor0 = data_state_hi[k-1] ^ k1_q;
    end
    assign data_state_xor1 = data_state_xor0 ^
                             prim_cipher_pkg::PRINCE_ROUND_CONST[10-NumRoundsHalf+k][DataWidth-1:0];
    logic [DataWidth-1:0] data_state_bwd;
    if (DataWidth == 64) begin : gen_bwd_d64
      always_comb begin : p_bwd_d64
        data_state_bwd = prim_cipher_pkg::prince_shiftrows_64bit(data_state_xor1,
            prim_cipher_pkg::PRINCE_SHIFT_ROWS64_INV);
        data_state_bwd = prim_cipher_pkg::prince_mult_prime_64bit(data_state_bwd);
        data_state_hi[k] = prim_cipher_pkg::sbox4_64bit(data_state_bwd,
            prim_cipher_pkg::PRINCE_SBOX4_INV);
      end
    end else begin : gen_bwd_d32
      always_comb begin : p_bwd_d32
        data_state_bwd = prim_cipher_pkg::prince_shiftrows_32bit(data_state_xor1,
            prim_cipher_pkg::PRINCE_SHIFT_ROWS64_INV);
        data_state_bwd = prim_cipher_pkg::prince_mult_prime_32bit(data_state_bwd);
        data_state_hi[k] = prim_cipher_pkg::sbox4_32bit(data_state_bwd,
            prim_cipher_pkg::PRINCE_SBOX4_INV);
      end
    end
  end
  always_comb begin : p_post_round_xor
    data_o  = data_state_hi[NumRoundsHalf] ^
              prim_cipher_pkg::PRINCE_ROUND_CONST[11][DataWidth-1:0];
    data_o ^= k1_q;
    data_o ^= k0_prime_q;
  end
endmodule : prim_prince
package prim_count_pkg;
  typedef logic [3:0] action_mask_t;
  typedef enum action_mask_t {Clr  = 4'h1,
                              Set  = 4'h2,
                              Incr = 4'h4,
                              Decr = 4'h8} action_e;
endpackage : prim_count_pkg
module prim_count
  import prim_count_pkg::*;
#(
  parameter int               Width = 2,
  parameter logic [Width-1:0] ResetValue = '0,
  parameter bit               EnableAlertTriggerSVA = 1,
  parameter action_mask_t     PossibleActions = {$bits(action_mask_t){1'b1}}
) (
  input clk_i,
  input rst_ni,
  input clr_i,
  input set_i,
  input [Width-1:0] set_cnt_i,                  
  input incr_en_i,
  input decr_en_i,
  input [Width-1:0] step_i,                     
  input commit_i,
  output logic [Width-1:0] cnt_o,               
  output logic [Width-1:0] cnt_after_commit_o,  
  output logic err_o
);
  localparam int NumCnt = 2;
  localparam logic [NumCnt-1:0][Width-1:0] ResetValues = {{Width{1'b1}} - ResetValue,  
                                                          ResetValue};                 
  logic [NumCnt-1:0][Width-1:0] cnt_d, cnt_d_committed, cnt_q;
  logic [NumCnt-1:0][Width-1:0] fpv_force;
  assign fpv_force = '0;
  for (genvar k = 0; k < NumCnt; k++) begin : gen_cnts
    logic incr_en, decr_en;
    logic [Width-1:0] set_val;
    if (k == 0) begin : gen_up_cnt
      assign incr_en = incr_en_i;
      assign decr_en = decr_en_i;
      assign set_val = set_cnt_i;
    end else begin : gen_dn_cnt
      assign incr_en = decr_en_i;
      assign decr_en = incr_en_i;
      assign set_val = {Width{1'b1}} - set_cnt_i;
    end
    logic [Width:0] ext_cnt;
    assign ext_cnt = (decr_en) ? {1'b0, cnt_q[k]} - {1'b0, step_i} :
                     (incr_en) ? {1'b0, cnt_q[k]} + {1'b0, step_i} : {1'b0, cnt_q[k]};
    logic uflow, oflow;
    assign oflow = incr_en && ext_cnt[Width];
    assign uflow = decr_en && ext_cnt[Width];
    logic [Width-1:0] cnt_sat;
    assign cnt_sat = (uflow) ? '0            :
                     (oflow) ? {Width{1'b1}} : ext_cnt[Width-1:0];
    logic cnt_en;
    assign cnt_en = (incr_en ^ decr_en) &&
                    ((incr_en && !(&cnt_q[k])) ||
                    (decr_en && !(cnt_q[k] == '0)));
    assign cnt_d[k] = (clr_i)  ? ResetValues[k] :
                      (set_i)  ? set_val        :
                      (cnt_en) ? cnt_sat        : cnt_q[k];
    assign cnt_d_committed[k] = commit_i ? cnt_d[k] : cnt_q[k];
    logic [Width-1:0] cnt_unforced_q;
    prim_flop #(
      .Width(Width),
      .ResetValue(ResetValues[k])
    ) u_cnt_flop (
      .clk_i,
      .rst_ni,
      .d_i(cnt_d_committed[k]),
      .q_o(cnt_unforced_q)
    );
    assign cnt_q[k] = fpv_force[k] + cnt_unforced_q;
  end
  logic [Width:0] sum;
  assign sum = (cnt_q[0] + cnt_q[1]);
  logic err_d, err_q;
  assign err_d = (sum != {1'b0, {Width{1'b1}}});
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      err_q <= 1'b0;
    end else begin
      err_q <= err_d;
    end
  end
  assign err_o = err_q;
  assign cnt_o              = cnt_q[0];
  assign cnt_after_commit_o = cnt_d[0];
endmodule  
module prim_clock_mux2 #(
  parameter bit NoFpgaBufG = 1'b0  
) (
  input        clk0_i,
  input        clk1_i,
  input        sel_i,
  output logic clk_o
);
  assign clk_o = (sel_i & clk1_i) | (~sel_i & clk0_i);
endmodule : prim_clock_mux2
module prim_pad_attr
  import prim_pad_wrapper_pkg::*;
#(
  parameter pad_type_e PadType = BidirStd  
) (
  output pad_attr_t attr_warl_o
);
  if (PadType == InputStd) begin : gen_input_only_warl
    always_comb begin : p_attr
      attr_warl_o = '0;
      attr_warl_o.invert = 1'b1;
      attr_warl_o.pull_en = 1'b1;
      attr_warl_o.pull_select = 1'b1;
      attr_warl_o.input_disable = 1'b1;
    end
  end else if (PadType == BidirStd ||
               PadType == BidirTol ||
               PadType == DualBidirTol ||
               PadType == BidirOd) begin : gen_bidir_warl
    always_comb begin : p_attr
      attr_warl_o = '0;
      attr_warl_o.invert = 1'b1;
      attr_warl_o.virt_od_en = 1'b1;
      attr_warl_o.pull_en = 1'b1;
      attr_warl_o.pull_select = 1'b1;
      attr_warl_o.input_disable = 1'b1;
    end
  end else if (PadType == AnalogIn0) begin : gen_analog0_warl
    always_comb begin : p_attr
      attr_warl_o = '0;
      attr_warl_o.input_disable = 1'b1;
    end
  end else begin : gen_invalid_config
    assert_static_in_generate_config_not_available
        assert_static_in_generate_config_not_available();
  end
endmodule : prim_pad_attr
module prim_pad_wrapper
  import prim_pad_wrapper_pkg::*;
#(
  parameter pad_type_e PadType = BidirStd,
  parameter scan_role_e ScanRole = NoScan
) (
  input              clk_scan_i,
  input              scanmode_i,
  input pad_pok_t    pok_i,
  inout wire         inout_io,  
  output logic       in_o,      
  output logic       in_raw_o,  
  input              ie_i,      
  input              out_i,     
  input              oe_i,      
  input pad_attr_t   attr_i     
);
  logic unused_sigs;
  assign unused_sigs = ^{attr_i.slew_rate,
                         attr_i.drive_strength[3:1],
                         attr_i.od_en,
                         attr_i.schmitt_en,
                         attr_i.keep_en,
                         scanmode_i,
                         pok_i};
  logic ie;
  assign ie = ie_i & ~attr_i.input_disable;
  if (PadType == InputStd) begin : gen_input_only
    logic unused_in_sigs;
    assign unused_in_sigs = ^{out_i,
                              oe_i,
                              attr_i.virt_od_en,
                              attr_i.drive_strength};
    assign in_raw_o = ie ? inout_io : 1'bz;
    assign in_o = attr_i.invert ^ in_raw_o;
  end else if (PadType == BidirTol ||
               PadType == DualBidirTol ||
               PadType == BidirOd ||
               PadType == BidirStd) begin : gen_bidir
    assign in_raw_o = ie ? inout_io : 1'bz;
    assign in_o = attr_i.invert ^ in_raw_o;
    logic oe, out;
    assign out = out_i ^ attr_i.invert;
    assign oe  = oe_i & ((attr_i.virt_od_en & ~out) | ~attr_i.virt_od_en);
    assign inout_io = (oe)   ? out : 1'bz;
  end else if (PadType == AnalogIn0 || PadType == AnalogIn1) begin : gen_analog
    logic unused_ana_sigs;
    assign unused_ana_sigs = ^{attr_i.invert,
                               attr_i.virt_od_en,
                               attr_i.drive_strength[0],
                               attr_i.pull_en,
                               attr_i.pull_select,
                               out_i,
                               oe_i,
                               ie_i};
    assign inout_io = 1'bz;  
    assign in_raw_o = ie ? inout_io : 1'bz;
    assign in_o = in_raw_o;
  end else begin : gen_invalid_config
    assert_static_in_generate_config_not_available
        assert_static_in_generate_config_not_available();
  end
endmodule : prim_pad_wrapper
module prim_ram_1p import prim_ram_1p_pkg::*; #(
  parameter  int Width           = 32,  
  parameter  int Depth           = 128,
  parameter  int DataBitsPerMask = 1,  
  parameter      MemInitFile     = "",  
  localparam int Aw              = $clog2(Depth)   
) (
  input  logic             clk_i,
  input  logic             rst_ni,
  input  logic             req_i,
  input  logic             write_i,
  input  logic [Aw-1:0]    addr_i,
  input  logic [Width-1:0] wdata_i,
  input  logic [Width-1:0] wmask_i,
  output logic [Width-1:0] rdata_o,  
  input  ram_1p_cfg_req_t  cfg_i,
  output ram_1p_cfg_rsp_t  cfg_o
);
  logic unused_signals;
  assign unused_signals = ^{cfg_i, rst_ni};
  assign cfg_o          = RAM_1P_CFG_RSP_DEFAULT;
  localparam int MaskWidth = Width / DataBitsPerMask;
  logic [Width-1:0]     mem [Depth];
  logic [MaskWidth-1:0] wmask;
  for (genvar k = 0; k < MaskWidth; k++) begin : gen_wmask
    assign wmask[k] = &wmask_i[k*DataBitsPerMask +: DataBitsPerMask];
  end
  always @(posedge clk_i) begin
    if (req_i) begin
      if (write_i) begin
        for (int i=0; i < MaskWidth; i = i + 1) begin
          if (wmask[i]) begin
            mem[addr_i][i*DataBitsPerMask +: DataBitsPerMask] <=
              wdata_i[i*DataBitsPerMask +: DataBitsPerMask];
          end
        end
      end else begin
        rdata_o <= mem[addr_i];
      end
    end
  end
  export "DPI-C" task simutil_memload;
  task simutil_memload;
    input string file;
    $readmemh(file, mem);
  endtask
  export "DPI-C" function simutil_set_mem;
  function int simutil_set_mem(input int index, input bit [311:0] val);
    int valid;
    valid = Width > 312 || index >= Depth ? 0 : 1;
    if (valid == 1) mem[index] = val[Width-1:0];
    return valid;
  endfunction
  export "DPI-C" function simutil_get_mem;
  function int simutil_get_mem(input int index, output bit [311:0] val);
    int valid;
    valid = Width > 312 || index >= Depth ? 0 : 1;
    if (valid == 1) begin
      val = 0;
      val[Width-1:0] = mem[index];
    end
    return valid;
  endfunction
initial begin
  logic show_mem_paths;
  void'($value$plusargs("show_mem_paths=%0b", show_mem_paths));
  if (show_mem_paths) $display("%m");
  if (MemInitFile != "") begin : gen_meminit
      $display("Initializing memory %m from file '%s'.", MemInitFile);
      $readmemh(MemInitFile, mem);
  end
end
endmodule
module prim_ram_1r1w import prim_ram_1r1w_pkg::*; #(
  parameter  int Width           = 32,  
  parameter  int Depth           = 128,
  parameter  int DataBitsPerMask = 1,  
  parameter      MemInitFile     = "",  
  localparam int Aw              = $clog2(Depth)   
) (
  input logic              clk_a_i,
  input logic              clk_b_i,
  input logic              rst_a_ni,
  input logic              rst_b_ni,
  input                    a_req_i,
  input        [Aw-1:0]    a_addr_i,
  input        [Width-1:0] a_wdata_i,
  input  logic [Width-1:0] a_wmask_i,
  input                    b_req_i,
  input        [Aw-1:0]    b_addr_i,
  output logic [Width-1:0] b_rdata_o,
  input  ram_1r1w_cfg_req_t cfg_i,
  output ram_1r1w_cfg_rsp_t cfg_o
);
  logic unused_signals;
  assign unused_signals = ^{cfg_i, rst_a_ni, rst_b_ni};
  assign cfg_o          = RAM_1R1W_CFG_RSP_DEFAULT;
  localparam int MaskWidth = Width / DataBitsPerMask;
  logic [Width-1:0]     mem [Depth];
  logic [MaskWidth-1:0] a_wmask;
  for (genvar k = 0; k < MaskWidth; k++) begin : gen_wmask
    assign a_wmask[k] = &a_wmask_i[k*DataBitsPerMask +: DataBitsPerMask];
  end
  always @(posedge clk_a_i) begin
    if (a_req_i) begin
      for (int i=0; i < MaskWidth; i = i + 1) begin
        if (a_wmask[i]) begin
          mem[a_addr_i][i*DataBitsPerMask +: DataBitsPerMask] <=
            a_wdata_i[i*DataBitsPerMask +: DataBitsPerMask];
        end
      end
    end
  end
  always @(posedge clk_b_i) begin
    if (b_req_i) begin
      b_rdata_o <= mem[b_addr_i];
    end
  end
  export "DPI-C" task simutil_memload;
  task simutil_memload;
    input string file;
    $readmemh(file, mem);
  endtask
  export "DPI-C" function simutil_set_mem;
  function int simutil_set_mem(input int index, input bit [311:0] val);
    int valid;
    valid = Width > 312 || index >= Depth ? 0 : 1;
    if (valid == 1) mem[index] = val[Width-1:0];
    return valid;
  endfunction
  export "DPI-C" function simutil_get_mem;
  function int simutil_get_mem(input int index, output bit [311:0] val);
    int valid;
    valid = Width > 312 || index >= Depth ? 0 : 1;
    if (valid == 1) begin
      val = 0;
      val[Width-1:0] = mem[index];
    end
    return valid;
  endfunction
initial begin
  logic show_mem_paths;
  void'($value$plusargs("show_mem_paths=%0b", show_mem_paths));
  if (show_mem_paths) $display("%m");
  if (MemInitFile != "") begin : gen_meminit
      $display("Initializing memory %m from file '%s'.", MemInitFile);
      $readmemh(MemInitFile, mem);
  end
end
endmodule
module prim_ram_2p import prim_ram_2p_pkg::*; #(
  parameter  int Width           = 32,  
  parameter  int Depth           = 128,
  parameter  int DataBitsPerMask = 1,  
  parameter      MemInitFile     = "",  
  localparam int Aw              = $clog2(Depth)   
) (
  input clk_a_i,
  input clk_b_i,
  input                    a_req_i,
  input                    a_write_i,
  input        [Aw-1:0]    a_addr_i,
  input        [Width-1:0] a_wdata_i,
  input  logic [Width-1:0] a_wmask_i,
  output logic [Width-1:0] a_rdata_o,
  input                    b_req_i,
  input                    b_write_i,
  input        [Aw-1:0]    b_addr_i,
  input        [Width-1:0] b_wdata_i,
  input  logic [Width-1:0] b_wmask_i,
  output logic [Width-1:0] b_rdata_o,
  input  ram_2p_cfg_req_t  cfg_i,
  output ram_2p_cfg_rsp_t  cfg_o
);
  logic unused_cfg;
  assign unused_cfg = ^cfg_i;
  assign cfg_o      = RAM_2P_CFG_RSP_DEFAULT;
  localparam int MaskWidth = Width / DataBitsPerMask;
  logic [Width-1:0]     mem [Depth];
  logic [MaskWidth-1:0] a_wmask;
  logic [MaskWidth-1:0] b_wmask;
  for (genvar k = 0; k < MaskWidth; k++) begin : gen_wmask
    assign a_wmask[k] = &a_wmask_i[k*DataBitsPerMask +: DataBitsPerMask];
    assign b_wmask[k] = &b_wmask_i[k*DataBitsPerMask +: DataBitsPerMask];
  end
  always @(posedge clk_a_i) begin
    if (a_req_i) begin
      if (a_write_i) begin
        for (int i=0; i < MaskWidth; i = i + 1) begin
          if (a_wmask[i]) begin
            mem[a_addr_i][i*DataBitsPerMask +: DataBitsPerMask] <=
              a_wdata_i[i*DataBitsPerMask +: DataBitsPerMask];
          end
        end
      end else begin
        a_rdata_o <= mem[a_addr_i];
      end
    end
  end
  always @(posedge clk_b_i) begin
    if (b_req_i) begin
      if (b_write_i) begin
        for (int i=0; i < MaskWidth; i = i + 1) begin
          if (b_wmask[i]) begin
            mem[b_addr_i][i*DataBitsPerMask +: DataBitsPerMask] <=
              b_wdata_i[i*DataBitsPerMask +: DataBitsPerMask];
          end
        end
      end else begin
        b_rdata_o <= mem[b_addr_i];
      end
    end
  end
  export "DPI-C" task simutil_memload;
  task simutil_memload;
    input string file;
    $readmemh(file, mem);
  endtask
  export "DPI-C" function simutil_set_mem;
  function int simutil_set_mem(input int index, input bit [311:0] val);
    int valid;
    valid = Width > 312 || index >= Depth ? 0 : 1;
    if (valid == 1) mem[index] = val[Width-1:0];
    return valid;
  endfunction
  export "DPI-C" function simutil_get_mem;
  function int simutil_get_mem(input int index, output bit [311:0] val);
    int valid;
    valid = Width > 312 || index >= Depth ? 0 : 1;
    if (valid == 1) begin
      val = 0;
      val[Width-1:0] = mem[index];
    end
    return valid;
  endfunction
initial begin
  logic show_mem_paths;
  void'($value$plusargs("show_mem_paths=%0b", show_mem_paths));
  if (show_mem_paths) $display("%m");
  if (MemInitFile != "") begin : gen_meminit
      $display("Initializing memory %m from file '%s'.", MemInitFile);
      $readmemh(MemInitFile, mem);
  end
end
endmodule
module prim_rom import prim_rom_pkg::*; #(
  parameter  int Width       = 32,
  parameter  int Depth       = 2048,  
  parameter      MemInitFile = "",  
  localparam int Aw          = $clog2(Depth)
) (
  input  logic             clk_i,
  input  logic             rst_ni,
  input  logic             req_i,
  input  logic [Aw-1:0]    addr_i,
  output logic             rvalid_o,
  output logic [Width-1:0] rdata_o,
  input rom_cfg_t          cfg_i
);
  logic unused_signals;
  assign unused_signals = ^{cfg_i};
  logic [Width-1:0] mem [Depth];
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rvalid_o <= 1'b0;
    end else begin
      rvalid_o <= req_i;
    end
  end
  always_ff @(posedge clk_i) begin
    if (req_i) begin
      rdata_o <= mem[addr_i];
    end
  end
  export "DPI-C" task simutil_memload;
  task simutil_memload;
    input string file;
    $readmemh(file, mem);
  endtask
  export "DPI-C" function simutil_set_mem;
  function int simutil_set_mem(input int index, input bit [311:0] val);
    int valid;
    valid = Width > 312 || index >= Depth ? 0 : 1;
    if (valid == 1) mem[index] = val[Width-1:0];
    return valid;
  endfunction
  export "DPI-C" function simutil_get_mem;
  function int simutil_get_mem(input int index, output bit [311:0] val);
    int valid;
    valid = Width > 312 || index >= Depth ? 0 : 1;
    if (valid == 1) begin
      val = 0;
      val[Width-1:0] = mem[index];
    end
    return valid;
  endfunction
initial begin
  logic show_mem_paths;
  void'($value$plusargs("show_mem_paths=%0b", show_mem_paths));
  if (show_mem_paths) $display("%m");
  if (MemInitFile != "") begin : gen_meminit
      $display("Initializing memory %m from file '%s'.", MemInitFile);
      $readmemh(MemInitFile, mem);
  end
end
endmodule
module prim_lfsr #(
  parameter                    LfsrType     = "GAL_XOR",
  parameter int unsigned       LfsrDw       = 32,
  localparam int unsigned      LfsrIdxDw    = $clog2(LfsrDw),
  parameter int unsigned       EntropyDw    =  8,
  parameter int unsigned       StateOutDw   =  8,
  parameter logic [LfsrDw-1:0] DefaultSeed  = LfsrDw'(1),
  parameter logic [LfsrDw-1:0] CustomCoeffs = '0,
  parameter bit                StatePermEn  = 1'b0,
  parameter logic [LfsrDw-1:0][LfsrIdxDw-1:0] StatePerm = '0,
  parameter bit                MaxLenSVA    = 1'b1,
  parameter bit                LockupSVA    = 1'b1,
  parameter bit                ExtSeedSVA   = 1'b1,
  parameter bit                NonLinearOut = 1'b0
) (
  input                         clk_i,
  input                         rst_ni,
  input                         seed_en_i,  
  input        [LfsrDw-1:0]     seed_i,     
  input                         lfsr_en_i,  
  input        [EntropyDw-1:0]  entropy_i,  
  output logic [StateOutDw-1:0] state_o     
);
  localparam int unsigned LUT_OFF = 3;
  localparam logic [167:0] LFSR_COEFFS [166] =
    '{ 168'h6,
       168'hC,
       168'h14,
       168'h30,
       168'h60,
       168'hB8,
       168'h110,
       168'h240,
       168'h500,
       168'h829,
       168'h100D,
       168'h2015,
       168'h6000,
       168'hD008,
       168'h12000,
       168'h20400,
       168'h40023,
       168'h90000,
       168'h140000,
       168'h300000,
       168'h420000,
       168'hE10000,
       168'h1200000,
       168'h2000023,
       168'h4000013,
       168'h9000000,
       168'h14000000,
       168'h20000029,
       168'h48000000,
       168'h80200003,
       168'h100080000,
       168'h204000003,
       168'h500000000,
       168'h801000000,
       168'h100000001F,
       168'h2000000031,
       168'h4400000000,
       168'hA000140000,
       168'h12000000000,
       168'h300000C0000,
       168'h63000000000,
       168'hC0000030000,
       168'h1B0000000000,
       168'h300003000000,
       168'h420000000000,
       168'hC00000180000,
       168'h1008000000000,
       168'h3000000C00000,
       168'h6000C00000000,
       168'h9000000000000,
       168'h18003000000000,
       168'h30000000030000,
       168'h40000040000000,
       168'hC0000600000000,
       168'h102000000000000,
       168'h200004000000000,
       168'h600003000000000,
       168'hC00000000000000,
       168'h1800300000000000,
       168'h3000000000000030,
       168'h6000000000000000,
       168'hD800000000000000,
       168'h10000400000000000,
       168'h30180000000000000,
       168'h60300000000000000,
       168'h80400000000000000,
       168'h140000028000000000,
       168'h300060000000000000,
       168'h410000000000000000,
       168'h820000000001040000,
       168'h1000000800000000000,
       168'h3000600000000000000,
       168'h6018000000000000000,
       168'hC000000018000000000,
       168'h18000000600000000000,
       168'h30000600000000000000,
       168'h40200000000000000000,
       168'hC0000000060000000000,
       168'h110000000000000000000,
       168'h240000000480000000000,
       168'h600000000003000000000,
       168'h800400000000000000000,
       168'h1800000300000000000000,
       168'h3003000000000000000000,
       168'h4002000000000000000000,
       168'hC000000000000000018000,
       168'h10000000004000000000000,
       168'h30000C00000000000000000,
       168'h600000000000000000000C0,
       168'hC00C0000000000000000000,
       168'h140000000000000000000000,
       168'h200001000000000000000000,
       168'h400800000000000000000000,
       168'hA00000000001400000000000,
       168'h1040000000000000000000000,
       168'h2004000000000000000000000,
       168'h5000000000028000000000000,
       168'h8000000004000000000000000,
       168'h18600000000000000000000000,
       168'h30000000000000000C00000000,
       168'h40200000000000000000000000,
       168'hC0300000000000000000000000,
       168'h100010000000000000000000000,
       168'h200040000000000000000000000,
       168'h5000000000000000A0000000000,
       168'h800000010000000000000000000,
       168'h1860000000000000000000000000,
       168'h3003000000000000000000000000,
       168'h4010000000000000000000000000,
       168'hA000000000140000000000000000,
       168'h10080000000000000000000000000,
       168'h30000000000000000000180000000,
       168'h60018000000000000000000000000,
       168'hC0000000000000000300000000000,
       168'h140005000000000000000000000000,
       168'h200000001000000000000000000000,
       168'h404000000000000000000000000000,
       168'h810000000000000000000000000102,
       168'h1000040000000000000000000000000,
       168'h3000000000000006000000000000000,
       168'h5000000000000000000000000000000,
       168'h8000000004000000000000000000000,
       168'h18000000000000000000000000030000,
       168'h30000000030000000000000000000000,
       168'h60000000000000000000000000000000,
       168'hA0000014000000000000000000000000,
       168'h108000000000000000000000000000000,
       168'h240000000000000000000000000000000,
       168'h600000000000C00000000000000000000,
       168'h800000040000000000000000000000000,
       168'h1800000000000300000000000000000000,
       168'h2000000000000010000000000000000000,
       168'h4008000000000000000000000000000000,
       168'hC000000000000000000000000000000600,
       168'h10000080000000000000000000000000000,
       168'h30600000000000000000000000000000000,
       168'h4A400000000000000000000000000000000,
       168'h80000004000000000000000000000000000,
       168'h180000003000000000000000000000000000,
       168'h200001000000000000000000000000000000,
       168'h600006000000000000000000000000000000,
       168'hC00000000000000006000000000000000000,
       168'h1000000000000100000000000000000000000,
       168'h3000000000000006000000000000000000000,
       168'h6000000003000000000000000000000000000,
       168'h8000001000000000000000000000000000000,
       168'h1800000000000000000000000000C000000000,
       168'h20000000000001000000000000000000000000,
       168'h48000000000000000000000000000000000000,
       168'hC0000000000000006000000000000000000000,
       168'h180000000000000000000000000000000000000,
       168'h280000000000000000000000000000005000000,
       168'h60000000C000000000000000000000000000000,
       168'hC00000000000000000000000000018000000000,
       168'h1800000600000000000000000000000000000000,
       168'h3000000C00000000000000000000000000000000,
       168'h4000000080000000000000000000000000000000,
       168'hC000300000000000000000000000000000000000,
       168'h10000400000000000000000000000000000000000,
       168'h30000000000000000000006000000000000000000,
       168'h600000000000000C0000000000000000000000000,
       168'hC0060000000000000000000000000000000000000,
       168'h180000006000000000000000000000000000000000,
       168'h3000000000C0000000000000000000000000000000,
       168'h410000000000000000000000000000000000000000,
       168'hA00140000000000000000000000000000000000000 };
  logic lockup;
  logic [LfsrDw-1:0] lfsr_d, lfsr_q;
  logic [LfsrDw-1:0] next_lfsr_state, coeffs;
    localparam logic [LfsrDw-1:0] DefaultSeedLocal = DefaultSeed;
  if (64'(LfsrType) == 64'("GAL_XOR")) begin : gen_gal_xor
    if (CustomCoeffs > 0) begin : gen_custom
      assign coeffs = CustomCoeffs[LfsrDw-1:0];
    end else begin : gen_lut
      assign coeffs = LFSR_COEFFS[LfsrDw-LUT_OFF][LfsrDw-1:0];
    end
    assign next_lfsr_state = LfsrDw'(entropy_i) ^ ({LfsrDw{lfsr_q[0]}} & coeffs) ^ (lfsr_q >> 1);
    assign lockup = ~(|lfsr_q);
  end else if (64'(LfsrType) == "FIB_XNOR") begin : gen_fib_xnor
    if (CustomCoeffs > 0) begin : gen_custom
      assign coeffs = CustomCoeffs[LfsrDw-1:0];
    end else begin : gen_lut
      assign coeffs = LFSR_COEFFS[LfsrDw-LUT_OFF][LfsrDw-1:0];
    end
    assign next_lfsr_state = LfsrDw'(entropy_i) ^ {lfsr_q[LfsrDw-2:0], ~(^(lfsr_q & coeffs))};
    assign lockup = &lfsr_q;
  end else begin : gen_unknown_type
    assign coeffs = '0;
    assign next_lfsr_state = '0;
    assign lockup = 1'b0;
  end
  assign lfsr_d = (seed_en_i)           ? seed_i          :
                  (lfsr_en_i && lockup) ? DefaultSeedLocal     :
                  (lfsr_en_i)           ? next_lfsr_state :
                                          lfsr_q;
  logic [LfsrDw-1:0] sbox_out;
  if (NonLinearOut) begin : gen_out_non_linear
    localparam int NumSboxes = LfsrDw / 4;
    logic [3:0][NumSboxes-1:0][LfsrIdxDw-1:0] matrix_indices;
    for (genvar j = 0; j < LfsrDw; j++) begin : gen_input_idx_map
      assign matrix_indices[j / NumSboxes][j % NumSboxes] = j;
    end
    logic [3:0][NumSboxes-1:0][LfsrIdxDw-1:0] matrix_rotrev_indices;
    typedef logic [NumSboxes-1:0][LfsrIdxDw-1:0] matrix_col_t;
    function automatic matrix_col_t lrotcol(matrix_col_t col, integer shift);
      matrix_col_t out;
      for (int k = 0; k < NumSboxes; k++) begin
        out[(k + shift) % NumSboxes] = col[k];
      end
      return out;
    endfunction : lrotcol
    function automatic matrix_col_t revcol(matrix_col_t col);
      return {<<LfsrIdxDw{col}};
    endfunction : revcol
    always_comb begin : p_rotrev
      matrix_rotrev_indices[0] = matrix_indices[0];
      matrix_rotrev_indices[1] = lrotcol(matrix_indices[1], NumSboxes/2);
      matrix_rotrev_indices[2] = revcol(matrix_indices[2]);
      matrix_rotrev_indices[3] = revcol(lrotcol(matrix_indices[3], 1));
    end
    logic [LfsrDw-1:0][LfsrIdxDw-1:0] sbox_in_indices;
    for (genvar k = 0; k < LfsrDw; k++) begin : gen_reverse_upper
      assign sbox_in_indices[k] = matrix_rotrev_indices[k % 4][k / 4];
    end
      logic [LfsrDw-1:0] sbox_perm_test;
      always_comb begin : p_perm_check
        for (int k = 0; k < LfsrDw; k++) begin
          sbox_perm_test[sbox_in_indices[k]] = 1'b1;
        end
      end
    for (genvar k = 0; k < NumSboxes; k++) begin : gen_sboxes
      logic [3:0] sbox_in;
      assign sbox_in = {lfsr_q[sbox_in_indices[k*4 + 3]],
                        lfsr_q[sbox_in_indices[k*4 + 2]],
                        lfsr_q[sbox_in_indices[k*4 + 1]],
                        lfsr_q[sbox_in_indices[k*4 + 0]]};
      assign sbox_out[k*4 +: 4] = prim_cipher_pkg::PRINCE_SBOX4[sbox_in];
    end
  end else begin : gen_out_passthru
    assign sbox_out = lfsr_q;
  end
  if (StatePermEn) begin : gen_state_perm
    for (genvar k = 0; k < StateOutDw; k++) begin : gen_perm_loop
      assign state_o[k] = sbox_out[StatePerm[k]];
    end
    if (LfsrDw > StateOutDw) begin : gen_tieoff_unused
      logic unused_sbox_out;
      assign unused_sbox_out = ^sbox_out;
    end
  end else begin : gen_no_state_perm
    assign state_o = StateOutDw'(sbox_out);
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin : p_reg
    if (!rst_ni) begin
      lfsr_q <= DefaultSeedLocal;
    end else begin
      lfsr_q <= lfsr_d;
    end
  end
  function automatic logic [LfsrDw-1:0] compute_next_state(logic [LfsrDw-1:0]    lfsrcoeffs,
                                                           logic [EntropyDw-1:0] entropy,
                                                           logic [LfsrDw-1:0]    current_state);
    logic state0;
    logic [LfsrDw-1:0] next_state;
    next_state = current_state;
    if (64'(LfsrType) == 64'("GAL_XOR")) begin
      if (next_state == 0) begin
        next_state = DefaultSeedLocal;
      end else begin
        state0 = next_state[0];
        next_state = next_state >> 1;
        if (state0) next_state ^= lfsrcoeffs;
        next_state ^= LfsrDw'(entropy);
      end
    end else if (64'(LfsrType) == "FIB_XNOR") begin
      if (&next_state) begin
        next_state = DefaultSeedLocal;
      end else begin
        state0 = ~(^(next_state & lfsrcoeffs));
        next_state = next_state << 1;
        next_state[0] = state0;
        next_state ^= LfsrDw'(entropy);
      end
    end else begin
      $error("unknown lfsr type");
    end
    return next_state;
  endfunction : compute_next_state
  if (StatePermEn) begin : gen_perm_check
    logic [LfsrDw-1:0] lfsr_perm_test;
    initial begin : p_perm_check
      lfsr_perm_test = '0;
      for (int k = 0; k < LfsrDw; k++) begin
        lfsr_perm_test[StatePerm[k]] = 1'b1;
      end
    end
  end
  if (!StatePermEn && !NonLinearOut) begin : gen_output_sva
  end
  if (ExtSeedSVA) begin : gen_ext_seed_sva
  end
  if (LockupSVA) begin : gen_lockup_mechanism_sva
  end
  if(NonLinearOut) begin : gen_nonlinear_align_check_sva
  end
  if (MaxLenSVA) begin : gen_max_len_sva
    logic [LfsrDw-1:0] cnt_d, cnt_q;
    logic perturbed_d, perturbed_q;
    logic [LfsrDw-1:0] cmp_val;
    assign cmp_val = {{(LfsrDw-1){1'b1}}, 1'b0};  
    assign cnt_d = (lfsr_en_i && lockup)             ? '0           :
                   (lfsr_en_i && (cnt_q == cmp_val)) ? '0           :
                   (lfsr_en_i)                       ? cnt_q + 1'b1 :
                                                       cnt_q;
    assign perturbed_d = perturbed_q | (|entropy_i) | seed_en_i;
    always_ff @(posedge clk_i or negedge rst_ni) begin : p_max_len
      if (!rst_ni) begin
        cnt_q       <= '0;
        perturbed_q <= 1'b0;
      end else begin
        cnt_q       <= cnt_d;
        perturbed_q <= perturbed_d;
      end
    end
  end
endmodule
package prim_mubi_pkg;
  parameter int MuBi4Width = 4;
  typedef enum logic [MuBi4Width-1:0] {
    MuBi4True = 4'h6,  
    MuBi4False = 4'h9   
  } mubi4_t;
  function automatic bit assert_static_in_package_CheckMuBi4ValsComplementary_A(); 
    bit unused_bit [((MuBi4True == ~MuBi4False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction
  function automatic logic mubi4_test_invalid(mubi4_t val);
    return ~(val inside {MuBi4True, MuBi4False});
  endfunction : mubi4_test_invalid
  function automatic mubi4_t mubi4_bool_to_mubi(logic val);
    return (val ? MuBi4True : MuBi4False);
  endfunction : mubi4_bool_to_mubi
  function automatic logic mubi4_test_true_strict(mubi4_t val);
    return MuBi4True == val;
  endfunction : mubi4_test_true_strict
  function automatic logic mubi4_logic_test_true_strict(logic [3:0] val);
    return MuBi4True == val;
  endfunction : mubi4_logic_test_true_strict
  function automatic logic mubi4_test_false_strict(mubi4_t val);
    return MuBi4False == val;
  endfunction : mubi4_test_false_strict
  function automatic logic mubi4_test_true_loose(mubi4_t val);
    return MuBi4False != val;
  endfunction : mubi4_test_true_loose
  function automatic logic mubi4_test_false_loose(mubi4_t val);
    return MuBi4True != val;
  endfunction : mubi4_test_false_loose
  function automatic mubi4_t mubi4_or(mubi4_t a, mubi4_t b, mubi4_t act);
    logic [MuBi4Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi4Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi4_t'(out);
  endfunction : mubi4_or
  function automatic mubi4_t mubi4_and(mubi4_t a, mubi4_t b, mubi4_t act);
    logic [MuBi4Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi4Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi4_t'(out);
  endfunction : mubi4_and
  function automatic mubi4_t mubi4_or_hi(mubi4_t a, mubi4_t b);
    return mubi4_or(a, b, MuBi4True);
  endfunction : mubi4_or_hi
  function automatic mubi4_t mubi4_and_hi(mubi4_t a, mubi4_t b);
    return mubi4_and(a, b, MuBi4True);
  endfunction : mubi4_and_hi
  function automatic mubi4_t mubi4_or_lo(mubi4_t a, mubi4_t b);
    return mubi4_or(a, b, MuBi4False);
  endfunction : mubi4_or_lo
  function automatic mubi4_t mubi4_and_lo(mubi4_t a, mubi4_t b);
    return mubi4_and(a, b, MuBi4False);
  endfunction : mubi4_and_lo
  parameter int MuBi8Width = 8;
  typedef enum logic [MuBi8Width-1:0] {
    MuBi8True = 8'h96,  
    MuBi8False = 8'h69   
  } mubi8_t;
  function automatic bit assert_static_in_package_CheckMuBi8ValsComplementary_A(); 
    bit unused_bit [((MuBi8True == ~MuBi8False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction
  function automatic logic mubi8_test_invalid(mubi8_t val);
    return ~(val inside {MuBi8True, MuBi8False});
  endfunction : mubi8_test_invalid
  function automatic mubi8_t mubi8_bool_to_mubi(logic val);
    return (val ? MuBi8True : MuBi8False);
  endfunction : mubi8_bool_to_mubi
  function automatic logic mubi8_test_true_strict(mubi8_t val);
    return MuBi8True == val;
  endfunction : mubi8_test_true_strict
  function automatic logic mubi8_logic_test_true_strict(logic [7:0] val);
    return MuBi8True == val;
  endfunction : mubi8_logic_test_true_strict
  function automatic logic mubi8_test_false_strict(mubi8_t val);
    return MuBi8False == val;
  endfunction : mubi8_test_false_strict
  function automatic logic mubi8_test_true_loose(mubi8_t val);
    return MuBi8False != val;
  endfunction : mubi8_test_true_loose
  function automatic logic mubi8_test_false_loose(mubi8_t val);
    return MuBi8True != val;
  endfunction : mubi8_test_false_loose
  function automatic mubi8_t mubi8_or(mubi8_t a, mubi8_t b, mubi8_t act);
    logic [MuBi8Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi8Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi8_t'(out);
  endfunction : mubi8_or
  function automatic mubi8_t mubi8_and(mubi8_t a, mubi8_t b, mubi8_t act);
    logic [MuBi8Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi8Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi8_t'(out);
  endfunction : mubi8_and
  function automatic mubi8_t mubi8_or_hi(mubi8_t a, mubi8_t b);
    return mubi8_or(a, b, MuBi8True);
  endfunction : mubi8_or_hi
  function automatic mubi8_t mubi8_and_hi(mubi8_t a, mubi8_t b);
    return mubi8_and(a, b, MuBi8True);
  endfunction : mubi8_and_hi
  function automatic mubi8_t mubi8_or_lo(mubi8_t a, mubi8_t b);
    return mubi8_or(a, b, MuBi8False);
  endfunction : mubi8_or_lo
  function automatic mubi8_t mubi8_and_lo(mubi8_t a, mubi8_t b);
    return mubi8_and(a, b, MuBi8False);
  endfunction : mubi8_and_lo
  parameter int MuBi12Width = 12;
  typedef enum logic [MuBi12Width-1:0] {
    MuBi12True = 12'h696,  
    MuBi12False = 12'h969   
  } mubi12_t;
  function automatic bit assert_static_in_package_CheckMuBi12ValsComplementary_A(); 
    bit unused_bit [((MuBi12True == ~MuBi12False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction
  function automatic logic mubi12_test_invalid(mubi12_t val);
    return ~(val inside {MuBi12True, MuBi12False});
  endfunction : mubi12_test_invalid
  function automatic mubi12_t mubi12_bool_to_mubi(logic val);
    return (val ? MuBi12True : MuBi12False);
  endfunction : mubi12_bool_to_mubi
  function automatic logic mubi12_test_true_strict(mubi12_t val);
    return MuBi12True == val;
  endfunction : mubi12_test_true_strict
  function automatic logic mubi12_logic_test_true_strict(logic [11:0] val);
    return MuBi12True == val;
  endfunction : mubi12_logic_test_true_strict
  function automatic logic mubi12_test_false_strict(mubi12_t val);
    return MuBi12False == val;
  endfunction : mubi12_test_false_strict
  function automatic logic mubi12_test_true_loose(mubi12_t val);
    return MuBi12False != val;
  endfunction : mubi12_test_true_loose
  function automatic logic mubi12_test_false_loose(mubi12_t val);
    return MuBi12True != val;
  endfunction : mubi12_test_false_loose
  function automatic mubi12_t mubi12_or(mubi12_t a, mubi12_t b, mubi12_t act);
    logic [MuBi12Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi12Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi12_t'(out);
  endfunction : mubi12_or
  function automatic mubi12_t mubi12_and(mubi12_t a, mubi12_t b, mubi12_t act);
    logic [MuBi12Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi12Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi12_t'(out);
  endfunction : mubi12_and
  function automatic mubi12_t mubi12_or_hi(mubi12_t a, mubi12_t b);
    return mubi12_or(a, b, MuBi12True);
  endfunction : mubi12_or_hi
  function automatic mubi12_t mubi12_and_hi(mubi12_t a, mubi12_t b);
    return mubi12_and(a, b, MuBi12True);
  endfunction : mubi12_and_hi
  function automatic mubi12_t mubi12_or_lo(mubi12_t a, mubi12_t b);
    return mubi12_or(a, b, MuBi12False);
  endfunction : mubi12_or_lo
  function automatic mubi12_t mubi12_and_lo(mubi12_t a, mubi12_t b);
    return mubi12_and(a, b, MuBi12False);
  endfunction : mubi12_and_lo
  parameter int MuBi16Width = 16;
  typedef enum logic [MuBi16Width-1:0] {
    MuBi16True = 16'h9696,  
    MuBi16False = 16'h6969   
  } mubi16_t;
  function automatic bit assert_static_in_package_CheckMuBi16ValsComplementary_A(); 
    bit unused_bit [((MuBi16True == ~MuBi16False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction
  function automatic logic mubi16_test_invalid(mubi16_t val);
    return ~(val inside {MuBi16True, MuBi16False});
  endfunction : mubi16_test_invalid
  function automatic mubi16_t mubi16_bool_to_mubi(logic val);
    return (val ? MuBi16True : MuBi16False);
  endfunction : mubi16_bool_to_mubi
  function automatic logic mubi16_test_true_strict(mubi16_t val);
    return MuBi16True == val;
  endfunction : mubi16_test_true_strict
  function automatic logic mubi16_logic_test_true_strict(logic [15:0] val);
    return MuBi16True == val;
  endfunction : mubi16_logic_test_true_strict
  function automatic logic mubi16_test_false_strict(mubi16_t val);
    return MuBi16False == val;
  endfunction : mubi16_test_false_strict
  function automatic logic mubi16_test_true_loose(mubi16_t val);
    return MuBi16False != val;
  endfunction : mubi16_test_true_loose
  function automatic logic mubi16_test_false_loose(mubi16_t val);
    return MuBi16True != val;
  endfunction : mubi16_test_false_loose
  function automatic mubi16_t mubi16_or(mubi16_t a, mubi16_t b, mubi16_t act);
    logic [MuBi16Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi16Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi16_t'(out);
  endfunction : mubi16_or
  function automatic mubi16_t mubi16_and(mubi16_t a, mubi16_t b, mubi16_t act);
    logic [MuBi16Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi16Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi16_t'(out);
  endfunction : mubi16_and
  function automatic mubi16_t mubi16_or_hi(mubi16_t a, mubi16_t b);
    return mubi16_or(a, b, MuBi16True);
  endfunction : mubi16_or_hi
  function automatic mubi16_t mubi16_and_hi(mubi16_t a, mubi16_t b);
    return mubi16_and(a, b, MuBi16True);
  endfunction : mubi16_and_hi
  function automatic mubi16_t mubi16_or_lo(mubi16_t a, mubi16_t b);
    return mubi16_or(a, b, MuBi16False);
  endfunction : mubi16_or_lo
  function automatic mubi16_t mubi16_and_lo(mubi16_t a, mubi16_t b);
    return mubi16_and(a, b, MuBi16False);
  endfunction : mubi16_and_lo
  parameter int MuBi20Width = 20;
  typedef enum logic [MuBi20Width-1:0] {
    MuBi20True = 20'h69696,  
    MuBi20False = 20'h96969   
  } mubi20_t;
  function automatic bit assert_static_in_package_CheckMuBi20ValsComplementary_A(); 
    bit unused_bit [((MuBi20True == ~MuBi20False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction
  function automatic logic mubi20_test_invalid(mubi20_t val);
    return ~(val inside {MuBi20True, MuBi20False});
  endfunction : mubi20_test_invalid
  function automatic mubi20_t mubi20_bool_to_mubi(logic val);
    return (val ? MuBi20True : MuBi20False);
  endfunction : mubi20_bool_to_mubi
  function automatic logic mubi20_test_true_strict(mubi20_t val);
    return MuBi20True == val;
  endfunction : mubi20_test_true_strict
  function automatic logic mubi20_logic_test_true_strict(logic [19:0] val);
    return MuBi20True == val;
  endfunction : mubi20_logic_test_true_strict
  function automatic logic mubi20_test_false_strict(mubi20_t val);
    return MuBi20False == val;
  endfunction : mubi20_test_false_strict
  function automatic logic mubi20_test_true_loose(mubi20_t val);
    return MuBi20False != val;
  endfunction : mubi20_test_true_loose
  function automatic logic mubi20_test_false_loose(mubi20_t val);
    return MuBi20True != val;
  endfunction : mubi20_test_false_loose
  function automatic mubi20_t mubi20_or(mubi20_t a, mubi20_t b, mubi20_t act);
    logic [MuBi20Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi20Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi20_t'(out);
  endfunction : mubi20_or
  function automatic mubi20_t mubi20_and(mubi20_t a, mubi20_t b, mubi20_t act);
    logic [MuBi20Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi20Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi20_t'(out);
  endfunction : mubi20_and
  function automatic mubi20_t mubi20_or_hi(mubi20_t a, mubi20_t b);
    return mubi20_or(a, b, MuBi20True);
  endfunction : mubi20_or_hi
  function automatic mubi20_t mubi20_and_hi(mubi20_t a, mubi20_t b);
    return mubi20_and(a, b, MuBi20True);
  endfunction : mubi20_and_hi
  function automatic mubi20_t mubi20_or_lo(mubi20_t a, mubi20_t b);
    return mubi20_or(a, b, MuBi20False);
  endfunction : mubi20_or_lo
  function automatic mubi20_t mubi20_and_lo(mubi20_t a, mubi20_t b);
    return mubi20_and(a, b, MuBi20False);
  endfunction : mubi20_and_lo
  parameter int MuBi24Width = 24;
  typedef enum logic [MuBi24Width-1:0] {
    MuBi24True = 24'h969696,  
    MuBi24False = 24'h696969   
  } mubi24_t;
  function automatic bit assert_static_in_package_CheckMuBi24ValsComplementary_A(); 
    bit unused_bit [((MuBi24True == ~MuBi24False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction
  function automatic logic mubi24_test_invalid(mubi24_t val);
    return ~(val inside {MuBi24True, MuBi24False});
  endfunction : mubi24_test_invalid
  function automatic mubi24_t mubi24_bool_to_mubi(logic val);
    return (val ? MuBi24True : MuBi24False);
  endfunction : mubi24_bool_to_mubi
  function automatic logic mubi24_test_true_strict(mubi24_t val);
    return MuBi24True == val;
  endfunction : mubi24_test_true_strict
  function automatic logic mubi24_logic_test_true_strict(logic [23:0] val);
    return MuBi24True == val;
  endfunction : mubi24_logic_test_true_strict
  function automatic logic mubi24_test_false_strict(mubi24_t val);
    return MuBi24False == val;
  endfunction : mubi24_test_false_strict
  function automatic logic mubi24_test_true_loose(mubi24_t val);
    return MuBi24False != val;
  endfunction : mubi24_test_true_loose
  function automatic logic mubi24_test_false_loose(mubi24_t val);
    return MuBi24True != val;
  endfunction : mubi24_test_false_loose
  function automatic mubi24_t mubi24_or(mubi24_t a, mubi24_t b, mubi24_t act);
    logic [MuBi24Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi24Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi24_t'(out);
  endfunction : mubi24_or
  function automatic mubi24_t mubi24_and(mubi24_t a, mubi24_t b, mubi24_t act);
    logic [MuBi24Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi24Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi24_t'(out);
  endfunction : mubi24_and
  function automatic mubi24_t mubi24_or_hi(mubi24_t a, mubi24_t b);
    return mubi24_or(a, b, MuBi24True);
  endfunction : mubi24_or_hi
  function automatic mubi24_t mubi24_and_hi(mubi24_t a, mubi24_t b);
    return mubi24_and(a, b, MuBi24True);
  endfunction : mubi24_and_hi
  function automatic mubi24_t mubi24_or_lo(mubi24_t a, mubi24_t b);
    return mubi24_or(a, b, MuBi24False);
  endfunction : mubi24_or_lo
  function automatic mubi24_t mubi24_and_lo(mubi24_t a, mubi24_t b);
    return mubi24_and(a, b, MuBi24False);
  endfunction : mubi24_and_lo
  parameter int MuBi28Width = 28;
  typedef enum logic [MuBi28Width-1:0] {
    MuBi28True = 28'h6969696,  
    MuBi28False = 28'h9696969   
  } mubi28_t;
  function automatic bit assert_static_in_package_CheckMuBi28ValsComplementary_A(); 
    bit unused_bit [((MuBi28True == ~MuBi28False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction
  function automatic logic mubi28_test_invalid(mubi28_t val);
    return ~(val inside {MuBi28True, MuBi28False});
  endfunction : mubi28_test_invalid
  function automatic mubi28_t mubi28_bool_to_mubi(logic val);
    return (val ? MuBi28True : MuBi28False);
  endfunction : mubi28_bool_to_mubi
  function automatic logic mubi28_test_true_strict(mubi28_t val);
    return MuBi28True == val;
  endfunction : mubi28_test_true_strict
  function automatic logic mubi28_logic_test_true_strict(logic [27:0] val);
    return MuBi28True == val;
  endfunction : mubi28_logic_test_true_strict
  function automatic logic mubi28_test_false_strict(mubi28_t val);
    return MuBi28False == val;
  endfunction : mubi28_test_false_strict
  function automatic logic mubi28_test_true_loose(mubi28_t val);
    return MuBi28False != val;
  endfunction : mubi28_test_true_loose
  function automatic logic mubi28_test_false_loose(mubi28_t val);
    return MuBi28True != val;
  endfunction : mubi28_test_false_loose
  function automatic mubi28_t mubi28_or(mubi28_t a, mubi28_t b, mubi28_t act);
    logic [MuBi28Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi28Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi28_t'(out);
  endfunction : mubi28_or
  function automatic mubi28_t mubi28_and(mubi28_t a, mubi28_t b, mubi28_t act);
    logic [MuBi28Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi28Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi28_t'(out);
  endfunction : mubi28_and
  function automatic mubi28_t mubi28_or_hi(mubi28_t a, mubi28_t b);
    return mubi28_or(a, b, MuBi28True);
  endfunction : mubi28_or_hi
  function automatic mubi28_t mubi28_and_hi(mubi28_t a, mubi28_t b);
    return mubi28_and(a, b, MuBi28True);
  endfunction : mubi28_and_hi
  function automatic mubi28_t mubi28_or_lo(mubi28_t a, mubi28_t b);
    return mubi28_or(a, b, MuBi28False);
  endfunction : mubi28_or_lo
  function automatic mubi28_t mubi28_and_lo(mubi28_t a, mubi28_t b);
    return mubi28_and(a, b, MuBi28False);
  endfunction : mubi28_and_lo
  parameter int MuBi32Width = 32;
  typedef enum logic [MuBi32Width-1:0] {
    MuBi32True = 32'h96969696,  
    MuBi32False = 32'h69696969   
  } mubi32_t;
  function automatic bit assert_static_in_package_CheckMuBi32ValsComplementary_A(); 
    bit unused_bit [((MuBi32True == ~MuBi32False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction
  function automatic logic mubi32_test_invalid(mubi32_t val);
    return ~(val inside {MuBi32True, MuBi32False});
  endfunction : mubi32_test_invalid
  function automatic mubi32_t mubi32_bool_to_mubi(logic val);
    return (val ? MuBi32True : MuBi32False);
  endfunction : mubi32_bool_to_mubi
  function automatic logic mubi32_test_true_strict(mubi32_t val);
    return MuBi32True == val;
  endfunction : mubi32_test_true_strict
  function automatic logic mubi32_logic_test_true_strict(logic [31:0] val);
    return MuBi32True == val;
  endfunction : mubi32_logic_test_true_strict
  function automatic logic mubi32_test_false_strict(mubi32_t val);
    return MuBi32False == val;
  endfunction : mubi32_test_false_strict
  function automatic logic mubi32_test_true_loose(mubi32_t val);
    return MuBi32False != val;
  endfunction : mubi32_test_true_loose
  function automatic logic mubi32_test_false_loose(mubi32_t val);
    return MuBi32True != val;
  endfunction : mubi32_test_false_loose
  function automatic mubi32_t mubi32_or(mubi32_t a, mubi32_t b, mubi32_t act);
    logic [MuBi32Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi32Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi32_t'(out);
  endfunction : mubi32_or
  function automatic mubi32_t mubi32_and(mubi32_t a, mubi32_t b, mubi32_t act);
    logic [MuBi32Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi32Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi32_t'(out);
  endfunction : mubi32_and
  function automatic mubi32_t mubi32_or_hi(mubi32_t a, mubi32_t b);
    return mubi32_or(a, b, MuBi32True);
  endfunction : mubi32_or_hi
  function automatic mubi32_t mubi32_and_hi(mubi32_t a, mubi32_t b);
    return mubi32_and(a, b, MuBi32True);
  endfunction : mubi32_and_hi
  function automatic mubi32_t mubi32_or_lo(mubi32_t a, mubi32_t b);
    return mubi32_or(a, b, MuBi32False);
  endfunction : mubi32_or_lo
  function automatic mubi32_t mubi32_and_lo(mubi32_t a, mubi32_t b);
    return mubi32_and(a, b, MuBi32False);
  endfunction : mubi32_and_lo
endpackage : prim_mubi_pkg
module prim_sec_anchor_buf #(
  parameter int Width = 1
) (
  input        [Width-1:0] in_i,
  output logic [Width-1:0] out_o
);
  prim_buf #(
    .Width(Width)
  ) u_secure_anchor_buf (
    .in_i,
    .out_o
  );
endmodule
module prim_sec_anchor_flop #(
  parameter int               Width      = 1,
  parameter logic [Width-1:0] ResetValue = 0
) (
  input                    clk_i,
  input                    rst_ni,
  input        [Width-1:0] d_i,
  output logic [Width-1:0] q_o
);
  prim_flop #(
    .Width(Width),
    .ResetValue(ResetValue)
  ) u_secure_anchor_flop (
    .clk_i,
    .rst_ni,
    .d_i,
    .q_o
  );
endmodule
package prim_util_pkg;
  function automatic integer vbits(integer value);
    return (value == 1) ? 1 : $clog2(value);
  endfunction
  function automatic integer ceil_div(input integer dividend, input integer divisor);
    ceil_div = ((dividend % divisor) != 0) ? (dividend / divisor) + 1 : (dividend / divisor);
  endfunction
endpackage
module prim_clock_inv #(
  parameter bit HasScanMode = 1'b1,
  parameter bit NoFpgaBufG  = 1'b0  
) (
  input        clk_i,
  input        scanmode_i,
  output logic clk_no       
);
  if (HasScanMode) begin : gen_scan
    prim_clock_mux2 #(
      .NoFpgaBufG(NoFpgaBufG)
    ) i_dft_tck_mux (
      .clk0_i ( ~clk_i     ),
      .clk1_i ( clk_i      ),  
      .sel_i  ( scanmode_i ),
      .clk_o  ( clk_no     )
    );
  end else begin : gen_noscan
    logic unused_scanmode;
    assign unused_scanmode = scanmode_i;
    assign clk_no = ~clk_i;
  end
endmodule : prim_clock_inv
module prim_flop_2sync #(
  parameter int               Width      = 16,
  parameter logic [Width-1:0] ResetValue = '0,
  parameter bit               EnablePrimCdcRand = 1
) (
  input                    clk_i,
  input                    rst_ni,
  input        [Width-1:0] d_i,
  output logic [Width-1:0] q_o
);
  logic [Width-1:0] d_o;
  logic [Width-1:0] intq;
  logic unused_sig;
  assign unused_sig = EnablePrimCdcRand;
  always_comb d_o = d_i;
  prim_flop #(
    .Width(Width),
    .ResetValue(ResetValue)
  ) u_sync_1 (
    .clk_i,
    .rst_ni,
    .d_i(d_o),
    .q_o(intq)
  );
  prim_flop #(
    .Width(Width),
    .ResetValue(ResetValue)
  ) u_sync_2 (
    .clk_i,
    .rst_ni,
    .d_i(intq),
    .q_o
  );
endmodule : prim_flop_2sync
module prim_flop_en #(
  parameter int               Width      = 1,
  parameter bit               EnSecBuf   = 0,
  parameter logic [Width-1:0] ResetValue = 0
) (
  input                    clk_i,
  input                    rst_ni,
  input                    en_i,
  input        [Width-1:0] d_i,
  output logic [Width-1:0] q_o
);
  logic en;
  if (EnSecBuf) begin : gen_en_sec_buf
    prim_sec_anchor_buf #(
      .Width(1)
    ) u_en_buf (
      .in_i(en_i),
      .out_o(en)
    );
  end else begin : gen_en_no_sec_buf
    assign en = en_i;
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      q_o <= ResetValue;
    end else if (en) begin
      q_o <= d_i;
    end
  end
endmodule
module prim_mubi4_sender
  import prim_mubi_pkg::*;
#(
  parameter bit AsyncOn = 1,
  parameter bit EnSecBuf = 0,
  parameter mubi4_t ResetValue = MuBi4False
) (
  input          clk_i,
  input          rst_ni,
  input  mubi4_t mubi_i,
  output mubi4_t mubi_o
);
  logic [MuBi4Width-1:0] mubi, mubi_int, mubi_out;
  assign mubi = MuBi4Width'(mubi_i);
  if (AsyncOn) begin : gen_flops
    prim_flop #(
      .Width(MuBi4Width),
      .ResetValue(MuBi4Width'(ResetValue))
    ) u_prim_flop (
      .clk_i,
      .rst_ni,
      .d_i   ( mubi     ),
      .q_o   ( mubi_int )
    );
  end else begin : gen_no_flops
    assign mubi_int = mubi;
    mubi4_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi4False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
  end
  if (EnSecBuf) begin : gen_sec_buf
    prim_sec_anchor_buf #(
      .Width(4)
    ) u_prim_sec_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else if (!AsyncOn) begin : gen_prim_buf
    prim_buf #(
      .Width(4)
    ) u_prim_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else begin : gen_feedthru
    assign mubi_out = mubi_int;
  end
  assign mubi_o = mubi4_t'(mubi_out);
endmodule : prim_mubi4_sender
module prim_mubi4_sync
  import prim_mubi_pkg::*;
#(
  parameter int NumCopies = 1,
  parameter bit AsyncOn = 1,
  parameter bit StabilityCheck = 0,
  parameter mubi4_t ResetValue = MuBi4False
) (
  input                          clk_i,
  input                          rst_ni,
  input  mubi4_t                 mubi_i,
  output mubi4_t [NumCopies-1:0] mubi_o
);
  logic [MuBi4Width-1:0] mubi;
  if (AsyncOn) begin : gen_flops
    logic [MuBi4Width-1:0] mubi_sync;
    prim_flop_2sync #(
      .Width(MuBi4Width),
      .ResetValue(MuBi4Width'(ResetValue))
    ) u_prim_flop_2sync (
      .clk_i,
      .rst_ni,
      .d_i(MuBi4Width'(mubi_i)),
      .q_o(mubi_sync)
    );
    if (StabilityCheck) begin : gen_stable_chks
      logic [MuBi4Width-1:0] mubi_q;
      prim_flop #(
        .Width(MuBi4Width),
        .ResetValue(MuBi4Width'(ResetValue))
      ) u_prim_flop_3rd_stage (
        .clk_i,
        .rst_ni,
        .d_i(mubi_sync),
        .q_o(mubi_q)
      );
      logic [MuBi4Width-1:0] sig_unstable;
      prim_xor2 #(
        .Width(MuBi4Width)
      ) u_mubi_xor (
        .in0_i(mubi_sync),
        .in1_i(mubi_q),
        .out_o(sig_unstable)
      );
      logic [MuBi4Width-1:0] reset_value;
      assign reset_value = ResetValue;
      for (genvar k = 0; k < MuBi4Width; k++) begin : gen_bufs_muxes
        logic [MuBi4Width-1:0] sig_unstable_buf;
        prim_sec_anchor_buf #(
          .Width(MuBi4Width)
        ) u_sig_unstable_buf (
          .in_i(sig_unstable),
          .out_o(sig_unstable_buf)
        );
        assign mubi[k] = (|sig_unstable_buf) ? reset_value[k] : mubi_q[k];
      end
    end else begin : gen_no_stable_chks
      assign mubi = mubi_sync;
    end
  end else begin : gen_no_flops
    mubi4_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi4False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
    assign mubi = MuBi4Width'(mubi_i);
  end
  for (genvar j = 0; j < NumCopies; j++) begin : gen_buffs
    logic [MuBi4Width-1:0] mubi_out;
    for (genvar k = 0; k < MuBi4Width; k++) begin : gen_bits
      prim_buf u_prim_buf (
        .in_i(mubi[k]),
        .out_o(mubi_out[k])
      );
    end
    assign mubi_o[j] = mubi4_t'(mubi_out);
  end
endmodule : prim_mubi4_sync
module prim_mubi4_dec
  import prim_mubi_pkg::*;
#(
  parameter bit TestTrue = 1,
  parameter bit TestStrict = 1
) (
  input  mubi4_t mubi_i,
  output logic           mubi_dec_o
);
logic [MuBi4Width-1:0] mubi, mubi_out;
assign mubi = MuBi4Width'(mubi_i);
for (genvar k = 0; k < MuBi4Width; k++) begin : gen_bits
  prim_buf u_prim_buf (
    .in_i  ( mubi[k]     ),
    .out_o ( mubi_out[k] )
  );
end
if (TestTrue && TestStrict) begin : gen_test_true_strict
  assign mubi_dec_o = mubi4_test_true_strict(mubi4_t'(mubi_out));
end else if (TestTrue && !TestStrict) begin : gen_test_true_loose
  assign mubi_dec_o = mubi4_test_true_loose(mubi4_t'(mubi_out));
end else if (!TestTrue && TestStrict) begin : gen_test_false_strict
  assign mubi_dec_o = mubi4_test_false_strict(mubi4_t'(mubi_out));
end else if (!TestTrue && !TestStrict) begin : gen_test_false_loose
  assign mubi_dec_o = mubi4_test_false_loose(mubi4_t'(mubi_out));
end else begin : gen_unknown_config
end
endmodule : prim_mubi4_dec
module prim_mubi8_sender
  import prim_mubi_pkg::*;
#(
  parameter bit AsyncOn = 1,
  parameter bit EnSecBuf = 0,
  parameter mubi8_t ResetValue = MuBi8False
) (
  input          clk_i,
  input          rst_ni,
  input  mubi8_t mubi_i,
  output mubi8_t mubi_o
);
  logic [MuBi8Width-1:0] mubi, mubi_int, mubi_out;
  assign mubi = MuBi8Width'(mubi_i);
  if (AsyncOn) begin : gen_flops
    prim_flop #(
      .Width(MuBi8Width),
      .ResetValue(MuBi8Width'(ResetValue))
    ) u_prim_flop (
      .clk_i,
      .rst_ni,
      .d_i   ( mubi     ),
      .q_o   ( mubi_int )
    );
  end else begin : gen_no_flops
    assign mubi_int = mubi;
    mubi8_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi8False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
  end
  if (EnSecBuf) begin : gen_sec_buf
    prim_sec_anchor_buf #(
      .Width(8)
    ) u_prim_sec_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else if (!AsyncOn) begin : gen_prim_buf
    prim_buf #(
      .Width(8)
    ) u_prim_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else begin : gen_feedthru
    assign mubi_out = mubi_int;
  end
  assign mubi_o = mubi8_t'(mubi_out);
endmodule : prim_mubi8_sender
module prim_mubi8_sync
  import prim_mubi_pkg::*;
#(
  parameter int NumCopies = 1,
  parameter bit AsyncOn = 1,
  parameter bit StabilityCheck = 0,
  parameter mubi8_t ResetValue = MuBi8False
) (
  input                          clk_i,
  input                          rst_ni,
  input  mubi8_t                 mubi_i,
  output mubi8_t [NumCopies-1:0] mubi_o
);
  logic [MuBi8Width-1:0] mubi;
  if (AsyncOn) begin : gen_flops
    logic [MuBi8Width-1:0] mubi_sync;
    prim_flop_2sync #(
      .Width(MuBi8Width),
      .ResetValue(MuBi8Width'(ResetValue))
    ) u_prim_flop_2sync (
      .clk_i,
      .rst_ni,
      .d_i(MuBi8Width'(mubi_i)),
      .q_o(mubi_sync)
    );
    if (StabilityCheck) begin : gen_stable_chks
      logic [MuBi8Width-1:0] mubi_q;
      prim_flop #(
        .Width(MuBi8Width),
        .ResetValue(MuBi8Width'(ResetValue))
      ) u_prim_flop_3rd_stage (
        .clk_i,
        .rst_ni,
        .d_i(mubi_sync),
        .q_o(mubi_q)
      );
      logic [MuBi8Width-1:0] sig_unstable;
      prim_xor2 #(
        .Width(MuBi8Width)
      ) u_mubi_xor (
        .in0_i(mubi_sync),
        .in1_i(mubi_q),
        .out_o(sig_unstable)
      );
      logic [MuBi8Width-1:0] reset_value;
      assign reset_value = ResetValue;
      for (genvar k = 0; k < MuBi8Width; k++) begin : gen_bufs_muxes
        logic [MuBi8Width-1:0] sig_unstable_buf;
        prim_sec_anchor_buf #(
          .Width(MuBi8Width)
        ) u_sig_unstable_buf (
          .in_i(sig_unstable),
          .out_o(sig_unstable_buf)
        );
        assign mubi[k] = (|sig_unstable_buf) ? reset_value[k] : mubi_q[k];
      end
    end else begin : gen_no_stable_chks
      assign mubi = mubi_sync;
    end
  end else begin : gen_no_flops
    mubi8_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi8False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
    assign mubi = MuBi8Width'(mubi_i);
  end
  for (genvar j = 0; j < NumCopies; j++) begin : gen_buffs
    logic [MuBi8Width-1:0] mubi_out;
    for (genvar k = 0; k < MuBi8Width; k++) begin : gen_bits
      prim_buf u_prim_buf (
        .in_i(mubi[k]),
        .out_o(mubi_out[k])
      );
    end
    assign mubi_o[j] = mubi8_t'(mubi_out);
  end
endmodule : prim_mubi8_sync
module prim_mubi8_dec
  import prim_mubi_pkg::*;
#(
  parameter bit TestTrue = 1,
  parameter bit TestStrict = 1
) (
  input  mubi8_t mubi_i,
  output logic           mubi_dec_o
);
logic [MuBi8Width-1:0] mubi, mubi_out;
assign mubi = MuBi8Width'(mubi_i);
for (genvar k = 0; k < MuBi8Width; k++) begin : gen_bits
  prim_buf u_prim_buf (
    .in_i  ( mubi[k]     ),
    .out_o ( mubi_out[k] )
  );
end
if (TestTrue && TestStrict) begin : gen_test_true_strict
  assign mubi_dec_o = mubi8_test_true_strict(mubi8_t'(mubi_out));
end else if (TestTrue && !TestStrict) begin : gen_test_true_loose
  assign mubi_dec_o = mubi8_test_true_loose(mubi8_t'(mubi_out));
end else if (!TestTrue && TestStrict) begin : gen_test_false_strict
  assign mubi_dec_o = mubi8_test_false_strict(mubi8_t'(mubi_out));
end else if (!TestTrue && !TestStrict) begin : gen_test_false_loose
  assign mubi_dec_o = mubi8_test_false_loose(mubi8_t'(mubi_out));
end else begin : gen_unknown_config
end
endmodule : prim_mubi8_dec
module prim_mubi12_sender
  import prim_mubi_pkg::*;
#(
  parameter bit AsyncOn = 1,
  parameter bit EnSecBuf = 0,
  parameter mubi12_t ResetValue = MuBi12False
) (
  input          clk_i,
  input          rst_ni,
  input  mubi12_t mubi_i,
  output mubi12_t mubi_o
);
  logic [MuBi12Width-1:0] mubi, mubi_int, mubi_out;
  assign mubi = MuBi12Width'(mubi_i);
  if (AsyncOn) begin : gen_flops
    prim_flop #(
      .Width(MuBi12Width),
      .ResetValue(MuBi12Width'(ResetValue))
    ) u_prim_flop (
      .clk_i,
      .rst_ni,
      .d_i   ( mubi     ),
      .q_o   ( mubi_int )
    );
  end else begin : gen_no_flops
    assign mubi_int = mubi;
    mubi12_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi12False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
  end
  if (EnSecBuf) begin : gen_sec_buf
    prim_sec_anchor_buf #(
      .Width(12)
    ) u_prim_sec_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else if (!AsyncOn) begin : gen_prim_buf
    prim_buf #(
      .Width(12)
    ) u_prim_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else begin : gen_feedthru
    assign mubi_out = mubi_int;
  end
  assign mubi_o = mubi12_t'(mubi_out);
endmodule : prim_mubi12_sender
module prim_mubi12_sync
  import prim_mubi_pkg::*;
#(
  parameter int NumCopies = 1,
  parameter bit AsyncOn = 1,
  parameter bit StabilityCheck = 0,
  parameter mubi12_t ResetValue = MuBi12False
) (
  input                          clk_i,
  input                          rst_ni,
  input  mubi12_t                 mubi_i,
  output mubi12_t [NumCopies-1:0] mubi_o
);
  logic [MuBi12Width-1:0] mubi;
  if (AsyncOn) begin : gen_flops
    logic [MuBi12Width-1:0] mubi_sync;
    prim_flop_2sync #(
      .Width(MuBi12Width),
      .ResetValue(MuBi12Width'(ResetValue))
    ) u_prim_flop_2sync (
      .clk_i,
      .rst_ni,
      .d_i(MuBi12Width'(mubi_i)),
      .q_o(mubi_sync)
    );
    if (StabilityCheck) begin : gen_stable_chks
      logic [MuBi12Width-1:0] mubi_q;
      prim_flop #(
        .Width(MuBi12Width),
        .ResetValue(MuBi12Width'(ResetValue))
      ) u_prim_flop_3rd_stage (
        .clk_i,
        .rst_ni,
        .d_i(mubi_sync),
        .q_o(mubi_q)
      );
      logic [MuBi12Width-1:0] sig_unstable;
      prim_xor2 #(
        .Width(MuBi12Width)
      ) u_mubi_xor (
        .in0_i(mubi_sync),
        .in1_i(mubi_q),
        .out_o(sig_unstable)
      );
      logic [MuBi12Width-1:0] reset_value;
      assign reset_value = ResetValue;
      for (genvar k = 0; k < MuBi12Width; k++) begin : gen_bufs_muxes
        logic [MuBi12Width-1:0] sig_unstable_buf;
        prim_sec_anchor_buf #(
          .Width(MuBi12Width)
        ) u_sig_unstable_buf (
          .in_i(sig_unstable),
          .out_o(sig_unstable_buf)
        );
        assign mubi[k] = (|sig_unstable_buf) ? reset_value[k] : mubi_q[k];
      end
    end else begin : gen_no_stable_chks
      assign mubi = mubi_sync;
    end
  end else begin : gen_no_flops
    mubi12_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi12False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
    assign mubi = MuBi12Width'(mubi_i);
  end
  for (genvar j = 0; j < NumCopies; j++) begin : gen_buffs
    logic [MuBi12Width-1:0] mubi_out;
    for (genvar k = 0; k < MuBi12Width; k++) begin : gen_bits
      prim_buf u_prim_buf (
        .in_i(mubi[k]),
        .out_o(mubi_out[k])
      );
    end
    assign mubi_o[j] = mubi12_t'(mubi_out);
  end
endmodule : prim_mubi12_sync
module prim_mubi12_dec
  import prim_mubi_pkg::*;
#(
  parameter bit TestTrue = 1,
  parameter bit TestStrict = 1
) (
  input  mubi12_t mubi_i,
  output logic           mubi_dec_o
);
logic [MuBi12Width-1:0] mubi, mubi_out;
assign mubi = MuBi12Width'(mubi_i);
for (genvar k = 0; k < MuBi12Width; k++) begin : gen_bits
  prim_buf u_prim_buf (
    .in_i  ( mubi[k]     ),
    .out_o ( mubi_out[k] )
  );
end
if (TestTrue && TestStrict) begin : gen_test_true_strict
  assign mubi_dec_o = mubi12_test_true_strict(mubi12_t'(mubi_out));
end else if (TestTrue && !TestStrict) begin : gen_test_true_loose
  assign mubi_dec_o = mubi12_test_true_loose(mubi12_t'(mubi_out));
end else if (!TestTrue && TestStrict) begin : gen_test_false_strict
  assign mubi_dec_o = mubi12_test_false_strict(mubi12_t'(mubi_out));
end else if (!TestTrue && !TestStrict) begin : gen_test_false_loose
  assign mubi_dec_o = mubi12_test_false_loose(mubi12_t'(mubi_out));
end else begin : gen_unknown_config
end
endmodule : prim_mubi12_dec
module prim_mubi16_sender
  import prim_mubi_pkg::*;
#(
  parameter bit AsyncOn = 1,
  parameter bit EnSecBuf = 0,
  parameter mubi16_t ResetValue = MuBi16False
) (
  input          clk_i,
  input          rst_ni,
  input  mubi16_t mubi_i,
  output mubi16_t mubi_o
);
  logic [MuBi16Width-1:0] mubi, mubi_int, mubi_out;
  assign mubi = MuBi16Width'(mubi_i);
  if (AsyncOn) begin : gen_flops
    prim_flop #(
      .Width(MuBi16Width),
      .ResetValue(MuBi16Width'(ResetValue))
    ) u_prim_flop (
      .clk_i,
      .rst_ni,
      .d_i   ( mubi     ),
      .q_o   ( mubi_int )
    );
  end else begin : gen_no_flops
    assign mubi_int = mubi;
    mubi16_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi16False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
  end
  if (EnSecBuf) begin : gen_sec_buf
    prim_sec_anchor_buf #(
      .Width(16)
    ) u_prim_sec_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else if (!AsyncOn) begin : gen_prim_buf
    prim_buf #(
      .Width(16)
    ) u_prim_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else begin : gen_feedthru
    assign mubi_out = mubi_int;
  end
  assign mubi_o = mubi16_t'(mubi_out);
endmodule : prim_mubi16_sender
module prim_mubi16_sync
  import prim_mubi_pkg::*;
#(
  parameter int NumCopies = 1,
  parameter bit AsyncOn = 1,
  parameter bit StabilityCheck = 0,
  parameter mubi16_t ResetValue = MuBi16False
) (
  input                          clk_i,
  input                          rst_ni,
  input  mubi16_t                 mubi_i,
  output mubi16_t [NumCopies-1:0] mubi_o
);
  logic [MuBi16Width-1:0] mubi;
  if (AsyncOn) begin : gen_flops
    logic [MuBi16Width-1:0] mubi_sync;
    prim_flop_2sync #(
      .Width(MuBi16Width),
      .ResetValue(MuBi16Width'(ResetValue))
    ) u_prim_flop_2sync (
      .clk_i,
      .rst_ni,
      .d_i(MuBi16Width'(mubi_i)),
      .q_o(mubi_sync)
    );
    if (StabilityCheck) begin : gen_stable_chks
      logic [MuBi16Width-1:0] mubi_q;
      prim_flop #(
        .Width(MuBi16Width),
        .ResetValue(MuBi16Width'(ResetValue))
      ) u_prim_flop_3rd_stage (
        .clk_i,
        .rst_ni,
        .d_i(mubi_sync),
        .q_o(mubi_q)
      );
      logic [MuBi16Width-1:0] sig_unstable;
      prim_xor2 #(
        .Width(MuBi16Width)
      ) u_mubi_xor (
        .in0_i(mubi_sync),
        .in1_i(mubi_q),
        .out_o(sig_unstable)
      );
      logic [MuBi16Width-1:0] reset_value;
      assign reset_value = ResetValue;
      for (genvar k = 0; k < MuBi16Width; k++) begin : gen_bufs_muxes
        logic [MuBi16Width-1:0] sig_unstable_buf;
        prim_sec_anchor_buf #(
          .Width(MuBi16Width)
        ) u_sig_unstable_buf (
          .in_i(sig_unstable),
          .out_o(sig_unstable_buf)
        );
        assign mubi[k] = (|sig_unstable_buf) ? reset_value[k] : mubi_q[k];
      end
    end else begin : gen_no_stable_chks
      assign mubi = mubi_sync;
    end
  end else begin : gen_no_flops
    mubi16_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi16False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
    assign mubi = MuBi16Width'(mubi_i);
  end
  for (genvar j = 0; j < NumCopies; j++) begin : gen_buffs
    logic [MuBi16Width-1:0] mubi_out;
    for (genvar k = 0; k < MuBi16Width; k++) begin : gen_bits
      prim_buf u_prim_buf (
        .in_i(mubi[k]),
        .out_o(mubi_out[k])
      );
    end
    assign mubi_o[j] = mubi16_t'(mubi_out);
  end
endmodule : prim_mubi16_sync
module prim_mubi16_dec
  import prim_mubi_pkg::*;
#(
  parameter bit TestTrue = 1,
  parameter bit TestStrict = 1
) (
  input  mubi16_t mubi_i,
  output logic           mubi_dec_o
);
logic [MuBi16Width-1:0] mubi, mubi_out;
assign mubi = MuBi16Width'(mubi_i);
for (genvar k = 0; k < MuBi16Width; k++) begin : gen_bits
  prim_buf u_prim_buf (
    .in_i  ( mubi[k]     ),
    .out_o ( mubi_out[k] )
  );
end
if (TestTrue && TestStrict) begin : gen_test_true_strict
  assign mubi_dec_o = mubi16_test_true_strict(mubi16_t'(mubi_out));
end else if (TestTrue && !TestStrict) begin : gen_test_true_loose
  assign mubi_dec_o = mubi16_test_true_loose(mubi16_t'(mubi_out));
end else if (!TestTrue && TestStrict) begin : gen_test_false_strict
  assign mubi_dec_o = mubi16_test_false_strict(mubi16_t'(mubi_out));
end else if (!TestTrue && !TestStrict) begin : gen_test_false_loose
  assign mubi_dec_o = mubi16_test_false_loose(mubi16_t'(mubi_out));
end else begin : gen_unknown_config
end
endmodule : prim_mubi16_dec
module prim_mubi20_sender
  import prim_mubi_pkg::*;
#(
  parameter bit AsyncOn = 1,
  parameter bit EnSecBuf = 0,
  parameter mubi20_t ResetValue = MuBi20False
) (
  input          clk_i,
  input          rst_ni,
  input  mubi20_t mubi_i,
  output mubi20_t mubi_o
);
  logic [MuBi20Width-1:0] mubi, mubi_int, mubi_out;
  assign mubi = MuBi20Width'(mubi_i);
  if (AsyncOn) begin : gen_flops
    prim_flop #(
      .Width(MuBi20Width),
      .ResetValue(MuBi20Width'(ResetValue))
    ) u_prim_flop (
      .clk_i,
      .rst_ni,
      .d_i   ( mubi     ),
      .q_o   ( mubi_int )
    );
  end else begin : gen_no_flops
    assign mubi_int = mubi;
    mubi20_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi20False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
  end
  if (EnSecBuf) begin : gen_sec_buf
    prim_sec_anchor_buf #(
      .Width(20)
    ) u_prim_sec_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else if (!AsyncOn) begin : gen_prim_buf
    prim_buf #(
      .Width(20)
    ) u_prim_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else begin : gen_feedthru
    assign mubi_out = mubi_int;
  end
  assign mubi_o = mubi20_t'(mubi_out);
endmodule : prim_mubi20_sender
module prim_mubi20_sync
  import prim_mubi_pkg::*;
#(
  parameter int NumCopies = 1,
  parameter bit AsyncOn = 1,
  parameter bit StabilityCheck = 0,
  parameter mubi20_t ResetValue = MuBi20False
) (
  input                          clk_i,
  input                          rst_ni,
  input  mubi20_t                 mubi_i,
  output mubi20_t [NumCopies-1:0] mubi_o
);
  logic [MuBi20Width-1:0] mubi;
  if (AsyncOn) begin : gen_flops
    logic [MuBi20Width-1:0] mubi_sync;
    prim_flop_2sync #(
      .Width(MuBi20Width),
      .ResetValue(MuBi20Width'(ResetValue))
    ) u_prim_flop_2sync (
      .clk_i,
      .rst_ni,
      .d_i(MuBi20Width'(mubi_i)),
      .q_o(mubi_sync)
    );
    if (StabilityCheck) begin : gen_stable_chks
      logic [MuBi20Width-1:0] mubi_q;
      prim_flop #(
        .Width(MuBi20Width),
        .ResetValue(MuBi20Width'(ResetValue))
      ) u_prim_flop_3rd_stage (
        .clk_i,
        .rst_ni,
        .d_i(mubi_sync),
        .q_o(mubi_q)
      );
      logic [MuBi20Width-1:0] sig_unstable;
      prim_xor2 #(
        .Width(MuBi20Width)
      ) u_mubi_xor (
        .in0_i(mubi_sync),
        .in1_i(mubi_q),
        .out_o(sig_unstable)
      );
      logic [MuBi20Width-1:0] reset_value;
      assign reset_value = ResetValue;
      for (genvar k = 0; k < MuBi20Width; k++) begin : gen_bufs_muxes
        logic [MuBi20Width-1:0] sig_unstable_buf;
        prim_sec_anchor_buf #(
          .Width(MuBi20Width)
        ) u_sig_unstable_buf (
          .in_i(sig_unstable),
          .out_o(sig_unstable_buf)
        );
        assign mubi[k] = (|sig_unstable_buf) ? reset_value[k] : mubi_q[k];
      end
    end else begin : gen_no_stable_chks
      assign mubi = mubi_sync;
    end
  end else begin : gen_no_flops
    mubi20_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi20False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
    assign mubi = MuBi20Width'(mubi_i);
  end
  for (genvar j = 0; j < NumCopies; j++) begin : gen_buffs
    logic [MuBi20Width-1:0] mubi_out;
    for (genvar k = 0; k < MuBi20Width; k++) begin : gen_bits
      prim_buf u_prim_buf (
        .in_i(mubi[k]),
        .out_o(mubi_out[k])
      );
    end
    assign mubi_o[j] = mubi20_t'(mubi_out);
  end
endmodule : prim_mubi20_sync
module prim_mubi20_dec
  import prim_mubi_pkg::*;
#(
  parameter bit TestTrue = 1,
  parameter bit TestStrict = 1
) (
  input  mubi20_t mubi_i,
  output logic           mubi_dec_o
);
logic [MuBi20Width-1:0] mubi, mubi_out;
assign mubi = MuBi20Width'(mubi_i);
for (genvar k = 0; k < MuBi20Width; k++) begin : gen_bits
  prim_buf u_prim_buf (
    .in_i  ( mubi[k]     ),
    .out_o ( mubi_out[k] )
  );
end
if (TestTrue && TestStrict) begin : gen_test_true_strict
  assign mubi_dec_o = mubi20_test_true_strict(mubi20_t'(mubi_out));
end else if (TestTrue && !TestStrict) begin : gen_test_true_loose
  assign mubi_dec_o = mubi20_test_true_loose(mubi20_t'(mubi_out));
end else if (!TestTrue && TestStrict) begin : gen_test_false_strict
  assign mubi_dec_o = mubi20_test_false_strict(mubi20_t'(mubi_out));
end else if (!TestTrue && !TestStrict) begin : gen_test_false_loose
  assign mubi_dec_o = mubi20_test_false_loose(mubi20_t'(mubi_out));
end else begin : gen_unknown_config
end
endmodule : prim_mubi20_dec
module prim_mubi24_sender
  import prim_mubi_pkg::*;
#(
  parameter bit AsyncOn = 1,
  parameter bit EnSecBuf = 0,
  parameter mubi24_t ResetValue = MuBi24False
) (
  input          clk_i,
  input          rst_ni,
  input  mubi24_t mubi_i,
  output mubi24_t mubi_o
);
  logic [MuBi24Width-1:0] mubi, mubi_int, mubi_out;
  assign mubi = MuBi24Width'(mubi_i);
  if (AsyncOn) begin : gen_flops
    prim_flop #(
      .Width(MuBi24Width),
      .ResetValue(MuBi24Width'(ResetValue))
    ) u_prim_flop (
      .clk_i,
      .rst_ni,
      .d_i   ( mubi     ),
      .q_o   ( mubi_int )
    );
  end else begin : gen_no_flops
    assign mubi_int = mubi;
    mubi24_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi24False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
  end
  if (EnSecBuf) begin : gen_sec_buf
    prim_sec_anchor_buf #(
      .Width(24)
    ) u_prim_sec_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else if (!AsyncOn) begin : gen_prim_buf
    prim_buf #(
      .Width(24)
    ) u_prim_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else begin : gen_feedthru
    assign mubi_out = mubi_int;
  end
  assign mubi_o = mubi24_t'(mubi_out);
endmodule : prim_mubi24_sender
module prim_mubi24_sync
  import prim_mubi_pkg::*;
#(
  parameter int NumCopies = 1,
  parameter bit AsyncOn = 1,
  parameter bit StabilityCheck = 0,
  parameter mubi24_t ResetValue = MuBi24False
) (
  input                          clk_i,
  input                          rst_ni,
  input  mubi24_t                 mubi_i,
  output mubi24_t [NumCopies-1:0] mubi_o
);
  logic [MuBi24Width-1:0] mubi;
  if (AsyncOn) begin : gen_flops
    logic [MuBi24Width-1:0] mubi_sync;
    prim_flop_2sync #(
      .Width(MuBi24Width),
      .ResetValue(MuBi24Width'(ResetValue))
    ) u_prim_flop_2sync (
      .clk_i,
      .rst_ni,
      .d_i(MuBi24Width'(mubi_i)),
      .q_o(mubi_sync)
    );
    if (StabilityCheck) begin : gen_stable_chks
      logic [MuBi24Width-1:0] mubi_q;
      prim_flop #(
        .Width(MuBi24Width),
        .ResetValue(MuBi24Width'(ResetValue))
      ) u_prim_flop_3rd_stage (
        .clk_i,
        .rst_ni,
        .d_i(mubi_sync),
        .q_o(mubi_q)
      );
      logic [MuBi24Width-1:0] sig_unstable;
      prim_xor2 #(
        .Width(MuBi24Width)
      ) u_mubi_xor (
        .in0_i(mubi_sync),
        .in1_i(mubi_q),
        .out_o(sig_unstable)
      );
      logic [MuBi24Width-1:0] reset_value;
      assign reset_value = ResetValue;
      for (genvar k = 0; k < MuBi24Width; k++) begin : gen_bufs_muxes
        logic [MuBi24Width-1:0] sig_unstable_buf;
        prim_sec_anchor_buf #(
          .Width(MuBi24Width)
        ) u_sig_unstable_buf (
          .in_i(sig_unstable),
          .out_o(sig_unstable_buf)
        );
        assign mubi[k] = (|sig_unstable_buf) ? reset_value[k] : mubi_q[k];
      end
    end else begin : gen_no_stable_chks
      assign mubi = mubi_sync;
    end
  end else begin : gen_no_flops
    mubi24_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi24False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
    assign mubi = MuBi24Width'(mubi_i);
  end
  for (genvar j = 0; j < NumCopies; j++) begin : gen_buffs
    logic [MuBi24Width-1:0] mubi_out;
    for (genvar k = 0; k < MuBi24Width; k++) begin : gen_bits
      prim_buf u_prim_buf (
        .in_i(mubi[k]),
        .out_o(mubi_out[k])
      );
    end
    assign mubi_o[j] = mubi24_t'(mubi_out);
  end
endmodule : prim_mubi24_sync
module prim_mubi24_dec
  import prim_mubi_pkg::*;
#(
  parameter bit TestTrue = 1,
  parameter bit TestStrict = 1
) (
  input  mubi24_t mubi_i,
  output logic           mubi_dec_o
);
logic [MuBi24Width-1:0] mubi, mubi_out;
assign mubi = MuBi24Width'(mubi_i);
for (genvar k = 0; k < MuBi24Width; k++) begin : gen_bits
  prim_buf u_prim_buf (
    .in_i  ( mubi[k]     ),
    .out_o ( mubi_out[k] )
  );
end
if (TestTrue && TestStrict) begin : gen_test_true_strict
  assign mubi_dec_o = mubi24_test_true_strict(mubi24_t'(mubi_out));
end else if (TestTrue && !TestStrict) begin : gen_test_true_loose
  assign mubi_dec_o = mubi24_test_true_loose(mubi24_t'(mubi_out));
end else if (!TestTrue && TestStrict) begin : gen_test_false_strict
  assign mubi_dec_o = mubi24_test_false_strict(mubi24_t'(mubi_out));
end else if (!TestTrue && !TestStrict) begin : gen_test_false_loose
  assign mubi_dec_o = mubi24_test_false_loose(mubi24_t'(mubi_out));
end else begin : gen_unknown_config
end
endmodule : prim_mubi24_dec
module prim_mubi28_sender
  import prim_mubi_pkg::*;
#(
  parameter bit AsyncOn = 1,
  parameter bit EnSecBuf = 0,
  parameter mubi28_t ResetValue = MuBi28False
) (
  input          clk_i,
  input          rst_ni,
  input  mubi28_t mubi_i,
  output mubi28_t mubi_o
);
  logic [MuBi28Width-1:0] mubi, mubi_int, mubi_out;
  assign mubi = MuBi28Width'(mubi_i);
  if (AsyncOn) begin : gen_flops
    prim_flop #(
      .Width(MuBi28Width),
      .ResetValue(MuBi28Width'(ResetValue))
    ) u_prim_flop (
      .clk_i,
      .rst_ni,
      .d_i   ( mubi     ),
      .q_o   ( mubi_int )
    );
  end else begin : gen_no_flops
    assign mubi_int = mubi;
    mubi28_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi28False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
  end
  if (EnSecBuf) begin : gen_sec_buf
    prim_sec_anchor_buf #(
      .Width(28)
    ) u_prim_sec_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else if (!AsyncOn) begin : gen_prim_buf
    prim_buf #(
      .Width(28)
    ) u_prim_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else begin : gen_feedthru
    assign mubi_out = mubi_int;
  end
  assign mubi_o = mubi28_t'(mubi_out);
endmodule : prim_mubi28_sender
module prim_mubi28_sync
  import prim_mubi_pkg::*;
#(
  parameter int NumCopies = 1,
  parameter bit AsyncOn = 1,
  parameter bit StabilityCheck = 0,
  parameter mubi28_t ResetValue = MuBi28False
) (
  input                          clk_i,
  input                          rst_ni,
  input  mubi28_t                 mubi_i,
  output mubi28_t [NumCopies-1:0] mubi_o
);
  logic [MuBi28Width-1:0] mubi;
  if (AsyncOn) begin : gen_flops
    logic [MuBi28Width-1:0] mubi_sync;
    prim_flop_2sync #(
      .Width(MuBi28Width),
      .ResetValue(MuBi28Width'(ResetValue))
    ) u_prim_flop_2sync (
      .clk_i,
      .rst_ni,
      .d_i(MuBi28Width'(mubi_i)),
      .q_o(mubi_sync)
    );
    if (StabilityCheck) begin : gen_stable_chks
      logic [MuBi28Width-1:0] mubi_q;
      prim_flop #(
        .Width(MuBi28Width),
        .ResetValue(MuBi28Width'(ResetValue))
      ) u_prim_flop_3rd_stage (
        .clk_i,
        .rst_ni,
        .d_i(mubi_sync),
        .q_o(mubi_q)
      );
      logic [MuBi28Width-1:0] sig_unstable;
      prim_xor2 #(
        .Width(MuBi28Width)
      ) u_mubi_xor (
        .in0_i(mubi_sync),
        .in1_i(mubi_q),
        .out_o(sig_unstable)
      );
      logic [MuBi28Width-1:0] reset_value;
      assign reset_value = ResetValue;
      for (genvar k = 0; k < MuBi28Width; k++) begin : gen_bufs_muxes
        logic [MuBi28Width-1:0] sig_unstable_buf;
        prim_sec_anchor_buf #(
          .Width(MuBi28Width)
        ) u_sig_unstable_buf (
          .in_i(sig_unstable),
          .out_o(sig_unstable_buf)
        );
        assign mubi[k] = (|sig_unstable_buf) ? reset_value[k] : mubi_q[k];
      end
    end else begin : gen_no_stable_chks
      assign mubi = mubi_sync;
    end
  end else begin : gen_no_flops
    mubi28_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi28False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
    assign mubi = MuBi28Width'(mubi_i);
  end
  for (genvar j = 0; j < NumCopies; j++) begin : gen_buffs
    logic [MuBi28Width-1:0] mubi_out;
    for (genvar k = 0; k < MuBi28Width; k++) begin : gen_bits
      prim_buf u_prim_buf (
        .in_i(mubi[k]),
        .out_o(mubi_out[k])
      );
    end
    assign mubi_o[j] = mubi28_t'(mubi_out);
  end
endmodule : prim_mubi28_sync
module prim_mubi28_dec
  import prim_mubi_pkg::*;
#(
  parameter bit TestTrue = 1,
  parameter bit TestStrict = 1
) (
  input  mubi28_t mubi_i,
  output logic           mubi_dec_o
);
logic [MuBi28Width-1:0] mubi, mubi_out;
assign mubi = MuBi28Width'(mubi_i);
for (genvar k = 0; k < MuBi28Width; k++) begin : gen_bits
  prim_buf u_prim_buf (
    .in_i  ( mubi[k]     ),
    .out_o ( mubi_out[k] )
  );
end
if (TestTrue && TestStrict) begin : gen_test_true_strict
  assign mubi_dec_o = mubi28_test_true_strict(mubi28_t'(mubi_out));
end else if (TestTrue && !TestStrict) begin : gen_test_true_loose
  assign mubi_dec_o = mubi28_test_true_loose(mubi28_t'(mubi_out));
end else if (!TestTrue && TestStrict) begin : gen_test_false_strict
  assign mubi_dec_o = mubi28_test_false_strict(mubi28_t'(mubi_out));
end else if (!TestTrue && !TestStrict) begin : gen_test_false_loose
  assign mubi_dec_o = mubi28_test_false_loose(mubi28_t'(mubi_out));
end else begin : gen_unknown_config
end
endmodule : prim_mubi28_dec
module prim_mubi32_sender
  import prim_mubi_pkg::*;
#(
  parameter bit AsyncOn = 1,
  parameter bit EnSecBuf = 0,
  parameter mubi32_t ResetValue = MuBi32False
) (
  input          clk_i,
  input          rst_ni,
  input  mubi32_t mubi_i,
  output mubi32_t mubi_o
);
  logic [MuBi32Width-1:0] mubi, mubi_int, mubi_out;
  assign mubi = MuBi32Width'(mubi_i);
  if (AsyncOn) begin : gen_flops
    prim_flop #(
      .Width(MuBi32Width),
      .ResetValue(MuBi32Width'(ResetValue))
    ) u_prim_flop (
      .clk_i,
      .rst_ni,
      .d_i   ( mubi     ),
      .q_o   ( mubi_int )
    );
  end else begin : gen_no_flops
    assign mubi_int = mubi;
    mubi32_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi32False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
  end
  if (EnSecBuf) begin : gen_sec_buf
    prim_sec_anchor_buf #(
      .Width(32)
    ) u_prim_sec_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else if (!AsyncOn) begin : gen_prim_buf
    prim_buf #(
      .Width(32)
    ) u_prim_buf (
      .in_i(mubi_int),
      .out_o(mubi_out)
    );
  end else begin : gen_feedthru
    assign mubi_out = mubi_int;
  end
  assign mubi_o = mubi32_t'(mubi_out);
endmodule : prim_mubi32_sender
module prim_mubi32_sync
  import prim_mubi_pkg::*;
#(
  parameter int NumCopies = 1,
  parameter bit AsyncOn = 1,
  parameter bit StabilityCheck = 0,
  parameter mubi32_t ResetValue = MuBi32False
) (
  input                          clk_i,
  input                          rst_ni,
  input  mubi32_t                 mubi_i,
  output mubi32_t [NumCopies-1:0] mubi_o
);
  logic [MuBi32Width-1:0] mubi;
  if (AsyncOn) begin : gen_flops
    logic [MuBi32Width-1:0] mubi_sync;
    prim_flop_2sync #(
      .Width(MuBi32Width),
      .ResetValue(MuBi32Width'(ResetValue))
    ) u_prim_flop_2sync (
      .clk_i,
      .rst_ni,
      .d_i(MuBi32Width'(mubi_i)),
      .q_o(mubi_sync)
    );
    if (StabilityCheck) begin : gen_stable_chks
      logic [MuBi32Width-1:0] mubi_q;
      prim_flop #(
        .Width(MuBi32Width),
        .ResetValue(MuBi32Width'(ResetValue))
      ) u_prim_flop_3rd_stage (
        .clk_i,
        .rst_ni,
        .d_i(mubi_sync),
        .q_o(mubi_q)
      );
      logic [MuBi32Width-1:0] sig_unstable;
      prim_xor2 #(
        .Width(MuBi32Width)
      ) u_mubi_xor (
        .in0_i(mubi_sync),
        .in1_i(mubi_q),
        .out_o(sig_unstable)
      );
      logic [MuBi32Width-1:0] reset_value;
      assign reset_value = ResetValue;
      for (genvar k = 0; k < MuBi32Width; k++) begin : gen_bufs_muxes
        logic [MuBi32Width-1:0] sig_unstable_buf;
        prim_sec_anchor_buf #(
          .Width(MuBi32Width)
        ) u_sig_unstable_buf (
          .in_i(sig_unstable),
          .out_o(sig_unstable_buf)
        );
        assign mubi[k] = (|sig_unstable_buf) ? reset_value[k] : mubi_q[k];
      end
    end else begin : gen_no_stable_chks
      assign mubi = mubi_sync;
    end
  end else begin : gen_no_flops
    mubi32_t unused_logic;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
         unused_logic <= MuBi32False;
      end else begin
         unused_logic <= mubi_i;
      end
    end
    assign mubi = MuBi32Width'(mubi_i);
  end
  for (genvar j = 0; j < NumCopies; j++) begin : gen_buffs
    logic [MuBi32Width-1:0] mubi_out;
    for (genvar k = 0; k < MuBi32Width; k++) begin : gen_bits
      prim_buf u_prim_buf (
        .in_i(mubi[k]),
        .out_o(mubi_out[k])
      );
    end
    assign mubi_o[j] = mubi32_t'(mubi_out);
  end
endmodule : prim_mubi32_sync
module prim_mubi32_dec
  import prim_mubi_pkg::*;
#(
  parameter bit TestTrue = 1,
  parameter bit TestStrict = 1
) (
  input  mubi32_t mubi_i,
  output logic           mubi_dec_o
);
logic [MuBi32Width-1:0] mubi, mubi_out;
assign mubi = MuBi32Width'(mubi_i);
for (genvar k = 0; k < MuBi32Width; k++) begin : gen_bits
  prim_buf u_prim_buf (
    .in_i  ( mubi[k]     ),
    .out_o ( mubi_out[k] )
  );
end
if (TestTrue && TestStrict) begin : gen_test_true_strict
  assign mubi_dec_o = mubi32_test_true_strict(mubi32_t'(mubi_out));
end else if (TestTrue && !TestStrict) begin : gen_test_true_loose
  assign mubi_dec_o = mubi32_test_true_loose(mubi32_t'(mubi_out));
end else if (!TestTrue && TestStrict) begin : gen_test_false_strict
  assign mubi_dec_o = mubi32_test_false_strict(mubi32_t'(mubi_out));
end else if (!TestTrue && !TestStrict) begin : gen_test_false_loose
  assign mubi_dec_o = mubi32_test_false_loose(mubi32_t'(mubi_out));
end else begin : gen_unknown_config
end
endmodule : prim_mubi32_dec
module prim_onehot_enc #(
  parameter int unsigned OneHotWidth = 32,
  localparam int unsigned InputWidth = $clog2(OneHotWidth)
) (
  input  logic [InputWidth-1:0]  in_i,
  input  logic                   en_i,  
  output logic [OneHotWidth-1:0] out_o
);
  for (genvar i = 0; i < OneHotWidth; ++i) begin : g_out
    assign out_o[i] = (in_i == i) & en_i;
  end
endmodule
module prim_onehot_mux #(
  parameter int Width  = 32,
  parameter int Inputs = 8
) (
  input clk_i,
  input rst_ni,
  input  logic [Width-1:0]  in_i [Inputs],
  input  logic [Inputs-1:0] sel_i,  
  output logic [Width-1:0]  out_o
);
  logic [Inputs-1:0] in_mux [Width];
  for (genvar b = 0; b < Width; ++b) begin : g_in_mux_outer
    logic [Inputs-1:0] out_mux_bits;
    for (genvar i = 0; i < Inputs; ++i) begin : g_in_mux_inner
      assign in_mux[b][i] = in_i[i][b];
    end
    prim_and2 #(.Width(Inputs)) u_mux_bit_and(
      .in0_i(in_mux[b]),
      .in1_i(sel_i),
      .out_o(out_mux_bits)
    );
    assign out_o[b] = |out_mux_bits;
  end
  logic unused_clk;
  logic unused_rst_n;
  assign unused_clk   = clk_i;
  assign unused_rst_n = rst_ni;
endmodule
module prim_onehot_check #(
  parameter int unsigned AddrWidth   = 5,
  parameter int unsigned OneHotWidth = 2**AddrWidth,
  parameter bit          AddrCheck   = 1,
  parameter bit          EnableCheck = 1,
  parameter bit          StrictCheck = 1,
  parameter bit EnableAlertTriggerSVA = 1
) (
  input                          clk_i,
  input                          rst_ni,
  input  logic [OneHotWidth-1:0] oh_i,
  input  logic [AddrWidth-1:0]   addr_i,
  input  logic                   en_i,
  output logic                   err_o
);
  localparam int NumLevels = AddrWidth;
  logic [2**(NumLevels+1)-2:0] or_tree;
  logic [2**(NumLevels+1)-2:0] and_tree;  
  logic [2**(NumLevels+1)-2:0] err_tree;  
  for (genvar level = 0; level < NumLevels+1; level++) begin : gen_tree
    localparam int Base0 = (2**level)-1;
    localparam int Base1 = (2**(level+1))-1;
    for (genvar offset = 0; offset < 2**level; offset++) begin : gen_level
      localparam int Pa = Base0 + offset;
      localparam int C0 = Base1 + 2*offset;
      localparam int C1 = Base1 + 2*offset + 1;
      if (level == NumLevels) begin : gen_leafs
        if (offset < OneHotWidth) begin : gen_assign
          assign or_tree[Pa]  = oh_i[offset];
          assign and_tree[Pa] = oh_i[offset];
        end else begin : gen_tie_off
          assign or_tree[Pa]  = 1'b0;
          assign and_tree[Pa] = 1'b0;
        end
        assign err_tree[Pa] = 1'b0;
      end else begin : gen_nodes
        assign or_tree[Pa]  = or_tree[C0] || or_tree[C1];
        assign and_tree[Pa] = (!addr_i[AddrWidth-1-level] && and_tree[C0]) ||
                              (addr_i[AddrWidth-1-level] && and_tree[C1]);
        assign err_tree[Pa] = (or_tree[C0] && or_tree[C1]) || err_tree[C0] || err_tree[C1];
      end
    end : gen_level
  end : gen_tree
  logic enable_err, addr_err, oh0_err;
  assign err_o = oh0_err || enable_err || addr_err;
  assign oh0_err = err_tree[0];
  if (EnableCheck) begin : gen_enable_check
    if (StrictCheck) begin : gen_strict
      assign enable_err = or_tree[0] ^ en_i;
    end else begin : gen_not_strict
      assign enable_err = !en_i && or_tree[0];
    end
  end else begin : gen_no_enable_check
    logic unused_or_tree;
    assign unused_or_tree = ^or_tree;
    assign enable_err = 1'b0;
  end
  if (AddrCheck) begin : gen_addr_check_strict
    assign addr_err = or_tree[0] ^ and_tree[0];
  end else begin : gen_no_addr_check_strict
    logic unused_and_tree;
    assign unused_and_tree = ^and_tree;
    assign addr_err = 1'b0;
  end
endmodule : prim_onehot_check
module prim_ram_1p_adv import prim_ram_1p_pkg::*; #(
  parameter  int Depth                = 512,
  parameter  int InstDepth            = Depth,
  parameter  int Width                = 32,
  parameter  int DataBitsPerMask      = 1,   
  parameter      MemInitFile          = "",  
  parameter  bit EnableECC            = 0,  
  parameter  bit EnableParity         = 0,  
  parameter  bit EnableInputPipeline  = 0,  
  parameter  bit EnableOutputPipeline = 0,  
  parameter bit HammingECC            = 0,
  localparam int Aw                   = prim_util_pkg::vbits(Depth),
  localparam int NumRamInst           = prim_util_pkg::ceil_div(Depth, InstDepth),
  localparam int InstAw               = prim_util_pkg::vbits(InstDepth)
) (
  input clk_i,
  input rst_ni,
  input                               req_i,
  input                               write_i,
  input        [Aw-1:0]               addr_i,
  input        [Width-1:0]            wdata_i,
  input        [Width-1:0]            wmask_i,
  output logic [Width-1:0]            rdata_o,
  output logic                        rvalid_o,  
  output logic [1:0]                  rerror_o,  
  input  ram_1p_cfg_req_t [NumRamInst-1:0] cfg_i,
  output ram_1p_cfg_rsp_t [NumRamInst-1:0] cfg_o,
  output logic                             alert_o
);
  import prim_mubi_pkg::mubi4_t;
  import prim_mubi_pkg::mubi4_and_hi;
  import prim_mubi_pkg::mubi4_bool_to_mubi;
  import prim_mubi_pkg::mubi4_test_invalid;
  import prim_mubi_pkg::mubi4_test_true_loose;
  import prim_mubi_pkg::mubi4_test_true_strict;
  import prim_mubi_pkg::MuBi4True;
  import prim_mubi_pkg::MuBi4False;
  import prim_mubi_pkg::MuBi4Width;
  localparam int ParWidth  = (EnableParity) ? Width/8 :
                             (!EnableECC)   ? 0 :
                             (Width <=   4) ? 4 :
                             (Width <=  11) ? 5 :
                             (Width <=  26) ? 6 :
                             (Width <=  57) ? 7 :
                             (Width <= 120) ? 8 : 8 ;
  localparam int TotalWidth = Width + ParWidth;
  localparam int LocalDataBitsPerMask = (EnableParity) ? 9          :
                                        (EnableECC)    ? TotalWidth :
                                                         DataBitsPerMask;
  mubi4_t                  req_q,     req_d,    req_buf_d ;
  logic [MuBi4Width-1:0]   req_buf_b_d;
  logic                    req_q_b ;
  mubi4_t                  write_q,   write_d,  write_buf_d ;
  logic [MuBi4Width-1:0]   write_buf_b_d;
  logic                    write_q_b ;
  logic [Aw-1:0]           addr_q,    addr_d ;
  logic [TotalWidth-1:0]   wdata_q,   wdata_d ;
  logic [TotalWidth-1:0]   wmask_q,   wmask_d ;
  mubi4_t                  rvalid_q,  rvalid_d, rvalid_sram_q, rvalid_sram_d ;
  logic [Width-1:0]        rdata_q,   rdata_d ;
  logic [TotalWidth-1:0]   rdata_sram ;
  logic [1:0]              rerror_q,  rerror_d ;
  assign req_q_b = mubi4_test_true_loose(req_q);
  assign write_q_b = mubi4_test_true_loose(write_q);
  logic [NumRamInst-1:0] inst_req_d, inst_req_q, rvalid_inst;
  logic [InstAw-1:0] inst_addr;
  logic [NumRamInst-1:0] [Width-1:0] inst_rdata;
  assign inst_addr = addr_q[InstAw-1:0];
  if (NumRamInst == 1) begin : gen_single_inst_req
    assign inst_req_d[0] = req_q_b;
  end else begin : gen_multi_inst_req
    always_comb begin
      inst_req_d = '0;
      for (int i = 0; i < NumRamInst; i++) begin
        if (req_q_b && (i == addr_q[Aw-1:InstAw])) begin
          inst_req_d[i] = 1'b1;
        end
      end
    end
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      inst_req_q <= '0;
    end else begin
      inst_req_q <= inst_req_d;
    end
  end
  for (genvar i = 0; i < NumRamInst; i++) begin : gen_ram_inst
    prim_ram_1p #(
      .MemInitFile     (MemInitFile),
      .Width           (TotalWidth),
      .Depth           (InstDepth),
      .DataBitsPerMask (LocalDataBitsPerMask)
    ) u_mem (
      .clk_i,
      .rst_ni,
      .req_i     (inst_req_d[i]),
      .write_i   (write_q_b),
      .addr_i    (inst_addr),
      .wdata_i   (wdata_q),
      .wmask_i   (wmask_q),
      .rdata_o   (inst_rdata[i]),
      .cfg_i     (cfg_i[i]),
      .cfg_o     (cfg_o[i])
    );
  end
  always_comb begin
    rdata_sram = '0;
    for (int i = 0; i < NumRamInst; i++) begin
      rvalid_inst[i] = mubi4_test_true_strict(
        mubi4_and_hi(mubi4_bool_to_mubi(inst_req_q[i]), rvalid_sram_q));
      if(rvalid_inst[i]) begin
        rdata_sram = inst_rdata[i];
      end
    end
  end
  assign rvalid_sram_d = mubi4_and_hi(req_q, mubi4_t'(~write_q));
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rvalid_sram_q <= MuBi4False;
    end else begin
      rvalid_sram_q <= rvalid_sram_d;
    end
  end
  assign req_d              = mubi4_bool_to_mubi(req_i);
  assign write_d            = mubi4_bool_to_mubi(write_i);
  assign addr_d             = addr_i;
  assign rvalid_o           = mubi4_test_true_loose(rvalid_q);
  assign rdata_o            = rdata_q;
  assign rerror_o           = rerror_q;
  prim_buf #(
    .Width(MuBi4Width)
  ) u_req_d_buf (
    .in_i (req_d),
    .out_o(req_buf_b_d)
  );
  assign req_buf_d = mubi4_t'(req_buf_b_d);
  prim_buf #(
    .Width(MuBi4Width)
  ) u_write_d_buf (
    .in_i (write_d),
    .out_o(write_buf_b_d)
  );
  assign write_buf_d = mubi4_t'(write_buf_b_d);
  if (EnableParity == 0 && EnableECC) begin : gen_secded
    logic unused_wmask;
    assign unused_wmask = ^wmask_i;
    assign wmask_d = {TotalWidth{1'b1}};
    if (Width == 16) begin : gen_secded_22_16
      if (HammingECC) begin : gen_hamming
        prim_secded_inv_hamming_22_16_enc u_enc (
          .data_i(wdata_i),
          .data_o(wdata_d)
        );
        prim_secded_inv_hamming_22_16_dec u_dec (
          .data_i     (rdata_sram),
          .data_o     (rdata_d[0+:Width]),
          .syndrome_o ( ),
          .err_o      (rerror_d)
        );
      end else begin : gen_hsiao
        prim_secded_inv_22_16_enc u_enc (
          .data_i(wdata_i),
          .data_o(wdata_d)
        );
        prim_secded_inv_22_16_dec u_dec (
          .data_i     (rdata_sram),
          .data_o     (rdata_d[0+:Width]),
          .syndrome_o ( ),
          .err_o      (rerror_d)
        );
      end
    end else if (Width == 32) begin : gen_secded_39_32
      if (HammingECC) begin : gen_hamming
        prim_secded_inv_hamming_39_32_enc u_enc (
          .data_i(wdata_i),
          .data_o(wdata_d)
        );
        prim_secded_inv_hamming_39_32_dec u_dec (
          .data_i     (rdata_sram),
          .data_o     (rdata_d[0+:Width]),
          .syndrome_o ( ),
          .err_o      (rerror_d)
        );
      end else begin : gen_hsiao
        prim_secded_inv_39_32_enc u_enc (
          .data_i(wdata_i),
          .data_o(wdata_d)
        );
        prim_secded_inv_39_32_dec u_dec (
          .data_i     (rdata_sram),
          .data_o     (rdata_d[0+:Width]),
          .syndrome_o ( ),
          .err_o      (rerror_d)
        );
      end
    end
  end else if (EnableParity) begin : gen_byte_parity
    always_comb begin : p_parity
      rerror_d = '0;
      for (int i = 0; i < Width/8; i ++) begin
        wmask_d[i*9 +: 8] = wmask_i[i*8 +: 8];
        wdata_d[i*9 +: 8] = wdata_i[i*8 +: 8];
        rdata_d[i*8 +: 8] = rdata_sram[i*9 +: 8];
        wdata_d[i*9 + 8] = ~(^wdata_i[i*8 +: 8]);
        wmask_d[i*9 + 8] = &wmask_i[i*8 +: 8];
        rerror_d[1] |= ~(^{rdata_sram[i*9 +: 8], rdata_sram[i*9 + 8]});
      end
    end
  end else begin : gen_nosecded_noparity
    assign wmask_d = wmask_i;
    assign wdata_d = wdata_i;
    assign rdata_d  = rdata_sram[0+:Width];
    assign rerror_d = '0;
  end
  assign rvalid_d = rvalid_sram_q;
  if (EnableInputPipeline) begin : gen_regslice_input
    if (EnableECC || EnableParity) begin : gen_prim_flop
      prim_flop #(
        .Width(MuBi4Width),
        .ResetValue(MuBi4Width'(MuBi4False))
      ) u_write_flop (
        .clk_i,
        .rst_ni,
        .d_i(MuBi4Width'(write_buf_d)),
        .q_o({write_q})
      );
      prim_flop #(
        .Width(MuBi4Width),
        .ResetValue(MuBi4Width'(MuBi4False))
      ) u_req_flop (
        .clk_i,
        .rst_ni,
        .d_i(MuBi4Width'(req_buf_d)),
        .q_o({req_q})
      );
    end else begin: gen_no_prim_flop
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          write_q <= MuBi4False;
          req_q   <= MuBi4False;
        end else begin
          write_q <= write_buf_d;
          req_q   <= req_buf_d;
        end
      end
    end
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        addr_q  <= '0;
        wdata_q <= '0;
        wmask_q <= '0;
      end else begin
        addr_q  <= addr_d;
        wdata_q <= wdata_d;
        wmask_q <= wmask_d;
      end
    end
  end else begin : gen_dirconnect_input
    assign req_q   = req_buf_d;
    assign write_q = write_buf_d;
    assign addr_q  = addr_d;
    assign wdata_q = wdata_d;
    assign wmask_q = wmask_d;
  end
  if (EnableOutputPipeline) begin : gen_regslice_output
    if (EnableECC || EnableParity) begin : gen_prim_rvalid_flop
      prim_flop #(
        .Width(MuBi4Width),
        .ResetValue(MuBi4Width'(MuBi4False))
      ) u_rvalid_flop (
        .clk_i,
        .rst_ni,
        .d_i(MuBi4Width'(rvalid_d)),
        .q_o({rvalid_q})
      );
    end else begin: gen_no_prim_rvalid_flop
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          rvalid_q <= MuBi4False;
        end else begin
          rvalid_q <= rvalid_d;
        end
      end
    end
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        rdata_q  <= '0;
        rerror_q <= '0;
      end else begin
        rdata_q  <= rdata_d;
        rerror_q <= rerror_d & {2{mubi4_test_true_loose(rvalid_d)}};
      end
    end
  end else begin : gen_dirconnect_output
    assign rvalid_q = rvalid_d;
    assign rdata_q  = rdata_d;
    assign rerror_q = rerror_d & {2{mubi4_test_true_loose(rvalid_d)}};
  end
  assign alert_o = mubi4_test_invalid(req_q) | mubi4_test_invalid(write_q) |
                   mubi4_test_invalid(rvalid_q) | mubi4_test_invalid(rvalid_sram_q);
endmodule : prim_ram_1p_adv
module ibex_alu #(
  parameter ibex_pkg::rv32b_e RV32B = ibex_pkg::RV32BNone
) (
  input  ibex_pkg::alu_op_e operator_i,
  input  logic [31:0]       operand_a_i,
  input  logic [31:0]       operand_b_i,
  input  logic              instr_first_cycle_i,
  input  logic [32:0]       multdiv_operand_a_i,
  input  logic [32:0]       multdiv_operand_b_i,
  input  logic              multdiv_sel_i,
  input  logic [31:0]       imd_val_q_i[2],
  output logic [31:0]       imd_val_d_o[2],
  output logic [1:0]        imd_val_we_o,
  output logic [31:0]       adder_result_o,
  output logic [33:0]       adder_result_ext_o,
  output logic [31:0]       result_o,
  output logic              comparison_result_o,
  output logic              is_equal_result_o
);
  import ibex_pkg::*;
  logic [31:0] operand_a_rev;
  logic [32:0] operand_b_neg;
  for (genvar k = 0; k < 32; k++) begin : gen_rev_operand_a
    assign operand_a_rev[k] = operand_a_i[31-k];
  end
  logic        adder_op_a_shift1;
  logic        adder_op_a_shift2;
  logic        adder_op_a_shift3;
  logic        adder_op_b_negate;
  logic [32:0] adder_in_a, adder_in_b;
  logic [31:0] adder_result;
  always_comb begin
    adder_op_a_shift1 = 1'b0;
    adder_op_a_shift2 = 1'b0;
    adder_op_a_shift3 = 1'b0;
    adder_op_b_negate = 1'b0;
    unique case (operator_i)
      ALU_SUB,
      ALU_EQ,   ALU_NE,
      ALU_GE,   ALU_GEU,
      ALU_LT,   ALU_LTU,
      ALU_SLT,  ALU_SLTU,
      ALU_MIN,  ALU_MINU,
      ALU_MAX,  ALU_MAXU: adder_op_b_negate = 1'b1;
      ALU_SH1ADD: if (RV32B != RV32BNone) adder_op_a_shift1 = 1'b1;
      ALU_SH2ADD: if (RV32B != RV32BNone) adder_op_a_shift2 = 1'b1;
      ALU_SH3ADD: if (RV32B != RV32BNone) adder_op_a_shift3 = 1'b1;
      default:;
    endcase
  end
  always_comb begin
    unique case (1'b1)
      multdiv_sel_i:     adder_in_a = multdiv_operand_a_i;
      adder_op_a_shift1: adder_in_a = {operand_a_i[30:0],2'b01};
      adder_op_a_shift2: adder_in_a = {operand_a_i[29:0],3'b001};
      adder_op_a_shift3: adder_in_a = {operand_a_i[28:0],4'b0001};
      default:           adder_in_a = {operand_a_i,1'b1};
    endcase
  end
  assign operand_b_neg = {operand_b_i,1'b0} ^ {33{1'b1}};
  always_comb begin
    unique case (1'b1)
      multdiv_sel_i:     adder_in_b = multdiv_operand_b_i;
      adder_op_b_negate: adder_in_b = operand_b_neg;
      default:           adder_in_b = {operand_b_i, 1'b0};
    endcase
  end
  assign adder_result_ext_o = $unsigned(adder_in_a) + $unsigned(adder_in_b);
  assign adder_result       = adder_result_ext_o[32:1];
  assign adder_result_o     = adder_result;
  logic is_equal;
  logic is_greater_equal;   
  logic cmp_signed;
  always_comb begin
    unique case (operator_i)
      ALU_GE,
      ALU_LT,
      ALU_SLT,
      ALU_MIN,
      ALU_MAX: cmp_signed = 1'b1;
      default: cmp_signed = 1'b0;
    endcase
  end
  assign is_equal = (adder_result == 32'b0);
  assign is_equal_result_o = is_equal;
  always_comb begin
    if ((operand_a_i[31] ^ operand_b_i[31]) == 1'b0) begin
      is_greater_equal = (adder_result[31] == 1'b0);
    end else begin
      is_greater_equal = operand_a_i[31] ^ (cmp_signed);
    end
  end
  logic cmp_result;
  always_comb begin
    unique case (operator_i)
      ALU_EQ:             cmp_result =  is_equal;
      ALU_NE:             cmp_result = ~is_equal;
      ALU_GE,   ALU_GEU,
      ALU_MAX,  ALU_MAXU: cmp_result = is_greater_equal;  
      ALU_LT,   ALU_LTU,
      ALU_MIN,  ALU_MINU,  
      ALU_SLT,  ALU_SLTU: cmp_result = ~is_greater_equal;
      default: cmp_result = is_equal;
    endcase
  end
  assign comparison_result_o = cmp_result;
  logic       shift_left;
  logic       shift_ones;
  logic       shift_arith;
  logic       shift_funnel;
  logic       shift_sbmode;
  logic [5:0] shift_amt;
  logic [5:0] shift_amt_compl;  
  logic        [31:0] shift_operand;
  logic signed [32:0] shift_result_ext_signed;
  logic        [32:0] shift_result_ext;
  logic               unused_shift_result_ext;
  logic        [31:0] shift_result;
  logic        [31:0] shift_result_rev;
  logic bfp_op;
  logic [4:0]  bfp_len;
  logic [4:0]  bfp_off;
  logic [31:0] bfp_mask;
  logic [31:0] bfp_mask_rev;
  logic [31:0] bfp_result;
  assign bfp_op = (RV32B != RV32BNone) ? (operator_i == ALU_BFP) : 1'b0;
  assign bfp_len = {~(|operand_b_i[27:24]), operand_b_i[27:24]};  
  assign bfp_off = operand_b_i[20:16];
  assign bfp_mask = (RV32B != RV32BNone) ? ~(32'hffff_ffff << bfp_len) : '0;
  for (genvar i = 0; i < 32; i++) begin : gen_rev_bfp_mask
    assign bfp_mask_rev[i] = bfp_mask[31-i];
  end
  assign bfp_result =(RV32B != RV32BNone) ?
      (~shift_result & operand_a_i) | ((operand_b_i & bfp_mask) << bfp_off) : '0;
  assign shift_amt[5] = operand_b_i[5] & shift_funnel;
  assign shift_amt_compl = 32 - operand_b_i[4:0];
  always_comb begin
    if (bfp_op) begin
      shift_amt[4:0] = bfp_off;   
    end else begin
      shift_amt[4:0] = instr_first_cycle_i ?
          (operand_b_i[5] && shift_funnel ? shift_amt_compl[4:0] : operand_b_i[4:0]) :
          (operand_b_i[5] && shift_funnel ? operand_b_i[4:0] : shift_amt_compl[4:0]);
    end
  end
  assign shift_sbmode = (RV32B != RV32BNone) ?
      (operator_i == ALU_BSET) | (operator_i == ALU_BCLR) | (operator_i == ALU_BINV) : 1'b0;
  always_comb begin
    unique case (operator_i)
      ALU_SLL: shift_left = 1'b1;
      ALU_SLO: shift_left = (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) ? 1'b1 : 1'b0;
      ALU_BFP: shift_left = (RV32B != RV32BNone) ? 1'b1 : 1'b0;
      ALU_ROL: shift_left = (RV32B != RV32BNone) ? instr_first_cycle_i : 0;
      ALU_ROR: shift_left = (RV32B != RV32BNone) ? ~instr_first_cycle_i : 0;
      ALU_FSL: shift_left = (RV32B != RV32BNone) ?
        (shift_amt[5] ? ~instr_first_cycle_i : instr_first_cycle_i) : 1'b0;
      ALU_FSR: shift_left = (RV32B != RV32BNone) ?
          (shift_amt[5] ? instr_first_cycle_i : ~instr_first_cycle_i) : 1'b0;
      default: shift_left = 1'b0;
    endcase
    if (shift_sbmode) begin
      shift_left = 1'b1;
    end
  end
  assign shift_arith  = (operator_i == ALU_SRA);
  assign shift_ones   = (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) ?
      (operator_i == ALU_SLO) | (operator_i == ALU_SRO) : 1'b0;
  assign shift_funnel = (RV32B != RV32BNone) ?
      (operator_i == ALU_FSL) | (operator_i == ALU_FSR) : 1'b0;
  always_comb begin
    if (RV32B == RV32BNone) begin
      shift_operand = shift_left ? operand_a_rev : operand_a_i;
    end else begin
      unique case (1'b1)
        bfp_op:       shift_operand = bfp_mask_rev;
        shift_sbmode: shift_operand = 32'h8000_0000;
        default:      shift_operand = shift_left ? operand_a_rev : operand_a_i;
      endcase
    end
    shift_result_ext_signed =
        $signed({shift_ones | (shift_arith & shift_operand[31]), shift_operand}) >>> shift_amt[4:0];
    shift_result_ext = $unsigned(shift_result_ext_signed);
    shift_result            = shift_result_ext[31:0];
    unused_shift_result_ext = shift_result_ext[32];
    for (int unsigned i = 0; i < 32; i++) begin
      shift_result_rev[i] = shift_result[31-i];
    end
    shift_result = shift_left ? shift_result_rev : shift_result;
  end
  logic bwlogic_or;
  logic bwlogic_and;
  logic [31:0] bwlogic_operand_b;
  logic [31:0] bwlogic_or_result;
  logic [31:0] bwlogic_and_result;
  logic [31:0] bwlogic_xor_result;
  logic [31:0] bwlogic_result;
  logic bwlogic_op_b_negate;
  always_comb begin
    unique case (operator_i)
      ALU_XNOR,
      ALU_ORN,
      ALU_ANDN: bwlogic_op_b_negate = (RV32B != RV32BNone) ? 1'b1 : 1'b0;
      ALU_CMIX: bwlogic_op_b_negate = (RV32B != RV32BNone) ? ~instr_first_cycle_i : 1'b0;
      default:  bwlogic_op_b_negate = 1'b0;
    endcase
  end
  assign bwlogic_operand_b = bwlogic_op_b_negate ? operand_b_neg[32:1] : operand_b_i;
  assign bwlogic_or_result  = operand_a_i | bwlogic_operand_b;
  assign bwlogic_and_result = operand_a_i & bwlogic_operand_b;
  assign bwlogic_xor_result = operand_a_i ^ bwlogic_operand_b;
  assign bwlogic_or  = (operator_i == ALU_OR)  | (operator_i == ALU_ORN);
  assign bwlogic_and = (operator_i == ALU_AND) | (operator_i == ALU_ANDN);
  always_comb begin
    unique case (1'b1)
      bwlogic_or:  bwlogic_result = bwlogic_or_result;
      bwlogic_and: bwlogic_result = bwlogic_and_result;
      default:     bwlogic_result = bwlogic_xor_result;
    endcase
  end
  logic [5:0]  bitcnt_result;
  logic [31:0] minmax_result;
  logic [31:0] pack_result;
  logic [31:0] sext_result;
  logic [31:0] singlebit_result;
  logic [31:0] rev_result;
  logic [31:0] shuffle_result;
  logic [31:0] xperm_result;
  logic [31:0] butterfly_result;
  logic [31:0] invbutterfly_result;
  logic [31:0] clmul_result;
  logic [31:0] multicycle_result;
  if (RV32B != RV32BNone) begin : g_alu_rvb
    logic        zbe_op;
    logic        bitcnt_ctz;
    logic        bitcnt_clz;
    logic        bitcnt_cz;
    logic [31:0] bitcnt_bits;
    logic [31:0] bitcnt_mask_op;
    logic [31:0] bitcnt_bit_mask;
    logic [ 5:0] bitcnt_partial [32];
    logic [31:0] bitcnt_partial_lsb_d;
    logic [31:0] bitcnt_partial_msb_d;
    assign bitcnt_ctz    = operator_i == ALU_CTZ;
    assign bitcnt_clz    = operator_i == ALU_CLZ;
    assign bitcnt_cz     = bitcnt_ctz | bitcnt_clz;
    assign bitcnt_result = bitcnt_partial[31];
    assign bitcnt_mask_op = bitcnt_clz ? operand_a_rev : operand_a_i;
    always_comb begin
      bitcnt_bit_mask = bitcnt_mask_op;
      bitcnt_bit_mask |= bitcnt_bit_mask << 1;
      bitcnt_bit_mask |= bitcnt_bit_mask << 2;
      bitcnt_bit_mask |= bitcnt_bit_mask << 4;
      bitcnt_bit_mask |= bitcnt_bit_mask << 8;
      bitcnt_bit_mask |= bitcnt_bit_mask << 16;
      bitcnt_bit_mask = ~bitcnt_bit_mask;
    end
    assign zbe_op = (operator_i == ALU_BCOMPRESS) | (operator_i == ALU_BDECOMPRESS);
    always_comb begin
      unique case (1'b1)
        zbe_op:      bitcnt_bits = operand_b_i;
        bitcnt_cz:   bitcnt_bits = bitcnt_bit_mask & ~bitcnt_mask_op;  
        default:     bitcnt_bits = operand_a_i;  
      endcase
    end
    always_comb begin
      bitcnt_partial = '{default: '0};
      for (int unsigned i = 1; i < 32; i += 2) begin
        bitcnt_partial[i] = {5'h0, bitcnt_bits[i]} + {5'h0, bitcnt_bits[i-1]};
      end
      for (int unsigned i = 3; i < 32; i += 4) begin
        bitcnt_partial[i] = bitcnt_partial[i-2] + bitcnt_partial[i];
      end
      for (int unsigned i = 7; i < 32; i += 8) begin
        bitcnt_partial[i] = bitcnt_partial[i-4] + bitcnt_partial[i];
      end
      for (int unsigned i = 15; i < 32; i += 16) begin
        bitcnt_partial[i] = bitcnt_partial[i-8] + bitcnt_partial[i];
      end
      bitcnt_partial[31] = bitcnt_partial[15] + bitcnt_partial[31];
      bitcnt_partial[23] = bitcnt_partial[15] + bitcnt_partial[23];
      for (int unsigned i = 11; i < 32; i += 8) begin
        bitcnt_partial[i] = bitcnt_partial[i-4] + bitcnt_partial[i];
      end
      for (int unsigned i = 5; i < 32; i += 4) begin
        bitcnt_partial[i] = bitcnt_partial[i-2] + bitcnt_partial[i];
      end
      bitcnt_partial[0] = {5'h0, bitcnt_bits[0]};
      for (int unsigned i = 2; i < 32; i += 2) begin
        bitcnt_partial[i] = bitcnt_partial[i-1] + {5'h0, bitcnt_bits[i]};
      end
    end
    assign minmax_result = cmp_result ? operand_a_i : operand_b_i;
    logic packu;
    logic packh;
    assign packu = operator_i == ALU_PACKU;
    assign packh = operator_i == ALU_PACKH;
    always_comb begin
      unique case (1'b1)
        packu:   pack_result = {operand_b_i[31:16], operand_a_i[31:16]};
        packh:   pack_result = {16'h0, operand_b_i[7:0], operand_a_i[7:0]};
        default: pack_result = {operand_b_i[15:0], operand_a_i[15:0]};
      endcase
    end
    assign sext_result = (operator_i == ALU_SEXTB) ?
        { {24{operand_a_i[7]}}, operand_a_i[7:0]} : { {16{operand_a_i[15]}}, operand_a_i[15:0]};
    always_comb begin
      unique case (operator_i)
        ALU_BSET: singlebit_result = operand_a_i | shift_result;
        ALU_BCLR: singlebit_result = operand_a_i & ~shift_result;
        ALU_BINV: singlebit_result = operand_a_i ^ shift_result;
        default:  singlebit_result = {31'h0, shift_result[0]};  
      endcase
    end
    logic [4:0] zbp_shift_amt;
    logic gorc_op;
    assign gorc_op = (operator_i == ALU_GORC);
    assign zbp_shift_amt[2:0] =
        (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) ? shift_amt[2:0] : {3{shift_amt[0]}};
    assign zbp_shift_amt[4:3] =
        (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) ? shift_amt[4:3] : {2{shift_amt[3]}};
    always_comb begin
      rev_result = operand_a_i;
      if (zbp_shift_amt[0]) begin
        rev_result = (gorc_op ? rev_result : 32'h0)       |
                     ((rev_result & 32'h5555_5555) <<  1) |
                     ((rev_result & 32'haaaa_aaaa) >>  1);
      end
      if (zbp_shift_amt[1]) begin
        rev_result = (gorc_op ? rev_result : 32'h0)       |
                     ((rev_result & 32'h3333_3333) <<  2) |
                     ((rev_result & 32'hcccc_cccc) >>  2);
      end
      if (zbp_shift_amt[2]) begin
        rev_result = (gorc_op ? rev_result : 32'h0)       |
                     ((rev_result & 32'h0f0f_0f0f) <<  4) |
                     ((rev_result & 32'hf0f0_f0f0) >>  4);
      end
      if (zbp_shift_amt[3]) begin
        rev_result = ((RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) &&
                      gorc_op ? rev_result : 32'h0) |
                     ((rev_result & 32'h00ff_00ff) <<  8) |
                     ((rev_result & 32'hff00_ff00) >>  8);
      end
      if (zbp_shift_amt[4]) begin
        rev_result = ((RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) &&
                      gorc_op ? rev_result : 32'h0) |
                     ((rev_result & 32'h0000_ffff) << 16) |
                     ((rev_result & 32'hffff_0000) >> 16);
      end
    end
    logic crc_hmode;
    logic crc_bmode;
    logic [31:0] clmul_result_rev;
    if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) begin : gen_alu_rvb_otearlgrey_full
      localparam logic [31:0] SHUFFLE_MASK_L [4] =
          '{32'h00ff_0000, 32'h0f00_0f00, 32'h3030_3030, 32'h4444_4444};
      localparam logic [31:0] SHUFFLE_MASK_R [4] =
          '{32'h0000_ff00, 32'h00f0_00f0, 32'h0c0c_0c0c, 32'h2222_2222};
      localparam logic [31:0] FLIP_MASK_L [4] =
          '{32'h2200_1100, 32'h0044_0000, 32'h4411_0000, 32'h1100_0000};
      localparam logic [31:0] FLIP_MASK_R [4] =
          '{32'h0088_0044, 32'h0000_2200, 32'h0000_8822, 32'h0000_0088};
      logic [31:0] SHUFFLE_MASK_NOT [4];
      for(genvar i = 0; i < 4; i++) begin : gen_shuffle_mask_not
        assign SHUFFLE_MASK_NOT[i] = ~(SHUFFLE_MASK_L[i] | SHUFFLE_MASK_R[i]);
      end
      logic shuffle_flip;
      assign shuffle_flip = operator_i == ALU_UNSHFL;
      logic [3:0] shuffle_mode;
      always_comb begin
        shuffle_result = operand_a_i;
        if (shuffle_flip) begin
          shuffle_mode[3] = shift_amt[0];
          shuffle_mode[2] = shift_amt[1];
          shuffle_mode[1] = shift_amt[2];
          shuffle_mode[0] = shift_amt[3];
        end else begin
          shuffle_mode = shift_amt[3:0];
        end
        if (shuffle_flip) begin
          shuffle_result = (shuffle_result & 32'h8822_4411) |
              ((shuffle_result << 6)  & FLIP_MASK_L[0]) |
              ((shuffle_result >> 6)  & FLIP_MASK_R[0]) |
              ((shuffle_result << 9)  & FLIP_MASK_L[1]) |
              ((shuffle_result >> 9)  & FLIP_MASK_R[1]) |
              ((shuffle_result << 15) & FLIP_MASK_L[2]) |
              ((shuffle_result >> 15) & FLIP_MASK_R[2]) |
              ((shuffle_result << 21) & FLIP_MASK_L[3]) |
              ((shuffle_result >> 21) & FLIP_MASK_R[3]);
        end
        if (shuffle_mode[3]) begin
          shuffle_result = (shuffle_result & SHUFFLE_MASK_NOT[0]) |
              (((shuffle_result << 8) & SHUFFLE_MASK_L[0]) |
              ((shuffle_result >> 8) & SHUFFLE_MASK_R[0]));
        end
        if (shuffle_mode[2]) begin
          shuffle_result = (shuffle_result & SHUFFLE_MASK_NOT[1]) |
              (((shuffle_result << 4) & SHUFFLE_MASK_L[1]) |
              ((shuffle_result >> 4) & SHUFFLE_MASK_R[1]));
        end
        if (shuffle_mode[1]) begin
          shuffle_result = (shuffle_result & SHUFFLE_MASK_NOT[2]) |
              (((shuffle_result << 2) & SHUFFLE_MASK_L[2]) |
              ((shuffle_result >> 2) & SHUFFLE_MASK_R[2]));
        end
        if (shuffle_mode[0]) begin
          shuffle_result = (shuffle_result & SHUFFLE_MASK_NOT[3]) |
              (((shuffle_result << 1) & SHUFFLE_MASK_L[3]) |
              ((shuffle_result >> 1) & SHUFFLE_MASK_R[3]));
        end
        if (shuffle_flip) begin
          shuffle_result = (shuffle_result & 32'h8822_4411) |
              ((shuffle_result << 6)  & FLIP_MASK_L[0]) |
              ((shuffle_result >> 6)  & FLIP_MASK_R[0]) |
              ((shuffle_result << 9)  & FLIP_MASK_L[1]) |
              ((shuffle_result >> 9)  & FLIP_MASK_R[1]) |
              ((shuffle_result << 15) & FLIP_MASK_L[2]) |
              ((shuffle_result >> 15) & FLIP_MASK_R[2]) |
              ((shuffle_result << 21) & FLIP_MASK_L[3]) |
              ((shuffle_result >> 21) & FLIP_MASK_R[3]);
        end
      end
      logic  [7:0][2:0] sel_n;  
      logic  [7:0]      vld_n;  
      logic  [3:0][1:0] sel_b;  
      logic  [3:0]      vld_b;  
      logic  [1:0][0:0] sel_h;  
      logic  [1:0]      vld_h;  
      for (genvar i = 0; i < 8; i++) begin : gen_sel_vld_n
        assign sel_n[i] =   operand_b_i[i*4     +: 3];
        assign vld_n[i] = ~|operand_b_i[i*4 + 3 +: 1];
      end
      for (genvar i = 0; i < 4; i++) begin : gen_sel_vld_b
        assign sel_b[i] =   operand_b_i[i*8     +: 2];
        assign vld_b[i] = ~|operand_b_i[i*8 + 2 +: 6];
      end
      for (genvar i = 0; i < 2; i++) begin : gen_sel_vld_h
        assign sel_h[i] =   operand_b_i[i*16     +: 1];
        assign vld_h[i] = ~|operand_b_i[i*16 + 1 +: 15];
      end
      logic [7:0][2:0] sel;
      logic [7:0]      vld;
      always_comb begin
        unique case (operator_i)
          ALU_XPERM_N: begin
            sel = sel_n;
            vld = vld_n;
          end
          ALU_XPERM_B: begin
            for (int b = 0; b < 4; b++) begin
              sel[b*2 +  0] =   {sel_b[b], 1'b0};
              sel[b*2 +  1] =   {sel_b[b], 1'b1};
              vld[b*2 +: 2] = {2{vld_b[b]}};
            end
          end
          ALU_XPERM_H: begin
            for (int h = 0; h < 2; h++) begin
              sel[h*4 +  0] =   {sel_h[h], 2'b00};
              sel[h*4 +  1] =   {sel_h[h], 2'b01};
              sel[h*4 +  2] =   {sel_h[h], 2'b10};
              sel[h*4 +  3] =   {sel_h[h], 2'b11};
              vld[h*4 +: 4] = {4{vld_h[h]}};
            end
          end
          default: begin
            sel = sel_n;
            vld = '0;
          end
        endcase
      end
      logic [7:0][3:0] val_n;
      logic [7:0][3:0] xperm_n;
      assign val_n = operand_a_i;
      for (genvar i = 0; i < 8; i++) begin : gen_xperm_n
        assign xperm_n[i] = vld[i] ? val_n[sel[i]] : '0;
      end
      assign xperm_result = xperm_n;
      logic clmul_rmode;
      logic clmul_hmode;
      logic [31:0] clmul_op_a;
      logic [31:0] clmul_op_b;
      logic [31:0] operand_b_rev;
      logic [31:0] clmul_and_stage[32];
      logic [31:0] clmul_xor_stage1[16];
      logic [31:0] clmul_xor_stage2[8];
      logic [31:0] clmul_xor_stage3[4];
      logic [31:0] clmul_xor_stage4[2];
      logic [31:0] clmul_result_raw;
      for (genvar i = 0; i < 32; i++) begin : gen_rev_operand_b
        assign operand_b_rev[i] = operand_b_i[31-i];
      end
      assign clmul_rmode = operator_i == ALU_CLMULR;
      assign clmul_hmode = operator_i == ALU_CLMULH;
      localparam logic [31:0] CRC32_POLYNOMIAL = 32'h04c1_1db7;
      localparam logic [31:0] CRC32_MU_REV = 32'hf701_1641;
      localparam logic [31:0] CRC32C_POLYNOMIAL = 32'h1edc_6f41;
      localparam logic [31:0] CRC32C_MU_REV = 32'hdea7_13f1;
      logic crc_op;
      logic crc_cpoly;
      logic [31:0] crc_operand;
      logic [31:0] crc_poly;
      logic [31:0] crc_mu_rev;
      assign crc_op = (operator_i == ALU_CRC32C_W) | (operator_i == ALU_CRC32_W) |
                      (operator_i == ALU_CRC32C_H) | (operator_i == ALU_CRC32_H) |
                      (operator_i == ALU_CRC32C_B) | (operator_i == ALU_CRC32_B);
      assign crc_cpoly = (operator_i == ALU_CRC32C_W) |
                         (operator_i == ALU_CRC32C_H) |
                         (operator_i == ALU_CRC32C_B);
      assign crc_hmode = (operator_i == ALU_CRC32_H) | (operator_i == ALU_CRC32C_H);
      assign crc_bmode = (operator_i == ALU_CRC32_B) | (operator_i == ALU_CRC32C_B);
      assign crc_poly   = crc_cpoly ? CRC32C_POLYNOMIAL : CRC32_POLYNOMIAL;
      assign crc_mu_rev = crc_cpoly ? CRC32C_MU_REV : CRC32_MU_REV;
      always_comb begin
        unique case (1'b1)
          crc_bmode: crc_operand = {operand_a_i[7:0], 24'h0};
          crc_hmode: crc_operand = {operand_a_i[15:0], 16'h0};
          default:   crc_operand = operand_a_i;
        endcase
      end
      always_comb begin
        if (crc_op) begin
          clmul_op_a = instr_first_cycle_i ? crc_operand : imd_val_q_i[0];
          clmul_op_b = instr_first_cycle_i ? crc_mu_rev : crc_poly;
        end else begin
          clmul_op_a = clmul_rmode | clmul_hmode ? operand_a_rev : operand_a_i;
          clmul_op_b = clmul_rmode | clmul_hmode ? operand_b_rev : operand_b_i;
        end
      end
      for (genvar i = 0; i < 32; i++) begin : gen_clmul_and_op
        assign clmul_and_stage[i] = clmul_op_b[i] ? clmul_op_a << i : '0;
      end
      for (genvar i = 0; i < 16; i++) begin : gen_clmul_xor_op_l1
        assign clmul_xor_stage1[i] = clmul_and_stage[2*i] ^ clmul_and_stage[2*i+1];
      end
      for (genvar i = 0; i < 8; i++) begin : gen_clmul_xor_op_l2
        assign clmul_xor_stage2[i] = clmul_xor_stage1[2*i] ^ clmul_xor_stage1[2*i+1];
      end
      for (genvar i = 0; i < 4; i++) begin : gen_clmul_xor_op_l3
        assign clmul_xor_stage3[i] = clmul_xor_stage2[2*i] ^ clmul_xor_stage2[2*i+1];
      end
      for (genvar i = 0; i < 2; i++) begin : gen_clmul_xor_op_l4
        assign clmul_xor_stage4[i] = clmul_xor_stage3[2*i] ^ clmul_xor_stage3[2*i+1];
      end
      assign clmul_result_raw = clmul_xor_stage4[0] ^ clmul_xor_stage4[1];
      for (genvar i = 0; i < 32; i++) begin : gen_rev_clmul_result
        assign clmul_result_rev[i] = clmul_result_raw[31-i];
      end
      always_comb begin
        unique case (1'b1)
          clmul_rmode: clmul_result = clmul_result_rev;
          clmul_hmode: clmul_result = {1'b0, clmul_result_rev[31:1]};
          default:     clmul_result = clmul_result_raw;
        endcase
      end
    end else begin : gen_alu_rvb_not_otearlgrey_full
      assign shuffle_result       = '0;
      assign xperm_result         = '0;
      assign clmul_result         = '0;
      assign clmul_result_rev     = '0;
      assign crc_bmode            = '0;
      assign crc_hmode            = '0;
    end
    if (RV32B == RV32BFull) begin : gen_alu_rvb_full
      logic [ 5:0] bitcnt_partial_q [32];
      for (genvar i = 0; i < 32; i++) begin : gen_bitcnt_reg_in_lsb
        assign bitcnt_partial_lsb_d[i] = bitcnt_partial[i][0];
      end
      for (genvar i = 0; i < 16; i++) begin : gen_bitcnt_reg_in_b1
        assign bitcnt_partial_msb_d[i] = bitcnt_partial[2*i+1][1];
      end
      for (genvar i = 0; i < 8; i++) begin : gen_bitcnt_reg_in_b2
        assign bitcnt_partial_msb_d[16+i] = bitcnt_partial[4*i+3][2];
      end
      for (genvar i = 0; i < 4; i++) begin : gen_bitcnt_reg_in_b3
        assign bitcnt_partial_msb_d[24+i] = bitcnt_partial[8*i+7][3];
      end
      for (genvar i = 0; i < 2; i++) begin : gen_bitcnt_reg_in_b4
        assign bitcnt_partial_msb_d[28+i] = bitcnt_partial[16*i+15][4];
      end
      assign bitcnt_partial_msb_d[30] = bitcnt_partial[31][5];
      assign bitcnt_partial_msb_d[31] = 1'b0;  
      always_comb begin
        bitcnt_partial_q = '{default: '0};
        for (int unsigned i = 0; i < 32; i++) begin : gen_bitcnt_reg_out_lsb
          bitcnt_partial_q[i][0] = imd_val_q_i[0][i];
        end
        for (int unsigned i = 0; i < 16; i++) begin : gen_bitcnt_reg_out_b1
          bitcnt_partial_q[2*i+1][1] = imd_val_q_i[1][i];
        end
        for (int unsigned i = 0; i < 8; i++) begin : gen_bitcnt_reg_out_b2
          bitcnt_partial_q[4*i+3][2] = imd_val_q_i[1][16+i];
        end
        for (int unsigned i = 0; i < 4; i++) begin : gen_bitcnt_reg_out_b3
          bitcnt_partial_q[8*i+7][3] = imd_val_q_i[1][24+i];
        end
        for (int unsigned i = 0; i < 2; i++) begin : gen_bitcnt_reg_out_b4
          bitcnt_partial_q[16*i+15][4] = imd_val_q_i[1][28+i];
        end
        bitcnt_partial_q[31][5] = imd_val_q_i[1][30];
      end
      logic [31:0] butterfly_mask_l[5];
      logic [31:0] butterfly_mask_r[5];
      logic [31:0] butterfly_mask_not[5];
      logic [31:0] lrotc_stage [5];  
      for (genvar stg = 0; stg < 5; stg++) begin : gen_butterfly_ctrl_stage
        for (genvar seg=0; seg<2**stg; seg++) begin : gen_butterfly_ctrl
          assign lrotc_stage[stg][2*(16 >> stg)*(seg+1)-1 : 2*(16 >> stg)*seg] =
              {{(16 >> stg){1'b0}},{(16 >> stg){1'b1}}} <<
                bitcnt_partial_q[(16 >> stg)*(2*seg+1)-1][$clog2((16 >> stg)):0];
          assign butterfly_mask_l[stg][(16 >> stg)*(2*seg+2)-1 : (16 >> stg)*(2*seg+1)]
                   = ~lrotc_stage[stg][(16 >> stg)*(2*seg+2)-1 : (16 >> stg)*(2*seg+1)];
          assign butterfly_mask_r[stg][(16 >> stg)*(2*seg+1)-1 : (16 >> stg)*(2*seg)]
                   = ~lrotc_stage[stg][(16 >> stg)*(2*seg+2)-1 : (16 >> stg)*(2*seg+1)];
          assign butterfly_mask_l[stg][(16 >> stg)*(2*seg+1)-1 : (16 >> stg)*(2*seg)]   = '0;
          assign butterfly_mask_r[stg][(16 >> stg)*(2*seg+2)-1 : (16 >> stg)*(2*seg+1)] = '0;
        end
      end
      for (genvar stg = 0; stg < 5; stg++) begin : gen_butterfly_not
        assign butterfly_mask_not[stg] =
            ~(butterfly_mask_l[stg] | butterfly_mask_r[stg]);
      end
      always_comb begin
        butterfly_result = operand_a_i;
        butterfly_result = butterfly_result & butterfly_mask_not[0] |
            ((butterfly_result & butterfly_mask_l[0]) >> 16)|
            ((butterfly_result & butterfly_mask_r[0]) << 16);
        butterfly_result = butterfly_result & butterfly_mask_not[1] |
            ((butterfly_result & butterfly_mask_l[1]) >> 8)|
            ((butterfly_result & butterfly_mask_r[1]) << 8);
        butterfly_result = butterfly_result & butterfly_mask_not[2] |
            ((butterfly_result & butterfly_mask_l[2]) >> 4)|
            ((butterfly_result & butterfly_mask_r[2]) << 4);
        butterfly_result = butterfly_result & butterfly_mask_not[3] |
            ((butterfly_result & butterfly_mask_l[3]) >> 2)|
            ((butterfly_result & butterfly_mask_r[3]) << 2);
        butterfly_result = butterfly_result & butterfly_mask_not[4] |
            ((butterfly_result & butterfly_mask_l[4]) >> 1)|
            ((butterfly_result & butterfly_mask_r[4]) << 1);
        butterfly_result = butterfly_result & operand_b_i;
      end
      always_comb begin
        invbutterfly_result = operand_a_i & operand_b_i;
        invbutterfly_result = invbutterfly_result & butterfly_mask_not[4] |
            ((invbutterfly_result & butterfly_mask_l[4]) >> 1)|
            ((invbutterfly_result & butterfly_mask_r[4]) << 1);
        invbutterfly_result = invbutterfly_result & butterfly_mask_not[3] |
            ((invbutterfly_result & butterfly_mask_l[3]) >> 2)|
            ((invbutterfly_result & butterfly_mask_r[3]) << 2);
        invbutterfly_result = invbutterfly_result & butterfly_mask_not[2] |
            ((invbutterfly_result & butterfly_mask_l[2]) >> 4)|
            ((invbutterfly_result & butterfly_mask_r[2]) << 4);
        invbutterfly_result = invbutterfly_result & butterfly_mask_not[1] |
            ((invbutterfly_result & butterfly_mask_l[1]) >> 8)|
            ((invbutterfly_result & butterfly_mask_r[1]) << 8);
        invbutterfly_result = invbutterfly_result & butterfly_mask_not[0] |
            ((invbutterfly_result & butterfly_mask_l[0]) >> 16)|
            ((invbutterfly_result & butterfly_mask_r[0]) << 16);
      end
    end else begin : gen_alu_rvb_not_full
      logic [31:0] unused_imd_val_q_1;
      assign unused_imd_val_q_1   = imd_val_q_i[1];
      assign butterfly_result     = '0;
      assign invbutterfly_result  = '0;
      assign bitcnt_partial_lsb_d = '0;
      assign bitcnt_partial_msb_d = '0;
    end
    always_comb begin
      unique case (operator_i)
        ALU_CMOV: begin
          multicycle_result = (operand_b_i == 32'h0) ? operand_a_i : imd_val_q_i[0];
          imd_val_d_o = '{operand_a_i, 32'h0};
          if (instr_first_cycle_i) begin
            imd_val_we_o = 2'b01;
          end else begin
            imd_val_we_o = 2'b00;
          end
        end
        ALU_CMIX: begin
          multicycle_result = imd_val_q_i[0] | bwlogic_and_result;
          imd_val_d_o = '{bwlogic_and_result, 32'h0};
          if (instr_first_cycle_i) begin
            imd_val_we_o = 2'b01;
          end else begin
            imd_val_we_o = 2'b00;
          end
        end
        ALU_FSR, ALU_FSL,
        ALU_ROL, ALU_ROR: begin
          if (shift_amt[4:0] == 5'h0) begin
            multicycle_result = shift_amt[5] ? operand_a_i : imd_val_q_i[0];
          end else begin
            multicycle_result = imd_val_q_i[0] | shift_result;
          end
          imd_val_d_o = '{shift_result, 32'h0};
          if (instr_first_cycle_i) begin
            imd_val_we_o = 2'b01;
          end else begin
            imd_val_we_o = 2'b00;
          end
        end
        ALU_CRC32_W, ALU_CRC32C_W,
        ALU_CRC32_H, ALU_CRC32C_H,
        ALU_CRC32_B, ALU_CRC32C_B: begin
          if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) begin
            unique case (1'b1)
              crc_bmode: multicycle_result = clmul_result_rev ^ (operand_a_i >> 8);
              crc_hmode: multicycle_result = clmul_result_rev ^ (operand_a_i >> 16);
              default:   multicycle_result = clmul_result_rev;
            endcase
            imd_val_d_o = '{clmul_result_rev, 32'h0};
            if (instr_first_cycle_i) begin
              imd_val_we_o = 2'b01;
            end else begin
              imd_val_we_o = 2'b00;
            end
          end else begin
            imd_val_d_o = '{operand_a_i, 32'h0};
            imd_val_we_o = 2'b00;
            multicycle_result = '0;
          end
        end
        ALU_BCOMPRESS, ALU_BDECOMPRESS: begin
          if (RV32B == RV32BFull) begin
            multicycle_result = (operator_i == ALU_BDECOMPRESS) ? butterfly_result :
                                                                  invbutterfly_result;
            imd_val_d_o = '{bitcnt_partial_lsb_d, bitcnt_partial_msb_d};
            if (instr_first_cycle_i) begin
              imd_val_we_o = 2'b11;
            end else begin
              imd_val_we_o = 2'b00;
            end
          end else begin
            imd_val_d_o = '{operand_a_i, 32'h0};
            imd_val_we_o = 2'b00;
            multicycle_result = '0;
          end
        end
        default: begin
          imd_val_d_o = '{operand_a_i, 32'h0};
          imd_val_we_o = 2'b00;
          multicycle_result = '0;
        end
      endcase
    end
  end else begin : g_no_alu_rvb
    logic [31:0] unused_imd_val_q[2];
    assign unused_imd_val_q           = imd_val_q_i;
    logic [31:0] unused_butterfly_result;
    assign unused_butterfly_result    = butterfly_result;
    logic [31:0] unused_invbutterfly_result;
    assign unused_invbutterfly_result = invbutterfly_result;
    assign bitcnt_result       = '0;
    assign minmax_result       = '0;
    assign pack_result         = '0;
    assign sext_result         = '0;
    assign singlebit_result    = '0;
    assign rev_result          = '0;
    assign shuffle_result      = '0;
    assign xperm_result        = '0;
    assign butterfly_result    = '0;
    assign invbutterfly_result = '0;
    assign clmul_result        = '0;
    assign multicycle_result   = '0;
    assign imd_val_d_o         = '{default: '0};
    assign imd_val_we_o        = '{default: '0};
  end
  always_comb begin
    result_o   = '0;
    unique case (operator_i)
      ALU_XOR,  ALU_XNOR,
      ALU_OR,   ALU_ORN,
      ALU_AND,  ALU_ANDN: result_o = bwlogic_result;
      ALU_ADD,  ALU_SUB,
      ALU_SH1ADD, ALU_SH2ADD,
      ALU_SH3ADD: result_o = adder_result;
      ALU_SLL,  ALU_SRL,
      ALU_SRA,
      ALU_SLO,  ALU_SRO: result_o = shift_result;
      ALU_SHFL, ALU_UNSHFL: result_o = shuffle_result;
      ALU_XPERM_N, ALU_XPERM_B, ALU_XPERM_H: result_o = xperm_result;
      ALU_EQ,   ALU_NE,
      ALU_GE,   ALU_GEU,
      ALU_LT,   ALU_LTU,
      ALU_SLT,  ALU_SLTU: result_o = {31'h0,cmp_result};
      ALU_MIN,  ALU_MAX,
      ALU_MINU, ALU_MAXU: result_o = minmax_result;
      ALU_CLZ, ALU_CTZ,
      ALU_CPOP: result_o = {26'h0, bitcnt_result};
      ALU_PACK, ALU_PACKH,
      ALU_PACKU: result_o = pack_result;
      ALU_SEXTB, ALU_SEXTH: result_o = sext_result;
      ALU_CMIX, ALU_CMOV,
      ALU_FSL,  ALU_FSR,
      ALU_ROL, ALU_ROR,
      ALU_CRC32_W, ALU_CRC32C_W,
      ALU_CRC32_H, ALU_CRC32C_H,
      ALU_CRC32_B, ALU_CRC32C_B,
      ALU_BCOMPRESS, ALU_BDECOMPRESS: result_o = multicycle_result;
      ALU_BSET, ALU_BCLR,
      ALU_BINV, ALU_BEXT: result_o = singlebit_result;
      ALU_GREV, ALU_GORC: result_o = rev_result;
      ALU_BFP: result_o = bfp_result;
      ALU_CLMUL, ALU_CLMULR,
      ALU_CLMULH: result_o = clmul_result;
      default: ;
    endcase
  end
  logic unused_shift_amt_compl;
  assign unused_shift_amt_compl = shift_amt_compl[5];
endmodule
module ibex_branch_predict (
  input  logic clk_i,
  input  logic rst_ni,
  input  logic [31:0] fetch_rdata_i,
  input  logic [31:0] fetch_pc_i,
  input  logic        fetch_valid_i,
  output logic        predict_branch_taken_o,
  output logic [31:0] predict_branch_pc_o
);
  import ibex_pkg::*;
  logic [31:0] imm_j_type;
  logic [31:0] imm_b_type;
  logic [31:0] imm_cj_type;
  logic [31:0] imm_cb_type;
  logic [31:0] branch_imm;
  logic [31:0] instr;
  logic instr_j;
  logic instr_b;
  logic instr_cj;
  logic instr_cb;
  logic instr_b_taken;
  assign instr = fetch_rdata_i;
  assign imm_j_type = { {12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0 };
  assign imm_b_type = { {19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0 };
  assign imm_cj_type = { {20{instr[12]}}, instr[12], instr[8], instr[10:9], instr[6], instr[7],
    instr[2], instr[11], instr[5:3], 1'b0 };
  assign imm_cb_type = { {23{instr[12]}}, instr[12], instr[6:5], instr[2], instr[11:10],
    instr[4:3], 1'b0};
  assign instr_b = opcode_e'(instr[6:0]) == OPCODE_BRANCH;
  assign instr_j = opcode_e'(instr[6:0]) == OPCODE_JAL;
  assign instr_cb = (instr[1:0] == 2'b01) & ((instr[15:13] == 3'b110) | (instr[15:13] == 3'b111));
  assign instr_cj = (instr[1:0] == 2'b01) & ((instr[15:13] == 3'b101) | (instr[15:13] == 3'b001));
  always_comb begin
    branch_imm = imm_b_type;
    unique case (1'b1)
      instr_j  : branch_imm = imm_j_type;
      instr_b  : branch_imm = imm_b_type;
      instr_cj : branch_imm = imm_cj_type;
      instr_cb : branch_imm = imm_cb_type;
      default : ;
    endcase
  end
  assign instr_b_taken = (instr_b & imm_b_type[31]) | (instr_cb & imm_cb_type[31]);
  assign predict_branch_taken_o = fetch_valid_i & (instr_j | instr_cj | instr_b_taken);
  assign predict_branch_pc_o    = fetch_pc_i + branch_imm;
endmodule
module ibex_compressed_decoder #(
  parameter ibex_pkg::rv32zc_e RV32ZC   = ibex_pkg::RV32ZcaZcbZcmp,
  parameter bit                ResetAll = 1'b0
) (
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic                 valid_i,
  input  logic                 id_in_ready_i,
  input  logic [31:0]          instr_i,
  output logic [31:0]          instr_o,
  output logic                 is_compressed_o,
  output ibex_pkg::instr_exp_e gets_expanded_o,
  input  logic                 flush_expanded_i,
  output logic                 illegal_instr_o
);
  import ibex_pkg::*;
  if (!(RV32ZC == RV32ZcaZcbZcmp || RV32ZC == RV32ZcaZcmp)) begin : gen_unused_valid
    logic unused_valid;
    logic unused_id_in_ready;
    assign unused_valid = valid_i;
    assign unused_id_in_ready = id_in_ready_i;
  end
  function automatic logic [6:0] cm_stack_adj_base(input logic [3:0] rlist);
    unique case (rlist)
      4'd4, 4'd5, 4'd6, 4'd7:   return 7'd16;
      4'd8, 4'd9, 4'd10, 4'd11: return 7'd32;
      4'd12, 4'd13, 4'd14:      return 7'd48;
      4'd15:                    return 7'd64;
      default:                  return 7'd0;  
    endcase
  endfunction
  function automatic logic [6:0] cm_stack_adj(input logic [3:0] rlist, input logic [1:0] spimm);
    return cm_stack_adj_base(rlist) + spimm * 16;
  endfunction
  function automatic logic [4:0] cm_stack_adj_word(input logic [3:0] rlist,
                                                   input logic [1:0] spimm);
    logic [6:0] tmp;
    logic [1:0] unused_tmp;
    tmp = cm_stack_adj(.rlist(rlist), .spimm(spimm));
    unused_tmp = tmp[1:0];
    return tmp[6:2];
  endfunction
  function automatic logic [4:0] cm_rlist_top_reg(input logic [4:0] rlist);
    unique case (rlist)
      5'd16,  
      5'd15, 5'd14, 5'd13,
      5'd12, 5'd11, 5'd10,
      5'd9, 5'd8, 5'd7:     return 5'd11 + rlist;
      5'd6, 5'd5:           return 5'd3 + rlist;
      5'd4:                 return 5'd1;
      default:              return 5'd0;  
    endcase
  endfunction
  function automatic logic [31:0] cm_push_store_reg(input logic [4:0] rlist,
                                                    input logic [4:0] sp_offset);
    logic [11:0] neg_offset;
    logic signed [11:0] neg_offset_signed;
    logic [31:0] instr;
    neg_offset_signed = -signed'({5'b00000, sp_offset, 2'b00});
    neg_offset = unsigned'(neg_offset_signed);
    instr[ 6: 0]   = OPCODE_STORE;
    instr[11: 7]   = neg_offset[4:0];
    instr[14:12]   = 3'b010;  
    instr[19:15]   = 5'd2;  
    instr[24:20]   = cm_rlist_top_reg(rlist);
    instr[31:25]   = neg_offset[11:5];
    return instr;
  endfunction
  function automatic logic [31:0] cm_pop_load_reg(input logic [4:0] rlist,
                                                  input logic [4:0] sp_offset);
    logic [31:0] instr;
    instr[ 6: 0]   = OPCODE_LOAD;
    instr[11: 7]   = cm_rlist_top_reg(rlist);
    instr[14:12]   = 3'b010;  
    instr[19:15]   = 5'd2;  
    instr[31:20]   = {5'b00000, sp_offset, 2'b00};
    return instr;
  endfunction
  function automatic logic [31:0] cm_sp_addi(input logic [3:0] rlist,
                                             input logic [1:0] spimm,
                                             input logic decr = 1'b0);
    logic [11:0] imm;
    logic signed [11:0] imm_signed;
    logic [31:0] instr;
    imm[11:7] = '0;
    imm[ 6:0] = cm_stack_adj(.rlist(rlist), .spimm(spimm));
    imm_signed = decr ? -signed'(imm) : signed'(imm);
    instr[ 6: 0]   = OPCODE_OP_IMM;
    instr[11: 7]   = 5'd2;  
    instr[14:12]   = 3'b000;  
    instr[19:15]   = 5'd2;  
    instr[31:20]   = unsigned'(imm_signed);
    return instr;
  endfunction
  function automatic logic [31:0] cm_mv_reg(input logic [4:0] src, input logic [4:0] dst);
    logic [31:0] instr;
    instr[ 6: 0]   = OPCODE_OP_IMM;
    instr[11: 7]   = dst;
    instr[14:12]   = 3'b000;  
    instr[19:15]   = src;
    instr[31:20]   = 12'd0;  
    return instr;
  endfunction
  function automatic logic [31:0] cm_zero_a0();
    return cm_mv_reg(.src(5'd0  ), .dst(5'd10  ));
  endfunction
  function automatic logic [31:0] cm_ret_ra();
    logic [31:0] instr;
    instr[ 6: 0]   = OPCODE_JALR;
    instr[11: 7]   = 5'd0;  
    instr[14:12]   = 3'b000;  
    instr[19:15]   = 5'd1;  
    instr[31:20]   = 12'd0;  
    return instr;
  endfunction
  function automatic logic [31:0] cm_mvsa01(input logic a01, input logic [2:0] rs);
    logic [4:0] src, dst;
    src = 5'd10 + {4'd0, a01};
    dst = {(rs[2:1] > 2'd0), (rs[2:1] == 2'd0), rs[2:0]};
    return cm_mv_reg(.src(src), .dst(dst));
  endfunction
  function automatic logic [31:0] cm_mva01s(input logic [2:0] rs, input logic a01);
    logic [4:0] src, dst;
    src = {(rs[2:1] > 2'd0), (rs[2:1] == 2'd0), rs[2:0]};
    dst = 5'd10 + {4'd0, a01};
    return cm_mv_reg(.src(src), .dst(dst));
  endfunction
  function automatic logic [4:0] cm_rlist_init(input logic [3:0] instr_rlist);
    logic [4:0] rlist;
    rlist = {1'b0, instr_rlist};
    if (rlist == 5'd15) begin
      rlist = 5'd16;
    end
    return rlist;
  endfunction
  typedef enum logic [2:0] {
    CmIdle,
    CmPushStoreReg,
    CmPushDecrSp,
    CmPopLoadReg,
    CmPopIncrSp,
    CmPopZeroA0,
    CmPopRetRa,
    CmMvSecondReg
  } cm_state_e;
  logic [4:0] cm_rlist_d, cm_rlist_q;
  logic [4:0] cm_sp_offset_d, cm_sp_offset_q;
  cm_state_e  cm_state_d, cm_state_q;
  ibex_pkg::instr_exp_e gets_expanded;
  if (RV32ZC == RV32ZcaZcbZcmp || RV32ZC == RV32ZcaZcmp) begin : gen_gets_expanded
    assign gets_expanded_o = valid_i ? gets_expanded : INSTR_NOT_EXPANDED;
  end else begin : gen_gets_expanded
    assign gets_expanded_o = gets_expanded;
  end
  always_comb begin
    instr_o         = instr_i;
    illegal_instr_o = 1'b0;
    gets_expanded   = INSTR_NOT_EXPANDED;
    cm_rlist_d     = cm_rlist_q;
    cm_sp_offset_d = cm_sp_offset_q;
    cm_state_d     = cm_state_q;
    unique case (instr_i[1:0])
      2'b00: begin
        unique case (instr_i[15:13])
          3'b000: begin
            instr_o = {2'b0, instr_i[10:7], instr_i[12:11], instr_i[5],
                       instr_i[6], 2'b00, 5'h02, 3'b000, 2'b01, instr_i[4:2], {OPCODE_OP_IMM}};
            if (instr_i[12:5] == 8'b0)  illegal_instr_o = 1'b1;
          end
          3'b010: begin
            instr_o = {5'b0, instr_i[5], instr_i[12:10], instr_i[6],
                       2'b00, 2'b01, instr_i[9:7], 3'b010, 2'b01, instr_i[4:2], {OPCODE_LOAD}};
          end
          3'b110: begin
            instr_o = {5'b0, instr_i[5], instr_i[12], 2'b01, instr_i[4:2],
                       2'b01, instr_i[9:7], 3'b010, instr_i[11:10], instr_i[6],
                       2'b00, {OPCODE_STORE}};
          end
          3'b100: begin  
            if (RV32ZC == RV32ZcaZcbZcmp || RV32ZC == RV32ZcaZcb) begin
              unique case (instr_i[12:10])
                3'b000: begin
                    instr_o = {10'b0, instr_i[5], instr_i[6], 2'b01, instr_i[9:7],
                               3'b100, 2'b01, instr_i[4:2], {OPCODE_LOAD}};
                end
                3'b001: begin
                    unique case (instr_i[6])
                      1'b0: begin
                        instr_o = {10'b0, instr_i[5], 1'b0, 2'b01, instr_i[9:7],
                                   3'b101, 2'b01, instr_i[4:2], {OPCODE_LOAD}};
                      end
                      1'b1: begin
                          instr_o = {10'b0, instr_i[5], 1'b0, 2'b01, instr_i[9:7],
                                     3'b001, 2'b01, instr_i[4:2], {OPCODE_LOAD}};
                      end
                      default: begin
                        illegal_instr_o = 1'b1;
                      end
                    endcase
                end
                3'b010: begin
                    instr_o = {7'b0, 2'b01, instr_i[4:2], 2'b01, instr_i[9:7],
                               3'b000, 3'b0, instr_i[5], instr_i[6], {OPCODE_STORE}};
                end
                3'b011: begin
                    unique case (instr_i[6])
                      1'b0: begin
                        instr_o = {7'b0, 2'b01, instr_i[4:2], 2'b01, instr_i[9:7],
                                   3'b001, 3'b0, instr_i[5], 1'b0, {OPCODE_STORE}};
                      end
                      1'b1: begin
                        illegal_instr_o = 1'b1;
                      end
                      default: begin
                        illegal_instr_o = 1'b1;
                      end
                    endcase
                end
                default: begin
                  illegal_instr_o = 1'b1;
                end
              endcase  
            end else begin
              illegal_instr_o = 1'b1;
            end
          end
          3'b001,
          3'b011,
          3'b101,
          3'b111: begin
            illegal_instr_o = 1'b1;
          end
          default: begin
            illegal_instr_o = 1'b1;
          end
        endcase
      end
      2'b01: begin
        unique case (instr_i[15:13])
          3'b000: begin
            instr_o = {{6 {instr_i[12]}}, instr_i[12], instr_i[6:2],
                       instr_i[11:7], 3'b0, instr_i[11:7], {OPCODE_OP_IMM}};
          end
          3'b001, 3'b101: begin
            instr_o = {instr_i[12], instr_i[8], instr_i[10:9], instr_i[6],
                       instr_i[7], instr_i[2], instr_i[11], instr_i[5:3],
                       {9 {instr_i[12]}}, 4'b0, ~instr_i[15], {OPCODE_JAL}};
          end
          3'b010: begin
            instr_o = {{6 {instr_i[12]}}, instr_i[12], instr_i[6:2], 5'b0,
                       3'b0, instr_i[11:7], {OPCODE_OP_IMM}};
          end
          3'b011: begin
            instr_o = {{15 {instr_i[12]}}, instr_i[6:2], instr_i[11:7], {OPCODE_LUI}};
            if (instr_i[11:7] == 5'h02) begin
              instr_o = {{3 {instr_i[12]}}, instr_i[4:3], instr_i[5], instr_i[2],
                         instr_i[6], 4'b0, 5'h02, 3'b000, 5'h02, {OPCODE_OP_IMM}};
            end
            if ({instr_i[12], instr_i[6:2]} == 6'b0) illegal_instr_o = 1'b1;
          end
          3'b100: begin
            unique case (instr_i[11:10])
              2'b00,
              2'b01: begin
                instr_o = {1'b0, instr_i[10], 5'b0, instr_i[6:2], 2'b01, instr_i[9:7],
                           3'b101, 2'b01, instr_i[9:7], {OPCODE_OP_IMM}};
                if (instr_i[12] == 1'b1)  illegal_instr_o = 1'b1;
              end
              2'b10: begin
                instr_o = {{6 {instr_i[12]}}, instr_i[12], instr_i[6:2], 2'b01, instr_i[9:7],
                           3'b111, 2'b01, instr_i[9:7], {OPCODE_OP_IMM}};
              end
              2'b11: begin
                unique case ({instr_i[12], instr_i[6:5]})
                  3'b000: begin
                    instr_o = {2'b01, 5'b0, 2'b01, instr_i[4:2], 2'b01, instr_i[9:7],
                               3'b000, 2'b01, instr_i[9:7], {OPCODE_OP}};
                  end
                  3'b001: begin
                    instr_o = {7'b0, 2'b01, instr_i[4:2], 2'b01, instr_i[9:7], 3'b100,
                               2'b01, instr_i[9:7], {OPCODE_OP}};
                  end
                  3'b010: begin
                    instr_o = {7'b0, 2'b01, instr_i[4:2], 2'b01, instr_i[9:7], 3'b110,
                               2'b01, instr_i[9:7], {OPCODE_OP}};
                  end
                  3'b011: begin
                    instr_o = {7'b0, 2'b01, instr_i[4:2], 2'b01, instr_i[9:7], 3'b111,
                               2'b01, instr_i[9:7], {OPCODE_OP}};
                  end
                  3'b100,
                  3'b101: begin
                    illegal_instr_o = 1'b1;
                  end
                  3'b110: begin
                    if (RV32ZC == RV32ZcaZcbZcmp || RV32ZC == RV32ZcaZcb) begin
                      instr_o = {7'b0000001, 2'b01, instr_i[4:2], 2'b01, instr_i[9:7],
                                 3'b000, 2'b01, instr_i[9:7], {OPCODE_OP}};
                    end else begin
                      illegal_instr_o = 1'b1;
                    end
                  end
                  3'b111: begin
                    if (RV32ZC == RV32ZcaZcbZcmp || RV32ZC == RV32ZcaZcb) begin
                      unique case ({instr_i[4:2]})
                        3'b000: begin
                          instr_o = {4'b0, 8'hff, 2'b01, instr_i[9:7], 3'b111,
                                     2'b01, instr_i[9:7], {OPCODE_OP_IMM}};
                        end
                        3'b001: begin
                          instr_o = {7'b0110000, 5'b00100, 2'b01, instr_i[9:7],
                                     3'b001, 2'b01, instr_i[9:7], {OPCODE_OP_IMM}};
                        end
                        3'b010: begin
                          instr_o = {7'b0000100, 5'b0, 2'b01, instr_i[9:7],
                                     3'b100, 2'b01, instr_i[9:7], {OPCODE_OP}};
                        end
                        3'b011: begin
                          instr_o = {7'b0110000, 5'b00101, 2'b01, instr_i[9:7],
                                     3'b001, 2'b01, instr_i[9:7], {OPCODE_OP_IMM}};
                        end
                        3'b100: begin
                          illegal_instr_o = 1'b1;
                        end
                        3'b101: begin
                          instr_o = {12'hfff, 2'b01, instr_i[9:7], 3'b100,
                                     2'b01, instr_i[9:7], {OPCODE_OP_IMM}};
                        end
                        default: begin
                          illegal_instr_o = 1'b1;
                        end
                      endcase
                    end else begin
                      illegal_instr_o = 1'b1;
                    end
                  end
                  default: begin
                    illegal_instr_o = 1'b1;
                  end
                endcase
              end
              default: begin
                illegal_instr_o = 1'b1;
              end
            endcase
          end
          3'b110, 3'b111: begin
            instr_o = {{4 {instr_i[12]}}, instr_i[6:5], instr_i[2], 5'b0, 2'b01,
                       instr_i[9:7], 2'b00, instr_i[13], instr_i[11:10], instr_i[4:3],
                       instr_i[12], {OPCODE_BRANCH}};
          end
          default: begin
            illegal_instr_o = 1'b1;
          end
        endcase
      end
      2'b10: begin
        unique case (instr_i[15:13])
          3'b000: begin
            instr_o = {7'b0, instr_i[6:2], instr_i[11:7], 3'b001, instr_i[11:7], {OPCODE_OP_IMM}};
            if (instr_i[12] == 1'b1)  illegal_instr_o = 1'b1;  
          end
          3'b010: begin
            instr_o = {4'b0, instr_i[3:2], instr_i[12], instr_i[6:4], 2'b00, 5'h02,
                       3'b010, instr_i[11:7], OPCODE_LOAD};
            if (instr_i[11:7] == 5'b0)  illegal_instr_o = 1'b1;
          end
          3'b100: begin
            if (instr_i[12] == 1'b0) begin
              if (instr_i[6:2] != 5'b0) begin
                instr_o = {7'b0, instr_i[6:2], 5'b0, 3'b0, instr_i[11:7], {OPCODE_OP}};
              end else begin
                instr_o = {12'b0, instr_i[11:7], 3'b0, 5'b0, {OPCODE_JALR}};
                if (instr_i[11:7] == 5'b0) illegal_instr_o = 1'b1;
              end
            end else begin
              if (instr_i[6:2] != 5'b0) begin
                instr_o = {7'b0, instr_i[6:2], instr_i[11:7], 3'b0, instr_i[11:7], {OPCODE_OP}};
              end else begin
                if (instr_i[11:7] == 5'b0) begin
                  instr_o = {32'h00_10_00_73};
                end else begin
                  instr_o = {12'b0, instr_i[11:7], 3'b000, 5'b00001, {OPCODE_JALR}};
                end
              end
            end
          end
          3'b101: begin
            if (RV32ZC == RV32ZcaZcbZcmp || RV32ZC == RV32ZcaZcmp) begin
              unique casez (instr_i[12:8])
                5'b11000: begin
                  gets_expanded = INSTR_EXPANDED;
                  unique case (cm_state_q)
                    CmIdle: begin
                      cm_rlist_d = cm_rlist_init(instr_i[7:4]);
                      instr_o = cm_push_store_reg(.rlist(cm_rlist_d), .sp_offset(5'd1));
                      if (cm_rlist_d <= 5'd3) begin
                        illegal_instr_o = 1'b1;
                      end else if (cm_rlist_d == 5'd4) begin
                        if (valid_i && id_in_ready_i) begin
                          cm_state_d = CmPushDecrSp;
                        end
                      end else begin
                        cm_rlist_d -= 5'd1;
                        cm_sp_offset_d = 5'd2;
                        if (valid_i && id_in_ready_i) begin
                          cm_state_d = CmPushStoreReg;
                        end
                      end
                    end
                    CmPushStoreReg: begin
                      instr_o = cm_push_store_reg(.rlist(cm_rlist_q), .sp_offset(cm_sp_offset_q));
                      if (id_in_ready_i) begin
                        cm_rlist_d = cm_rlist_q - 5'd1;
                        cm_sp_offset_d = cm_sp_offset_q + 5'd1;
                        if (cm_rlist_q == 5'd4) begin
                          cm_state_d = CmPushDecrSp;
                        end
                      end
                    end
                    CmPushDecrSp: begin
                      instr_o = cm_sp_addi(.rlist(instr_i[7:4]), .spimm(instr_i[3:2]), .decr(1'b1));
                      if (id_in_ready_i) begin
                        gets_expanded = INSTR_EXPANDED_LAST;
                        cm_state_d = CmIdle;
                      end
                    end
                    default: cm_state_d = CmIdle;
                  endcase
                end
                5'b11010,
                5'b11100,
                5'b11110: begin
                  gets_expanded = INSTR_EXPANDED;
                  unique case (cm_state_q)
                    CmIdle: begin
                      cm_rlist_d = cm_rlist_init(instr_i[7:4]);
                      cm_sp_offset_d = cm_stack_adj_word(.rlist(instr_i[7:4]),
                                                        .spimm(instr_i[3:2])) - 5'd1;
                      instr_o = cm_pop_load_reg(.rlist(cm_rlist_d), .sp_offset(cm_sp_offset_d));
                      if (cm_rlist_d <= 5'd3) begin
                        illegal_instr_o = 1'b1;
                      end else if (cm_rlist_d == 5'd4) begin
                        if (valid_i && id_in_ready_i) begin
                          cm_state_d = CmPopIncrSp;
                        end
                      end else begin
                        cm_rlist_d -= 5'd1;
                        cm_sp_offset_d -= 5'd1;
                        if (valid_i && id_in_ready_i) begin
                          cm_state_d = CmPopLoadReg;
                        end
                      end
                    end
                    CmPopLoadReg: begin
                      instr_o = cm_pop_load_reg(.rlist(cm_rlist_q), .sp_offset(cm_sp_offset_q));
                      if (id_in_ready_i) begin
                        cm_rlist_d = cm_rlist_q - 5'd1;
                        cm_sp_offset_d = cm_sp_offset_q - 5'd1;
                        if (cm_rlist_q == 5'd4) begin
                          cm_state_d = CmPopIncrSp;
                        end
                      end
                    end
                    CmPopIncrSp: begin
                      instr_o = cm_sp_addi(.rlist(instr_i[7:4]),
                                          .spimm(instr_i[3:2]),
                                          .decr(1'b0));
                      gets_expanded = INSTR_EXPANDED_COMMIT;
                      if (id_in_ready_i) begin
                        unique case (instr_i[12:8])
                          5'b11100: cm_state_d = CmPopZeroA0;  
                          5'b11110: cm_state_d = CmPopRetRa;   
                          default: begin  
                            gets_expanded = INSTR_EXPANDED_LAST;
                            cm_state_d = CmIdle;
                          end
                        endcase
                      end
                    end
                    CmPopZeroA0: begin
                      instr_o = cm_zero_a0();
                      gets_expanded = INSTR_EXPANDED_COMMIT;
                      if (id_in_ready_i) begin
                        cm_state_d = CmPopRetRa;
                      end
                    end
                    CmPopRetRa: begin
                      instr_o = cm_ret_ra();
                      if (id_in_ready_i) begin
                        gets_expanded = INSTR_EXPANDED_LAST;
                        cm_state_d = CmIdle;
                      end
                    end
                    default: cm_state_d = CmIdle;
                  endcase
                end
                5'b011??: begin
                  unique case (instr_i[6:5])
                    2'b01: begin
                      gets_expanded = INSTR_EXPANDED;
                      unique case (cm_state_q)
                        CmIdle: begin
                          instr_o = cm_mvsa01(.a01(1'b0), .rs(instr_i[9:7]));
                          gets_expanded = INSTR_EXPANDED_COMMIT;
                          if (valid_i && id_in_ready_i) begin
                            cm_state_d = CmMvSecondReg;
                          end
                        end
                        CmMvSecondReg: begin
                          instr_o = cm_mvsa01(.a01(1'b1), .rs(instr_i[4:2]));
                          if (id_in_ready_i) begin
                            gets_expanded = INSTR_EXPANDED_LAST;
                            cm_state_d = CmIdle;
                          end
                        end
                        default: cm_state_d = CmIdle;
                      endcase
                    end
                    2'b11: begin
                      gets_expanded = INSTR_EXPANDED;
                      unique case (cm_state_q)
                        CmIdle: begin
                          instr_o = cm_mva01s(.rs(instr_i[9:7]), .a01(1'b0));
                          gets_expanded = INSTR_EXPANDED_COMMIT;
                          if (valid_i && id_in_ready_i) begin
                            cm_state_d = CmMvSecondReg;
                          end
                        end
                        CmMvSecondReg: begin
                          instr_o = cm_mva01s(.rs(instr_i[4:2]), .a01(1'b1));
                          if (id_in_ready_i) begin
                            gets_expanded = INSTR_EXPANDED_LAST;
                            cm_state_d = CmIdle;
                          end
                        end
                        default: cm_state_d = CmIdle;
                      endcase
                    end
                    default: illegal_instr_o = 1'b1;
                  endcase
                end
                default: illegal_instr_o = 1'b1;
              endcase
            end else begin
              illegal_instr_o = 1'b1;
            end
          end
          3'b110: begin
            instr_o = {4'b0, instr_i[8:7], instr_i[12], instr_i[6:2], 5'h02, 3'b010,
                       instr_i[11:9], 2'b00, {OPCODE_STORE}};
          end
          3'b001,
          3'b011,
          3'b111: begin
            illegal_instr_o = 1'b1;
          end
          default: begin
            illegal_instr_o = 1'b1;
          end
        endcase
      end
      2'b11:;
      default: begin
        illegal_instr_o = 1'b1;
      end
    endcase
  end
  assign is_compressed_o = (instr_i[1:0] != 2'b11);
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      cm_state_q <= CmIdle;
    end else begin
      cm_state_q <= flush_expanded_i ? CmIdle : cm_state_d;
    end
  end
  if (ResetAll) begin : g_cm_meta_ra
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        cm_rlist_q     <= '0;
        cm_sp_offset_q <= '0;
      end else begin
        cm_rlist_q     <= cm_rlist_d;
        cm_sp_offset_q <= cm_sp_offset_d;
      end
    end
  end else begin : g_cm_meta_nr
    always_ff @(posedge clk_i) begin
      cm_rlist_q     <= cm_rlist_d;
      cm_sp_offset_q <= cm_sp_offset_d;
    end
  end
endmodule
module ibex_controller #(
  parameter bit WritebackStage  = 1'b0,
  parameter bit BranchPredictor = 1'b0,
  parameter bit MemECC          = 1'b0
 ) (
  input  logic                  clk_i,
  input  logic                  rst_ni,
  output logic                  ctrl_busy_o,              
  input  logic                  illegal_insn_i,           
  input  logic                  ecall_insn_i,             
  input  logic                  mret_insn_i,              
  input  logic                  dret_insn_i,              
  input  logic                  wfi_insn_i,               
  input  logic                  ebrk_insn_i,              
  input  logic                  csr_pipe_flush_i,         
  input  logic                  instr_valid_i,            
  input  logic [31:0]           instr_i,                  
  input  logic [15:0]           instr_compressed_i,       
  input  logic                  instr_is_compressed_i,    
  input  ibex_pkg::instr_exp_e  instr_gets_expanded_i,    
  input  logic                  instr_bp_taken_i,         
  input  logic                  instr_fetch_err_i,        
  input  logic                  instr_fetch_err_plus2_i,  
  input  logic [31:0]           pc_id_i,                  
  output logic                  instr_valid_clear_o,      
  output logic                  id_in_ready_o,            
  output logic                  controller_run_o,         
  input  logic                  instr_exec_i,             
  output logic                  instr_req_o,              
  output logic                  pc_set_o,                 
  output ibex_pkg::pc_sel_e     pc_mux_o,                 
  output logic                  nt_branch_mispredict_o,   
  output ibex_pkg::exc_pc_sel_e exc_pc_mux_o,             
  output ibex_pkg::exc_cause_t  exc_cause_o,              
  input  logic [31:0]           lsu_addr_last_i,          
  input  logic                  load_err_i,
  input  logic                  store_err_i,
  input  logic                  mem_resp_intg_err_i,
  output logic                  wb_exception_o,           
  output logic                  id_exception_o,           
  input  logic                  branch_set_i,             
  input  logic                  branch_not_set_i,         
  input  logic                  jump_set_i,               
  input  logic                  csr_mstatus_mie_i,        
  input  logic                  irq_pending_i,            
  input  ibex_pkg::irqs_t       irqs_i,                   
  input  logic                  irq_nm_ext_i,             
  output logic                  nmi_mode_o,               
  input  logic                  debug_req_i,
  output ibex_pkg::dbg_cause_e  debug_cause_o,
  output logic                  debug_csr_save_o,
  output logic                  debug_mode_o,
  output logic                  debug_mode_entering_o,
  input  logic                  debug_single_step_i,
  input  logic                  debug_ebreakm_i,
  input  logic                  debug_ebreaku_i,
  input  logic                  trigger_match_i,
  output logic                  csr_save_if_o,
  output logic                  csr_save_id_o,
  output logic                  csr_save_wb_o,
  output logic                  csr_restore_mret_id_o,
  output logic                  csr_restore_dret_id_o,
  output logic                  csr_save_cause_o,
  output logic [31:0]           csr_mtval_o,
  input  ibex_pkg::priv_lvl_e   priv_mode_i,
  input  logic                  stall_id_i,
  input  logic                  stall_wb_i,
  output logic                  flush_id_o,
  input  logic                  ready_wb_i,
  output logic                  perf_jump_o,              
  output logic                  perf_tbranch_o            
);
  import ibex_pkg::*;
  ctrl_fsm_e ctrl_fsm_cs, ctrl_fsm_ns;
  logic nmi_mode_q, nmi_mode_d;
  logic debug_mode_q, debug_mode_d;
  dbg_cause_e debug_cause_d, debug_cause_q;
  logic load_err_q, load_err_d;
  logic store_err_q, store_err_d;
  logic exc_req_q, exc_req_d;
  logic illegal_insn_q, illegal_insn_d;
  logic instr_fetch_err_prio;
  logic illegal_insn_prio;
  logic ecall_insn_prio;
  logic ebrk_insn_prio;
  logic store_err_prio;
  logic load_err_prio;
  logic stall;
  logic halt_if;
  logic retain_id;
  logic flush_id;
  logic exc_req_lsu;
  logic special_req;
  logic special_req_pc_change;
  logic special_req_flush_only;
  logic do_single_step_d;
  logic do_single_step_q;
  logic enter_debug_mode_prio_d;
  logic enter_debug_mode_prio_q;
  logic enter_debug_mode;
  logic ebreak_into_debug;
  logic irq_enabled;
  logic handle_irq;
  logic id_wb_pending;
  logic                     irq_nm;
  logic                     irq_nm_int;
  logic [31:0]              irq_nm_int_mtval;
  ibex_pkg::nmi_int_cause_e irq_nm_int_cause;
  logic [3:0] mfip_id;
  logic       unused_irq_timer;
  logic ecall_insn;
  logic mret_insn;
  logic dret_insn;
  logic wfi_insn;
  logic ebrk_insn;
  logic csr_pipe_flush;
  logic instr_fetch_err;
  always_ff @(negedge clk_i) begin
    if ((ctrl_fsm_cs == DECODE) && instr_valid_i && !instr_fetch_err_i && illegal_insn_d) begin
      $display("%t: Illegal instruction (hart %0x) at PC 0x%h: 0x%h", $time, u_ibex_core.hart_id_i,
               pc_id_i, instr_is_compressed_i ? {16'b0, instr_compressed_i} : instr_i );
    end
  end
  assign load_err_d  = load_err_i;
  assign store_err_d = store_err_i;
  assign ecall_insn      = ecall_insn_i      & instr_valid_i;
  assign mret_insn       = mret_insn_i       & instr_valid_i;
  assign dret_insn       = dret_insn_i       & instr_valid_i;
  assign wfi_insn        = wfi_insn_i        & instr_valid_i;
  assign ebrk_insn       = ebrk_insn_i       & instr_valid_i;
  assign csr_pipe_flush  = csr_pipe_flush_i  & instr_valid_i;
  assign instr_fetch_err = instr_fetch_err_i & instr_valid_i;
  assign illegal_insn_d = illegal_insn_i & (ctrl_fsm_cs != FLUSH);
  assign exc_req_d = (ecall_insn | ebrk_insn | illegal_insn_d | instr_fetch_err) &
                     (ctrl_fsm_cs != FLUSH);
  assign exc_req_lsu = store_err_i | load_err_i;
  assign id_exception_o = exc_req_d & ~wb_exception_o;
  assign special_req_flush_only = wfi_insn | csr_pipe_flush;
  assign special_req_pc_change = mret_insn | dret_insn | exc_req_d | exc_req_lsu;
  assign special_req = special_req_pc_change | special_req_flush_only;
  assign id_wb_pending = instr_valid_i | ~ready_wb_i;
  if (WritebackStage) begin : g_wb_exceptions
    always_comb begin
      instr_fetch_err_prio = 0;
      illegal_insn_prio    = 0;
      ecall_insn_prio      = 0;
      ebrk_insn_prio       = 0;
      store_err_prio       = 0;
      load_err_prio        = 0;
      if (store_err_q) begin
        store_err_prio = 1'b1;
      end else if (load_err_q) begin
        load_err_prio  = 1'b1;
      end else if (instr_fetch_err) begin
        instr_fetch_err_prio = 1'b1;
      end else if (illegal_insn_q) begin
        illegal_insn_prio = 1'b1;
      end else if (ecall_insn) begin
        ecall_insn_prio = 1'b1;
      end else if (ebrk_insn) begin
        ebrk_insn_prio = 1'b1;
      end
    end
    assign wb_exception_o = load_err_q | store_err_q | load_err_i | store_err_i;
  end else begin : g_no_wb_exceptions
    always_comb begin
      instr_fetch_err_prio = 0;
      illegal_insn_prio    = 0;
      ecall_insn_prio      = 0;
      ebrk_insn_prio       = 0;
      store_err_prio       = 0;
      load_err_prio        = 0;
      if (instr_fetch_err) begin
        instr_fetch_err_prio = 1'b1;
      end else if (illegal_insn_q) begin
        illegal_insn_prio = 1'b1;
      end else if (ecall_insn) begin
        ecall_insn_prio = 1'b1;
      end else if (ebrk_insn) begin
        ebrk_insn_prio = 1'b1;
      end else if (store_err_q) begin
        store_err_prio = 1'b1;
      end else if (load_err_q) begin
        load_err_prio  = 1'b1;
      end
    end
    assign wb_exception_o = 1'b0;
  end
  if (MemECC) begin : g_intg_irq_int
    logic        mem_resp_intg_err_irq_pending_q, mem_resp_intg_err_irq_pending_d;
    logic [31:0] mem_resp_intg_err_addr_q, mem_resp_intg_err_addr_d;
    logic        mem_resp_intg_err_irq_set, mem_resp_intg_err_irq_clear;
    logic        entering_nmi;
    assign entering_nmi = nmi_mode_d & ~nmi_mode_q;
    always_comb begin
      mem_resp_intg_err_addr_d        = mem_resp_intg_err_addr_q;
      mem_resp_intg_err_irq_set       = 1'b0;
      mem_resp_intg_err_irq_clear     = 1'b0;
      if (mem_resp_intg_err_irq_pending_q) begin
        if (entering_nmi & !irq_nm_ext_i) begin
          mem_resp_intg_err_irq_clear = 1'b1;
        end
      end else if (mem_resp_intg_err_i) begin
        mem_resp_intg_err_addr_d        = lsu_addr_last_i;
        mem_resp_intg_err_irq_set       = 1'b1;
      end
    end
    assign mem_resp_intg_err_irq_pending_d =
      (mem_resp_intg_err_irq_pending_q & ~mem_resp_intg_err_irq_clear) | mem_resp_intg_err_irq_set;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        mem_resp_intg_err_irq_pending_q <= 1'b0;
        mem_resp_intg_err_addr_q        <= '0;
      end else begin
        mem_resp_intg_err_irq_pending_q <= mem_resp_intg_err_irq_pending_d;
        mem_resp_intg_err_addr_q        <= mem_resp_intg_err_addr_d;
      end
    end
    assign irq_nm_int       = mem_resp_intg_err_irq_pending_q;
    assign irq_nm_int_cause = NMI_INT_CAUSE_ECC;
    assign irq_nm_int_mtval = mem_resp_intg_err_addr_q;
  end else begin : g_no_intg_irq_int
    logic unused_mem_resp_intg_err_i;
    assign unused_mem_resp_intg_err_i = mem_resp_intg_err_i;
    assign irq_nm_int       = 1'b0;
    assign irq_nm_int_cause = nmi_int_cause_e'(0);
    assign irq_nm_int_mtval = '0;
  end
  assign do_single_step_d = instr_valid_i ? ~debug_mode_q & debug_single_step_i : do_single_step_q;
  assign enter_debug_mode_prio_d = (debug_req_i | do_single_step_d) & ~debug_mode_q &
      !(instr_gets_expanded_i inside {INSTR_EXPANDED, INSTR_EXPANDED_COMMIT});
  assign enter_debug_mode = enter_debug_mode_prio_d | (trigger_match_i & ~debug_mode_q) &
      !(instr_gets_expanded_i inside {INSTR_EXPANDED, INSTR_EXPANDED_COMMIT});
  assign ebreak_into_debug = priv_mode_i == PRIV_LVL_M ? debug_ebreakm_i :
                             priv_mode_i == PRIV_LVL_U ? debug_ebreaku_i :
                                                         1'b0;
  assign irq_nm = irq_nm_ext_i | irq_nm_int;
  assign irq_enabled = csr_mstatus_mie_i | (priv_mode_i == PRIV_LVL_U);
  assign handle_irq = ~debug_mode_q & ~debug_single_step_i & ~nmi_mode_q &
      (irq_nm | (irq_pending_i & irq_enabled)) &
      !(instr_gets_expanded_i == INSTR_EXPANDED_COMMIT);
  always_comb begin : gen_mfip_id
    mfip_id = 4'd0;
    for (int i = 14; i >= 0; i--) begin
      if (irqs_i.irq_fast[i]) begin
        mfip_id = i[3:0];
      end
    end
  end
  assign unused_irq_timer = irqs_i.irq_timer;
  assign debug_cause_d = trigger_match_i                    ? DBG_CAUSE_TRIGGER :
                         ebrk_insn_prio & ebreak_into_debug ? DBG_CAUSE_EBREAK  :
                         debug_req_i                        ? DBG_CAUSE_HALTREQ :
                         do_single_step_d                   ? DBG_CAUSE_STEP    :
                                                              DBG_CAUSE_NONE ;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      debug_cause_q <= DBG_CAUSE_NONE;
    end else begin
      debug_cause_q <= debug_cause_d;
    end
  end
  assign debug_cause_o = debug_cause_q;
  always_comb begin
    instr_req_o           = 1'b1;
    csr_save_if_o         = 1'b0;
    csr_save_id_o         = 1'b0;
    csr_save_wb_o         = 1'b0;
    csr_restore_mret_id_o = 1'b0;
    csr_restore_dret_id_o = 1'b0;
    csr_save_cause_o      = 1'b0;
    csr_mtval_o           = '0;
    pc_mux_o               = PC_BOOT;
    pc_set_o               = 1'b0;
    nt_branch_mispredict_o = 1'b0;
    exc_pc_mux_o           = EXC_PC_IRQ;
    exc_cause_o            = ExcCauseInsnAddrMisa;  
    ctrl_fsm_ns            = ctrl_fsm_cs;
    ctrl_busy_o            = 1'b1;
    halt_if                = 1'b0;
    retain_id              = 1'b0;
    flush_id               = 1'b0;
    debug_csr_save_o       = 1'b0;
    debug_mode_d           = debug_mode_q;
    debug_mode_entering_o  = 1'b0;
    nmi_mode_d             = nmi_mode_q;
    perf_tbranch_o         = 1'b0;
    perf_jump_o            = 1'b0;
    controller_run_o       = 1'b0;
    unique case (ctrl_fsm_cs)
      RESET: begin
        instr_req_o   = 1'b0;
        pc_mux_o      = PC_BOOT;
        pc_set_o      = 1'b1;
        ctrl_fsm_ns   = BOOT_SET;
      end
      BOOT_SET: begin
        instr_req_o   = 1'b1;
        pc_mux_o      = PC_BOOT;
        pc_set_o      = 1'b1;
        ctrl_fsm_ns = FIRST_FETCH;
      end
      WAIT_SLEEP: begin
        ctrl_busy_o   = 1'b0;
        instr_req_o   = 1'b0;
        halt_if       = 1'b1;
        flush_id      = 1'b1;
        ctrl_fsm_ns   = SLEEP;
      end
      SLEEP: begin
        instr_req_o   = 1'b0;
        halt_if       = 1'b1;
        flush_id      = 1'b1;
        if (irq_nm || irq_pending_i || debug_req_i || debug_mode_q || debug_single_step_i) begin
          ctrl_fsm_ns = FIRST_FETCH;
        end else begin
          ctrl_busy_o = 1'b0;
        end
      end
      FIRST_FETCH: begin
        if (id_in_ready_o) begin
          ctrl_fsm_ns = DECODE;
        end
        if (handle_irq) begin
          ctrl_fsm_ns = IRQ_TAKEN;
          halt_if     = 1'b1;
        end
        if (enter_debug_mode) begin
          ctrl_fsm_ns = DBG_TAKEN_IF;
          halt_if     = 1'b1;
        end
      end
      DECODE: begin
        controller_run_o = 1'b1;
        pc_mux_o = PC_JUMP;
        if (special_req) begin
          retain_id = 1'b1;
          if (ready_wb_i | wb_exception_o) begin
            ctrl_fsm_ns = FLUSH;
          end
        end
        if (branch_set_i || jump_set_i) begin
          pc_set_o       = BranchPredictor ? ~instr_bp_taken_i : 1'b1;
          perf_tbranch_o = branch_set_i;
          perf_jump_o    = jump_set_i;
        end
        if (BranchPredictor) begin
          if (instr_bp_taken_i & branch_not_set_i) begin
            nt_branch_mispredict_o = 1'b1;
          end
        end
        if ((enter_debug_mode || handle_irq) && (stall || id_wb_pending)) begin
          halt_if = 1'b1;
        end
        if (!stall && !special_req && !id_wb_pending) begin
          if (enter_debug_mode) begin
            ctrl_fsm_ns = DBG_TAKEN_IF;
            halt_if     = 1'b1;
          end else if (handle_irq) begin
            ctrl_fsm_ns = IRQ_TAKEN;
            halt_if     = 1'b1;
          end
        end
      end  
      IRQ_TAKEN: begin
        pc_mux_o     = PC_EXC;
        exc_pc_mux_o = EXC_PC_IRQ;
        if (handle_irq) begin
          pc_set_o         = 1'b1;
          csr_save_if_o    = 1'b1;
          csr_save_cause_o = 1'b1;
          if (irq_nm && !nmi_mode_q) begin
            exc_cause_o =
              irq_nm_ext_i ? ExcCauseIrqNm :
                             '{irq_ext: 1'b0, irq_int: 1'b1, lower_cause: irq_nm_int_cause};
            if (irq_nm_int & !irq_nm_ext_i) begin
              csr_mtval_o = irq_nm_int_mtval;
            end
            nmi_mode_d  = 1'b1;  
          end else if (irqs_i.irq_fast != 15'b0) begin
            exc_cause_o = '{irq_ext: 1'b1, irq_int: 1'b0, lower_cause: {1'b1, mfip_id}};
          end else if (irqs_i.irq_external) begin
            exc_cause_o = ExcCauseIrqExternalM;
          end else if (irqs_i.irq_software) begin
            exc_cause_o = ExcCauseIrqSoftwareM;
          end else begin  
            exc_cause_o = ExcCauseIrqTimerM;
          end
        end
        ctrl_fsm_ns = DECODE;
      end
      DBG_TAKEN_IF: begin
        pc_mux_o     = PC_EXC;
        exc_pc_mux_o = EXC_PC_DBD;
        flush_id         = 1'b1;
        pc_set_o         = 1'b1;
        csr_save_if_o    = 1'b1;
        debug_csr_save_o = 1'b1;
        csr_save_cause_o = 1'b1;
        debug_mode_d          = 1'b1;
        debug_mode_entering_o = 1'b1;
        ctrl_fsm_ns  = DECODE;
      end
      DBG_TAKEN_ID: begin
        flush_id      = 1'b1;
        pc_mux_o      = PC_EXC;
        pc_set_o      = 1'b1;
        exc_pc_mux_o  = EXC_PC_DBD;
        if (ebreak_into_debug && !debug_mode_q) begin  
          csr_save_cause_o = 1'b1;
          csr_save_id_o    = 1'b1;
          debug_csr_save_o = 1'b1;
        end
        debug_mode_d          = 1'b1;
        debug_mode_entering_o = 1'b1;
        ctrl_fsm_ns  = DECODE;
      end
      FLUSH: begin
        halt_if     = 1'b1;
        flush_id    = 1'b1;
        ctrl_fsm_ns = DECODE;
        if (exc_req_q || store_err_q || load_err_q) begin
          pc_set_o         = 1'b1;
          pc_mux_o         = PC_EXC;
          exc_pc_mux_o     = debug_mode_q ? EXC_PC_DBG_EXC : EXC_PC_EXC;
          if (WritebackStage) begin : g_writeback_mepc_save
            csr_save_id_o  = ~(store_err_q | load_err_q);
            csr_save_wb_o  = store_err_q | load_err_q;
          end else begin : g_no_writeback_mepc_save
            csr_save_id_o  = 1'b0;
          end
          csr_save_cause_o = 1'b1;
          unique case (1'b1)
            instr_fetch_err_prio: begin
              exc_cause_o = ExcCauseInstrAccessFault;
              csr_mtval_o = instr_fetch_err_plus2_i ? (pc_id_i + 32'd2) : pc_id_i;
            end
            illegal_insn_prio: begin
              exc_cause_o = ExcCauseIllegalInsn;
              csr_mtval_o = instr_is_compressed_i ? {16'b0, instr_compressed_i} : instr_i;
            end
            ecall_insn_prio: begin
              exc_cause_o = (priv_mode_i == PRIV_LVL_M) ? ExcCauseEcallMMode :
                                                          ExcCauseEcallUMode;
            end
            ebrk_insn_prio: begin
              if (debug_mode_q | ebreak_into_debug) begin
                pc_set_o         = 1'b0;
                csr_save_id_o    = 1'b0;
                csr_save_cause_o = 1'b0;
                ctrl_fsm_ns      = DBG_TAKEN_ID;
                flush_id         = 1'b0;
              end else begin
                exc_cause_o      = ExcCauseBreakpoint;
              end
            end
            store_err_prio: begin
              exc_cause_o = ExcCauseStoreAccessFault;
              csr_mtval_o = lsu_addr_last_i;
            end
            load_err_prio: begin
              exc_cause_o = ExcCauseLoadAccessFault;
              csr_mtval_o = lsu_addr_last_i;
            end
            default: ;
          endcase
        end else begin
          if (mret_insn) begin
            pc_mux_o              = PC_ERET;
            pc_set_o              = 1'b1;
            csr_restore_mret_id_o = 1'b1;
            if (nmi_mode_q) begin
              nmi_mode_d          = 1'b0;  
            end
          end else if (dret_insn) begin
            pc_mux_o              = PC_DRET;
            pc_set_o              = 1'b1;
            debug_mode_d          = 1'b0;
            csr_restore_dret_id_o = 1'b1;
          end else if (wfi_insn) begin
            ctrl_fsm_ns           = WAIT_SLEEP;
          end
        end  
        if (enter_debug_mode_prio_q && !(ebrk_insn_prio && ebreak_into_debug)) begin
          ctrl_fsm_ns = DBG_TAKEN_IF;
        end
      end  
      default: begin
        instr_req_o = 1'b0;
        ctrl_fsm_ns = RESET;
      end
    endcase
    if (~instr_exec_i) begin
      halt_if = 1'b1;
    end
  end
  assign flush_id_o = flush_id;
  assign debug_mode_o = debug_mode_q;
  assign nmi_mode_o = nmi_mode_q;
  assign stall = stall_id_i | stall_wb_i;
  assign id_in_ready_o = ~stall & ~halt_if & ~retain_id;
  assign instr_valid_clear_o = ~(stall | retain_id) | flush_id;
  always_ff @(posedge clk_i or negedge rst_ni) begin : update_regs
    if (!rst_ni) begin
      ctrl_fsm_cs             <= RESET;
      nmi_mode_q              <= 1'b0;
      do_single_step_q        <= 1'b0;
      debug_mode_q            <= 1'b0;
      enter_debug_mode_prio_q <= 1'b0;
      load_err_q              <= 1'b0;
      store_err_q             <= 1'b0;
      exc_req_q               <= 1'b0;
      illegal_insn_q          <= 1'b0;
    end else begin
      ctrl_fsm_cs             <= ctrl_fsm_ns;
      nmi_mode_q              <= nmi_mode_d;
      do_single_step_q        <= do_single_step_d;
      debug_mode_q            <= debug_mode_d;
      enter_debug_mode_prio_q <= enter_debug_mode_prio_d;
      load_err_q              <= load_err_d;
      store_err_q             <= store_err_d;
      exc_req_q               <= exc_req_d;
      illegal_insn_q          <= illegal_insn_d;
    end
  end
    logic fcov_all_debug_req; 
    assign fcov_all_debug_req = debug_req_i || debug_mode_q || debug_single_step_i; 
    logic unused_fcov_all_debug_req; 
    assign unused_fcov_all_debug_req = fcov_all_debug_req;
    logic fcov_debug_wakeup; 
    assign fcov_debug_wakeup = (ctrl_fsm_cs == SLEEP) & (ctrl_fsm_ns == FIRST_FETCH) &                                        (debug_req_i || debug_mode_q || debug_single_step_i); 
    logic unused_fcov_debug_wakeup; 
    assign unused_fcov_debug_wakeup = fcov_debug_wakeup;
    logic fcov_interrupt_taken; 
    assign fcov_interrupt_taken = (ctrl_fsm_cs != IRQ_TAKEN) & (ctrl_fsm_ns == IRQ_TAKEN); 
    logic unused_fcov_interrupt_taken; 
    assign unused_fcov_interrupt_taken = fcov_interrupt_taken;
    logic fcov_debug_entry_if; 
    assign fcov_debug_entry_if = (ctrl_fsm_cs != DBG_TAKEN_IF) & (ctrl_fsm_ns == DBG_TAKEN_IF); 
    logic unused_fcov_debug_entry_if; 
    assign unused_fcov_debug_entry_if = fcov_debug_entry_if;
    logic fcov_debug_entry_id; 
    assign fcov_debug_entry_id = (ctrl_fsm_cs != DBG_TAKEN_ID) & (ctrl_fsm_ns == DBG_TAKEN_ID); 
    logic unused_fcov_debug_entry_id; 
    assign unused_fcov_debug_entry_id = fcov_debug_entry_id;
    logic fcov_pipe_flush; 
    assign fcov_pipe_flush = (ctrl_fsm_cs != FLUSH) & (ctrl_fsm_ns == FLUSH); 
    logic unused_fcov_pipe_flush; 
    assign unused_fcov_pipe_flush = fcov_pipe_flush;
    logic fcov_debug_req; 
    assign fcov_debug_req = debug_req_i & ~debug_mode_q; 
    logic unused_fcov_debug_req; 
    assign unused_fcov_debug_req = fcov_debug_req;
    logic fcov_debug_single_step_taken; 
    assign fcov_debug_single_step_taken = do_single_step_d & ~do_single_step_q; 
    logic unused_fcov_debug_single_step_taken; 
    assign unused_fcov_debug_single_step_taken = fcov_debug_single_step_taken;
    logic rvfi_flush_next;
    assign rvfi_flush_next = ctrl_fsm_ns == FLUSH;
endmodule
module ibex_cs_registers import ibex_pkg::*; #(
  parameter bit                     DbgTriggerEn                = 0,
  parameter int unsigned            DbgHwBreakNum               = 1,
  parameter bit                     DataIndTiming               = 1'b0,
  parameter bit                     DummyInstructions           = 1'b0,
  parameter bit                     ShadowCSR                   = 1'b0,
  parameter bit                     ICache                      = 1'b0,
  parameter int unsigned            MHPMCounterNum              = 10,
  parameter int unsigned            MHPMCounterWidth            = 40,
  parameter bit                     PMPEnable                   = 0,
  parameter int unsigned            PMPGranularity              = 0,
  parameter int unsigned            PMPNumRegions               = 4,
  parameter ibex_pkg::pmp_cfg_t     PMPRstCfg[PMP_MAX_REGIONS]  = ibex_pkg::PmpCfgRst,
  parameter logic [PMP_ADDR_MSB:0]  PMPRstAddr[PMP_MAX_REGIONS] = ibex_pkg::PmpAddrRst,
  parameter ibex_pkg::pmp_mseccfg_t PMPRstMsecCfg               = ibex_pkg::PmpMseccfgRst,
  parameter bit                     RV32E                       = 0,
  parameter ibex_pkg::rv32m_e RV32M                             = ibex_pkg::RV32MFast,
  parameter ibex_pkg::rv32b_e RV32B                             = ibex_pkg::RV32BNone,
  parameter logic [31:0]            CsrMvendorId                = 32'b0,
  parameter logic [31:0]            CsrMimpId                   = 32'b0
) (
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic [31:0]          hart_id_i,
  output ibex_pkg::priv_lvl_e  priv_mode_id_o,
  output ibex_pkg::priv_lvl_e  priv_mode_lsu_o,
  output logic                 csr_mstatus_tw_o,
  output logic [31:0]          csr_mtvec_o,
  input  logic                 csr_mtvec_init_i,
  input  logic [31:0]          boot_addr_i,
  input  logic                 csr_access_i,
  input  ibex_pkg::csr_num_e   csr_addr_i,
  input  logic [31:0]          csr_wdata_i,
  input  ibex_pkg::csr_op_e    csr_op_i,
  input                        csr_op_en_i,
  output logic [31:0]          csr_rdata_o,
  input  logic                 irq_software_i,
  input  logic                 irq_timer_i,
  input  logic                 irq_external_i,
  input  logic [14:0]          irq_fast_i,
  input  logic                 nmi_mode_i,
  output logic                 irq_pending_o,           
  output ibex_pkg::irqs_t      irqs_o,                  
  output logic                 csr_mstatus_mie_o,
  output logic [31:0]          csr_mepc_o,
  output logic [31:0]          csr_mtval_o,
  output ibex_pkg::pmp_cfg_t     csr_pmp_cfg_o  [PMPNumRegions],
  output logic [PMP_ADDR_MSB:0]  csr_pmp_addr_o [PMPNumRegions],
  output ibex_pkg::pmp_mseccfg_t csr_pmp_mseccfg_o,
  input  logic                 debug_mode_i,
  input  logic                 debug_mode_entering_i,
  input  ibex_pkg::dbg_cause_e debug_cause_i,
  input  logic                 debug_csr_save_i,
  output logic [31:0]          csr_depc_o,
  output logic                 debug_single_step_o,
  output logic                 debug_ebreakm_o,
  output logic                 debug_ebreaku_o,
  output logic                 trigger_match_o,
  input  logic [31:0]          pc_if_i,
  input  logic [31:0]          pc_id_i,
  input  logic [31:0]          pc_wb_i,
  output logic                 data_ind_timing_o,
  output logic                 dummy_instr_en_o,
  output logic [2:0]           dummy_instr_mask_o,
  output logic                 dummy_instr_seed_en_o,
  output logic [31:0]          dummy_instr_seed_o,
  output logic                 icache_enable_o,
  output logic                 csr_shadow_err_o,
  input  logic                 ic_scr_key_valid_i,
  input  ibex_mubi_t           mcounteren_writable_i,
  input  logic                 csr_save_if_i,
  input  logic                 csr_save_id_i,
  input  logic                 csr_save_wb_i,
  input  logic                 csr_restore_mret_i,
  input  logic                 csr_restore_dret_i,
  input  logic                 csr_save_cause_i,
  input  ibex_pkg::exc_cause_t csr_mcause_i,
  input  logic [31:0]          csr_mtval_i,
  output logic                 illegal_csr_insn_o,      
  output logic                 double_fault_seen_o,
  input  logic                 instr_ret_i,                  
  input  logic                 instr_ret_compressed_i,       
  input  logic                 instr_ret_spec_i,             
  input  logic                 instr_ret_compressed_spec_i,  
  input  logic                 iside_wait_i,                 
  input  logic                 jump_i,                       
  input  logic                 branch_i,                     
  input  logic                 branch_taken_i,               
  input  logic                 mem_load_i,                   
  input  logic                 mem_store_i,                  
  input  logic                 dside_wait_i,                 
  input  logic                 mul_wait_i,                   
  input  logic                 div_wait_i                    
);
  function automatic logic is_mml_m_exec_cfg(ibex_pkg::pmp_cfg_t pmp_cfg);
    logic unused_cfg = ^{pmp_cfg.mode};
    logic value = 1'b0;
    if (pmp_cfg.lock) begin
      unique case ({pmp_cfg.read, pmp_cfg.write, pmp_cfg.exec})
        3'b001, 3'b010, 3'b011, 3'b101: value = 1'b1;
        default: value = 1'b0;
      endcase
    end
    return value;
  endfunction
  localparam int unsigned RV32BExtra   = (RV32B != RV32BNone) ? 1 : 0;
  localparam int unsigned RV32MEnabled = (RV32M == RV32MNone) ? 0 : 1;
  localparam int unsigned PMPAddrWidth = (PMPGranularity > 0) ? PMP_ADDR_MSB - PMPGranularity : 32;
  localparam int unsigned MHPMCOUNTER_BASE = 3;
  localparam logic [31:0] MISA_VALUE =
      (0                 <<  0)   
    | (0                 <<  1)   
    | (1                 <<  2)   
    | (0                 <<  3)   
    | (32'(RV32E)        <<  4)   
    | (0                 <<  5)   
    | (32'(!RV32E)       <<  8)   
    | (RV32MEnabled      << 12)   
    | (0                 << 13)   
    | (0                 << 18)   
    | (1                 << 20)   
    | (RV32BExtra        << 23)   
    | (32'(CSR_MISA_MXL) << 30);  
  typedef struct packed {
    logic      mie;
    logic      mpie;
    priv_lvl_e mpp;
    logic      mprv;
    logic      tw;
  } status_t;
  typedef struct packed {
    logic      mpie;
    priv_lvl_e mpp;
  } status_stk_t;
  typedef struct packed {
      x_debug_ver_e xdebugver;
      logic [11:0]  zero2;
      logic         ebreakm;
      logic         zero1;
      logic         ebreaks;
      logic         ebreaku;
      logic         stepie;
      logic         stopcount;
      logic         stoptime;
      dbg_cause_e   cause;
      logic         zero0;
      logic         mprven;
      logic         nmip;
      logic         step;
      priv_lvl_e    prv;
  } dcsr_t;
  typedef struct packed {
    logic        double_fault_seen;
    logic        sync_exc_seen;
    logic [2:0]  dummy_instr_mask;
    logic        dummy_instr_en;
    logic        data_ind_timing;
    logic        icache_enable;
  } cpu_ctrl_sts_part_t;
  logic [31:0] exception_pc;
  priv_lvl_e   priv_lvl_q, priv_lvl_d;
  status_t     mstatus_q, mstatus_d;
  logic        mstatus_err;
  logic        mstatus_en;
  irqs_t       mie_q, mie_d;
  logic        mie_en;
  logic [31:0] mscratch_q;
  logic        mscratch_en;
  logic [31:0] mepc_q, mepc_d;
  logic        mepc_en;
  exc_cause_t  mcause_q, mcause_d;
  logic        mcause_en;
  logic [31:0] mtval_q, mtval_d;
  logic        mtval_en;
  logic [31:0] mtvec_q, mtvec_d;
  logic        mtvec_err;
  logic        mtvec_en;
  irqs_t       mip;
  dcsr_t       dcsr_q, dcsr_d;
  logic        dcsr_en;
  logic [31:0] depc_q, depc_d;
  logic        depc_en;
  logic [31:0] dscratch0_q;
  logic [31:0] dscratch1_q;
  logic        dscratch0_en, dscratch1_en;
  status_stk_t mstack_q, mstack_d;
  logic        mstack_en;
  logic [31:0] mstack_epc_q, mstack_epc_d;
  exc_cause_t  mstack_cause_q, mstack_cause_d;
  logic [31:0]                 pmp_addr_rdata  [PMP_MAX_REGIONS];
  logic [PMP_CFG_W-1:0]        pmp_cfg_rdata   [PMP_MAX_REGIONS];
  logic                        pmp_csr_err;
  pmp_mseccfg_t                pmp_mseccfg;
  logic [31:0]                                mcountinhibit;
  logic [MHPMCounterNum+MHPMCOUNTER_BASE-1:0] mcountinhibit_d, mcountinhibit_q;
  logic                                       mcountinhibit_we;
  logic [31:0]                                mcounteren;
  logic [MHPMCounterNum+MHPMCOUNTER_BASE-1:0] mcounteren_d, mcounteren_q;
  logic                                       mcounteren_we;
  logic [63:0] mhpmcounter [32];
  logic [31:0] mhpmcounter_we;
  logic [31:0] mhpmcounterh_we;
  logic [31:0] mhpmcounter_incr;
  logic [31:0] mhpmevent [32];
  logic  [4:0] mhpmcounter_idx;
  logic        unused_mhpmcounter_we_1;
  logic        unused_mhpmcounterh_we_1;
  logic        unused_mhpmcounter_incr_1;
  logic [63:0] minstret_next, minstret_raw;
  logic [31:0] tselect_rdata;
  logic [31:0] tmatch_control_rdata;
  logic [31:0] tmatch_value_rdata;
  cpu_ctrl_sts_part_t cpuctrlsts_part_q, cpuctrlsts_part_d;
  cpu_ctrl_sts_part_t cpuctrlsts_part_wdata_raw, cpuctrlsts_part_wdata;
  logic               cpuctrlsts_part_we;
  logic               cpuctrlsts_part_err;
  logic cpuctrlsts_ic_scr_key_valid_q;
  logic cpuctrlsts_ic_scr_key_err;
  logic [31:0] csr_wdata_int;
  logic [31:0] csr_rdata_int;
  logic        csr_we_int;
  logic        csr_wr;
  logic        dbg_csr;
  logic        illegal_csr;
  logic        illegal_csr_priv;
  logic        illegal_csr_dbg;
  logic        illegal_csr_write;
  logic [7:0]  unused_boot_addr;
  logic [2:0]  unused_csr_addr;
  assign unused_boot_addr = boot_addr_i[7:0];
  logic [$bits(csr_num_e)-1:0] csr_addr;
  assign csr_addr           = {csr_addr_i};
  assign unused_csr_addr    = csr_addr[7:5];
  assign mhpmcounter_idx    = csr_addr[4:0];
  assign illegal_csr_dbg    = dbg_csr & ~debug_mode_i;
  assign illegal_csr_priv   = (csr_addr[9:8] > {priv_lvl_q});
  assign illegal_csr_write  = (csr_addr[11:10] == 2'b11) && csr_wr;
  assign illegal_csr_insn_o = csr_access_i & (illegal_csr | illegal_csr_write | illegal_csr_priv |
                                              illegal_csr_dbg);
  assign mip.irq_software = irq_software_i;
  assign mip.irq_timer    = irq_timer_i;
  assign mip.irq_external = irq_external_i;
  assign mip.irq_fast     = irq_fast_i;
  always_comb begin
    csr_rdata_int = '0;
    illegal_csr   = 1'b0;
    dbg_csr       = 1'b0;
    unique case (csr_addr_i)
      CSR_MVENDORID: csr_rdata_int = CsrMvendorId;
      CSR_MARCHID: csr_rdata_int = CSR_MARCHID_VALUE;
      CSR_MIMPID: csr_rdata_int = CsrMimpId;
      CSR_MHARTID: csr_rdata_int = hart_id_i;
      CSR_MCONFIGPTR: csr_rdata_int = CSR_MCONFIGPTR_VALUE;
      CSR_MSTATUS: begin
        csr_rdata_int                                                   = '0;
        csr_rdata_int[CSR_MSTATUS_MIE_BIT]                              = mstatus_q.mie;
        csr_rdata_int[CSR_MSTATUS_MPIE_BIT]                             = mstatus_q.mpie;
        csr_rdata_int[CSR_MSTATUS_MPP_BIT_HIGH:CSR_MSTATUS_MPP_BIT_LOW] = mstatus_q.mpp;
        csr_rdata_int[CSR_MSTATUS_MPRV_BIT]                             = mstatus_q.mprv;
        csr_rdata_int[CSR_MSTATUS_TW_BIT]                               = mstatus_q.tw;
      end
      CSR_MSTATUSH: csr_rdata_int = '0;
      CSR_MENVCFG, CSR_MENVCFGH: csr_rdata_int = '0;
      CSR_MISA: csr_rdata_int = MISA_VALUE;
      CSR_MIE: begin
        csr_rdata_int                                     = '0;
        csr_rdata_int[CSR_MSIX_BIT]                       = mie_q.irq_software;
        csr_rdata_int[CSR_MTIX_BIT]                       = mie_q.irq_timer;
        csr_rdata_int[CSR_MEIX_BIT]                       = mie_q.irq_external;
        csr_rdata_int[CSR_MFIX_BIT_HIGH:CSR_MFIX_BIT_LOW] = mie_q.irq_fast;
      end
      CSR_MCOUNTEREN: csr_rdata_int = mcounteren;
      CSR_MSCRATCH: csr_rdata_int = mscratch_q;
      CSR_MTVEC: csr_rdata_int = mtvec_q;
      CSR_MEPC: csr_rdata_int = mepc_q;
      CSR_MCAUSE: csr_rdata_int = {mcause_q.irq_ext | mcause_q.irq_int,
                                   mcause_q.irq_int ? {26{1'b1}} : 26'b0,
                                   mcause_q.lower_cause[4:0]};
      CSR_MTVAL: csr_rdata_int = mtval_q;
      CSR_MIP: begin
        csr_rdata_int                                     = '0;
        csr_rdata_int[CSR_MSIX_BIT]                       = mip.irq_software;
        csr_rdata_int[CSR_MTIX_BIT]                       = mip.irq_timer;
        csr_rdata_int[CSR_MEIX_BIT]                       = mip.irq_external;
        csr_rdata_int[CSR_MFIX_BIT_HIGH:CSR_MFIX_BIT_LOW] = mip.irq_fast;
      end
      CSR_MSECCFG: begin
        if (PMPEnable) begin
          csr_rdata_int                       = '0;
          csr_rdata_int[CSR_MSECCFG_MML_BIT]  = pmp_mseccfg.mml;
          csr_rdata_int[CSR_MSECCFG_MMWP_BIT] = pmp_mseccfg.mmwp;
          csr_rdata_int[CSR_MSECCFG_RLB_BIT]  = pmp_mseccfg.rlb;
        end else begin
          illegal_csr = 1'b1;
        end
      end
      CSR_MSECCFGH: begin
        if (PMPEnable) begin
          csr_rdata_int = '0;
        end else begin
          illegal_csr = 1'b1;
        end
      end
      CSR_PMPCFG0:   csr_rdata_int = {pmp_cfg_rdata[3],  pmp_cfg_rdata[2],
                                      pmp_cfg_rdata[1],  pmp_cfg_rdata[0]};
      CSR_PMPCFG1:   csr_rdata_int = {pmp_cfg_rdata[7],  pmp_cfg_rdata[6],
                                      pmp_cfg_rdata[5],  pmp_cfg_rdata[4]};
      CSR_PMPCFG2:   csr_rdata_int = {pmp_cfg_rdata[11], pmp_cfg_rdata[10],
                                      pmp_cfg_rdata[9],  pmp_cfg_rdata[8]};
      CSR_PMPCFG3:   csr_rdata_int = {pmp_cfg_rdata[15], pmp_cfg_rdata[14],
                                      pmp_cfg_rdata[13], pmp_cfg_rdata[12]};
      CSR_PMPADDR0:  csr_rdata_int = pmp_addr_rdata[0];
      CSR_PMPADDR1:  csr_rdata_int = pmp_addr_rdata[1];
      CSR_PMPADDR2:  csr_rdata_int = pmp_addr_rdata[2];
      CSR_PMPADDR3:  csr_rdata_int = pmp_addr_rdata[3];
      CSR_PMPADDR4:  csr_rdata_int = pmp_addr_rdata[4];
      CSR_PMPADDR5:  csr_rdata_int = pmp_addr_rdata[5];
      CSR_PMPADDR6:  csr_rdata_int = pmp_addr_rdata[6];
      CSR_PMPADDR7:  csr_rdata_int = pmp_addr_rdata[7];
      CSR_PMPADDR8:  csr_rdata_int = pmp_addr_rdata[8];
      CSR_PMPADDR9:  csr_rdata_int = pmp_addr_rdata[9];
      CSR_PMPADDR10: csr_rdata_int = pmp_addr_rdata[10];
      CSR_PMPADDR11: csr_rdata_int = pmp_addr_rdata[11];
      CSR_PMPADDR12: csr_rdata_int = pmp_addr_rdata[12];
      CSR_PMPADDR13: csr_rdata_int = pmp_addr_rdata[13];
      CSR_PMPADDR14: csr_rdata_int = pmp_addr_rdata[14];
      CSR_PMPADDR15: csr_rdata_int = pmp_addr_rdata[15];
      CSR_DCSR: begin
        csr_rdata_int = dcsr_q;
        dbg_csr       = 1'b1;
      end
      CSR_DPC: begin
        csr_rdata_int = depc_q;
        dbg_csr       = 1'b1;
      end
      CSR_DSCRATCH0: begin
        csr_rdata_int = dscratch0_q;
        dbg_csr       = 1'b1;
      end
      CSR_DSCRATCH1: begin
        csr_rdata_int = dscratch1_q;
        dbg_csr       = 1'b1;
      end
      CSR_MCOUNTINHIBIT: csr_rdata_int = mcountinhibit;
      CSR_MHPMEVENT3,
      CSR_MHPMEVENT4,  CSR_MHPMEVENT5,  CSR_MHPMEVENT6,  CSR_MHPMEVENT7,
      CSR_MHPMEVENT8,  CSR_MHPMEVENT9,  CSR_MHPMEVENT10, CSR_MHPMEVENT11,
      CSR_MHPMEVENT12, CSR_MHPMEVENT13, CSR_MHPMEVENT14, CSR_MHPMEVENT15,
      CSR_MHPMEVENT16, CSR_MHPMEVENT17, CSR_MHPMEVENT18, CSR_MHPMEVENT19,
      CSR_MHPMEVENT20, CSR_MHPMEVENT21, CSR_MHPMEVENT22, CSR_MHPMEVENT23,
      CSR_MHPMEVENT24, CSR_MHPMEVENT25, CSR_MHPMEVENT26, CSR_MHPMEVENT27,
      CSR_MHPMEVENT28, CSR_MHPMEVENT29, CSR_MHPMEVENT30, CSR_MHPMEVENT31: begin
        csr_rdata_int = mhpmevent[mhpmcounter_idx];
      end
      CSR_MCYCLE,
      CSR_MINSTRET,
      CSR_MHPMCOUNTER3,
      CSR_MHPMCOUNTER4,  CSR_MHPMCOUNTER5,  CSR_MHPMCOUNTER6,  CSR_MHPMCOUNTER7,
      CSR_MHPMCOUNTER8,  CSR_MHPMCOUNTER9,  CSR_MHPMCOUNTER10, CSR_MHPMCOUNTER11,
      CSR_MHPMCOUNTER12, CSR_MHPMCOUNTER13, CSR_MHPMCOUNTER14, CSR_MHPMCOUNTER15,
      CSR_MHPMCOUNTER16, CSR_MHPMCOUNTER17, CSR_MHPMCOUNTER18, CSR_MHPMCOUNTER19,
      CSR_MHPMCOUNTER20, CSR_MHPMCOUNTER21, CSR_MHPMCOUNTER22, CSR_MHPMCOUNTER23,
      CSR_MHPMCOUNTER24, CSR_MHPMCOUNTER25, CSR_MHPMCOUNTER26, CSR_MHPMCOUNTER27,
      CSR_MHPMCOUNTER28, CSR_MHPMCOUNTER29, CSR_MHPMCOUNTER30, CSR_MHPMCOUNTER31: begin
        csr_rdata_int = mhpmcounter[mhpmcounter_idx][31:0];
      end
      CSR_MCYCLEH,
      CSR_MINSTRETH,
      CSR_MHPMCOUNTER3H,
      CSR_MHPMCOUNTER4H,  CSR_MHPMCOUNTER5H,  CSR_MHPMCOUNTER6H,  CSR_MHPMCOUNTER7H,
      CSR_MHPMCOUNTER8H,  CSR_MHPMCOUNTER9H,  CSR_MHPMCOUNTER10H, CSR_MHPMCOUNTER11H,
      CSR_MHPMCOUNTER12H, CSR_MHPMCOUNTER13H, CSR_MHPMCOUNTER14H, CSR_MHPMCOUNTER15H,
      CSR_MHPMCOUNTER16H, CSR_MHPMCOUNTER17H, CSR_MHPMCOUNTER18H, CSR_MHPMCOUNTER19H,
      CSR_MHPMCOUNTER20H, CSR_MHPMCOUNTER21H, CSR_MHPMCOUNTER22H, CSR_MHPMCOUNTER23H,
      CSR_MHPMCOUNTER24H, CSR_MHPMCOUNTER25H, CSR_MHPMCOUNTER26H, CSR_MHPMCOUNTER27H,
      CSR_MHPMCOUNTER28H, CSR_MHPMCOUNTER29H, CSR_MHPMCOUNTER30H, CSR_MHPMCOUNTER31H: begin
        csr_rdata_int = mhpmcounter[mhpmcounter_idx][63:32];
      end
      CSR_CYCLE,
      CSR_INSTRET,
      CSR_HPMCOUNTER3,
      CSR_HPMCOUNTER4,  CSR_HPMCOUNTER5,  CSR_HPMCOUNTER6,  CSR_HPMCOUNTER7,
      CSR_HPMCOUNTER8,  CSR_HPMCOUNTER9,  CSR_HPMCOUNTER10, CSR_HPMCOUNTER11,
      CSR_HPMCOUNTER12, CSR_HPMCOUNTER13, CSR_HPMCOUNTER14, CSR_HPMCOUNTER15,
      CSR_HPMCOUNTER16, CSR_HPMCOUNTER17, CSR_HPMCOUNTER18, CSR_HPMCOUNTER19,
      CSR_HPMCOUNTER20, CSR_HPMCOUNTER21, CSR_HPMCOUNTER22, CSR_HPMCOUNTER23,
      CSR_HPMCOUNTER24, CSR_HPMCOUNTER25, CSR_HPMCOUNTER26, CSR_HPMCOUNTER27,
      CSR_HPMCOUNTER28, CSR_HPMCOUNTER29, CSR_HPMCOUNTER30, CSR_HPMCOUNTER31: begin
        csr_rdata_int = mhpmcounter[mhpmcounter_idx][31:0];
        illegal_csr   = (priv_lvl_q == PRIV_LVL_U) && !mcounteren[mhpmcounter_idx];
      end
      CSR_CYCLEH,
      CSR_INSTRETH,
      CSR_HPMCOUNTER3H,
      CSR_HPMCOUNTER4H,  CSR_HPMCOUNTER5H,  CSR_HPMCOUNTER6H,  CSR_HPMCOUNTER7H,
      CSR_HPMCOUNTER8H,  CSR_HPMCOUNTER9H,  CSR_HPMCOUNTER10H, CSR_HPMCOUNTER11H,
      CSR_HPMCOUNTER12H, CSR_HPMCOUNTER13H, CSR_HPMCOUNTER14H, CSR_HPMCOUNTER15H,
      CSR_HPMCOUNTER16H, CSR_HPMCOUNTER17H, CSR_HPMCOUNTER18H, CSR_HPMCOUNTER19H,
      CSR_HPMCOUNTER20H, CSR_HPMCOUNTER21H, CSR_HPMCOUNTER22H, CSR_HPMCOUNTER23H,
      CSR_HPMCOUNTER24H, CSR_HPMCOUNTER25H, CSR_HPMCOUNTER26H, CSR_HPMCOUNTER27H,
      CSR_HPMCOUNTER28H, CSR_HPMCOUNTER29H, CSR_HPMCOUNTER30H, CSR_HPMCOUNTER31H: begin
        csr_rdata_int = mhpmcounter[mhpmcounter_idx][63:32];
        illegal_csr   = (priv_lvl_q == PRIV_LVL_U) && !mcounteren[mhpmcounter_idx];
      end
      CSR_TSELECT: begin
        csr_rdata_int = tselect_rdata;
        illegal_csr   = ~DbgTriggerEn;
      end
      CSR_TDATA1: begin
        csr_rdata_int = tmatch_control_rdata;
        illegal_csr   = ~DbgTriggerEn;
      end
      CSR_TDATA2: begin
        csr_rdata_int = tmatch_value_rdata;
        illegal_csr   = ~DbgTriggerEn;
      end
      CSR_TDATA3: begin
        csr_rdata_int = '0;
        illegal_csr   = ~DbgTriggerEn;
      end
      CSR_MCONTEXT: begin
        csr_rdata_int = '0;
        illegal_csr   = ~DbgTriggerEn;
      end
      CSR_SCONTEXT: begin
        csr_rdata_int = '0;
        illegal_csr   = ~DbgTriggerEn;
      end
      CSR_MSCONTEXT: begin
        csr_rdata_int = '0;
        illegal_csr   = ~DbgTriggerEn;
      end
      CSR_CPUCTRLSTS: begin
        csr_rdata_int = {{32 - $bits(cpu_ctrl_sts_part_t) - 1 {1'b0}},
                         cpuctrlsts_ic_scr_key_valid_q,
                         cpuctrlsts_part_q};
      end
      CSR_SECURESEED: begin
        csr_rdata_int = '0;
      end
      default: begin
        illegal_csr = 1'b1;
      end
    endcase
    if (!PMPEnable) begin
      if (csr_addr inside {CSR_PMPCFG0,   CSR_PMPCFG1,   CSR_PMPCFG2,   CSR_PMPCFG3,
                           CSR_PMPADDR0,  CSR_PMPADDR1,  CSR_PMPADDR2,  CSR_PMPADDR3,
                           CSR_PMPADDR4,  CSR_PMPADDR5,  CSR_PMPADDR6,  CSR_PMPADDR7,
                           CSR_PMPADDR8,  CSR_PMPADDR9,  CSR_PMPADDR10, CSR_PMPADDR11,
                           CSR_PMPADDR12, CSR_PMPADDR13, CSR_PMPADDR14, CSR_PMPADDR15}) begin
        illegal_csr = 1'b1;
      end
    end
  end
  always_comb begin
    exception_pc = pc_id_i;
    priv_lvl_d   = priv_lvl_q;
    mstatus_en   = 1'b0;
    mstatus_d    = mstatus_q;
    mie_en       = 1'b0;
    mscratch_en  = 1'b0;
    mepc_en      = 1'b0;
    mepc_d       = {csr_wdata_int[31:1], 1'b0};
    mcause_en    = 1'b0;
    mcause_d     = '{irq_ext :    csr_wdata_int[31:30] == 2'b10,
                     irq_int :    csr_wdata_int[31:30] == 2'b11,
                     lower_cause: csr_wdata_int[4:0]};
    mtval_en     = 1'b0;
    mtval_d      = csr_wdata_int;
    mtvec_en     = csr_mtvec_init_i;
    mtvec_d      = csr_mtvec_init_i ? {boot_addr_i[31:8], 6'b0, 2'b01} :
                                      {csr_wdata_int[31:8], 6'b0, 2'b01};
    dcsr_en      = 1'b0;
    dcsr_d       = dcsr_q;
    depc_d       = {csr_wdata_int[31:1], 1'b0};
    depc_en      = 1'b0;
    dscratch0_en = 1'b0;
    dscratch1_en = 1'b0;
    mstack_en      = 1'b0;
    mstack_d.mpie  = mstatus_q.mpie;
    mstack_d.mpp   = mstatus_q.mpp;
    mstack_epc_d   = mepc_q;
    mstack_cause_d = mcause_q;
    mcountinhibit_we = 1'b0;
    mcounteren_we    = 1'b0;
    mhpmcounter_we   = '0;
    mhpmcounterh_we  = '0;
    cpuctrlsts_part_we = 1'b0;
    cpuctrlsts_part_d  = cpuctrlsts_part_q;
    double_fault_seen_o = 1'b0;
    if (csr_we_int) begin
      unique case (csr_addr_i)
        CSR_MSTATUS: begin
          mstatus_en = 1'b1;
          mstatus_d    = '{
              mie:  csr_wdata_int[CSR_MSTATUS_MIE_BIT],
              mpie: csr_wdata_int[CSR_MSTATUS_MPIE_BIT],
              mpp:  priv_lvl_e'(csr_wdata_int[CSR_MSTATUS_MPP_BIT_HIGH:CSR_MSTATUS_MPP_BIT_LOW]),
              mprv: csr_wdata_int[CSR_MSTATUS_MPRV_BIT],
              tw:   csr_wdata_int[CSR_MSTATUS_TW_BIT]
          };
          if ((mstatus_d.mpp != PRIV_LVL_M) && (mstatus_d.mpp != PRIV_LVL_U)) begin
            mstatus_d.mpp = PRIV_LVL_U;
          end
        end
        CSR_MIE: mie_en = 1'b1;
        CSR_MSCRATCH: mscratch_en = 1'b1;
        CSR_MEPC: mepc_en = 1'b1;
        CSR_MCAUSE: mcause_en = 1'b1;
        CSR_MTVAL: mtval_en = 1'b1;
        CSR_MTVEC: mtvec_en = 1'b1;
        CSR_DCSR: begin
          dcsr_d = csr_wdata_int;
          dcsr_d.xdebugver = XDEBUGVER_STD;
          if ((dcsr_d.prv != PRIV_LVL_M) && (dcsr_d.prv != PRIV_LVL_U)) begin
            dcsr_d.prv = PRIV_LVL_U;
          end
          dcsr_d.cause = dcsr_q.cause;
          dcsr_d.stepie = 1'b0;
          dcsr_d.nmip = 1'b0;
          dcsr_d.mprven = 1'b0;
          dcsr_d.stopcount = 1'b0;
          dcsr_d.stoptime = 1'b0;
          dcsr_d.zero0 = 1'b0;
          dcsr_d.zero1 = 1'b0;
          dcsr_d.zero2 = 12'h0;
          dcsr_en      = 1'b1;
        end
        CSR_DPC: depc_en = 1'b1;
        CSR_DSCRATCH0: dscratch0_en = 1'b1;
        CSR_DSCRATCH1: dscratch1_en = 1'b1;
        CSR_MCOUNTEREN:    mcounteren_we    = mcounteren_writable_i == IbexMuBiOn;
        CSR_MCOUNTINHIBIT: mcountinhibit_we = 1'b1;
        CSR_MCYCLE,
        CSR_MINSTRET,
        CSR_MHPMCOUNTER3,
        CSR_MHPMCOUNTER4,  CSR_MHPMCOUNTER5,  CSR_MHPMCOUNTER6,  CSR_MHPMCOUNTER7,
        CSR_MHPMCOUNTER8,  CSR_MHPMCOUNTER9,  CSR_MHPMCOUNTER10, CSR_MHPMCOUNTER11,
        CSR_MHPMCOUNTER12, CSR_MHPMCOUNTER13, CSR_MHPMCOUNTER14, CSR_MHPMCOUNTER15,
        CSR_MHPMCOUNTER16, CSR_MHPMCOUNTER17, CSR_MHPMCOUNTER18, CSR_MHPMCOUNTER19,
        CSR_MHPMCOUNTER20, CSR_MHPMCOUNTER21, CSR_MHPMCOUNTER22, CSR_MHPMCOUNTER23,
        CSR_MHPMCOUNTER24, CSR_MHPMCOUNTER25, CSR_MHPMCOUNTER26, CSR_MHPMCOUNTER27,
        CSR_MHPMCOUNTER28, CSR_MHPMCOUNTER29, CSR_MHPMCOUNTER30, CSR_MHPMCOUNTER31: begin
          mhpmcounter_we[mhpmcounter_idx] = 1'b1;
        end
        CSR_MCYCLEH,
        CSR_MINSTRETH,
        CSR_MHPMCOUNTER3H,
        CSR_MHPMCOUNTER4H,  CSR_MHPMCOUNTER5H,  CSR_MHPMCOUNTER6H,  CSR_MHPMCOUNTER7H,
        CSR_MHPMCOUNTER8H,  CSR_MHPMCOUNTER9H,  CSR_MHPMCOUNTER10H, CSR_MHPMCOUNTER11H,
        CSR_MHPMCOUNTER12H, CSR_MHPMCOUNTER13H, CSR_MHPMCOUNTER14H, CSR_MHPMCOUNTER15H,
        CSR_MHPMCOUNTER16H, CSR_MHPMCOUNTER17H, CSR_MHPMCOUNTER18H, CSR_MHPMCOUNTER19H,
        CSR_MHPMCOUNTER20H, CSR_MHPMCOUNTER21H, CSR_MHPMCOUNTER22H, CSR_MHPMCOUNTER23H,
        CSR_MHPMCOUNTER24H, CSR_MHPMCOUNTER25H, CSR_MHPMCOUNTER26H, CSR_MHPMCOUNTER27H,
        CSR_MHPMCOUNTER28H, CSR_MHPMCOUNTER29H, CSR_MHPMCOUNTER30H, CSR_MHPMCOUNTER31H: begin
          mhpmcounterh_we[mhpmcounter_idx] = 1'b1;
        end
        CSR_CPUCTRLSTS: begin
          cpuctrlsts_part_d  = cpuctrlsts_part_wdata;
          cpuctrlsts_part_we = 1'b1;
        end
        default:;
      endcase
    end
    unique case (1'b1)
      csr_save_cause_i: begin
        unique case (1'b1)
          csr_save_if_i: begin
            exception_pc = pc_if_i;
          end
          csr_save_id_i: begin
            exception_pc = pc_id_i;
          end
          csr_save_wb_i: begin
            exception_pc = pc_wb_i;
          end
          default:;
        endcase
        priv_lvl_d = PRIV_LVL_M;
        if (debug_csr_save_i) begin
          dcsr_d.prv   = priv_lvl_q;
          dcsr_d.cause = debug_cause_i;
          dcsr_en      = 1'b1;
          depc_d       = exception_pc;
          depc_en      = 1'b1;
        end else if (!debug_mode_i) begin
          mtval_en       = 1'b1;
          mtval_d        = csr_mtval_i;
          mstatus_en     = 1'b1;
          mstatus_d.mie  = 1'b0;  
          mstatus_d.mpie = mstatus_q.mie;
          mstatus_d.mpp  = priv_lvl_q;
          mepc_en        = 1'b1;
          mepc_d         = exception_pc;
          mcause_en      = 1'b1;
          mcause_d       = csr_mcause_i;
          mstack_en      = 1'b1;
          if (!(mcause_d.irq_ext || mcause_d.irq_int)) begin
            cpuctrlsts_part_we = 1'b1;
            cpuctrlsts_part_d.sync_exc_seen = 1'b1;
            if (cpuctrlsts_part_q.sync_exc_seen) begin
              double_fault_seen_o                 = 1'b1;
              cpuctrlsts_part_d.double_fault_seen = 1'b1;
            end
          end
        end
      end  
      csr_restore_dret_i: begin  
        priv_lvl_d = dcsr_q.prv;
      end  
      csr_restore_mret_i: begin  
        priv_lvl_d     = mstatus_q.mpp;
        mstatus_en     = 1'b1;
        mstatus_d.mie  = mstatus_q.mpie;  
        if (mstatus_q.mpp != PRIV_LVL_M) begin
          mstatus_d.mprv = 1'b0;
        end
        cpuctrlsts_part_we              = 1'b1;
        cpuctrlsts_part_d.sync_exc_seen = 1'b0;
        if (nmi_mode_i) begin
          mstatus_d.mpie = mstack_q.mpie;
          mstatus_d.mpp  = mstack_q.mpp;
          mepc_en        = 1'b1;
          mepc_d         = mstack_epc_q;
          mcause_en      = 1'b1;
          mcause_d       = mstack_cause_q;
        end else begin
          mstatus_d.mpie = 1'b1;
          mstatus_d.mpp  = PRIV_LVL_U;
        end
      end  
      default:;
    endcase
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      priv_lvl_q     <= PRIV_LVL_M;
    end else begin
      priv_lvl_q     <= priv_lvl_d;
    end
  end
  assign priv_mode_id_o = priv_lvl_q;
  assign priv_mode_lsu_o = mstatus_q.mprv ? mstatus_q.mpp : priv_lvl_q;
  always_comb begin
    unique case (csr_op_i)
      CSR_OP_WRITE: csr_wdata_int =  csr_wdata_i;
      CSR_OP_SET:   csr_wdata_int =  csr_wdata_i | csr_rdata_o;
      CSR_OP_CLEAR: csr_wdata_int = ~csr_wdata_i & csr_rdata_o;
      CSR_OP_READ:  csr_wdata_int = csr_wdata_i;
      default:      csr_wdata_int = csr_wdata_i;
    endcase
  end
  assign csr_wr = (csr_op_i inside {CSR_OP_WRITE, CSR_OP_SET, CSR_OP_CLEAR});
  assign csr_we_int  = csr_wr & csr_op_en_i & ~illegal_csr_insn_o;
  assign csr_rdata_o = csr_rdata_int;
  assign csr_mepc_o  = mepc_q;
  assign csr_depc_o  = depc_q;
  assign csr_mtvec_o = mtvec_q;
  assign csr_mtval_o = mtval_q;
  assign csr_mstatus_mie_o   = mstatus_q.mie;
  assign csr_mstatus_tw_o    = mstatus_q.tw;
  assign debug_single_step_o = dcsr_q.step;
  assign debug_ebreakm_o     = dcsr_q.ebreakm;
  assign debug_ebreaku_o     = dcsr_q.ebreaku;
  assign irqs_o        = mip & mie_q;
  assign irq_pending_o = |irqs_o;
  localparam status_t MSTATUS_RST_VAL = '{mie:  1'b0,
                                          mpie: 1'b1,
                                          mpp:  PRIV_LVL_U,
                                          mprv: 1'b0,
                                          tw:   1'b0};
  ibex_csr #(
    .Width     ($bits(status_t)),
    .ShadowCopy(ShadowCSR),
    .ResetValue({MSTATUS_RST_VAL})
  ) u_mstatus_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i ({mstatus_d}),
    .wr_en_i   (mstatus_en),
    .rd_data_o (mstatus_q),
    .rd_error_o(mstatus_err)
  );
  ibex_csr #(
    .Width     (32),
    .ShadowCopy(1'b0),
    .ResetValue('0)
  ) u_mepc_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i (mepc_d),
    .wr_en_i   (mepc_en),
    .rd_data_o (mepc_q),
    .rd_error_o()
  );
  assign mie_d.irq_software = csr_wdata_int[CSR_MSIX_BIT];
  assign mie_d.irq_timer    = csr_wdata_int[CSR_MTIX_BIT];
  assign mie_d.irq_external = csr_wdata_int[CSR_MEIX_BIT];
  assign mie_d.irq_fast     = csr_wdata_int[CSR_MFIX_BIT_HIGH:CSR_MFIX_BIT_LOW];
  ibex_csr #(
    .Width     ($bits(irqs_t)),
    .ShadowCopy(1'b0),
    .ResetValue('0)
  ) u_mie_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i ({mie_d}),
    .wr_en_i   (mie_en),
    .rd_data_o (mie_q),
    .rd_error_o()
  );
  ibex_csr #(
    .Width     (32),
    .ShadowCopy(1'b0),
    .ResetValue('0)
  ) u_mscratch_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i (csr_wdata_int),
    .wr_en_i   (mscratch_en),
    .rd_data_o (mscratch_q),
    .rd_error_o()
  );
  ibex_csr #(
    .Width     ($bits(exc_cause_t)),
    .ShadowCopy(1'b0),
    .ResetValue('0)
  ) u_mcause_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i ({mcause_d}),
    .wr_en_i   (mcause_en),
    .rd_data_o (mcause_q),
    .rd_error_o()
  );
  ibex_csr #(
    .Width     (32),
    .ShadowCopy(1'b0),
    .ResetValue('0)
  ) u_mtval_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i (mtval_d),
    .wr_en_i   (mtval_en),
    .rd_data_o (mtval_q),
    .rd_error_o()
  );
  ibex_csr #(
    .Width     (32),
    .ShadowCopy(ShadowCSR),
    .ResetValue(32'd1)
  ) u_mtvec_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i (mtvec_d),
    .wr_en_i   (mtvec_en),
    .rd_data_o (mtvec_q),
    .rd_error_o(mtvec_err)
  );
  localparam dcsr_t DCSR_RESET_VAL = '{
      xdebugver: XDEBUGVER_STD,
      cause: DBG_CAUSE_NONE,   
      prv: PRIV_LVL_M,
      default: '0
  };
  ibex_csr #(
    .Width     ($bits(dcsr_t)),
    .ShadowCopy(1'b0),
    .ResetValue({DCSR_RESET_VAL})
  ) u_dcsr_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i ({dcsr_d}),
    .wr_en_i   (dcsr_en),
    .rd_data_o (dcsr_q),
    .rd_error_o()
  );
  ibex_csr #(
    .Width     (32),
    .ShadowCopy(1'b0),
    .ResetValue('0)
  ) u_depc_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i (depc_d),
    .wr_en_i   (depc_en),
    .rd_data_o (depc_q),
    .rd_error_o()
  );
  ibex_csr #(
    .Width     (32),
    .ShadowCopy(1'b0),
    .ResetValue('0)
  ) u_dscratch0_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i (csr_wdata_int),
    .wr_en_i   (dscratch0_en),
    .rd_data_o (dscratch0_q),
    .rd_error_o()
  );
  ibex_csr #(
    .Width     (32),
    .ShadowCopy(1'b0),
    .ResetValue('0)
  ) u_dscratch1_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i (csr_wdata_int),
    .wr_en_i   (dscratch1_en),
    .rd_data_o (dscratch1_q),
    .rd_error_o()
  );
  localparam status_stk_t MSTACK_RESET_VAL = '{mpie: 1'b1, mpp: PRIV_LVL_U};
  ibex_csr #(
    .Width     ($bits(status_stk_t)),
    .ShadowCopy(1'b0),
    .ResetValue({MSTACK_RESET_VAL})
  ) u_mstack_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i ({mstack_d}),
    .wr_en_i   (mstack_en),
    .rd_data_o (mstack_q),
    .rd_error_o()
  );
  ibex_csr #(
    .Width     (32),
    .ShadowCopy(1'b0),
    .ResetValue('0)
  ) u_mstack_epc_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i (mstack_epc_d),
    .wr_en_i   (mstack_en),
    .rd_data_o (mstack_epc_q),
    .rd_error_o()
  );
  ibex_csr #(
    .Width     ($bits(exc_cause_t)),
    .ShadowCopy(1'b0),
    .ResetValue('0)
  ) u_mstack_cause_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i (mstack_cause_d),
    .wr_en_i   (mstack_en),
    .rd_data_o (mstack_cause_q),
    .rd_error_o()
  );
  if (PMPEnable) begin : g_pmp_registers
    pmp_mseccfg_t                pmp_mseccfg_q, pmp_mseccfg_d;
    logic                        pmp_mseccfg_we;
    logic                        pmp_mseccfg_err;
    pmp_cfg_t                    pmp_cfg         [PMPNumRegions];
    logic [PMPNumRegions-1:0]    pmp_cfg_locked;
    logic [PMPNumRegions-1:0]    pmp_cfg_wr_suppress;
    pmp_cfg_t                    pmp_cfg_wdata   [PMPNumRegions];
    logic [PMPAddrWidth-1:0]     pmp_addr        [PMPNumRegions];
    logic [PMPNumRegions-1:0]    pmp_cfg_we;
    logic [PMPNumRegions-1:0]    pmp_cfg_err;
    logic [PMPNumRegions-1:0]    pmp_addr_we;
    logic [PMPNumRegions-1:0]    pmp_addr_err;
    logic                        any_pmp_entry_locked;
    for (genvar i = 0; i < PMP_MAX_REGIONS; i++) begin : g_exp_rd_data
      if (i < PMPNumRegions) begin : g_implemented_regions
        assign pmp_cfg_rdata[i] = {pmp_cfg[i].lock, 2'b00, pmp_cfg[i].mode,
                                   pmp_cfg[i].exec, pmp_cfg[i].write, pmp_cfg[i].read};
        if (PMPGranularity == 0) begin : g_pmp_g0
          assign pmp_addr_rdata[i] = pmp_addr[i];
        end else if (PMPGranularity == 1) begin : g_pmp_g1
          always_comb begin
            pmp_addr_rdata[i] = pmp_addr[i];
            if ((pmp_cfg[i].mode == PMP_MODE_OFF) || (pmp_cfg[i].mode == PMP_MODE_TOR)) begin
              pmp_addr_rdata[i][PMPGranularity-1:0] = '0;
            end
          end
        end else begin : g_pmp_g2
          always_comb begin
            pmp_addr_rdata[i] = {pmp_addr[i], {PMPGranularity - 1{1'b1}}};
            if ((pmp_cfg[i].mode == PMP_MODE_OFF) || (pmp_cfg[i].mode == PMP_MODE_TOR)) begin
              pmp_addr_rdata[i][PMPGranularity-1:0] = '0;
            end
          end
        end
      end else begin : g_other_regions
        assign pmp_cfg_rdata[i]  = '0;
        assign pmp_addr_rdata[i] = '0;
      end
    end
    for (genvar i = 0; i < PMPNumRegions; i++) begin : g_pmp_csrs
      assign pmp_cfg_we[i] = csr_we_int                                       &
                             ~pmp_cfg_locked[i]                               &
                             ~pmp_cfg_wr_suppress[i]                          &
                             (csr_addr == (CSR_OFF_PMP_CFG + (i[11:0] >> 2)));
      assign pmp_cfg_wdata[i].lock  = csr_wdata_int[(i%4)*PMP_CFG_W+7];
      always_comb begin
        unique case (csr_wdata_int[(i%4)*PMP_CFG_W+3+:2])
          2'b00   : pmp_cfg_wdata[i].mode = PMP_MODE_OFF;
          2'b01   : pmp_cfg_wdata[i].mode = PMP_MODE_TOR;
          2'b10   : pmp_cfg_wdata[i].mode = (PMPGranularity == 0) ? PMP_MODE_NA4:
                                                                    PMP_MODE_OFF;
          2'b11   : pmp_cfg_wdata[i].mode = PMP_MODE_NAPOT;
          default : pmp_cfg_wdata[i].mode = PMP_MODE_OFF;
        endcase
      end
      assign pmp_cfg_wdata[i].exec  = csr_wdata_int[(i%4)*PMP_CFG_W+2];
      assign pmp_cfg_wdata[i].write = pmp_mseccfg_q.mml ? csr_wdata_int[(i%4)*PMP_CFG_W+1] :
                                                          &csr_wdata_int[(i%4)*PMP_CFG_W+:2];
      assign pmp_cfg_wdata[i].read  = csr_wdata_int[(i%4)*PMP_CFG_W];
      ibex_csr #(
        .Width     ($bits(pmp_cfg_t)),
        .ShadowCopy(ShadowCSR),
        .ResetValue(PMPRstCfg[i])
      ) u_pmp_cfg_csr (
        .clk_i     (clk_i),
        .rst_ni    (rst_ni),
        .wr_data_i ({pmp_cfg_wdata[i]}),
        .wr_en_i   (pmp_cfg_we[i]),
        .rd_data_o (pmp_cfg[i]),
        .rd_error_o(pmp_cfg_err[i])
      );
      assign pmp_cfg_locked[i] = pmp_cfg[i].lock & ~pmp_mseccfg_q.rlb;
      assign pmp_cfg_wr_suppress[i] = pmp_mseccfg_q.mml                   &
                                      ~pmp_mseccfg_q.rlb                  &
                                      is_mml_m_exec_cfg(pmp_cfg_wdata[i]);
      if (i < PMPNumRegions - 1) begin : g_lower
        assign pmp_addr_we[i] = csr_we_int & ~pmp_cfg_locked[i] &
                                (~pmp_cfg_locked[i+1] | (pmp_cfg[i+1].mode != PMP_MODE_TOR)) &
                                (csr_addr == (CSR_OFF_PMP_ADDR + i[11:0]));
      end else begin : g_upper
        assign pmp_addr_we[i] = csr_we_int & ~pmp_cfg_locked[i] &
                                (csr_addr == (CSR_OFF_PMP_ADDR + i[11:0]));
      end
      ibex_csr #(
        .Width     (PMPAddrWidth),
        .ShadowCopy(ShadowCSR),
        .ResetValue(PMPRstAddr[i][PMP_ADDR_MSB-:PMPAddrWidth])
      ) u_pmp_addr_csr (
        .clk_i     (clk_i),
        .rst_ni    (rst_ni),
        .wr_data_i (csr_wdata_int[31-:PMPAddrWidth]),
        .wr_en_i   (pmp_addr_we[i]),
        .rd_data_o (pmp_addr[i]),
        .rd_error_o(pmp_addr_err[i])
      );
      assign csr_pmp_cfg_o[i]  = pmp_cfg[i];
      assign csr_pmp_addr_o[i] = {pmp_addr_rdata[i], 2'b00};
    end
    assign pmp_mseccfg_we = csr_we_int & (csr_addr == CSR_MSECCFG);
    assign pmp_mseccfg_d.mml  = pmp_mseccfg_q.mml  ? 1'b1 : csr_wdata_int[CSR_MSECCFG_MML_BIT];
    assign pmp_mseccfg_d.mmwp = pmp_mseccfg_q.mmwp ? 1'b1 : csr_wdata_int[CSR_MSECCFG_MMWP_BIT];
    assign any_pmp_entry_locked = |pmp_cfg_locked;
    assign pmp_mseccfg_d.rlb = any_pmp_entry_locked ? 1'b0 : csr_wdata_int[CSR_MSECCFG_RLB_BIT];
    ibex_csr #(
      .Width     ($bits(pmp_mseccfg_t)),
      .ShadowCopy(ShadowCSR),
      .ResetValue(PMPRstMsecCfg)
    ) u_pmp_mseccfg (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .wr_data_i (pmp_mseccfg_d),
      .wr_en_i   (pmp_mseccfg_we),
      .rd_data_o (pmp_mseccfg_q),
      .rd_error_o(pmp_mseccfg_err)
    );
    assign pmp_csr_err = (|pmp_cfg_err) | (|pmp_addr_err) | pmp_mseccfg_err;
    assign pmp_mseccfg = pmp_mseccfg_q;
  end else begin : g_no_pmp_tieoffs
    for (genvar i = 0; i < PMP_MAX_REGIONS; i++) begin : g_rdata
      assign pmp_addr_rdata[i] = '0;
      assign pmp_cfg_rdata[i]  = '0;
    end
    for (genvar i = 0; i < PMPNumRegions; i++) begin : g_outputs
      assign csr_pmp_cfg_o[i]  = pmp_cfg_t'(1'b0);
      assign csr_pmp_addr_o[i] = '0;
    end
    assign pmp_csr_err = 1'b0;
    assign pmp_mseccfg = '0;
  end
  assign csr_pmp_mseccfg_o = pmp_mseccfg;
  always_comb begin : mcountinhibit_update
    if (mcountinhibit_we == 1'b1) begin
      mcountinhibit_d = csr_wdata_int[MHPMCounterNum+MHPMCOUNTER_BASE-1:0];
      mcountinhibit_d[1] = 1'b0;
    end else begin
      mcountinhibit_d = mcountinhibit_q;
    end
  end
  always_comb begin : mcounteren_update
    if (mcounteren_we == 1'b1) begin
      mcounteren_d = csr_wdata_int[MHPMCounterNum+MHPMCOUNTER_BASE-1:0];
      mcounteren_d[1] = 1'b0;
    end else begin
      mcounteren_d = mcounteren_q;
    end
  end
  always_comb begin : gen_mhpmcounter_incr
    for (int unsigned i = 0; i < 32; i++) begin : gen_mhpmcounter_incr_inactive
      mhpmcounter_incr[i] = 1'b0;
    end
    mhpmcounter_incr[0]  = 1'b1;                    
    mhpmcounter_incr[1]  = 1'b0;                    
    mhpmcounter_incr[2]  = instr_ret_i;             
    mhpmcounter_incr[3]  = dside_wait_i;            
    mhpmcounter_incr[4]  = iside_wait_i;            
    mhpmcounter_incr[5]  = mem_load_i;              
    mhpmcounter_incr[6]  = mem_store_i;             
    mhpmcounter_incr[7]  = jump_i;                  
    mhpmcounter_incr[8]  = branch_i;                
    mhpmcounter_incr[9]  = branch_taken_i;          
    mhpmcounter_incr[10] = instr_ret_compressed_i;  
    mhpmcounter_incr[11] = mul_wait_i;              
    mhpmcounter_incr[12] = div_wait_i;              
  end
  always_comb begin : gen_mhpmevent
    for (int i = 0; i < 32; i++) begin : gen_mhpmevent_active
      mhpmevent[i] = '0;
      if (i >= MHPMCOUNTER_BASE) begin
        mhpmevent[i][i - MHPMCOUNTER_BASE] = 1'b1;
      end
    end
    mhpmevent[1] = '0;  
    for (int unsigned i = MHPMCOUNTER_BASE + MHPMCounterNum; i < 32; i++)
    begin : gen_mhpmevent_inactive
      mhpmevent[i] = '0;
    end
  end
  ibex_counter #(
    .CounterWidth(64)
  ) mcycle_counter_i (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .counter_inc_i(mhpmcounter_incr[0] & ~mcountinhibit[0]),
    .counterh_we_i(mhpmcounterh_we[0]),
    .counter_we_i(mhpmcounter_we[0]),
    .counter_val_i(csr_wdata_int),
    .counter_val_o(mhpmcounter[0]),
    .counter_val_upd_o()
  );
  ibex_counter #(
    .CounterWidth(64),
    .ProvideValUpd(1)
  ) minstret_counter_i (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .counter_inc_i(mhpmcounter_incr[2] & ~mcountinhibit[2]),
    .counterh_we_i(mhpmcounterh_we[2]),
    .counter_we_i(mhpmcounter_we[2]),
    .counter_val_i(csr_wdata_int),
    .counter_val_o(minstret_raw),
    .counter_val_upd_o(minstret_next)
  );
  assign mhpmcounter[2] = instr_ret_spec_i & ~mcountinhibit[2] ? minstret_next : minstret_raw;
  assign mhpmcounter[1]            = '0;
  assign unused_mhpmcounter_we_1   = mhpmcounter_we[1];
  assign unused_mhpmcounterh_we_1  = mhpmcounterh_we[1];
  assign unused_mhpmcounter_incr_1 = mhpmcounter_incr[1];
  for (genvar i = 0; i < 32 - MHPMCOUNTER_BASE; i++) begin : gen_cntrs
    localparam int Cnt = i + MHPMCOUNTER_BASE;
    if (i < MHPMCounterNum) begin : gen_imp
      logic [63:0] mhpmcounter_raw, mhpmcounter_next;
      ibex_counter #(
        .CounterWidth(MHPMCounterWidth),
        .ProvideValUpd(Cnt == 10)
      ) mcounters_variable_i (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .counter_inc_i(mhpmcounter_incr[Cnt] & ~mcountinhibit[Cnt]),
        .counterh_we_i(mhpmcounterh_we[Cnt]),
        .counter_we_i(mhpmcounter_we[Cnt]),
        .counter_val_i(csr_wdata_int),
        .counter_val_o(mhpmcounter_raw),
        .counter_val_upd_o(mhpmcounter_next)
      );
      if (Cnt == 10) begin : gen_compressed_instr_cnt
        assign mhpmcounter[Cnt] =
          instr_ret_compressed_spec_i & ~mcountinhibit[Cnt] ? mhpmcounter_next:
                                                              mhpmcounter_raw;
      end else begin : gen_other_cnts
        logic [63:0] unused_mhpmcounter_next;
        assign mhpmcounter[Cnt] = mhpmcounter_raw;
        assign unused_mhpmcounter_next = mhpmcounter_next;
      end
    end else begin : gen_unimp
      assign mhpmcounter[Cnt] = '0;
      if (Cnt == 10) begin : gen_no_compressed_instr_cnt
        logic unused_instr_ret_compressed_spec_i;
        assign unused_instr_ret_compressed_spec_i = instr_ret_compressed_spec_i;
      end
    end
  end
  if (MHPMCounterNum < 29) begin : g_mcountinhibit_reduced
    logic [29-MHPMCounterNum-1:0] unused_mhphcounter_we;
    logic [29-MHPMCounterNum-1:0] unused_mhphcounterh_we;
    logic [29-MHPMCounterNum-1:0] unused_mhphcounter_incr;
    assign mcountinhibit = {{29 - MHPMCounterNum{1'b0}}, mcountinhibit_q};
    assign unused_mhphcounter_we   = mhpmcounter_we[31:MHPMCounterNum+MHPMCOUNTER_BASE];
    assign unused_mhphcounterh_we  = mhpmcounterh_we[31:MHPMCounterNum+MHPMCOUNTER_BASE];
    assign unused_mhphcounter_incr = mhpmcounter_incr[31:MHPMCounterNum+MHPMCOUNTER_BASE];
  end else begin : g_mcountinhibit_full
    assign mcountinhibit = mcountinhibit_q;
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      mcountinhibit_q <= '0;
    end else begin
      mcountinhibit_q <= mcountinhibit_d;
    end
  end
  if (MHPMCounterNum < 29) begin : g_mcounteren_reduced
    assign mcounteren = {{29 - MHPMCounterNum{1'b0}}, mcounteren_q};
  end else begin : g_mcounteren_full
    assign mcounteren = mcounteren_q;
  end
  ibex_csr #(
    .Width     (MHPMCounterNum+MHPMCOUNTER_BASE),
    .ShadowCopy(1'b0),
    .ResetValue('0)
  ) u_mcounteren_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i (mcounteren_d),
    .wr_en_i   (mcounteren_we),
    .rd_data_o (mcounteren_q),
    .rd_error_o()
  );
  if (DbgTriggerEn) begin : gen_trigger_regs
    localparam int unsigned DbgHwNumLen = DbgHwBreakNum > 1 ? $clog2(DbgHwBreakNum) : 1;
    localparam int unsigned MaxTselect = DbgHwBreakNum - 1;
    logic [DbgHwNumLen-1:0]   tselect_d, tselect_q;
    logic                     tmatch_control_d;
    logic [DbgHwBreakNum-1:0] tmatch_control_q;
    logic [31:0]              tmatch_value_d;
    logic [31:0]              tmatch_value_q[DbgHwBreakNum];
    logic                     selected_tmatch_control;
    logic [31:0]              selected_tmatch_value;
    logic                     tselect_we;
    logic [DbgHwBreakNum-1:0] tmatch_control_we;
    logic [DbgHwBreakNum-1:0] tmatch_value_we;
    logic [DbgHwBreakNum-1:0] trigger_match;
    assign tselect_we = csr_we_int & debug_mode_i & (csr_addr_i == CSR_TSELECT);
    for (genvar i = 0; i < DbgHwBreakNum; i++) begin : g_dbg_tmatch_we
      assign tmatch_control_we[i] = (i[DbgHwNumLen-1:0] == tselect_q) & csr_we_int & debug_mode_i &
                                    (csr_addr_i == CSR_TDATA1);
      assign tmatch_value_we[i]   = (i[DbgHwNumLen-1:0] == tselect_q) & csr_we_int & debug_mode_i &
                                    (csr_addr_i == CSR_TDATA2);
    end
    assign tselect_d = (csr_wdata_int < DbgHwBreakNum) ? csr_wdata_int[DbgHwNumLen-1:0] :
                                                         MaxTselect[DbgHwNumLen-1:0];
    assign tmatch_control_d = csr_wdata_int[2];
    assign tmatch_value_d   = csr_wdata_int[31:0];
    ibex_csr #(
      .Width     (DbgHwNumLen),
      .ShadowCopy(1'b0),
      .ResetValue('0)
    ) u_tselect_csr (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .wr_data_i (tselect_d),
      .wr_en_i   (tselect_we),
      .rd_data_o (tselect_q),
      .rd_error_o()
    );
    for (genvar i = 0; i < DbgHwBreakNum; i++) begin : g_dbg_tmatch_reg
      ibex_csr #(
        .Width     (1),
        .ShadowCopy(1'b0),
        .ResetValue('0)
      ) u_tmatch_control_csr (
        .clk_i     (clk_i),
        .rst_ni    (rst_ni),
        .wr_data_i (tmatch_control_d),
        .wr_en_i   (tmatch_control_we[i]),
        .rd_data_o (tmatch_control_q[i]),
        .rd_error_o()
      );
      ibex_csr #(
        .Width     (32),
        .ShadowCopy(1'b0),
        .ResetValue('0)
      ) u_tmatch_value_csr (
        .clk_i     (clk_i),
        .rst_ni    (rst_ni),
        .wr_data_i (tmatch_value_d),
        .wr_en_i   (tmatch_value_we[i]),
        .rd_data_o (tmatch_value_q[i]),
        .rd_error_o()
      );
    end
    localparam int unsigned TSelectRdataPadlen = DbgHwNumLen >= 32 ? 0 : (32 - DbgHwNumLen);
    assign tselect_rdata = {{TSelectRdataPadlen{1'b0}}, tselect_q};
    if (DbgHwBreakNum > 1) begin : g_dbg_tmatch_multiple_select
      assign selected_tmatch_control = tmatch_control_q[tselect_q];
      assign selected_tmatch_value   = tmatch_value_q[tselect_q];
    end else begin : g_dbg_tmatch_single_select
      assign selected_tmatch_control = tmatch_control_q[0];
      assign selected_tmatch_value   = tmatch_value_q[0];
    end
    assign tmatch_control_rdata = {4'h2,                     
                                   1'b1,                     
                                   6'h00,                    
                                   1'b0,                     
                                   1'b0,                     
                                   1'b0,                     
                                   2'b00,                    
                                   4'h1,                     
                                   1'b0,                     
                                   4'h0,                     
                                   1'b1,                     
                                   1'b0,                     
                                   1'b0,                     
                                   1'b1,                     
                                   selected_tmatch_control,  
                                   1'b0,                     
                                   1'b0};                    
    assign tmatch_value_rdata = selected_tmatch_value;
    for (genvar i = 0; i < DbgHwBreakNum; i++) begin : g_dbg_trigger_match
      assign trigger_match[i] = tmatch_control_q[i] & (pc_if_i[31:0] == tmatch_value_q[i]);
    end
    assign trigger_match_o = |trigger_match;
  end else begin : gen_no_trigger_regs
    assign tselect_rdata        = 'b0;
    assign tmatch_control_rdata = 'b0;
    assign tmatch_value_rdata   = 'b0;
    assign trigger_match_o      = 'b0;
  end
  assign cpuctrlsts_part_wdata_raw =
    cpu_ctrl_sts_part_t'(csr_wdata_int[$bits(cpu_ctrl_sts_part_t)-1:0]);
  if (DataIndTiming) begin : gen_dit
    assign cpuctrlsts_part_wdata.data_ind_timing = cpuctrlsts_part_wdata_raw.data_ind_timing;
  end else begin : gen_no_dit
    logic unused_dit;
    assign unused_dit = cpuctrlsts_part_wdata_raw.data_ind_timing;
    assign cpuctrlsts_part_wdata.data_ind_timing = 1'b0;
  end
  assign data_ind_timing_o = cpuctrlsts_part_q.data_ind_timing;
  if (DummyInstructions) begin : gen_dummy
    assign cpuctrlsts_part_wdata.dummy_instr_en   = cpuctrlsts_part_wdata_raw.dummy_instr_en;
    assign cpuctrlsts_part_wdata.dummy_instr_mask = cpuctrlsts_part_wdata_raw.dummy_instr_mask;
    assign dummy_instr_seed_en_o = csr_we_int && (csr_addr == CSR_SECURESEED);
    assign dummy_instr_seed_o    = csr_wdata_int;
  end else begin : gen_no_dummy
    logic       unused_dummy_en;
    logic [2:0] unused_dummy_mask;
    assign unused_dummy_en   = cpuctrlsts_part_wdata_raw.dummy_instr_en;
    assign unused_dummy_mask = cpuctrlsts_part_wdata_raw.dummy_instr_mask;
    assign cpuctrlsts_part_wdata.dummy_instr_en   = 1'b0;
    assign cpuctrlsts_part_wdata.dummy_instr_mask = 3'b000;
    assign dummy_instr_seed_en_o             = 1'b0;
    assign dummy_instr_seed_o                = '0;
  end
  assign dummy_instr_en_o   = cpuctrlsts_part_q.dummy_instr_en;
  assign dummy_instr_mask_o = cpuctrlsts_part_q.dummy_instr_mask;
  if (ICache) begin : gen_icache_enable
    assign cpuctrlsts_part_wdata.icache_enable = cpuctrlsts_part_wdata_raw.icache_enable;
    ibex_csr #(
      .Width     (1),
      .ShadowCopy(ShadowCSR),
      .ResetValue(1'b0)
    ) u_cpuctrlsts_ic_scr_key_valid_q_csr (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .wr_data_i (ic_scr_key_valid_i),
      .wr_en_i   (1'b1),
      .rd_data_o (cpuctrlsts_ic_scr_key_valid_q),
      .rd_error_o(cpuctrlsts_ic_scr_key_err)
    );
  end else begin : gen_no_icache
    logic unused_icen;
    assign unused_icen = cpuctrlsts_part_wdata_raw.icache_enable;
    assign cpuctrlsts_part_wdata.icache_enable = 1'b0;
    logic unused_ic_scr_key_valid;
    assign unused_ic_scr_key_valid = ic_scr_key_valid_i;
    assign cpuctrlsts_ic_scr_key_valid_q = 1'b0;
    assign cpuctrlsts_ic_scr_key_err     = 1'b0;
  end
  assign cpuctrlsts_part_wdata.double_fault_seen = cpuctrlsts_part_wdata_raw.double_fault_seen;
  assign cpuctrlsts_part_wdata.sync_exc_seen     = cpuctrlsts_part_wdata_raw.sync_exc_seen;
  assign icache_enable_o =
    cpuctrlsts_part_q.icache_enable & ~(debug_mode_i | debug_mode_entering_i);
  ibex_csr #(
    .Width     ($bits(cpu_ctrl_sts_part_t)),
    .ShadowCopy(ShadowCSR),
    .ResetValue('0)
  ) u_cpuctrlsts_part_csr (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .wr_data_i ({cpuctrlsts_part_d}),
    .wr_en_i   (cpuctrlsts_part_we),
    .rd_data_o (cpuctrlsts_part_q),
    .rd_error_o(cpuctrlsts_part_err)
  );
  assign csr_shadow_err_o =
    mstatus_err | mtvec_err | pmp_csr_err | cpuctrlsts_part_err | cpuctrlsts_ic_scr_key_err;
endmodule
module ibex_csr #(
  parameter int unsigned    Width      = 32,
  parameter bit             ShadowCopy = 1'b0,
  parameter bit [Width-1:0] ResetValue = '0
 ) (
  input  logic             clk_i,
  input  logic             rst_ni,
  input  logic [Width-1:0] wr_data_i,
  input  logic             wr_en_i,
  output logic [Width-1:0] rd_data_o,
  output logic             rd_error_o
);
  logic [Width-1:0] rdata_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rdata_q <= ResetValue;
    end else if (wr_en_i) begin
      rdata_q <= wr_data_i;
    end
  end
  assign rd_data_o = rdata_q;
  if (ShadowCopy) begin : gen_shadow
    logic [Width-1:0] shadow_q;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        shadow_q <= ~ResetValue;
      end else if (wr_en_i) begin
        shadow_q <= ~wr_data_i;
      end
    end
    assign rd_error_o = rdata_q != ~shadow_q;
  end else begin : gen_no_shadow
    assign rd_error_o = 1'b0;
  end
endmodule
module ibex_counter #(
  parameter int CounterWidth = 32,
  parameter bit ProvideValUpd = 0
) (
  input  logic        clk_i,
  input  logic        rst_ni,
  input  logic        counter_inc_i,
  input  logic        counterh_we_i,
  input  logic        counter_we_i,
  input  logic [31:0] counter_val_i,
  output logic [63:0] counter_val_o,
  output logic [63:0] counter_val_upd_o
);
  logic [63:0]             counter;
  logic [CounterWidth-1:0] counter_upd;
  logic [63:0]             counter_load;
  logic                    we;
  logic [CounterWidth-1:0] counter_d;
  assign counter_upd = counter[CounterWidth-1:0] + {{CounterWidth - 1{1'b0}}, 1'b1};
  always_comb begin
    we = counter_we_i | counterh_we_i;
    counter_load[63:32] = counter[63:32];
    counter_load[31:0]  = counter_val_i;
    if (counterh_we_i) begin
      counter_load[63:32] = counter_val_i;
      counter_load[31:0]  = counter[31:0];
    end
    if (we) begin
      counter_d = counter_load[CounterWidth-1:0];
    end else if (counter_inc_i) begin
      counter_d = counter_upd[CounterWidth-1:0];
    end else begin
      counter_d = counter[CounterWidth-1:0];
    end
  end
  localparam int UseDsp = "no";
  logic [CounterWidth-1:0] counter_q;
  if (UseDsp == "yes") begin : g_cnt_dsp
    always_ff @(posedge clk_i) begin
      if (!rst_ni) begin
        counter_q <= '0;
      end else begin
        counter_q <= counter_d;
      end
    end
  end else begin : g_cnt_no_dsp
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        counter_q <= '0;
      end else begin
        counter_q <= counter_d;
      end
    end
  end
  if (CounterWidth < 64) begin : g_counter_narrow
    logic [63:CounterWidth] unused_counter_load;
    assign counter[CounterWidth-1:0]           = counter_q;
    assign counter[63:CounterWidth]            = '0;
    if (ProvideValUpd) begin : g_counter_val_upd_o
      assign counter_val_upd_o[CounterWidth-1:0] = counter_upd;
    end else begin : g_no_counter_val_upd_o
      assign counter_val_upd_o[CounterWidth-1:0] = '0;
    end
    assign counter_val_upd_o[63:CounterWidth]  = '0;
    assign unused_counter_load                 = counter_load[63:CounterWidth];
  end else begin : g_counter_full
    assign counter           = counter_q;
    if (ProvideValUpd) begin : g_counter_val_upd_o
      assign counter_val_upd_o = counter_upd;
    end else begin : g_no_counter_val_upd_o
      assign counter_val_upd_o = '0;
    end
  end
  assign counter_val_o = counter;
endmodule
module ibex_decoder #(
  parameter bit RV32E               = 0,
  parameter ibex_pkg::rv32m_e RV32M = ibex_pkg::RV32MFast,
  parameter ibex_pkg::rv32b_e RV32B = ibex_pkg::RV32BNone,
  parameter bit BranchTargetALU     = 0
) (
  input  logic                 clk_i,
  input  logic                 rst_ni,
  output logic                 illegal_insn_o,         
  output logic                 ebrk_insn_o,            
  output logic                 mret_insn_o,            
  output logic                 dret_insn_o,            
  output logic                 ecall_insn_o,           
  output logic                 wfi_insn_o,             
  output logic                 jump_set_o,             
  input  logic                 branch_taken_i,         
  output logic                 icache_inval_o,
  input  logic                 instr_first_cycle_i,    
  input  logic [31:0]          instr_rdata_i,          
  input  logic [31:0]          instr_rdata_alu_i,      
  input  logic                 illegal_c_insn_i,       
  output ibex_pkg::imm_a_sel_e  imm_a_mux_sel_o,        
  output ibex_pkg::imm_b_sel_e  imm_b_mux_sel_o,        
  output ibex_pkg::op_a_sel_e   bt_a_mux_sel_o,         
  output ibex_pkg::imm_b_sel_e  bt_b_mux_sel_o,         
  output logic [31:0]           imm_i_type_o,
  output logic [31:0]           imm_s_type_o,
  output logic [31:0]           imm_b_type_o,
  output logic [31:0]           imm_u_type_o,
  output logic [31:0]           imm_j_type_o,
  output logic [31:0]           zimm_rs1_type_o,
  output ibex_pkg::rf_wd_sel_e rf_wdata_sel_o,    
  output logic                 rf_we_o,           
  output logic [4:0]           rf_raddr_a_o,
  output logic [4:0]           rf_raddr_b_o,
  output logic [4:0]           rf_waddr_o,
  output logic                 rf_ren_a_o,           
  output logic                 rf_ren_b_o,           
  output ibex_pkg::alu_op_e    alu_operator_o,         
  output ibex_pkg::op_a_sel_e  alu_op_a_mux_sel_o,     
  output ibex_pkg::op_b_sel_e  alu_op_b_mux_sel_o,     
  output logic                 alu_multicycle_o,       
  output logic                 mult_en_o,              
  output logic                 div_en_o,               
  output logic                 mult_sel_o,             
  output logic                 div_sel_o,              
  output ibex_pkg::md_op_e     multdiv_operator_o,
  output logic [1:0]           multdiv_signed_mode_o,
  output logic                 csr_access_o,           
  output ibex_pkg::csr_op_e    csr_op_o,               
  output ibex_pkg::csr_num_e   csr_addr_o,             
  output logic                 data_req_o,             
  output logic                 data_we_o,              
  output logic [1:0]           data_type_o,            
  output logic                 data_sign_extension_o,  
  output logic                 jump_in_dec_o,          
  output logic                 branch_in_dec_o
);
  import ibex_pkg::*;
  logic        illegal_insn;
  logic        illegal_reg_rv32e;
  logic        csr_illegal;
  logic        rf_we;
  logic [31:0] instr;
  logic [31:0] instr_alu;
  logic [9:0]  unused_instr_alu;
  logic [4:0] instr_rs1;
  logic [4:0] instr_rs2;
  logic [4:0] instr_rs3;
  logic [4:0] instr_rd;
  logic        use_rs3_d;
  logic        use_rs3_q;
  csr_op_e     csr_op;
  opcode_e     opcode;
  opcode_e     opcode_alu;
  assign instr     = instr_rdata_i;
  assign instr_alu = instr_rdata_alu_i;
  assign imm_i_type_o = { {20{instr[31]}}, instr[31:20] };
  assign imm_s_type_o = { {20{instr[31]}}, instr[31:25], instr[11:7] };
  assign imm_b_type_o = { {19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0 };
  assign imm_u_type_o = { instr[31:12], 12'b0 };
  assign imm_j_type_o = { {12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0 };
  assign csr_addr_o = csr_num_e'(instr[31:20]);
  assign zimm_rs1_type_o = { 27'b0, instr_rs1 };  
  if (RV32B != RV32BNone) begin : gen_rs3_flop
    always_ff  @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        use_rs3_q <= 1'b0;
      end else begin
        use_rs3_q <= use_rs3_d;
      end
    end
  end else begin : gen_no_rs3_flop
    logic unused_clk;
    logic unused_rst_n;
    assign unused_clk = clk_i;
    assign unused_rst_n = rst_ni;
    assign use_rs3_q = use_rs3_d;
  end
  assign instr_rs1 = instr[19:15];
  assign instr_rs2 = instr[24:20];
  assign instr_rs3 = instr[31:27];
  assign rf_raddr_a_o = (use_rs3_q & ~instr_first_cycle_i) ? instr_rs3 : instr_rs1;  
  assign rf_raddr_b_o = instr_rs2;  
  assign instr_rd = instr[11:7];
  assign rf_waddr_o   = instr_rd;  
  if (RV32E) begin : gen_rv32e_reg_check_active
    assign illegal_reg_rv32e = ((rf_raddr_a_o[4] & (alu_op_a_mux_sel_o == OP_A_REG_A)) |
                                (rf_raddr_b_o[4] & (alu_op_b_mux_sel_o == OP_B_REG_B)) |
                                (rf_waddr_o[4]   & rf_we));
  end else begin : gen_rv32e_reg_check_inactive
    assign illegal_reg_rv32e = 1'b0;
  end
  always_comb begin : csr_operand_check
    csr_op_o = csr_op;
    if ((csr_op == CSR_OP_SET || csr_op == CSR_OP_CLEAR) &&
        instr_rs1 == '0) begin
      csr_op_o = CSR_OP_READ;
    end
  end
  always_comb begin
    jump_in_dec_o         = 1'b0;
    jump_set_o            = 1'b0;
    branch_in_dec_o       = 1'b0;
    icache_inval_o        = 1'b0;
    multdiv_operator_o    = MD_OP_MULL;
    multdiv_signed_mode_o = 2'b00;
    rf_wdata_sel_o        = RF_WD_EX;
    rf_we                 = 1'b0;
    rf_ren_a_o            = 1'b0;
    rf_ren_b_o            = 1'b0;
    csr_access_o          = 1'b0;
    csr_illegal           = 1'b0;
    csr_op                = CSR_OP_READ;
    data_we_o             = 1'b0;
    data_type_o           = 2'b00;
    data_sign_extension_o = 1'b0;
    data_req_o            = 1'b0;
    illegal_insn          = 1'b0;
    ebrk_insn_o           = 1'b0;
    mret_insn_o           = 1'b0;
    dret_insn_o           = 1'b0;
    ecall_insn_o          = 1'b0;
    wfi_insn_o            = 1'b0;
    opcode                = opcode_e'(instr[6:0]);
    unique case (opcode)
      OPCODE_JAL: begin    
        jump_in_dec_o      = 1'b1;
        if (instr_first_cycle_i) begin
          rf_we            = BranchTargetALU;
          jump_set_o       = 1'b1;
        end else begin
          rf_we            = 1'b1;
        end
      end
      OPCODE_JALR: begin   
        jump_in_dec_o      = 1'b1;
        if (instr_first_cycle_i) begin
          rf_we            = BranchTargetALU;
          jump_set_o       = 1'b1;
        end else begin
          rf_we            = 1'b1;
        end
        if (instr[14:12] != 3'b0) begin
          illegal_insn = 1'b1;
        end
        rf_ren_a_o = 1'b1;
      end
      OPCODE_BRANCH: begin  
        branch_in_dec_o       = 1'b1;
        unique case (instr[14:12])
          3'b000,
          3'b001,
          3'b100,
          3'b101,
          3'b110,
          3'b111:  illegal_insn = 1'b0;
          default: illegal_insn = 1'b1;
        endcase
        rf_ren_a_o = 1'b1;
        rf_ren_b_o = 1'b1;
      end
      OPCODE_STORE: begin
        rf_ren_a_o         = 1'b1;
        rf_ren_b_o         = 1'b1;
        data_req_o         = 1'b1;
        data_we_o          = 1'b1;
        if (instr[14]) begin
          illegal_insn = 1'b1;
        end
        unique case (instr[13:12])
          2'b00:   data_type_o  = 2'b10;  
          2'b01:   data_type_o  = 2'b01;  
          2'b10:   data_type_o  = 2'b00;  
          default: illegal_insn = 1'b1;
        endcase
      end
      OPCODE_LOAD: begin
        rf_ren_a_o          = 1'b1;
        data_req_o          = 1'b1;
        data_type_o         = 2'b00;
        data_sign_extension_o = ~instr[14];
        unique case (instr[13:12])
          2'b00: data_type_o = 2'b10;  
          2'b01: data_type_o = 2'b01;  
          2'b10: begin
            data_type_o = 2'b00;       
            if (instr[14]) begin
              illegal_insn = 1'b1;     
            end
          end
          default: begin
            illegal_insn = 1'b1;
          end
        endcase
      end
      OPCODE_LUI: begin   
        rf_we            = 1'b1;
      end
      OPCODE_AUIPC: begin   
        rf_we            = 1'b1;
      end
      OPCODE_OP_IMM: begin  
        rf_ren_a_o       = 1'b1;
        rf_we            = 1'b1;
        unique case (instr[14:12])
          3'b000,
          3'b010,
          3'b011,
          3'b100,
          3'b110,
          3'b111: illegal_insn = 1'b0;
          3'b001: begin
            unique case (instr[31:27])
              5'b0_0000: illegal_insn = (instr[26:25] == 2'b00) ? 1'b0 : 1'b1;         
              5'b0_0100: begin                                                         
                illegal_insn = (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) ? 1'b0 : 1'b1;
              end
              5'b0_1001,                                                               
              5'b0_0101,                                                               
              5'b0_1101: illegal_insn = (RV32B != RV32BNone) ? 1'b0 : 1'b1;            
              5'b0_0001: begin
                if (instr[26] == 1'b0) begin                                           
                  illegal_insn = (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) ? 1'b0 : 1'b1;
                end else begin
                  illegal_insn = 1'b1;
                end
              end
              5'b0_1100: begin
                unique case(instr[26:20])
                  7'b000_0000,                                                          
                  7'b000_0001,                                                          
                  7'b000_0010,                                                          
                  7'b000_0100,                                                          
                  7'b000_0101: illegal_insn = (RV32B != RV32BNone) ? 1'b0 : 1'b1;       
                  7'b001_0000,                                                          
                  7'b001_0001,                                                          
                  7'b001_0010,                                                          
                  7'b001_1000,                                                          
                  7'b001_1001,                                                          
                  7'b001_1010: begin                                                    
                    illegal_insn = (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) ? 1'b0 : 1'b1;
                  end
                  default: illegal_insn = 1'b1;
                endcase
              end
              default : illegal_insn = 1'b1;
            endcase
          end
          3'b101: begin
            if (instr[26]) begin
              illegal_insn = (RV32B != RV32BNone) ? 1'b0 : 1'b1;                        
            end else begin
              unique case (instr[31:27])
                5'b0_0000,                                                              
                5'b0_1000: illegal_insn = (instr[26:25] == 2'b00) ? 1'b0 : 1'b1;        
                5'b0_0100: begin                                                        
                  illegal_insn = (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) ? 1'b0 : 1'b1;
                end
                5'b0_1100,                                                              
                5'b0_1001: illegal_insn = (RV32B != RV32BNone) ? 1'b0 : 1'b1;           
                5'b0_1101: begin
                  if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) begin
                    illegal_insn = 1'b0;                                                
                  end else if (RV32B == RV32BBalanced) begin
                    illegal_insn = (instr[24:20] == 5'b11000) ? 1'b0 : 1'b1;            
                  end else begin
                    illegal_insn = 1'b1;
                  end
                end
                5'b0_0101: begin
                  if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) begin
                    illegal_insn = 1'b0;                                               
                  end else if (instr[24:20] == 5'b00111) begin
                    illegal_insn = (RV32B == RV32BBalanced) ? 1'b0 : 1'b1;             
                  end else begin
                    illegal_insn = 1'b1;
                  end
                end
                5'b0_0001: begin
                  illegal_insn = (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) ? 1'b0 : 1'b1;
                end
                default: illegal_insn = 1'b1;
              endcase
            end
          end
          default: illegal_insn = 1'b1;
        endcase
      end
      OPCODE_OP: begin   
        rf_ren_a_o      = 1'b1;
        rf_ren_b_o      = 1'b1;
        rf_we           = 1'b1;
        if ({instr[26], instr[13:12]} == {1'b1, 2'b01}) begin
          illegal_insn = (RV32B != RV32BNone) ? 1'b0 : 1'b1;  
        end else begin
          unique case ({instr[31:25], instr[14:12]})
            {7'b000_0000, 3'b000},
            {7'b010_0000, 3'b000},
            {7'b000_0000, 3'b010},
            {7'b000_0000, 3'b011},
            {7'b000_0000, 3'b100},
            {7'b000_0000, 3'b110},
            {7'b000_0000, 3'b111},
            {7'b000_0000, 3'b001},
            {7'b000_0000, 3'b101},
            {7'b010_0000, 3'b101}: illegal_insn = 1'b0;
            {7'b001_0000, 3'b010},  
            {7'b001_0000, 3'b100},  
            {7'b001_0000, 3'b110},  
            {7'b010_0000, 3'b111},  
            {7'b010_0000, 3'b110},  
            {7'b010_0000, 3'b100},  
            {7'b011_0000, 3'b001},  
            {7'b011_0000, 3'b101},  
            {7'b000_0101, 3'b100},  
            {7'b000_0101, 3'b110},  
            {7'b000_0101, 3'b101},  
            {7'b000_0101, 3'b111},  
            {7'b000_0100, 3'b100},  
            {7'b010_0100, 3'b100},  
            {7'b000_0100, 3'b111},  
            {7'b010_0100, 3'b001},  
            {7'b001_0100, 3'b001},  
            {7'b011_0100, 3'b001},  
            {7'b010_0100, 3'b101},  
            {7'b010_0100, 3'b111}: illegal_insn = (RV32B != RV32BNone) ? 1'b0 : 1'b1;  
            {7'b011_0100, 3'b101},  
            {7'b001_0100, 3'b101},  
            {7'b000_0100, 3'b001},  
            {7'b000_0100, 3'b101},  
            {7'b001_0100, 3'b010},  
            {7'b001_0100, 3'b100},  
            {7'b001_0100, 3'b110},  
            {7'b001_0000, 3'b001},  
            {7'b001_0000, 3'b101},  
            {7'b000_0101, 3'b001},  
            {7'b000_0101, 3'b010},  
            {7'b000_0101, 3'b011}: begin  
              illegal_insn = (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) ? 1'b0 : 1'b1;
            end
            {7'b010_0100, 3'b110},  
            {7'b000_0100, 3'b110}: illegal_insn = (RV32B == RV32BFull) ? 1'b0 : 1'b1;  
            {7'b000_0001, 3'b000}: begin  
              multdiv_operator_o    = MD_OP_MULL;
              multdiv_signed_mode_o = 2'b00;
              illegal_insn          = (RV32M == RV32MNone) ? 1'b1 : 1'b0;
            end
            {7'b000_0001, 3'b001}: begin  
              multdiv_operator_o    = MD_OP_MULH;
              multdiv_signed_mode_o = 2'b11;
              illegal_insn          = (RV32M == RV32MNone) ? 1'b1 : 1'b0;
            end
            {7'b000_0001, 3'b010}: begin  
              multdiv_operator_o    = MD_OP_MULH;
              multdiv_signed_mode_o = 2'b01;
              illegal_insn          = (RV32M == RV32MNone) ? 1'b1 : 1'b0;
            end
            {7'b000_0001, 3'b011}: begin  
              multdiv_operator_o    = MD_OP_MULH;
              multdiv_signed_mode_o = 2'b00;
              illegal_insn          = (RV32M == RV32MNone) ? 1'b1 : 1'b0;
            end
            {7'b000_0001, 3'b100}: begin  
              multdiv_operator_o    = MD_OP_DIV;
              multdiv_signed_mode_o = 2'b11;
              illegal_insn          = (RV32M == RV32MNone) ? 1'b1 : 1'b0;
            end
            {7'b000_0001, 3'b101}: begin  
              multdiv_operator_o    = MD_OP_DIV;
              multdiv_signed_mode_o = 2'b00;
              illegal_insn          = (RV32M == RV32MNone) ? 1'b1 : 1'b0;
            end
            {7'b000_0001, 3'b110}: begin  
              multdiv_operator_o    = MD_OP_REM;
              multdiv_signed_mode_o = 2'b11;
              illegal_insn          = (RV32M == RV32MNone) ? 1'b1 : 1'b0;
            end
            {7'b000_0001, 3'b111}: begin  
              multdiv_operator_o    = MD_OP_REM;
              multdiv_signed_mode_o = 2'b00;
              illegal_insn          = (RV32M == RV32MNone) ? 1'b1 : 1'b0;
            end
            default: begin
              illegal_insn = 1'b1;
            end
          endcase
        end
      end
      OPCODE_MISC_MEM: begin
        unique case (instr[14:12])
          3'b000: begin
            rf_we           = 1'b0;
          end
          3'b001: begin
            jump_in_dec_o   = 1'b1;
            rf_we           = 1'b0;
            if (instr_first_cycle_i) begin
              jump_set_o       = 1'b1;
              icache_inval_o   = 1'b1;
            end
          end
          default: begin
            illegal_insn       = 1'b1;
          end
        endcase
      end
      OPCODE_SYSTEM: begin
        if (instr[14:12] == 3'b000) begin
          unique case (instr[31:20])
            12'h000:   
              ecall_insn_o = 1'b1;
            12'h001:   
              ebrk_insn_o = 1'b1;
            12'h302:   
              mret_insn_o = 1'b1;
            12'h7b2:   
              dret_insn_o = 1'b1;
            12'h105:   
              wfi_insn_o = 1'b1;
            default:
              illegal_insn = 1'b1;
          endcase
          if (instr_rs1 != 5'b0 || instr_rd != 5'b0) begin
            illegal_insn = 1'b1;
          end
        end else begin
          csr_access_o     = 1'b1;
          rf_wdata_sel_o   = RF_WD_CSR;
          rf_we            = 1'b1;
          if (~instr[14]) begin
            rf_ren_a_o         = 1'b1;
          end
          unique case (instr[13:12])
            2'b01:   csr_op = CSR_OP_WRITE;
            2'b10:   csr_op = CSR_OP_SET;
            2'b11:   csr_op = CSR_OP_CLEAR;
            default: csr_illegal = 1'b1;
          endcase
          illegal_insn = csr_illegal;
        end
      end
      default: begin
        illegal_insn = 1'b1;
      end
    endcase
    if (illegal_c_insn_i) begin
      illegal_insn = 1'b1;
    end
    if (illegal_insn) begin
      rf_we           = 1'b0;
      data_req_o      = 1'b0;
      data_we_o       = 1'b0;
      jump_in_dec_o   = 1'b0;
      jump_set_o      = 1'b0;
      branch_in_dec_o = 1'b0;
      csr_access_o    = 1'b0;
    end
  end
  always_comb begin
    alu_operator_o     = ALU_SLTU;
    alu_op_a_mux_sel_o = OP_A_IMM;
    alu_op_b_mux_sel_o = OP_B_IMM;
    imm_a_mux_sel_o    = IMM_A_ZERO;
    imm_b_mux_sel_o    = IMM_B_I;
    bt_a_mux_sel_o     = OP_A_CURRPC;
    bt_b_mux_sel_o     = IMM_B_I;
    opcode_alu         = opcode_e'(instr_alu[6:0]);
    use_rs3_d          = 1'b0;
    alu_multicycle_o   = 1'b0;
    mult_sel_o         = 1'b0;
    div_sel_o          = 1'b0;
    unique case (opcode_alu)
      OPCODE_JAL: begin  
        if (BranchTargetALU) begin
          bt_a_mux_sel_o = OP_A_CURRPC;
          bt_b_mux_sel_o = IMM_B_J;
        end
        if (instr_first_cycle_i && !BranchTargetALU) begin
          alu_op_a_mux_sel_o  = OP_A_CURRPC;
          alu_op_b_mux_sel_o  = OP_B_IMM;
          imm_b_mux_sel_o     = IMM_B_J;
          alu_operator_o      = ALU_ADD;
        end else begin
          alu_op_a_mux_sel_o  = OP_A_CURRPC;
          alu_op_b_mux_sel_o  = OP_B_IMM;
          imm_b_mux_sel_o     = IMM_B_INCR_PC;
          alu_operator_o      = ALU_ADD;
        end
      end
      OPCODE_JALR: begin  
        if (BranchTargetALU) begin
          bt_a_mux_sel_o = OP_A_REG_A;
          bt_b_mux_sel_o = IMM_B_I;
        end
        if (instr_first_cycle_i && !BranchTargetALU) begin
          alu_op_a_mux_sel_o  = OP_A_REG_A;
          alu_op_b_mux_sel_o  = OP_B_IMM;
          imm_b_mux_sel_o     = IMM_B_I;
          alu_operator_o      = ALU_ADD;
        end else begin
          alu_op_a_mux_sel_o  = OP_A_CURRPC;
          alu_op_b_mux_sel_o  = OP_B_IMM;
          imm_b_mux_sel_o     = IMM_B_INCR_PC;
          alu_operator_o      = ALU_ADD;
        end
      end
      OPCODE_BRANCH: begin  
        unique case (instr_alu[14:12])
          3'b000:  alu_operator_o = ALU_EQ;
          3'b001:  alu_operator_o = ALU_NE;
          3'b100:  alu_operator_o = ALU_LT;
          3'b101:  alu_operator_o = ALU_GE;
          3'b110:  alu_operator_o = ALU_LTU;
          3'b111:  alu_operator_o = ALU_GEU;
          default: ;
        endcase
        if (BranchTargetALU) begin
          bt_a_mux_sel_o = OP_A_CURRPC;
          bt_b_mux_sel_o = branch_taken_i ? IMM_B_B : IMM_B_INCR_PC;
        end
        if (instr_first_cycle_i) begin
          alu_op_a_mux_sel_o  = OP_A_REG_A;
          alu_op_b_mux_sel_o  = OP_B_REG_B;
        end else if (!BranchTargetALU) begin
          alu_op_a_mux_sel_o  = OP_A_CURRPC;
          alu_op_b_mux_sel_o  = OP_B_IMM;
          imm_b_mux_sel_o     = branch_taken_i ? IMM_B_B : IMM_B_INCR_PC;
          alu_operator_o      = ALU_ADD;
        end
      end
      OPCODE_STORE: begin
        alu_op_a_mux_sel_o = OP_A_REG_A;
        alu_op_b_mux_sel_o = OP_B_REG_B;
        alu_operator_o     = ALU_ADD;
        if (!instr_alu[14]) begin
          imm_b_mux_sel_o     = IMM_B_S;
          alu_op_b_mux_sel_o  = OP_B_IMM;
        end
      end
      OPCODE_LOAD: begin
        alu_op_a_mux_sel_o  = OP_A_REG_A;
        alu_operator_o      = ALU_ADD;
        alu_op_b_mux_sel_o  = OP_B_IMM;
        imm_b_mux_sel_o     = IMM_B_I;
      end
      OPCODE_LUI: begin   
        alu_op_a_mux_sel_o  = OP_A_IMM;
        alu_op_b_mux_sel_o  = OP_B_IMM;
        imm_a_mux_sel_o     = IMM_A_ZERO;
        imm_b_mux_sel_o     = IMM_B_U;
        alu_operator_o      = ALU_ADD;
      end
      OPCODE_AUIPC: begin   
        alu_op_a_mux_sel_o  = OP_A_CURRPC;
        alu_op_b_mux_sel_o  = OP_B_IMM;
        imm_b_mux_sel_o     = IMM_B_U;
        alu_operator_o      = ALU_ADD;
      end
      OPCODE_OP_IMM: begin  
        alu_op_a_mux_sel_o  = OP_A_REG_A;
        alu_op_b_mux_sel_o  = OP_B_IMM;
        imm_b_mux_sel_o     = IMM_B_I;
        unique case (instr_alu[14:12])
          3'b000: alu_operator_o = ALU_ADD;   
          3'b010: alu_operator_o = ALU_SLT;   
          3'b011: alu_operator_o = ALU_SLTU;  
          3'b100: alu_operator_o = ALU_XOR;   
          3'b110: alu_operator_o = ALU_OR;    
          3'b111: alu_operator_o = ALU_AND;   
          3'b001: begin
            if (RV32B != RV32BNone) begin
              unique case (instr_alu[31:27])
                5'b0_0000: alu_operator_o = ALU_SLL;     
                5'b0_0100: begin
                  if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) alu_operator_o = ALU_SLO;
                end
                5'b0_1001: alu_operator_o = ALU_BCLR;  
                5'b0_0101: alu_operator_o = ALU_BSET;  
                5'b0_1101: alu_operator_o = ALU_BINV;  
                5'b0_0001: if (instr_alu[26] == 0) alu_operator_o = ALU_SHFL;
                5'b0_1100: begin
                  unique case (instr_alu[26:20])
                    7'b000_0000: alu_operator_o = ALU_CLZ;    
                    7'b000_0001: alu_operator_o = ALU_CTZ;    
                    7'b000_0010: alu_operator_o = ALU_CPOP;   
                    7'b000_0100: alu_operator_o = ALU_SEXTB;  
                    7'b000_0101: alu_operator_o = ALU_SEXTH;  
                    7'b001_0000: begin
                      if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) begin
                        alu_operator_o = ALU_CRC32_B;   
                        alu_multicycle_o = 1'b1;
                      end
                    end
                    7'b001_0001: begin
                      if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) begin
                        alu_operator_o = ALU_CRC32_H;   
                        alu_multicycle_o = 1'b1;
                      end
                    end
                    7'b001_0010: begin
                      if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) begin
                        alu_operator_o = ALU_CRC32_W;   
                        alu_multicycle_o = 1'b1;
                      end
                    end
                    7'b001_1000: begin
                      if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) begin
                        alu_operator_o = ALU_CRC32C_B;  
                        alu_multicycle_o = 1'b1;
                      end
                    end
                    7'b001_1001: begin
                      if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) begin
                        alu_operator_o = ALU_CRC32C_H;  
                        alu_multicycle_o = 1'b1;
                      end
                    end
                    7'b001_1010: begin
                      if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) begin
                        alu_operator_o = ALU_CRC32C_W;  
                        alu_multicycle_o = 1'b1;
                      end
                    end
                    default: ;
                  endcase
                end
                default: ;
              endcase
            end else begin
              alu_operator_o = ALU_SLL;  
            end
          end
          3'b101: begin
            if (RV32B != RV32BNone) begin
              if (instr_alu[26] == 1'b1) begin
                alu_operator_o = ALU_FSR;
                alu_multicycle_o = 1'b1;
                if (instr_first_cycle_i) begin
                  use_rs3_d = 1'b1;
                end else begin
                  use_rs3_d = 1'b0;
                end
              end else begin
                unique case (instr_alu[31:27])
                  5'b0_0000: alu_operator_o = ALU_SRL;    
                  5'b0_1000: alu_operator_o = ALU_SRA;    
                  5'b0_0100: begin
                    if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) alu_operator_o = ALU_SRO;
                  end
                  5'b0_1001: alu_operator_o = ALU_BEXT;   
                  5'b0_1100: begin
                    alu_operator_o = ALU_ROR;             
                    alu_multicycle_o = 1'b1;
                  end
                  5'b0_1101: alu_operator_o = ALU_GREV;   
                  5'b0_0101: alu_operator_o = ALU_GORC;   
                  5'b0_0001: begin
                    if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) begin
                      if (instr_alu[26] == 1'b0) alu_operator_o = ALU_UNSHFL;
                    end
                  end
                  default: ;
                endcase
              end
            end else begin
              if (instr_alu[31:27] == 5'b0_0000) begin
                alu_operator_o = ALU_SRL;                
              end else if (instr_alu[31:27] == 5'b0_1000) begin
                alu_operator_o = ALU_SRA;                
              end
            end
          end
          default: ;
        endcase
      end
      OPCODE_OP: begin   
        alu_op_a_mux_sel_o = OP_A_REG_A;
        alu_op_b_mux_sel_o = OP_B_REG_B;
        if (instr_alu[26]) begin
          if (RV32B != RV32BNone) begin
            unique case ({instr_alu[26:25], instr_alu[14:12]})
              {2'b11, 3'b001}: begin
                alu_operator_o   = ALU_CMIX;  
                alu_multicycle_o = 1'b1;
                if (instr_first_cycle_i) begin
                  use_rs3_d = 1'b1;
                end else begin
                  use_rs3_d = 1'b0;
                end
              end
              {2'b11, 3'b101}: begin
                alu_operator_o   = ALU_CMOV;  
                alu_multicycle_o = 1'b1;
                if (instr_first_cycle_i) begin
                  use_rs3_d = 1'b1;
                end else begin
                  use_rs3_d = 1'b0;
                end
              end
              {2'b10, 3'b001}: begin
                alu_operator_o   = ALU_FSL;   
                alu_multicycle_o = 1'b1;
                if (instr_first_cycle_i) begin
                  use_rs3_d = 1'b1;
                end else begin
                  use_rs3_d = 1'b0;
                end
              end
              {2'b10, 3'b101}: begin
                alu_operator_o   = ALU_FSR;   
                alu_multicycle_o = 1'b1;
                if (instr_first_cycle_i) begin
                  use_rs3_d = 1'b1;
                end else begin
                  use_rs3_d = 1'b0;
                end
              end
              default: ;
            endcase
          end
        end else begin
          unique case ({instr_alu[31:25], instr_alu[14:12]})
            {7'b000_0000, 3'b000}: alu_operator_o = ALU_ADD;    
            {7'b010_0000, 3'b000}: alu_operator_o = ALU_SUB;    
            {7'b000_0000, 3'b010}: alu_operator_o = ALU_SLT;    
            {7'b000_0000, 3'b011}: alu_operator_o = ALU_SLTU;   
            {7'b000_0000, 3'b100}: alu_operator_o = ALU_XOR;    
            {7'b000_0000, 3'b110}: alu_operator_o = ALU_OR;     
            {7'b000_0000, 3'b111}: alu_operator_o = ALU_AND;    
            {7'b000_0000, 3'b001}: alu_operator_o = ALU_SLL;    
            {7'b000_0000, 3'b101}: alu_operator_o = ALU_SRL;    
            {7'b010_0000, 3'b101}: alu_operator_o = ALU_SRA;    
            {7'b011_0000, 3'b001}: begin
              if (RV32B != RV32BNone) begin
                alu_operator_o = ALU_ROL;
                alu_multicycle_o = 1'b1;
              end
            end
            {7'b011_0000, 3'b101}: begin
              if (RV32B != RV32BNone) begin
                alu_operator_o = ALU_ROR;
                alu_multicycle_o = 1'b1;
              end
            end
            {7'b000_0101, 3'b100}: if (RV32B != RV32BNone) alu_operator_o = ALU_MIN;
            {7'b000_0101, 3'b110}: if (RV32B != RV32BNone) alu_operator_o = ALU_MAX;
            {7'b000_0101, 3'b101}: if (RV32B != RV32BNone) alu_operator_o = ALU_MINU;
            {7'b000_0101, 3'b111}: if (RV32B != RV32BNone) alu_operator_o = ALU_MAXU;
            {7'b000_0100, 3'b100}: if (RV32B != RV32BNone) alu_operator_o = ALU_PACK;
            {7'b010_0100, 3'b100}: if (RV32B != RV32BNone) alu_operator_o = ALU_PACKU;
            {7'b000_0100, 3'b111}: if (RV32B != RV32BNone) alu_operator_o = ALU_PACKH;
            {7'b010_0000, 3'b100}: if (RV32B != RV32BNone) alu_operator_o = ALU_XNOR;
            {7'b010_0000, 3'b110}: if (RV32B != RV32BNone) alu_operator_o = ALU_ORN;
            {7'b010_0000, 3'b111}: if (RV32B != RV32BNone) alu_operator_o = ALU_ANDN;
            {7'b001_0000, 3'b010}: if (RV32B != RV32BNone) alu_operator_o = ALU_SH1ADD;
            {7'b001_0000, 3'b100}: if (RV32B != RV32BNone) alu_operator_o = ALU_SH2ADD;
            {7'b001_0000, 3'b110}: if (RV32B != RV32BNone) alu_operator_o = ALU_SH3ADD;
            {7'b010_0100, 3'b001}: if (RV32B != RV32BNone) alu_operator_o = ALU_BCLR;
            {7'b001_0100, 3'b001}: if (RV32B != RV32BNone) alu_operator_o = ALU_BSET;
            {7'b011_0100, 3'b001}: if (RV32B != RV32BNone) alu_operator_o = ALU_BINV;
            {7'b010_0100, 3'b101}: if (RV32B != RV32BNone) alu_operator_o = ALU_BEXT;
            {7'b010_0100, 3'b111}: if (RV32B != RV32BNone) alu_operator_o = ALU_BFP;
            {7'b011_0100, 3'b101}: if (RV32B != RV32BNone) alu_operator_o = ALU_GREV;
            {7'b001_0100, 3'b101}: if (RV32B != RV32BNone) alu_operator_o = ALU_GORC;
            {7'b000_0100, 3'b001}: begin
              if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) alu_operator_o = ALU_SHFL;
            end
            {7'b000_0100, 3'b101}: begin
              if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) alu_operator_o = ALU_UNSHFL;
            end
            {7'b001_0100, 3'b010}: begin
              if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) alu_operator_o = ALU_XPERM_N;
            end
            {7'b001_0100, 3'b100}: begin
              if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) alu_operator_o = ALU_XPERM_B;
            end
            {7'b001_0100, 3'b110}: begin
              if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) alu_operator_o = ALU_XPERM_H;
            end
            {7'b001_0000, 3'b001}: begin
              if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) alu_operator_o = ALU_SLO;
            end
            {7'b001_0000, 3'b101}: begin
              if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) alu_operator_o = ALU_SRO;
            end
            {7'b000_0101, 3'b001}: begin
              if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) alu_operator_o = ALU_CLMUL;
            end
            {7'b000_0101, 3'b010}: begin
              if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) alu_operator_o = ALU_CLMULR;
            end
            {7'b000_0101, 3'b011}: begin
              if (RV32B == RV32BOTEarlGrey || RV32B == RV32BFull) alu_operator_o = ALU_CLMULH;
            end
            {7'b010_0100, 3'b110}: begin
              if (RV32B == RV32BFull) begin
                alu_operator_o = ALU_BDECOMPRESS;
                alu_multicycle_o = 1'b1;
              end
            end
            {7'b000_0100, 3'b110}: begin
              if (RV32B == RV32BFull) begin
                alu_operator_o = ALU_BCOMPRESS;
                alu_multicycle_o = 1'b1;
              end
            end
            {7'b000_0001, 3'b000}: begin  
              alu_operator_o = ALU_ADD;
              mult_sel_o     = (RV32M == RV32MNone) ? 1'b0 : 1'b1;
            end
            {7'b000_0001, 3'b001}: begin  
              alu_operator_o = ALU_ADD;
              mult_sel_o     = (RV32M == RV32MNone) ? 1'b0 : 1'b1;
            end
            {7'b000_0001, 3'b010}: begin  
              alu_operator_o = ALU_ADD;
              mult_sel_o     = (RV32M == RV32MNone) ? 1'b0 : 1'b1;
            end
            {7'b000_0001, 3'b011}: begin  
              alu_operator_o = ALU_ADD;
              mult_sel_o     = (RV32M == RV32MNone) ? 1'b0 : 1'b1;
            end
            {7'b000_0001, 3'b100}: begin  
              alu_operator_o = ALU_ADD;
              div_sel_o      = (RV32M == RV32MNone) ? 1'b0 : 1'b1;
            end
            {7'b000_0001, 3'b101}: begin  
              alu_operator_o = ALU_ADD;
              div_sel_o      = (RV32M == RV32MNone) ? 1'b0 : 1'b1;
            end
            {7'b000_0001, 3'b110}: begin  
              alu_operator_o = ALU_ADD;
              div_sel_o      = (RV32M == RV32MNone) ? 1'b0 : 1'b1;
            end
            {7'b000_0001, 3'b111}: begin  
              alu_operator_o = ALU_ADD;
              div_sel_o      = (RV32M == RV32MNone) ? 1'b0 : 1'b1;
            end
            default: ;
          endcase
        end
      end
      OPCODE_MISC_MEM: begin
        unique case (instr_alu[14:12])
          3'b000: begin
            alu_operator_o     = ALU_ADD;  
            alu_op_a_mux_sel_o = OP_A_REG_A;
            alu_op_b_mux_sel_o = OP_B_IMM;
          end
          3'b001: begin
            if (BranchTargetALU) begin
              bt_a_mux_sel_o     = OP_A_CURRPC;
              bt_b_mux_sel_o     = IMM_B_INCR_PC;
            end else begin
              alu_op_a_mux_sel_o = OP_A_CURRPC;
              alu_op_b_mux_sel_o = OP_B_IMM;
              imm_b_mux_sel_o    = IMM_B_INCR_PC;
              alu_operator_o     = ALU_ADD;
            end
          end
          default: ;
        endcase
      end
      OPCODE_SYSTEM: begin
        if (instr_alu[14:12] == 3'b000) begin
          alu_op_a_mux_sel_o = OP_A_REG_A;
          alu_op_b_mux_sel_o = OP_B_IMM;
        end else begin
          imm_a_mux_sel_o    = IMM_A_Z;
          if (instr_alu[14]) begin
            alu_op_a_mux_sel_o = OP_A_IMM;
          end else begin
            alu_op_a_mux_sel_o = OP_A_REG_A;
          end
        end
      end
      default: ;
    endcase
  end
  assign mult_en_o = illegal_insn ? 1'b0 : mult_sel_o;
  assign div_en_o  = illegal_insn ? 1'b0 : div_sel_o;
  assign illegal_insn_o = illegal_insn | illegal_reg_rv32e;
  assign rf_we_o = rf_we & ~illegal_reg_rv32e;
  assign unused_instr_alu = {instr_alu[19:15],instr_alu[11:7]};
endmodule  
module ibex_ex_block #(
  parameter ibex_pkg::rv32m_e RV32M           = ibex_pkg::RV32MFast,
  parameter ibex_pkg::rv32b_e RV32B           = ibex_pkg::RV32BNone,
  parameter bit               BranchTargetALU = 0
) (
  input  logic                  clk_i,
  input  logic                  rst_ni,
  input  ibex_pkg::alu_op_e     alu_operator_i,
  input  logic [31:0]           alu_operand_a_i,
  input  logic [31:0]           alu_operand_b_i,
  input  logic                  alu_instr_first_cycle_i,
  input  logic [31:0]           bt_a_operand_i,
  input  logic [31:0]           bt_b_operand_i,
  input  ibex_pkg::md_op_e      multdiv_operator_i,
  input  logic                  mult_en_i,              
  input  logic                  div_en_i,               
  input  logic                  mult_sel_i,             
  input  logic                  div_sel_i,              
  input  logic  [1:0]           multdiv_signed_mode_i,
  input  logic [31:0]           multdiv_operand_a_i,
  input  logic [31:0]           multdiv_operand_b_i,
  input  logic                  multdiv_ready_id_i,
  input  logic                  data_ind_timing_i,
  output logic [1:0]            imd_val_we_o,
  output logic [33:0]           imd_val_d_o[2],
  input  logic [33:0]           imd_val_q_i[2],
  output logic [31:0]           alu_adder_result_ex_o,  
  output logic [31:0]           result_ex_o,
  output logic [31:0]           branch_target_o,        
  output logic                  branch_decision_o,      
  output logic                  ex_valid_o              
);
  import ibex_pkg::*;
  logic [31:0] alu_result, multdiv_result;
  logic [32:0] multdiv_alu_operand_b, multdiv_alu_operand_a;
  logic [33:0] alu_adder_result_ext;
  logic        alu_cmp_result, alu_is_equal_result;
  logic        multdiv_valid;
  logic        multdiv_sel;
  logic [31:0] alu_imd_val_q[2];
  logic [31:0] alu_imd_val_d[2];
  logic [ 1:0] alu_imd_val_we;
  logic [33:0] multdiv_imd_val_d[2];
  logic [ 1:0] multdiv_imd_val_we;
  if (RV32M != RV32MNone) begin : gen_multdiv_m
    assign multdiv_sel = mult_sel_i | div_sel_i;
  end else begin : gen_multdiv_no_m
    assign multdiv_sel = 1'b0;
  end
  assign imd_val_d_o[0] = multdiv_sel ? multdiv_imd_val_d[0] : {2'b0, alu_imd_val_d[0]};
  assign imd_val_d_o[1] = multdiv_sel ? multdiv_imd_val_d[1] : {2'b0, alu_imd_val_d[1]};
  assign imd_val_we_o   = multdiv_sel ? multdiv_imd_val_we : alu_imd_val_we;
  assign alu_imd_val_q = '{imd_val_q_i[0][31:0], imd_val_q_i[1][31:0]};
  assign result_ex_o  = multdiv_sel ? multdiv_result : alu_result;
  assign branch_decision_o  = alu_cmp_result;
  if (BranchTargetALU) begin : g_branch_target_alu
    logic [32:0] bt_alu_result;
    logic        unused_bt_carry;
    assign bt_alu_result   = bt_a_operand_i + bt_b_operand_i;
    assign unused_bt_carry = bt_alu_result[32];
    assign branch_target_o = bt_alu_result[31:0];
  end else begin : g_no_branch_target_alu
    logic [31:0] unused_bt_a_operand, unused_bt_b_operand;
    assign unused_bt_a_operand = bt_a_operand_i;
    assign unused_bt_b_operand = bt_b_operand_i;
    assign branch_target_o = alu_adder_result_ex_o;
  end
  ibex_alu #(
    .RV32B(RV32B)
  ) alu_i (
    .operator_i         (alu_operator_i),
    .operand_a_i        (alu_operand_a_i),
    .operand_b_i        (alu_operand_b_i),
    .instr_first_cycle_i(alu_instr_first_cycle_i),
    .imd_val_q_i        (alu_imd_val_q),
    .imd_val_we_o       (alu_imd_val_we),
    .imd_val_d_o        (alu_imd_val_d),
    .multdiv_operand_a_i(multdiv_alu_operand_a),
    .multdiv_operand_b_i(multdiv_alu_operand_b),
    .multdiv_sel_i      (multdiv_sel),
    .adder_result_o     (alu_adder_result_ex_o),
    .adder_result_ext_o (alu_adder_result_ext),
    .result_o           (alu_result),
    .comparison_result_o(alu_cmp_result),
    .is_equal_result_o  (alu_is_equal_result)
  );
  if (RV32M == RV32MSlow) begin : gen_multdiv_slow
    ibex_multdiv_slow multdiv_i (
      .clk_i             (clk_i),
      .rst_ni            (rst_ni),
      .mult_en_i         (mult_en_i),
      .div_en_i          (div_en_i),
      .mult_sel_i        (mult_sel_i),
      .div_sel_i         (div_sel_i),
      .operator_i        (multdiv_operator_i),
      .signed_mode_i     (multdiv_signed_mode_i),
      .op_a_i            (multdiv_operand_a_i),
      .op_b_i            (multdiv_operand_b_i),
      .alu_adder_ext_i   (alu_adder_result_ext),
      .alu_adder_i       (alu_adder_result_ex_o),
      .equal_to_zero_i   (alu_is_equal_result),
      .data_ind_timing_i (data_ind_timing_i),
      .valid_o           (multdiv_valid),
      .alu_operand_a_o   (multdiv_alu_operand_a),
      .alu_operand_b_o   (multdiv_alu_operand_b),
      .imd_val_q_i       (imd_val_q_i),
      .imd_val_d_o       (multdiv_imd_val_d),
      .imd_val_we_o      (multdiv_imd_val_we),
      .multdiv_ready_id_i(multdiv_ready_id_i),
      .multdiv_result_o  (multdiv_result)
    );
  end else if (RV32M == RV32MFast || RV32M == RV32MSingleCycle) begin : gen_multdiv_fast
    ibex_multdiv_fast #(
      .RV32M(RV32M)
    ) multdiv_i (
      .clk_i             (clk_i),
      .rst_ni            (rst_ni),
      .mult_en_i         (mult_en_i),
      .div_en_i          (div_en_i),
      .mult_sel_i        (mult_sel_i),
      .div_sel_i         (div_sel_i),
      .operator_i        (multdiv_operator_i),
      .signed_mode_i     (multdiv_signed_mode_i),
      .op_a_i            (multdiv_operand_a_i),
      .op_b_i            (multdiv_operand_b_i),
      .alu_operand_a_o   (multdiv_alu_operand_a),
      .alu_operand_b_o   (multdiv_alu_operand_b),
      .alu_adder_ext_i   (alu_adder_result_ext),
      .alu_adder_i       (alu_adder_result_ex_o),
      .equal_to_zero_i   (alu_is_equal_result),
      .data_ind_timing_i (data_ind_timing_i),
      .imd_val_q_i       (imd_val_q_i),
      .imd_val_d_o       (multdiv_imd_val_d),
      .imd_val_we_o      (multdiv_imd_val_we),
      .multdiv_ready_id_i(multdiv_ready_id_i),
      .valid_o           (multdiv_valid),
      .multdiv_result_o  (multdiv_result)
    );
  end
  assign ex_valid_o = multdiv_sel ? multdiv_valid : ~(|alu_imd_val_we);
endmodule
module ibex_fetch_fifo #(
  parameter int unsigned NUM_REQS = 2,
  parameter bit          ResetAll = 1'b0
) (
  input  logic                clk_i,
  input  logic                rst_ni,
  input  logic                clear_i,    
  output logic [NUM_REQS-1:0] busy_o,
  input  logic                in_valid_i,
  input  logic [31:0]         in_addr_i,
  input  logic [31:0]         in_rdata_i,
  input  logic                in_err_i,
  output logic                out_valid_o,
  input  logic                out_ready_i,
  output logic [31:0]         out_addr_o,
  output logic [31:0]         out_rdata_o,
  output logic                out_err_o,
  output logic                out_err_plus2_o
);
  localparam int unsigned DEPTH = NUM_REQS+1;
  logic [DEPTH-1:0] [31:0]  rdata_d,   rdata_q;
  logic [DEPTH-1:0]         err_d,     err_q;
  logic [DEPTH-1:0]         valid_d,   valid_q;
  logic [DEPTH-1:0]         lowest_free_entry;
  logic [DEPTH-1:0]         valid_pushed, valid_popped;
  logic [DEPTH-1:0]         entry_en;
  logic                     pop_fifo;
  logic             [31:0]  rdata, rdata_unaligned;
  logic                     err,   err_unaligned, err_plus2;
  logic                     valid, valid_unaligned;
  logic                     aligned_is_compressed, unaligned_is_compressed;
  logic                     addr_incr_two;
  logic [31:1]              instr_addr_next;
  logic [31:1]              instr_addr_d, instr_addr_q;
  logic                     instr_addr_en;
  logic                     unused_addr_in;
  assign rdata = valid_q[0] ? rdata_q[0] : in_rdata_i;
  assign err   = valid_q[0] ? err_q[0]   : in_err_i;
  assign valid = valid_q[0] | in_valid_i;
  assign rdata_unaligned = valid_q[1] ? {rdata_q[1][15:0], rdata[31:16]} :
                                        {in_rdata_i[15:0], rdata[31:16]};
  assign err_unaligned   = valid_q[1] ? ((err_q[1] & ~unaligned_is_compressed) | err_q[0]) :
                                        ((valid_q[0] & err_q[0]) |
                                         (in_err_i & (~valid_q[0] | ~unaligned_is_compressed)));
  assign err_plus2       = valid_q[1] ? (err_q[1] & ~err_q[0]) :
                                        (in_err_i & valid_q[0] & ~err_q[0]);
  assign valid_unaligned = valid_q[1] ? 1'b1 :
                                        (valid_q[0] & in_valid_i);
  assign unaligned_is_compressed = (rdata[17:16] != 2'b11) & ~err;
  assign aligned_is_compressed   = (rdata[ 1: 0] != 2'b11) & ~err;
  always_comb begin
    if (out_addr_o[1]) begin
      out_rdata_o     = rdata_unaligned;
      out_err_o       = err_unaligned;
      out_err_plus2_o = err_plus2;
      if (unaligned_is_compressed) begin
        out_valid_o = valid;
      end else begin
        out_valid_o = valid_unaligned;
      end
    end else begin
      out_rdata_o     = rdata;
      out_err_o       = err;
      out_err_plus2_o = 1'b0;
      out_valid_o     = valid;
    end
  end
  assign instr_addr_en = clear_i | (out_ready_i & out_valid_o);
  assign addr_incr_two = instr_addr_q[1] ? unaligned_is_compressed :
                                           aligned_is_compressed;
  assign instr_addr_next = (instr_addr_q[31:1] +
                            {29'd0,~addr_incr_two,addr_incr_two});
  assign instr_addr_d = clear_i ? in_addr_i[31:1] :
                                  instr_addr_next;
  if (ResetAll) begin : g_instr_addr_ra
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        instr_addr_q <= '0;
      end else if (instr_addr_en) begin
        instr_addr_q <= instr_addr_d;
      end
    end
  end else begin : g_instr_addr_nr
    always_ff @(posedge clk_i) begin
      if (instr_addr_en) begin
        instr_addr_q <= instr_addr_d;
      end
    end
  end
  assign out_addr_o      = {instr_addr_q, 1'b0};
  assign unused_addr_in = in_addr_i[0];
  assign busy_o = valid_q[DEPTH-1:DEPTH-NUM_REQS];
  assign pop_fifo = out_ready_i & out_valid_o & (~aligned_is_compressed | out_addr_o[1]);
  for (genvar i = 0; i < (DEPTH - 1); i++) begin : g_fifo_next
    if (i == 0) begin : g_ent0
      assign lowest_free_entry[i] = ~valid_q[i];
    end else begin : g_ent_others
      assign lowest_free_entry[i] = ~valid_q[i] & valid_q[i-1];
    end
    assign valid_pushed[i] = (in_valid_i & lowest_free_entry[i]) |
                             valid_q[i];
    assign valid_popped[i] = pop_fifo ? valid_pushed[i+1] : valid_pushed[i];
    assign valid_d[i] = valid_popped[i] & ~clear_i;
    assign entry_en[i] = (valid_pushed[i+1] & pop_fifo) |
                         (in_valid_i & lowest_free_entry[i] & ~pop_fifo);
    assign rdata_d[i]  = valid_q[i+1] ? rdata_q[i+1] : in_rdata_i;
    assign err_d  [i]  = valid_q[i+1] ? err_q  [i+1] : in_err_i;
  end
  assign lowest_free_entry[DEPTH-1] = ~valid_q[DEPTH-1] & valid_q[DEPTH-2];
  assign valid_pushed     [DEPTH-1] = valid_q[DEPTH-1] | (in_valid_i & lowest_free_entry[DEPTH-1]);
  assign valid_popped     [DEPTH-1] = pop_fifo ? 1'b0 : valid_pushed[DEPTH-1];
  assign valid_d [DEPTH-1]          = valid_popped[DEPTH-1] & ~clear_i;
  assign entry_en[DEPTH-1]          = in_valid_i & lowest_free_entry[DEPTH-1];
  assign rdata_d [DEPTH-1]          = in_rdata_i;
  assign err_d   [DEPTH-1]          = in_err_i;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      valid_q <= '0;
    end else begin
      valid_q <= valid_d;
    end
  end
  for (genvar i = 0; i < DEPTH; i++) begin : g_fifo_regs
    if (ResetAll) begin : g_rdata_ra
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          rdata_q[i] <= '0;
          err_q[i]   <= '0;
        end else if (entry_en[i]) begin
          rdata_q[i] <= rdata_d[i];
          err_q[i]   <= err_d[i];
        end
      end
    end else begin : g_rdata_nr
      always_ff @(posedge clk_i) begin
        if (entry_en[i]) begin
          rdata_q[i] <= rdata_d[i];
          err_q[i]   <= err_d[i];
        end
      end
    end
  end
endmodule
module ibex_id_stage #(
  parameter bit               RV32E           = 0,
  parameter ibex_pkg::rv32m_e RV32M           = ibex_pkg::RV32MFast,
  parameter ibex_pkg::rv32b_e RV32B           = ibex_pkg::RV32BNone,
  parameter bit               DataIndTiming   = 1'b0,
  parameter bit               BranchTargetALU = 0,
  parameter bit               WritebackStage  = 0,
  parameter bit               BranchPredictor = 0,
  parameter bit               MemECC          = 1'b0
) (
  input  logic                      clk_i,
  input  logic                      rst_ni,
  output logic                      ctrl_busy_o,
  output logic                      illegal_insn_o,
  input  logic                      instr_valid_i,
  input  logic [31:0]               instr_rdata_i,          
  input  logic [31:0]               instr_rdata_alu_i,      
  input  logic [15:0]               instr_rdata_c_i,        
  input  logic                      instr_is_compressed_i,
  input  ibex_pkg::instr_exp_e      instr_gets_expanded_i,
  input  logic                      instr_bp_taken_i,
  output logic                      instr_req_o,
  output logic                      instr_first_cycle_id_o,
  output logic                      instr_valid_clear_o,    
  output logic                      id_in_ready_o,          
  input  logic                      instr_exec_i,
  output logic                      icache_inval_o,
  input  logic                      branch_decision_i,
  output logic                      pc_set_o,
  output ibex_pkg::pc_sel_e         pc_mux_o,
  output logic                      nt_branch_mispredict_o,
  output logic [31:0]               nt_branch_addr_o,
  output ibex_pkg::exc_pc_sel_e     exc_pc_mux_o,
  output ibex_pkg::exc_cause_t      exc_cause_o,
  input  logic                      illegal_c_insn_i,
  input  logic                      instr_fetch_err_i,
  input  logic                      instr_fetch_err_plus2_i,
  input  logic [31:0]               pc_id_i,
  input  logic                      ex_valid_i,        
  input  logic                      lsu_resp_valid_i,  
  output ibex_pkg::alu_op_e         alu_operator_ex_o,
  output logic [31:0]               alu_operand_a_ex_o,
  output logic [31:0]               alu_operand_b_ex_o,
  input  logic [1:0]                imd_val_we_ex_i,
  input  logic [33:0]               imd_val_d_ex_i[2],
  output logic [33:0]               imd_val_q_ex_o[2],
  output logic [31:0]               bt_a_operand_o,
  output logic [31:0]               bt_b_operand_o,
  output logic                      mult_en_ex_o,
  output logic                      div_en_ex_o,
  output logic                      mult_sel_ex_o,
  output logic                      div_sel_ex_o,
  output ibex_pkg::md_op_e          multdiv_operator_ex_o,
  output logic  [1:0]               multdiv_signed_mode_ex_o,
  output logic [31:0]               multdiv_operand_a_ex_o,
  output logic [31:0]               multdiv_operand_b_ex_o,
  output logic                      multdiv_ready_id_o,
  output logic                      csr_access_o,
  output ibex_pkg::csr_op_e         csr_op_o,
  output ibex_pkg::csr_num_e        csr_addr_o,
  output logic                      csr_op_en_o,
  output logic                      csr_save_if_o,
  output logic                      csr_save_id_o,
  output logic                      csr_save_wb_o,
  output logic                      csr_restore_mret_id_o,
  output logic                      csr_restore_dret_id_o,
  output logic                      csr_save_cause_o,
  output logic [31:0]               csr_mtval_o,
  input  ibex_pkg::priv_lvl_e       priv_mode_i,
  input  logic                      csr_mstatus_tw_i,
  input  logic                      illegal_csr_insn_i,
  input  logic                      data_ind_timing_i,
  output logic                      lsu_req_o,
  output logic                      lsu_we_o,
  output logic [1:0]                lsu_type_o,
  output logic                      lsu_sign_ext_o,
  output logic [31:0]               lsu_wdata_o,
  input  logic                      lsu_req_done_i,  
  input  logic                      lsu_addr_incr_req_i,
  input  logic [31:0]               lsu_addr_last_i,
  input  logic                      csr_mstatus_mie_i,
  input  logic                      irq_pending_i,
  input  ibex_pkg::irqs_t           irqs_i,
  input  logic                      irq_nm_i,
  output logic                      nmi_mode_o,
  input  logic                      lsu_load_err_i,
  input  logic                      lsu_load_resp_intg_err_i,
  input  logic                      lsu_store_err_i,
  input  logic                      lsu_store_resp_intg_err_i,
  output logic                      expecting_load_resp_o,
  output logic                      expecting_store_resp_o,
  output logic                      debug_mode_o,
  output logic                      debug_mode_entering_o,
  output ibex_pkg::dbg_cause_e      debug_cause_o,
  output logic                      debug_csr_save_o,
  input  logic                      debug_req_i,
  input  logic                      debug_single_step_i,
  input  logic                      debug_ebreakm_i,
  input  logic                      debug_ebreaku_i,
  input  logic                      trigger_match_i,
  input  logic [31:0]               result_ex_i,
  input  logic [31:0]               csr_rdata_i,
  output logic [4:0]                rf_raddr_a_o,
  input  logic [31:0]               rf_rdata_a_i,
  output logic [4:0]                rf_raddr_b_o,
  input  logic [31:0]               rf_rdata_b_i,
  output logic                      rf_ren_a_o,
  output logic                      rf_ren_b_o,
  output logic [4:0]                rf_waddr_id_o,
  output logic [31:0]               rf_wdata_id_o,
  output logic                      rf_we_id_o,
  output logic                      rf_rd_a_wb_match_o,
  output logic                      rf_rd_b_wb_match_o,
  input  logic [4:0]                rf_waddr_wb_i,
  input  logic [31:0]               rf_wdata_fwd_wb_i,
  input  logic                      rf_write_wb_i,
  output  logic                     en_wb_o,
  output  ibex_pkg::wb_instr_type_e instr_type_wb_o,
  output  logic                     instr_perf_count_id_o,
  input logic                       ready_wb_i,
  input logic                       outstanding_load_wb_i,
  input logic                       outstanding_store_wb_i,
  output logic                      perf_jump_o,     
  output logic                      perf_branch_o,   
  output logic                      perf_tbranch_o,  
  output logic                      perf_dside_wait_o,  
  output logic                      perf_mul_wait_o,
  output logic                      perf_div_wait_o,
  output logic                      instr_id_done_o
);
  import ibex_pkg::*;
  logic        illegal_insn_dec;
  logic        illegal_dret_insn;
  logic        illegal_umode_insn;
  logic        ebrk_insn;
  logic        mret_insn_dec;
  logic        dret_insn_dec;
  logic        ecall_insn_dec;
  logic        wfi_insn_dec;
  logic        wb_exception;
  logic        id_exception;
  logic        branch_in_dec;
  logic        branch_set, branch_set_raw, branch_set_raw_d;
  logic        branch_jump_set_done_q, branch_jump_set_done_d;
  logic        branch_not_set;
  logic        branch_taken;
  logic        jump_in_dec;
  logic        jump_set_dec;
  logic        jump_set, jump_set_raw;
  logic        instr_first_cycle;
  logic        instr_executing_spec;
  logic        instr_executing;
  logic        instr_done;
  logic        controller_run;
  logic        stall_ld_hz;
  logic        stall_mem;
  logic        stall_multdiv;
  logic        stall_branch;
  logic        stall_jump;
  logic        stall_id;
  logic        stall_wb;
  logic        flush_id;
  logic        multicycle_done;
  logic        mem_resp_intg_err;
  logic [31:0] imm_i_type;
  logic [31:0] imm_s_type;
  logic [31:0] imm_b_type;
  logic [31:0] imm_u_type;
  logic [31:0] imm_j_type;
  logic [31:0] zimm_rs1_type;
  logic [31:0] imm_a;        
  logic [31:0] imm_b;        
  rf_wd_sel_e  rf_wdata_sel;
  logic        rf_we_dec, rf_we_raw;
  logic        rf_ren_a, rf_ren_b;
  logic        rf_ren_a_dec, rf_ren_b_dec;
  assign rf_ren_a = instr_valid_i & ~instr_fetch_err_i & ~illegal_insn_o & rf_ren_a_dec;
  assign rf_ren_b = instr_valid_i & ~instr_fetch_err_i & ~illegal_insn_o & rf_ren_b_dec;
  assign rf_ren_a_o = rf_ren_a;
  assign rf_ren_b_o = rf_ren_b;
  logic [31:0] rf_rdata_a_fwd;
  logic [31:0] rf_rdata_b_fwd;
  alu_op_e     alu_operator;
  op_a_sel_e   alu_op_a_mux_sel, alu_op_a_mux_sel_dec;
  op_b_sel_e   alu_op_b_mux_sel, alu_op_b_mux_sel_dec;
  logic        alu_multicycle_dec;
  logic        stall_alu;
  logic [33:0] imd_val_q[2];
  op_a_sel_e   bt_a_mux_sel;
  imm_b_sel_e  bt_b_mux_sel;
  imm_a_sel_e  imm_a_mux_sel;
  imm_b_sel_e  imm_b_mux_sel, imm_b_mux_sel_dec;
  logic        mult_en_id, mult_en_dec;  
  logic        div_en_id, div_en_dec;    
  logic        multdiv_en_dec;
  md_op_e      multdiv_operator;
  logic [1:0]  multdiv_signed_mode;
  logic        lsu_we;
  logic [1:0]  lsu_type;
  logic        lsu_sign_ext;
  logic        lsu_req, lsu_req_dec;
  logic        data_req_allowed;
  logic        no_flush_csr_addr;
  logic        csr_pipe_flush;
  logic [31:0] alu_operand_a;
  logic [31:0] alu_operand_b;
  assign alu_op_a_mux_sel = lsu_addr_incr_req_i ? OP_A_FWD        : alu_op_a_mux_sel_dec;
  assign alu_op_b_mux_sel = lsu_addr_incr_req_i ? OP_B_IMM        : alu_op_b_mux_sel_dec;
  assign imm_b_mux_sel    = lsu_addr_incr_req_i ? IMM_B_INCR_ADDR : imm_b_mux_sel_dec;
  assign imm_a = (imm_a_mux_sel == IMM_A_Z) ? zimm_rs1_type : '0;
  always_comb begin : alu_operand_a_mux
    unique case (alu_op_a_mux_sel)
      OP_A_REG_A:  alu_operand_a = rf_rdata_a_fwd;
      OP_A_FWD:    alu_operand_a = lsu_addr_last_i;
      OP_A_CURRPC: alu_operand_a = pc_id_i;
      OP_A_IMM:    alu_operand_a = imm_a;
      default:     alu_operand_a = pc_id_i;
    endcase
  end
  if (BranchTargetALU) begin : g_btalu_muxes
    always_comb begin : bt_operand_a_mux
      unique case (bt_a_mux_sel)
        OP_A_REG_A:  bt_a_operand_o = rf_rdata_a_fwd;
        OP_A_CURRPC: bt_a_operand_o = pc_id_i;
        default:     bt_a_operand_o = pc_id_i;
      endcase
    end
    always_comb begin : bt_immediate_b_mux
      unique case (bt_b_mux_sel)
        IMM_B_I:         bt_b_operand_o = imm_i_type;
        IMM_B_B:         bt_b_operand_o = imm_b_type;
        IMM_B_J:         bt_b_operand_o = imm_j_type;
        IMM_B_INCR_PC:   bt_b_operand_o = instr_is_compressed_i ? 32'h2 : 32'h4;
        default:         bt_b_operand_o = instr_is_compressed_i ? 32'h2 : 32'h4;
      endcase
    end
    always_comb begin : immediate_b_mux
      unique case (imm_b_mux_sel)
        IMM_B_I:         imm_b = imm_i_type;
        IMM_B_S:         imm_b = imm_s_type;
        IMM_B_U:         imm_b = imm_u_type;
        IMM_B_INCR_PC:   imm_b = instr_is_compressed_i ? 32'h2 : 32'h4;
        IMM_B_INCR_ADDR: imm_b = 32'h4;
        default:         imm_b = 32'h4;
      endcase
    end
  end else begin : g_nobtalu
    op_a_sel_e  unused_a_mux_sel;
    imm_b_sel_e unused_b_mux_sel;
    assign unused_a_mux_sel = bt_a_mux_sel;
    assign unused_b_mux_sel = bt_b_mux_sel;
    assign bt_a_operand_o   = '0;
    assign bt_b_operand_o   = '0;
    always_comb begin : immediate_b_mux
      unique case (imm_b_mux_sel)
        IMM_B_I:         imm_b = imm_i_type;
        IMM_B_S:         imm_b = imm_s_type;
        IMM_B_B:         imm_b = imm_b_type;
        IMM_B_U:         imm_b = imm_u_type;
        IMM_B_J:         imm_b = imm_j_type;
        IMM_B_INCR_PC:   imm_b = instr_is_compressed_i ? 32'h2 : 32'h4;
        IMM_B_INCR_ADDR: imm_b = 32'h4;
        default:         imm_b = 32'h4;
      endcase
    end
  end
  assign alu_operand_b = (alu_op_b_mux_sel == OP_B_IMM) ? imm_b : rf_rdata_b_fwd;
  for (genvar i = 0; i < 2; i++) begin : gen_intermediate_val_reg
    always_ff @(posedge clk_i or negedge rst_ni) begin : intermediate_val_reg
      if (!rst_ni) begin
        imd_val_q[i] <= '0;
      end else if (imd_val_we_ex_i[i]) begin
        imd_val_q[i] <= imd_val_d_ex_i[i];
      end
    end
  end
  assign imd_val_q_ex_o = imd_val_q;
  assign rf_we_id_o = rf_we_raw & instr_executing & ~illegal_csr_insn_i;
  always_comb begin : rf_wdata_id_mux
    unique case (rf_wdata_sel)
      RF_WD_EX:  rf_wdata_id_o = result_ex_i;
      RF_WD_CSR: rf_wdata_id_o = csr_rdata_i;
      default:   rf_wdata_id_o = result_ex_i;
    endcase
  end
  ibex_decoder #(
    .RV32E          (RV32E),
    .RV32M          (RV32M),
    .RV32B          (RV32B),
    .BranchTargetALU(BranchTargetALU)
  ) decoder_i (
    .clk_i (clk_i),
    .rst_ni(rst_ni),
    .illegal_insn_o(illegal_insn_dec),
    .ebrk_insn_o   (ebrk_insn),
    .mret_insn_o   (mret_insn_dec),
    .dret_insn_o   (dret_insn_dec),
    .ecall_insn_o  (ecall_insn_dec),
    .wfi_insn_o    (wfi_insn_dec),
    .jump_set_o    (jump_set_dec),
    .branch_taken_i(branch_taken),
    .icache_inval_o(icache_inval_o),
    .instr_first_cycle_i(instr_first_cycle),
    .instr_rdata_i      (instr_rdata_i),
    .instr_rdata_alu_i  (instr_rdata_alu_i),
    .illegal_c_insn_i   (illegal_c_insn_i),
    .imm_a_mux_sel_o(imm_a_mux_sel),
    .imm_b_mux_sel_o(imm_b_mux_sel_dec),
    .bt_a_mux_sel_o (bt_a_mux_sel),
    .bt_b_mux_sel_o (bt_b_mux_sel),
    .imm_i_type_o   (imm_i_type),
    .imm_s_type_o   (imm_s_type),
    .imm_b_type_o   (imm_b_type),
    .imm_u_type_o   (imm_u_type),
    .imm_j_type_o   (imm_j_type),
    .zimm_rs1_type_o(zimm_rs1_type),
    .rf_wdata_sel_o(rf_wdata_sel),
    .rf_we_o       (rf_we_dec),
    .rf_raddr_a_o(rf_raddr_a_o),
    .rf_raddr_b_o(rf_raddr_b_o),
    .rf_waddr_o  (rf_waddr_id_o),
    .rf_ren_a_o  (rf_ren_a_dec),
    .rf_ren_b_o  (rf_ren_b_dec),
    .alu_operator_o    (alu_operator),
    .alu_op_a_mux_sel_o(alu_op_a_mux_sel_dec),
    .alu_op_b_mux_sel_o(alu_op_b_mux_sel_dec),
    .alu_multicycle_o  (alu_multicycle_dec),
    .mult_en_o            (mult_en_dec),
    .div_en_o             (div_en_dec),
    .mult_sel_o           (mult_sel_ex_o),
    .div_sel_o            (div_sel_ex_o),
    .multdiv_operator_o   (multdiv_operator),
    .multdiv_signed_mode_o(multdiv_signed_mode),
    .csr_access_o(csr_access_o),
    .csr_op_o    (csr_op_o),
    .csr_addr_o  (csr_addr_o),
    .data_req_o           (lsu_req_dec),
    .data_we_o            (lsu_we),
    .data_type_o          (lsu_type),
    .data_sign_extension_o(lsu_sign_ext),
    .jump_in_dec_o  (jump_in_dec),
    .branch_in_dec_o(branch_in_dec)
  );
  assign no_flush_csr_addr = csr_addr_o inside {CSR_MSCRATCH, CSR_MEPC};
  assign csr_pipe_flush = (csr_op_en_o == 1)                                         &&
                          (csr_op_o inside {CSR_OP_WRITE, CSR_OP_SET, CSR_OP_CLEAR}) &&
                          !no_flush_csr_addr;
  assign illegal_dret_insn  = dret_insn_dec & ~debug_mode_o;
  assign illegal_umode_insn = (priv_mode_i != PRIV_LVL_M) &
                              (mret_insn_dec | (csr_mstatus_tw_i & wfi_insn_dec));
  assign illegal_insn_o = instr_valid_i &
      (illegal_insn_dec | illegal_csr_insn_i | illegal_dret_insn | illegal_umode_insn);
  assign mem_resp_intg_err = lsu_load_resp_intg_err_i | lsu_store_resp_intg_err_i;
  ibex_controller #(
    .WritebackStage (WritebackStage),
    .BranchPredictor(BranchPredictor),
    .MemECC(MemECC)
  ) controller_i (
    .clk_i (clk_i),
    .rst_ni(rst_ni),
    .ctrl_busy_o(ctrl_busy_o),
    .illegal_insn_i  (illegal_insn_o),
    .ecall_insn_i    (ecall_insn_dec),
    .mret_insn_i     (mret_insn_dec),
    .dret_insn_i     (dret_insn_dec),
    .wfi_insn_i      (wfi_insn_dec),
    .ebrk_insn_i     (ebrk_insn),
    .csr_pipe_flush_i(csr_pipe_flush),
    .instr_valid_i          (instr_valid_i),
    .instr_i                (instr_rdata_i),
    .instr_compressed_i     (instr_rdata_c_i),
    .instr_is_compressed_i  (instr_is_compressed_i),
    .instr_gets_expanded_i  (instr_gets_expanded_i),
    .instr_bp_taken_i       (instr_bp_taken_i),
    .instr_fetch_err_i      (instr_fetch_err_i),
    .instr_fetch_err_plus2_i(instr_fetch_err_plus2_i),
    .pc_id_i                (pc_id_i),
    .instr_valid_clear_o(instr_valid_clear_o),
    .id_in_ready_o      (id_in_ready_o),
    .controller_run_o   (controller_run),
    .instr_exec_i       (instr_exec_i),
    .instr_req_o           (instr_req_o),
    .pc_set_o              (pc_set_o),
    .pc_mux_o              (pc_mux_o),
    .nt_branch_mispredict_o(nt_branch_mispredict_o),
    .exc_pc_mux_o          (exc_pc_mux_o),
    .exc_cause_o           (exc_cause_o),
    .lsu_addr_last_i    (lsu_addr_last_i),
    .load_err_i         (lsu_load_err_i),
    .mem_resp_intg_err_i(mem_resp_intg_err),
    .store_err_i        (lsu_store_err_i),
    .wb_exception_o     (wb_exception),
    .id_exception_o     (id_exception),
    .branch_set_i     (branch_set),
    .branch_not_set_i (branch_not_set),
    .jump_set_i       (jump_set),
    .csr_mstatus_mie_i(csr_mstatus_mie_i),
    .irq_pending_i    (irq_pending_i),
    .irqs_i           (irqs_i),
    .irq_nm_ext_i     (irq_nm_i),
    .nmi_mode_o       (nmi_mode_o),
    .csr_save_if_o        (csr_save_if_o),
    .csr_save_id_o        (csr_save_id_o),
    .csr_save_wb_o        (csr_save_wb_o),
    .csr_restore_mret_id_o(csr_restore_mret_id_o),
    .csr_restore_dret_id_o(csr_restore_dret_id_o),
    .csr_save_cause_o     (csr_save_cause_o),
    .csr_mtval_o          (csr_mtval_o),
    .priv_mode_i          (priv_mode_i),
    .debug_mode_o         (debug_mode_o),
    .debug_mode_entering_o(debug_mode_entering_o),
    .debug_cause_o        (debug_cause_o),
    .debug_csr_save_o     (debug_csr_save_o),
    .debug_req_i          (debug_req_i),
    .debug_single_step_i  (debug_single_step_i),
    .debug_ebreakm_i      (debug_ebreakm_i),
    .debug_ebreaku_i      (debug_ebreaku_i),
    .trigger_match_i      (trigger_match_i),
    .stall_id_i(stall_id),
    .stall_wb_i(stall_wb),
    .flush_id_o(flush_id),
    .ready_wb_i(ready_wb_i),
    .perf_jump_o   (perf_jump_o),
    .perf_tbranch_o(perf_tbranch_o)
  );
  assign multdiv_en_dec   = mult_en_dec | div_en_dec;
  assign lsu_req         = instr_executing ? data_req_allowed & lsu_req_dec  : 1'b0;
  assign mult_en_id      = instr_executing ? mult_en_dec                     : 1'b0;
  assign div_en_id       = instr_executing ? div_en_dec                      : 1'b0;
  assign lsu_req_o               = lsu_req;
  assign lsu_we_o                = lsu_we;
  assign lsu_type_o              = lsu_type;
  assign lsu_sign_ext_o          = lsu_sign_ext;
  assign lsu_wdata_o             = rf_rdata_b_fwd;
  assign csr_op_en_o             = csr_access_o & instr_executing & instr_id_done_o;
  assign alu_operator_ex_o           = alu_operator;
  assign alu_operand_a_ex_o          = alu_operand_a;
  assign alu_operand_b_ex_o          = alu_operand_b;
  assign mult_en_ex_o                = mult_en_id;
  assign div_en_ex_o                 = div_en_id;
  assign multdiv_operator_ex_o       = multdiv_operator;
  assign multdiv_signed_mode_ex_o    = multdiv_signed_mode;
  assign multdiv_operand_a_ex_o      = rf_rdata_a_fwd;
  assign multdiv_operand_b_ex_o      = rf_rdata_b_fwd;
  if (BranchTargetALU && !DataIndTiming) begin : g_branch_set_direct
    assign branch_set_raw      = branch_set_raw_d;
  end else begin : g_branch_set_flop
    logic branch_set_raw_q;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        branch_set_raw_q <= 1'b0;
      end else begin
        branch_set_raw_q <= branch_set_raw_d;
      end
    end
    assign branch_set_raw      = (BranchTargetALU && !data_ind_timing_i) ? branch_set_raw_d :
                                                                           branch_set_raw_q;
  end
  assign branch_jump_set_done_d = (branch_set_raw | jump_set_raw | branch_jump_set_done_q) &
    ~instr_valid_clear_o;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      branch_jump_set_done_q <= 1'b0;
    end else begin
      branch_jump_set_done_q <= branch_jump_set_done_d;
    end
  end
  assign jump_set        = jump_set_raw        & ~branch_jump_set_done_q;
  assign branch_set      = branch_set_raw      & ~branch_jump_set_done_q;
  if (DataIndTiming) begin : g_sec_branch_taken
    logic branch_taken_q;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        branch_taken_q <= 1'b0;
      end else begin
        branch_taken_q <= branch_decision_i;
      end
    end
    assign branch_taken = ~data_ind_timing_i | branch_taken_q;
  end else begin : g_nosec_branch_taken
    assign branch_taken = 1'b1;
  end
  if (BranchPredictor) begin : g_calc_nt_addr
    assign nt_branch_addr_o = pc_id_i + (instr_is_compressed_i ? 32'd2 : 32'd4);
  end else begin : g_n_calc_nt_addr
    assign nt_branch_addr_o = 32'd0;
  end
  typedef enum logic { FIRST_CYCLE, MULTI_CYCLE } id_fsm_e;
  id_fsm_e id_fsm_q, id_fsm_d;
  always_ff @(posedge clk_i or negedge rst_ni) begin : id_pipeline_reg
    if (!rst_ni) begin
      id_fsm_q <= FIRST_CYCLE;
    end else if (instr_executing) begin
      id_fsm_q <= id_fsm_d;
    end
  end
  always_comb begin
    id_fsm_d                = id_fsm_q;
    rf_we_raw               = rf_we_dec;
    stall_multdiv           = 1'b0;
    stall_jump              = 1'b0;
    stall_branch            = 1'b0;
    stall_alu               = 1'b0;
    branch_set_raw_d        = 1'b0;
    branch_not_set          = 1'b0;
    jump_set_raw            = 1'b0;
    perf_branch_o           = 1'b0;
    if (instr_executing_spec) begin
      unique case (id_fsm_q)
        FIRST_CYCLE: begin
          unique case (1'b1)
            lsu_req_dec: begin
              if (!WritebackStage) begin
                id_fsm_d    = MULTI_CYCLE;
              end else begin
                if(~lsu_req_done_i) begin
                  id_fsm_d  = MULTI_CYCLE;
                end
              end
            end
            multdiv_en_dec: begin
              if (~ex_valid_i) begin
                id_fsm_d      = MULTI_CYCLE;
                rf_we_raw     = 1'b0;
                stall_multdiv = 1'b1;
              end
            end
            branch_in_dec: begin
              id_fsm_d         = (data_ind_timing_i || (!BranchTargetALU && branch_decision_i)) ?
                                     MULTI_CYCLE : FIRST_CYCLE;
              stall_branch     = (~BranchTargetALU & branch_decision_i) | data_ind_timing_i;
              branch_set_raw_d = (branch_decision_i | data_ind_timing_i);
              if (BranchPredictor) begin
                branch_not_set = ~branch_decision_i;
              end
              perf_branch_o = 1'b1;
            end
            jump_in_dec: begin
              id_fsm_d      = BranchTargetALU ? FIRST_CYCLE : MULTI_CYCLE;
              stall_jump    = ~BranchTargetALU;
              jump_set_raw  = jump_set_dec;
            end
            alu_multicycle_dec: begin
              stall_alu     = 1'b1;
              id_fsm_d      = MULTI_CYCLE;
              rf_we_raw     = 1'b0;
            end
            default: begin
              id_fsm_d      = FIRST_CYCLE;
            end
          endcase
        end
        MULTI_CYCLE: begin
          if(multdiv_en_dec) begin
            rf_we_raw       = rf_we_dec & ex_valid_i;
          end
          if (multicycle_done & ready_wb_i) begin
            id_fsm_d        = FIRST_CYCLE;
          end else begin
            stall_multdiv   = multdiv_en_dec;
            stall_branch    = branch_in_dec;
            stall_jump      = jump_in_dec;
          end
        end
        default: begin
          id_fsm_d          = FIRST_CYCLE;
        end
      endcase
    end
  end
  assign multdiv_ready_id_o = ready_wb_i;
  assign stall_id = stall_ld_hz | stall_mem | stall_multdiv | stall_jump | stall_branch |
                      stall_alu;
  assign instr_done = ~stall_id & ~flush_id & instr_executing;
  assign instr_first_cycle      = instr_valid_i & (id_fsm_q == FIRST_CYCLE);
  assign instr_first_cycle_id_o = instr_first_cycle;
  if (WritebackStage) begin : gen_stall_mem
    logic rf_rd_a_wb_match;
    logic rf_rd_b_wb_match;
    logic rf_rd_a_hz;
    logic rf_rd_b_hz;
    logic outstanding_memory_access;
    logic instr_kill;
    assign multicycle_done = lsu_req_dec ? ~stall_mem : ex_valid_i;
    assign outstanding_memory_access = (outstanding_load_wb_i | outstanding_store_wb_i) &
                                       ~lsu_resp_valid_i;
    assign data_req_allowed = ~outstanding_memory_access;
    assign instr_kill = instr_fetch_err_i |
                        wb_exception      |
                        id_exception      |
                        ~controller_run;
    assign instr_executing_spec = instr_valid_i      &
                                  ~instr_fetch_err_i &
                                  controller_run     &
                                  ~stall_ld_hz;
    assign instr_executing = instr_valid_i              &
                             ~instr_kill                &
                             ~stall_ld_hz               &
                             ~outstanding_memory_access;
    assign stall_mem = instr_valid_i &
                       (outstanding_memory_access | (lsu_req_dec & ~lsu_req_done_i));
    assign rf_rd_a_wb_match = (rf_waddr_wb_i == rf_raddr_a_o) & |rf_raddr_a_o;
    assign rf_rd_b_wb_match = (rf_waddr_wb_i == rf_raddr_b_o) & |rf_raddr_b_o;
    assign rf_rd_a_wb_match_o = rf_rd_a_wb_match;
    assign rf_rd_b_wb_match_o = rf_rd_b_wb_match;
    assign rf_rd_a_hz = rf_rd_a_wb_match & rf_ren_a;
    assign rf_rd_b_hz = rf_rd_b_wb_match & rf_ren_b;
    assign rf_rdata_a_fwd = rf_rd_a_wb_match & rf_write_wb_i ? rf_wdata_fwd_wb_i : rf_rdata_a_i;
    assign rf_rdata_b_fwd = rf_rd_b_wb_match & rf_write_wb_i ? rf_wdata_fwd_wb_i : rf_rdata_b_i;
    assign stall_ld_hz = outstanding_load_wb_i & (rf_rd_a_hz | rf_rd_b_hz);
    assign instr_type_wb_o = ~lsu_req_dec ? WB_INSTR_OTHER :
                              lsu_we      ? WB_INSTR_STORE :
                                            WB_INSTR_LOAD;
    assign instr_id_done_o = en_wb_o & ready_wb_i;
    assign stall_wb = en_wb_o & ~ready_wb_i;
    assign perf_dside_wait_o = instr_valid_i & ~instr_kill &
                               (outstanding_memory_access | stall_ld_hz);
    assign expecting_load_resp_o  = 1'b0;
    assign expecting_store_resp_o = 1'b0;
  end else begin : gen_no_stall_mem
    assign multicycle_done = lsu_req_dec ? lsu_resp_valid_i : ex_valid_i;
    assign data_req_allowed = instr_first_cycle;
    assign stall_mem = instr_valid_i & (lsu_req_dec & (~lsu_resp_valid_i | instr_first_cycle));
    assign stall_ld_hz   = 1'b0;
    assign instr_executing_spec = instr_valid_i & ~instr_fetch_err_i & controller_run;
    assign instr_executing = instr_executing_spec;
    assign rf_rdata_a_fwd = rf_rdata_a_i;
    assign rf_rdata_b_fwd = rf_rdata_b_i;
    assign rf_rd_a_wb_match_o = 1'b0;
    assign rf_rd_b_wb_match_o = 1'b0;
    assign expecting_load_resp_o  = instr_valid_i & lsu_req_dec & ~instr_first_cycle & ~lsu_we;
    assign expecting_store_resp_o = instr_valid_i & lsu_req_dec & ~instr_first_cycle &  lsu_we;
    logic unused_data_req_done_ex;
    logic [4:0] unused_rf_waddr_wb;
    logic unused_rf_write_wb;
    logic unused_outstanding_load_wb;
    logic unused_outstanding_store_wb;
    logic unused_wb_exception;
    logic [31:0] unused_rf_wdata_fwd_wb;
    logic unused_id_exception;
    assign unused_data_req_done_ex     = lsu_req_done_i;
    assign unused_rf_waddr_wb          = rf_waddr_wb_i;
    assign unused_rf_write_wb          = rf_write_wb_i;
    assign unused_outstanding_load_wb  = outstanding_load_wb_i;
    assign unused_outstanding_store_wb = outstanding_store_wb_i;
    assign unused_wb_exception         = wb_exception;
    assign unused_rf_wdata_fwd_wb      = rf_wdata_fwd_wb_i;
    assign unused_id_exception         = id_exception;
    assign instr_type_wb_o = WB_INSTR_OTHER;
    assign stall_wb        = 1'b0;
    assign perf_dside_wait_o = instr_executing & lsu_req_dec & ~lsu_resp_valid_i;
    assign instr_id_done_o = instr_done;
  end
  logic minstret_write;
  assign minstret_write = csr_access_o &
      (csr_op_o inside {CSR_OP_WRITE, CSR_OP_SET, CSR_OP_CLEAR}) &
      (csr_addr_o inside {CSR_MINSTRET, CSR_MINSTRETH});
  assign instr_perf_count_id_o = ~ebrk_insn & ~ecall_insn_dec & ~illegal_insn_dec &
      ~illegal_csr_insn_i & ~instr_fetch_err_i & ~minstret_write &
      !(instr_gets_expanded_i inside {INSTR_EXPANDED, INSTR_EXPANDED_COMMIT});
  assign en_wb_o = instr_done;
  assign perf_mul_wait_o = stall_multdiv & mult_en_dec;
  assign perf_div_wait_o = stall_multdiv & div_en_dec;
    logic fcov_rf_rd_wb_hz; 
    if (WritebackStage) begin : g_fcov_rf_rd_wb_hz 
      assign fcov_rf_rd_wb_hz = (gen_stall_mem.rf_rd_a_hz | gen_stall_mem.rf_rd_b_hz) & instr_valid_i; 
    end else begin : g_no_fcov_rf_rd_wb_hz 
      assign fcov_rf_rd_wb_hz =  '0; 
    end 
    logic unused_fcov_rf_rd_wb_hz; 
    assign unused_fcov_rf_rd_wb_hz = fcov_rf_rd_wb_hz;
    logic fcov_branch_taken; 
    assign fcov_branch_taken = instr_executing & (id_fsm_q == FIRST_CYCLE) & branch_decision_i; 
    logic unused_fcov_branch_taken; 
    assign unused_fcov_branch_taken = fcov_branch_taken;
    logic fcov_branch_not_taken; 
    assign fcov_branch_not_taken = instr_executing & (id_fsm_q == FIRST_CYCLE) & ~branch_decision_i; 
    logic unused_fcov_branch_not_taken; 
    assign unused_fcov_branch_not_taken = fcov_branch_not_taken;
endmodule
module ibex_if_stage import ibex_pkg::*; #(
  parameter int unsigned DmHaltAddr           = 32'h1A110800,
  parameter int unsigned DmExceptionAddr      = 32'h1A110808,
  parameter bit          DummyInstructions    = 1'b0,
  parameter bit          ICache               = 1'b0,
  parameter rv32zc_e     RV32ZC               = RV32ZcaZcbZcmp,
  parameter bit          ICacheECC            = 1'b0,
  parameter bit          ICacheTweakInfection = 1'b0,
  parameter int unsigned BusSizeECC           = BUS_SIZE,
  parameter int unsigned TagSizeECC           = IC_TAG_SIZE,
  parameter int unsigned LineSizeECC          = IC_LINE_SIZE,
  parameter bit          PCIncrCheck          = 1'b0,
  parameter bit          ResetAll             = 1'b0,
  parameter lfsr_seed_t  RndCnstLfsrSeed      = RndCnstLfsrSeedDefault,
  parameter lfsr_perm_t  RndCnstLfsrPerm      = RndCnstLfsrPermDefault,
  parameter bit          BranchPredictor      = 1'b0,
  parameter bit          MemECC               = 1'b0,
  parameter int unsigned MemDataWidth         = MemECC ? 32 + 7 : 32
) (
  input  logic                         clk_i,
  input  logic                         rst_ni,
  input  logic [31:0]                  boot_addr_i,               
  input  logic                         req_i,                     
  output logic                        instr_req_o,
  output logic [31:0]                 instr_addr_o,
  input  logic                        instr_gnt_i,
  input  logic                        instr_rvalid_i,
  input  logic [MemDataWidth-1:0]     instr_rdata_i,
  input  logic                        instr_bus_err_i,
  output logic                        instr_intg_err_o,
  output logic [IC_NUM_WAYS-1:0]      ic_tag_req_o,
  output logic                        ic_tag_write_o,
  output logic [IC_INDEX_W-1:0]       ic_tag_addr_o,
  output logic [TagSizeECC-1:0]       ic_tag_wdata_o,
  input  logic [TagSizeECC-1:0]       ic_tag_rdata_i [IC_NUM_WAYS],
  output logic [IC_NUM_WAYS-1:0]      ic_data_req_o,
  output logic                        ic_data_write_o,
  output logic [IC_INDEX_W-1:0]       ic_data_addr_o,
  output logic [LineSizeECC-1:0]      ic_data_wdata_o,
  input  logic [LineSizeECC-1:0]      ic_data_rdata_i [IC_NUM_WAYS],
  input  logic                        ic_scr_key_valid_i,
  output logic                        ic_scr_key_req_o,
  output logic                        instr_valid_id_o,          
  output logic                        instr_new_id_o,            
  output logic [31:0]                 instr_rdata_id_o,          
  output logic [31:0]                 instr_rdata_alu_id_o,      
  output logic [15:0]                 instr_rdata_c_id_o,        
  output logic                        instr_is_compressed_id_o,  
  output instr_exp_e                  instr_gets_expanded_id_o,  
  output logic [15:0]                 instr_expanded_id_o,       
  output logic                        instr_bp_taken_o,          
  output logic                        instr_fetch_err_o,         
  output logic                        instr_fetch_err_plus2_o,   
  output logic                        illegal_c_insn_id_o,       
  output logic                        dummy_instr_id_o,          
  output logic [31:0]                 pc_if_o,
  output logic [31:0]                 pc_id_o,
  input  logic                        pmp_err_if_i,
  input  logic                        pmp_err_if_plus2_i,
  input  logic                        instr_valid_clear_i,       
  input  logic                        pc_set_i,                  
  input  pc_sel_e                     pc_mux_i,                  
  input  logic                        nt_branch_mispredict_i,    
  input  logic [31:0]                 nt_branch_addr_i,          
  input  exc_pc_sel_e                 exc_pc_mux_i,              
  input  exc_cause_t                  exc_cause,                 
  input  logic                        dummy_instr_en_i,
  input  logic [2:0]                  dummy_instr_mask_i,
  input  logic                        dummy_instr_seed_en_i,
  input  logic [31:0]                 dummy_instr_seed_i,
  input  logic                        icache_enable_i,
  input  logic                        icache_inval_i,
  output logic                        icache_ecc_error_o,
  input  logic [31:0]                 branch_target_ex_i,        
  input  logic [31:0]                 csr_mepc_i,                
  input  logic [31:0]                 csr_depc_i,                
  input  logic [31:0]                 csr_mtvec_i,               
  output logic                        csr_mtvec_init_o,          
  input  logic                        id_in_ready_i,             
  output logic                        pc_mismatch_alert_o,
  output logic                        if_busy_o                  
);
  logic              instr_valid_id_d, instr_valid_id_q;
  logic              instr_new_id_d, instr_new_id_q;
  logic              instr_err, instr_intg_err;
  logic              prefetch_busy;
  logic              branch_req;
  logic       [31:0] fetch_addr_n;
  logic              unused_fetch_addr_n0;
  logic              prefetch_branch;
  logic [31:0]       prefetch_addr;
  logic              fetch_valid_raw;
  logic              fetch_valid;
  logic              fetch_ready;
  logic       [31:0] fetch_rdata;
  logic       [31:0] fetch_addr;
  logic              fetch_err;
  logic              fetch_err_plus2;
  logic [31:0]       instr_decompressed;
  logic              illegal_c_insn;
  logic              instr_is_compressed;
  instr_exp_e        instr_gets_expanded;
  logic              if_instr_valid;
  logic       [31:0] if_instr_rdata;
  logic       [31:0] if_instr_addr;
  logic              if_instr_bus_err;
  logic              if_instr_pmp_err;
  logic              if_instr_err;
  logic              if_instr_err_plus2;
  logic       [31:0] exc_pc;
  logic              if_id_pipe_reg_we;  
  logic              stall_dummy_instr;
  logic [31:0]       instr_out;
  logic              instr_is_compressed_out;
  instr_exp_e        instr_gets_expanded_out;
  logic              illegal_c_instr_out;
  logic              instr_err_out;
  logic              predict_branch_taken;
  logic       [31:0] predict_branch_pc;
  logic        [4:0] irq_vec;
  ibex_pkg::pc_sel_e pc_mux_internal;
  logic        [7:0] unused_boot_addr;
  logic        [7:0] unused_csr_mtvec;
  logic              unused_exc_cause;
  assign unused_boot_addr = boot_addr_i[7:0];
  assign unused_csr_mtvec = csr_mtvec_i[7:0];
  assign unused_exc_cause = |{exc_cause.irq_ext, exc_cause.irq_int};
  always_comb begin : exc_pc_mux
    irq_vec = exc_cause.lower_cause;
    if (exc_cause.irq_int) begin
      irq_vec = ExcCauseIrqNm.lower_cause;
    end
    unique case (exc_pc_mux_i)
      EXC_PC_EXC:     exc_pc = { csr_mtvec_i[31:8], 8'h00                };
      EXC_PC_IRQ:     exc_pc = { csr_mtvec_i[31:8], 1'b0, irq_vec, 2'b00 };
      EXC_PC_DBD:     exc_pc = DmHaltAddr;
      EXC_PC_DBG_EXC: exc_pc = DmExceptionAddr;
      default:        exc_pc = { csr_mtvec_i[31:8], 8'h00                };
    endcase
  end
  assign pc_mux_internal =
    (BranchPredictor && predict_branch_taken && !pc_set_i) ? PC_BP : pc_mux_i;
  always_comb begin : fetch_addr_mux
    unique case (pc_mux_internal)
      PC_BOOT: fetch_addr_n = { boot_addr_i[31:8], 8'h80 };
      PC_JUMP: fetch_addr_n = branch_target_ex_i;
      PC_EXC:  fetch_addr_n = exc_pc;                        
      PC_ERET: fetch_addr_n = csr_mepc_i;                    
      PC_DRET: fetch_addr_n = csr_depc_i;
      PC_BP:   fetch_addr_n = BranchPredictor ? predict_branch_pc : { boot_addr_i[31:8], 8'h80 };
      default: fetch_addr_n = { boot_addr_i[31:8], 8'h80 };
    endcase
  end
  assign csr_mtvec_init_o = (pc_mux_i == PC_BOOT) & pc_set_i;
  if (MemECC) begin : g_mem_ecc
    logic [1:0] ecc_err;
    logic [MemDataWidth-1:0] instr_rdata_buf;
    prim_buf #(.Width(MemDataWidth)) u_prim_buf_instr_rdata (
      .in_i (instr_rdata_i),
      .out_o(instr_rdata_buf)
    );
    prim_secded_inv_39_32_dec u_instr_intg_dec (
      .data_i     (instr_rdata_buf),
      .data_o     (),
      .syndrome_o (),
      .err_o      (ecc_err)
    );
    assign instr_intg_err = |ecc_err;
  end else begin : g_no_mem_ecc
    assign instr_intg_err            = 1'b0;
  end
  assign instr_err        = instr_intg_err | instr_bus_err_i;
  assign instr_intg_err_o = instr_intg_err & instr_rvalid_i;
  assign prefetch_branch = branch_req | nt_branch_mispredict_i;
  assign prefetch_addr   = branch_req ? {fetch_addr_n[31:1], 1'b0} : nt_branch_addr_i;
  assign fetch_valid = fetch_valid_raw & ~nt_branch_mispredict_i;
  if (ICache) begin : gen_icache
    ibex_icache #(
      .ICacheECC       (ICacheECC),
      .ResetAll        (ResetAll),
      .BusSizeECC      (BusSizeECC),
      .TagSizeECC      (TagSizeECC),
      .LineSizeECC     (LineSizeECC),
      .TweakInfection  (ICacheTweakInfection)
    ) icache_i (
        .clk_i               ( clk_i                      ),
        .rst_ni              ( rst_ni                     ),
        .req_i               ( req_i                      ),
        .branch_i            ( prefetch_branch            ),
        .addr_i              ( prefetch_addr              ),
        .ready_i             ( fetch_ready                ),
        .valid_o             ( fetch_valid_raw            ),
        .rdata_o             ( fetch_rdata                ),
        .addr_o              ( fetch_addr                 ),
        .err_o               ( fetch_err                  ),
        .err_plus2_o         ( fetch_err_plus2            ),
        .instr_req_o         ( instr_req_o                ),
        .instr_addr_o        ( instr_addr_o               ),
        .instr_gnt_i         ( instr_gnt_i                ),
        .instr_rvalid_i      ( instr_rvalid_i             ),
        .instr_rdata_i       ( instr_rdata_i[31:0]        ),
        .instr_err_i         ( instr_err                  ),
        .ic_tag_req_o        ( ic_tag_req_o               ),
        .ic_tag_write_o      ( ic_tag_write_o             ),
        .ic_tag_addr_o       ( ic_tag_addr_o              ),
        .ic_tag_wdata_o      ( ic_tag_wdata_o             ),
        .ic_tag_rdata_i      ( ic_tag_rdata_i             ),
        .ic_data_req_o       ( ic_data_req_o              ),
        .ic_data_write_o     ( ic_data_write_o            ),
        .ic_data_addr_o      ( ic_data_addr_o             ),
        .ic_data_wdata_o     ( ic_data_wdata_o            ),
        .ic_data_rdata_i     ( ic_data_rdata_i            ),
        .ic_scr_key_valid_i  ( ic_scr_key_valid_i         ),
        .ic_scr_key_req_o    ( ic_scr_key_req_o           ),
        .icache_enable_i     ( icache_enable_i            ),
        .icache_inval_i      ( icache_inval_i             ),
        .busy_o              ( prefetch_busy              ),
        .ecc_error_o         ( icache_ecc_error_o         )
    );
  end else begin : gen_prefetch_buffer
    ibex_prefetch_buffer #(
      .ResetAll        (ResetAll)
    ) prefetch_buffer_i (
        .clk_i               ( clk_i                      ),
        .rst_ni              ( rst_ni                     ),
        .req_i               ( req_i                      ),
        .branch_i            ( prefetch_branch            ),
        .addr_i              ( prefetch_addr              ),
        .ready_i             ( fetch_ready                ),
        .valid_o             ( fetch_valid_raw            ),
        .rdata_o             ( fetch_rdata                ),
        .addr_o              ( fetch_addr                 ),
        .err_o               ( fetch_err                  ),
        .err_plus2_o         ( fetch_err_plus2            ),
        .instr_req_o         ( instr_req_o                ),
        .instr_addr_o        ( instr_addr_o               ),
        .instr_gnt_i         ( instr_gnt_i                ),
        .instr_rvalid_i      ( instr_rvalid_i             ),
        .instr_rdata_i       ( instr_rdata_i[31:0]        ),
        .instr_err_i         ( instr_err                  ),
        .busy_o              ( prefetch_busy              )
    );
    logic                   unused_icen, unused_icinv, unused_scr_key_valid;
    logic [TagSizeECC-1:0]  unused_tag_ram_input [IC_NUM_WAYS];
    logic [LineSizeECC-1:0] unused_data_ram_input [IC_NUM_WAYS];
    assign unused_icen           = icache_enable_i;
    assign unused_icinv          = icache_inval_i;
    assign unused_tag_ram_input  = ic_tag_rdata_i;
    assign unused_data_ram_input = ic_data_rdata_i;
    assign unused_scr_key_valid  = ic_scr_key_valid_i;
    assign ic_tag_req_o          = 'b0;
    assign ic_tag_write_o        = 'b0;
    assign ic_tag_addr_o         = 'b0;
    assign ic_tag_wdata_o        = 'b0;
    assign ic_data_req_o         = 'b0;
    assign ic_data_write_o       = 'b0;
    assign ic_data_addr_o        = 'b0;
    assign ic_data_wdata_o       = 'b0;
    assign ic_scr_key_req_o      = 'b0;
    assign icache_ecc_error_o    = 'b0;
    export "DPI-C" function simutil_get_scramble_key;
    export "DPI-C" function simutil_get_scramble_nonce;
    function automatic int simutil_get_scramble_key(output bit [127:0] val);
      return 0;
    endfunction
    function automatic int simutil_get_scramble_nonce(output bit [319:0] nonce);
      return 0;
    endfunction
  end
  assign unused_fetch_addr_n0 = fetch_addr_n[0];
  assign branch_req  = pc_set_i | predict_branch_taken;
  assign pc_if_o     = if_instr_addr;
  assign if_busy_o   = prefetch_busy;
  assign if_instr_pmp_err = pmp_err_if_i |
                            (if_instr_addr[1] & ~instr_is_compressed & pmp_err_if_plus2_i);
  assign if_instr_err = if_instr_bus_err | if_instr_pmp_err;
  assign if_instr_err_plus2 = ((if_instr_addr[1] & ~instr_is_compressed & pmp_err_if_plus2_i) |
                               fetch_err_plus2) & ~pmp_err_if_i;
  logic flush_expanded;
  assign flush_expanded = pc_set_i & (pc_mux_i == ibex_pkg::PC_EXC);
  ibex_compressed_decoder #(
    .RV32ZC   (RV32ZC),
    .ResetAll (ResetAll)
  ) compressed_decoder_i (
    .clk_i          (clk_i),
    .rst_ni         (rst_ni),
    .valid_i        (fetch_valid & ~fetch_err),
    .id_in_ready_i  (id_in_ready_i & ~pc_set_i),
    .instr_i        (if_instr_rdata),
    .instr_o        (instr_decompressed),
    .is_compressed_o(instr_is_compressed),
    .gets_expanded_o(instr_gets_expanded),
    .flush_expanded_i(flush_expanded),
    .illegal_instr_o(illegal_c_insn)
  );
  if (DummyInstructions) begin : gen_dummy_instr
    logic        insert_dummy_instr;
    logic [31:0] dummy_instr_data;
    ibex_dummy_instr #(
      .RndCnstLfsrSeed (RndCnstLfsrSeed),
      .RndCnstLfsrPerm (RndCnstLfsrPerm)
    ) dummy_instr_i (
      .clk_i                (clk_i),
      .rst_ni               (rst_ni),
      .dummy_instr_en_i     (dummy_instr_en_i),
      .dummy_instr_mask_i   (dummy_instr_mask_i),
      .dummy_instr_seed_en_i(dummy_instr_seed_en_i),
      .dummy_instr_seed_i   (dummy_instr_seed_i),
      .fetch_valid_i        (fetch_valid),
      .id_in_ready_i        (id_in_ready_i),
      .insert_dummy_instr_o (insert_dummy_instr),
      .dummy_instr_data_o   (dummy_instr_data)
    );
    assign instr_out               = insert_dummy_instr ? dummy_instr_data : instr_decompressed;
    assign instr_is_compressed_out = insert_dummy_instr ? 1'b0 : instr_is_compressed;
    assign instr_gets_expanded_out = insert_dummy_instr ? INSTR_NOT_EXPANDED : instr_gets_expanded;
    assign illegal_c_instr_out     = insert_dummy_instr ? 1'b0 : illegal_c_insn;
    assign instr_err_out           = insert_dummy_instr ? 1'b0 : if_instr_err;
    assign stall_dummy_instr = insert_dummy_instr;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        dummy_instr_id_o <= 1'b0;
      end else if (if_id_pipe_reg_we) begin
        dummy_instr_id_o <= insert_dummy_instr;
      end
    end
  end else begin : gen_no_dummy_instr
    logic        unused_dummy_en;
    logic [2:0]  unused_dummy_mask;
    logic        unused_dummy_seed_en;
    logic [31:0] unused_dummy_seed;
    assign unused_dummy_en         = dummy_instr_en_i;
    assign unused_dummy_mask       = dummy_instr_mask_i;
    assign unused_dummy_seed_en    = dummy_instr_seed_en_i;
    assign unused_dummy_seed       = dummy_instr_seed_i;
    assign instr_out               = instr_decompressed;
    assign instr_is_compressed_out = instr_is_compressed;
    assign instr_gets_expanded_out = instr_gets_expanded;
    assign illegal_c_instr_out     = illegal_c_insn;
    assign instr_err_out           = if_instr_err;
    assign stall_dummy_instr       = 1'b0;
    assign dummy_instr_id_o        = 1'b0;
  end
  assign instr_valid_id_d = (if_instr_valid & id_in_ready_i & ~pc_set_i) |
                            (instr_valid_id_q & ~instr_valid_clear_i);
  assign instr_new_id_d   = if_instr_valid & id_in_ready_i & ~pc_set_i;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      instr_valid_id_q <= 1'b0;
      instr_new_id_q   <= 1'b0;
    end else begin
      instr_valid_id_q <= instr_valid_id_d;
      instr_new_id_q   <= instr_new_id_d;
    end
  end
  assign instr_valid_id_o = instr_valid_id_q;
  assign instr_new_id_o   = instr_new_id_q;
  assign if_id_pipe_reg_we = instr_new_id_d;
  if (ResetAll) begin : g_instr_rdata_ra
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        instr_rdata_id_o         <= '0;
        instr_rdata_alu_id_o     <= '0;
        instr_fetch_err_o        <= '0;
        instr_fetch_err_plus2_o  <= '0;
        instr_rdata_c_id_o       <= '0;
        instr_is_compressed_id_o <= '0;
        instr_gets_expanded_id_o <= INSTR_NOT_EXPANDED;
        instr_expanded_id_o      <= '0;
        illegal_c_insn_id_o      <= '0;
        pc_id_o                  <= '0;
      end else if (if_id_pipe_reg_we) begin
        instr_rdata_id_o         <= instr_out;
        instr_rdata_alu_id_o     <= instr_out;
        instr_fetch_err_o        <= instr_err_out;
        instr_fetch_err_plus2_o  <= if_instr_err_plus2;
        instr_rdata_c_id_o       <= if_instr_rdata[15:0];
        instr_is_compressed_id_o <= instr_is_compressed_out;
        instr_gets_expanded_id_o <= instr_gets_expanded_out;
        instr_expanded_id_o      <= if_instr_rdata[15:0];
        illegal_c_insn_id_o      <= illegal_c_instr_out;
        pc_id_o                  <= pc_if_o;
      end
    end
  end else begin : g_instr_rdata_nr
    always_ff @(posedge clk_i) begin
      if (if_id_pipe_reg_we) begin
        instr_rdata_id_o         <= instr_out;
        instr_rdata_alu_id_o     <= instr_out;
        instr_fetch_err_o        <= instr_err_out;
        instr_fetch_err_plus2_o  <= if_instr_err_plus2;
        instr_rdata_c_id_o       <= if_instr_rdata[15:0];
        instr_is_compressed_id_o <= instr_is_compressed_out;
        instr_gets_expanded_id_o <= instr_gets_expanded_out;
        instr_expanded_id_o      <= if_instr_rdata[15:0];
        illegal_c_insn_id_o      <= illegal_c_instr_out;
        pc_id_o                  <= pc_if_o;
      end
    end
  end
  if (PCIncrCheck) begin : g_secure_pc
    logic [31:0] prev_instr_addr_incr, prev_instr_addr_incr_buf;
    logic        prev_instr_seq_q, prev_instr_seq_d;
    assign prev_instr_seq_d = (prev_instr_seq_q | instr_new_id_d) &
        ~branch_req & ~if_instr_err & ~stall_dummy_instr &
        !(instr_gets_expanded inside {INSTR_EXPANDED, INSTR_EXPANDED_COMMIT});
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        prev_instr_seq_q <= 1'b0;
      end else begin
        prev_instr_seq_q <= prev_instr_seq_d;
      end
    end
    assign prev_instr_addr_incr = pc_id_o + (instr_is_compressed_id_o ? 32'd2 : 32'd4);
    prim_buf #(.Width(32)) u_prev_instr_addr_incr_buf (
      .in_i (prev_instr_addr_incr),
      .out_o(prev_instr_addr_incr_buf)
    );
    assign pc_mismatch_alert_o = prev_instr_seq_q & (pc_if_o != prev_instr_addr_incr_buf);
  end else begin : g_no_secure_pc
    assign pc_mismatch_alert_o = 1'b0;
  end
  if (BranchPredictor) begin : g_branch_predictor
    logic [31:0] instr_skid_data_q;
    logic [31:0] instr_skid_addr_q;
    logic        instr_skid_bp_taken_q;
    logic        instr_skid_valid_q, instr_skid_valid_d;
    logic        instr_skid_en;
    logic        instr_bp_taken_q, instr_bp_taken_d;
    logic        predict_branch_taken_raw;
    if (ResetAll) begin : g_bp_taken_ra
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          instr_bp_taken_q <= '0;
        end else if (if_id_pipe_reg_we) begin
          instr_bp_taken_q <= instr_bp_taken_d;
        end
      end
    end else begin : g_bp_taken_nr
      always_ff @(posedge clk_i) begin
        if (if_id_pipe_reg_we) begin
          instr_bp_taken_q <= instr_bp_taken_d;
        end
      end
    end
    assign instr_skid_en = predict_branch_taken & ~pc_set_i & ~id_in_ready_i & ~instr_skid_valid_q;
    assign instr_skid_valid_d = (instr_skid_valid_q & ~id_in_ready_i & ~stall_dummy_instr &
                                 !(instr_gets_expanded inside
                                 {INSTR_EXPANDED, INSTR_EXPANDED_COMMIT})) | instr_skid_en;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        instr_skid_valid_q <= 1'b0;
      end else begin
        instr_skid_valid_q <= instr_skid_valid_d;
      end
    end
    if (ResetAll) begin : g_instr_skid_ra
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          instr_skid_bp_taken_q <= '0;
          instr_skid_data_q     <= '0;
          instr_skid_addr_q     <= '0;
        end else if (instr_skid_en) begin
          instr_skid_bp_taken_q <= predict_branch_taken;
          instr_skid_data_q     <= fetch_rdata;
          instr_skid_addr_q     <= fetch_addr;
        end
      end
    end else begin : g_instr_skid_nr
      always_ff @(posedge clk_i) begin
        if (instr_skid_en) begin
          instr_skid_bp_taken_q <= predict_branch_taken;
          instr_skid_data_q     <= fetch_rdata;
          instr_skid_addr_q     <= fetch_addr;
        end
      end
    end
    ibex_branch_predict branch_predict_i (
      .clk_i        (clk_i),
      .rst_ni       (rst_ni),
      .fetch_rdata_i(fetch_rdata),
      .fetch_pc_i   (fetch_addr),
      .fetch_valid_i(fetch_valid),
      .predict_branch_taken_o(predict_branch_taken_raw),
      .predict_branch_pc_o   (predict_branch_pc)
    );
    assign predict_branch_taken = predict_branch_taken_raw & ~instr_skid_valid_q & ~fetch_err;
    assign if_instr_valid   = fetch_valid | (instr_skid_valid_q & ~nt_branch_mispredict_i);
    assign if_instr_rdata   = instr_skid_valid_q ? instr_skid_data_q : fetch_rdata;
    assign if_instr_addr    = instr_skid_valid_q ? instr_skid_addr_q : fetch_addr;
    assign if_instr_bus_err = ~instr_skid_valid_q & fetch_err;
    assign instr_bp_taken_d = instr_skid_valid_q ? instr_skid_bp_taken_q : predict_branch_taken;
    assign fetch_ready = id_in_ready_i & ~stall_dummy_instr &
                         !(instr_gets_expanded inside {INSTR_EXPANDED, INSTR_EXPANDED_COMMIT}) &
                         ~instr_skid_valid_q;
    assign instr_bp_taken_o = instr_bp_taken_q;
  end else begin : g_no_branch_predictor
    assign instr_bp_taken_o     = 1'b0;
    assign predict_branch_taken = 1'b0;
    assign predict_branch_pc    = 32'b0;
    assign if_instr_valid = fetch_valid;
    assign if_instr_rdata = fetch_rdata;
    assign if_instr_addr  = fetch_addr;
    assign if_instr_bus_err = fetch_err;
    assign fetch_ready = id_in_ready_i & ~stall_dummy_instr &
                         !(instr_gets_expanded inside {INSTR_EXPANDED, INSTR_EXPANDED_COMMIT});
  end
    logic [1:0] fcov_dummy_instr_type; 
    if (DummyInstructions) begin : g_fcov_dummy_instr_type 
      assign fcov_dummy_instr_type = gen_dummy_instr.dummy_instr_i.lfsr_data.instr_type; 
    end else begin : g_no_fcov_dummy_instr_type 
      assign fcov_dummy_instr_type =  '0; 
    end 
    logic [1:0] unused_fcov_dummy_instr_type; 
    assign unused_fcov_dummy_instr_type = fcov_dummy_instr_type;
    logic fcov_insert_dummy_instr; 
    if (DummyInstructions) begin : g_fcov_insert_dummy_instr 
      assign fcov_insert_dummy_instr = gen_dummy_instr.insert_dummy_instr; 
    end else begin : g_no_fcov_insert_dummy_instr 
      assign fcov_insert_dummy_instr =  '0; 
    end 
    logic unused_fcov_insert_dummy_instr; 
    assign unused_fcov_insert_dummy_instr = fcov_insert_dummy_instr;
  if (BranchPredictor) begin : g_branch_predictor_asserts
  end else begin : g_no_branch_predictor_asserts
  end
endmodule
module ibex_load_store_unit #(
  parameter bit          MemECC       = 1'b0,
  parameter int unsigned MemDataWidth = MemECC ? 32 + 7 : 32
) (
  input  logic         clk_i,
  input  logic         rst_ni,
  output logic         data_req_o,
  input  logic         data_gnt_i,
  input  logic         data_rvalid_i,
  input  logic         data_bus_err_i,
  input  logic         data_pmp_err_i,
  output logic [31:0]             data_addr_o,
  output logic                    data_we_o,
  output logic [3:0]              data_be_o,
  output logic [MemDataWidth-1:0] data_wdata_o,
  input  logic [MemDataWidth-1:0] data_rdata_i,
  input  logic         lsu_we_i,              
  input  logic [1:0]   lsu_type_i,            
  input  logic [31:0]  lsu_wdata_i,           
  input  logic         lsu_sign_ext_i,        
  output logic [31:0]  lsu_rdata_o,           
  output logic         lsu_rdata_valid_o,
  input  logic         lsu_req_i,             
  input  logic [31:0]  adder_result_ex_i,     
  output logic         addr_incr_req_o,       
  output logic [31:0]  addr_last_o,           
  output logic         lsu_req_done_o,        
  output logic         lsu_resp_valid_o,      
  output logic         load_err_o,
  output logic         load_resp_intg_err_o,
  output logic         store_err_o,
  output logic         store_resp_intg_err_o,
  output logic         busy_o,
  output logic         perf_load_o,
  output logic         perf_store_o
);
  logic [31:0]  data_addr;
  logic [31:0]  data_addr_w_aligned;
  logic [31:0]  addr_last_q, addr_last_d;
  logic         addr_update;
  logic         ctrl_update;
  logic         rdata_update;
  logic [31:8]  rdata_q;
  logic [1:0]   rdata_offset_q;
  logic [1:0]   data_type_q;
  logic         data_sign_ext_q;
  logic         data_we_q;
  logic [1:0]   data_offset;    
  logic [3:0]   data_be;
  logic [31:0]  data_wdata;
  logic [31:0]  data_rdata_ext;
  logic [31:0]  rdata_w_ext;  
  logic [31:0]  rdata_h_ext;  
  logic [31:0]  rdata_b_ext;  
  logic         split_misaligned_access;
  logic         handle_misaligned_q, handle_misaligned_d;  
  logic         pmp_err_q, pmp_err_d;
  logic         lsu_err_q, lsu_err_d;
  logic         data_intg_err, data_or_pmp_err;
  typedef enum logic [2:0]  {
    IDLE, WAIT_GNT_MIS, WAIT_RVALID_MIS, WAIT_GNT,
    WAIT_RVALID_MIS_GNTS_DONE
  } ls_fsm_e;
  ls_fsm_e ls_fsm_cs, ls_fsm_ns;
  assign data_addr   = adder_result_ex_i;
  assign data_offset = data_addr[1:0];
  always_comb begin
    unique case (lsu_type_i)  
      2'b00: begin  
        if (!handle_misaligned_q) begin  
          unique case (data_offset)
            2'b00:   data_be = 4'b1111;
            2'b01:   data_be = 4'b1110;
            2'b10:   data_be = 4'b1100;
            2'b11:   data_be = 4'b1000;
            default: data_be = 4'b1111;
          endcase  
        end else begin  
          unique case (data_offset)
            2'b00:   data_be = 4'b0000;  
            2'b01:   data_be = 4'b0001;
            2'b10:   data_be = 4'b0011;
            2'b11:   data_be = 4'b0111;
            default: data_be = 4'b1111;
          endcase  
        end
      end
      2'b01: begin  
        if (!handle_misaligned_q) begin  
          unique case (data_offset)
            2'b00:   data_be = 4'b0011;
            2'b01:   data_be = 4'b0110;
            2'b10:   data_be = 4'b1100;
            2'b11:   data_be = 4'b1000;
            default: data_be = 4'b1111;
          endcase  
        end else begin  
          data_be = 4'b0001;
        end
      end
      2'b10,
      2'b11: begin  
        unique case (data_offset)
          2'b00:   data_be = 4'b0001;
          2'b01:   data_be = 4'b0010;
          2'b10:   data_be = 4'b0100;
          2'b11:   data_be = 4'b1000;
          default: data_be = 4'b1111;
        endcase  
      end
      default:     data_be = 4'b1111;
    endcase  
  end
  always_comb begin
    unique case (data_offset)
      2'b00:   data_wdata =  lsu_wdata_i[31:0];
      2'b01:   data_wdata = {lsu_wdata_i[23:0], lsu_wdata_i[31:24]};
      2'b10:   data_wdata = {lsu_wdata_i[15:0], lsu_wdata_i[31:16]};
      2'b11:   data_wdata = {lsu_wdata_i[ 7:0], lsu_wdata_i[31: 8]};
      default: data_wdata =  lsu_wdata_i[31:0];
    endcase  
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rdata_q <= '0;
    end else if (rdata_update) begin
      rdata_q <= data_rdata_i[31:8];
    end
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rdata_offset_q  <= 2'h0;
      data_type_q     <= 2'h0;
      data_sign_ext_q <= 1'b0;
      data_we_q       <= 1'b0;
    end else if (ctrl_update) begin
      rdata_offset_q  <= data_offset;
      data_type_q     <= lsu_type_i;
      data_sign_ext_q <= lsu_sign_ext_i;
      data_we_q       <= lsu_we_i;
    end
  end
  assign addr_last_d = addr_incr_req_o ? data_addr_w_aligned : data_addr;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      addr_last_q <= '0;
    end else if (addr_update) begin
      addr_last_q <= addr_last_d;
    end
  end
  always_comb begin
    unique case (rdata_offset_q)
      2'b00:   rdata_w_ext =  data_rdata_i[31:0];
      2'b01:   rdata_w_ext = {data_rdata_i[ 7:0], rdata_q[31:8]};
      2'b10:   rdata_w_ext = {data_rdata_i[15:0], rdata_q[31:16]};
      2'b11:   rdata_w_ext = {data_rdata_i[23:0], rdata_q[31:24]};
      default: rdata_w_ext =  data_rdata_i[31:0];
    endcase
  end
  always_comb begin
    unique case (rdata_offset_q)
      2'b00: begin
        if (!data_sign_ext_q) begin
          rdata_h_ext = {16'h0000, data_rdata_i[15:0]};
        end else begin
          rdata_h_ext = {{16{data_rdata_i[15]}}, data_rdata_i[15:0]};
        end
      end
      2'b01: begin
        if (!data_sign_ext_q) begin
          rdata_h_ext = {16'h0000, data_rdata_i[23:8]};
        end else begin
          rdata_h_ext = {{16{data_rdata_i[23]}}, data_rdata_i[23:8]};
        end
      end
      2'b10: begin
        if (!data_sign_ext_q) begin
          rdata_h_ext = {16'h0000, data_rdata_i[31:16]};
        end else begin
          rdata_h_ext = {{16{data_rdata_i[31]}}, data_rdata_i[31:16]};
        end
      end
      2'b11: begin
        if (!data_sign_ext_q) begin
          rdata_h_ext = {16'h0000, data_rdata_i[7:0], rdata_q[31:24]};
        end else begin
          rdata_h_ext = {{16{data_rdata_i[7]}}, data_rdata_i[7:0], rdata_q[31:24]};
        end
      end
      default: rdata_h_ext = {16'h0000, data_rdata_i[15:0]};
    endcase  
  end
  always_comb begin
    unique case (rdata_offset_q)
      2'b00: begin
        if (!data_sign_ext_q) begin
          rdata_b_ext = {24'h00_0000, data_rdata_i[7:0]};
        end else begin
          rdata_b_ext = {{24{data_rdata_i[7]}}, data_rdata_i[7:0]};
        end
      end
      2'b01: begin
        if (!data_sign_ext_q) begin
          rdata_b_ext = {24'h00_0000, data_rdata_i[15:8]};
        end else begin
          rdata_b_ext = {{24{data_rdata_i[15]}}, data_rdata_i[15:8]};
        end
      end
      2'b10: begin
        if (!data_sign_ext_q) begin
          rdata_b_ext = {24'h00_0000, data_rdata_i[23:16]};
        end else begin
          rdata_b_ext = {{24{data_rdata_i[23]}}, data_rdata_i[23:16]};
        end
      end
      2'b11: begin
        if (!data_sign_ext_q) begin
          rdata_b_ext = {24'h00_0000, data_rdata_i[31:24]};
        end else begin
          rdata_b_ext = {{24{data_rdata_i[31]}}, data_rdata_i[31:24]};
        end
      end
      default: rdata_b_ext = {24'h00_0000, data_rdata_i[7:0]};
    endcase  
  end
  always_comb begin
    unique case (data_type_q)
      2'b00:       data_rdata_ext = rdata_w_ext;
      2'b01:       data_rdata_ext = rdata_h_ext;
      2'b10,2'b11: data_rdata_ext = rdata_b_ext;
      default:     data_rdata_ext = rdata_w_ext;
    endcase  
  end
  if (MemECC) begin : g_mem_rdata_ecc
    logic [1:0] ecc_err;
    logic [MemDataWidth-1:0] data_rdata_buf;
    prim_buf #(.Width(MemDataWidth)) u_prim_buf_instr_rdata (
      .in_i (data_rdata_i),
      .out_o(data_rdata_buf)
    );
    prim_secded_inv_39_32_dec u_data_intg_dec (
      .data_i     (data_rdata_buf),
      .data_o     (),
      .syndrome_o (),
      .err_o      (ecc_err)
    );
    assign data_intg_err = |ecc_err;
  end else begin : g_no_mem_data_ecc
    assign data_intg_err = 1'b0;
  end
  assign split_misaligned_access =
      ((lsu_type_i == 2'b00) && (data_offset != 2'b00)) ||  
      ((lsu_type_i == 2'b01) && (data_offset == 2'b11));    
  always_comb begin
    ls_fsm_ns       = ls_fsm_cs;
    data_req_o          = 1'b0;
    addr_incr_req_o     = 1'b0;
    handle_misaligned_d = handle_misaligned_q;
    pmp_err_d           = pmp_err_q;
    lsu_err_d           = lsu_err_q;
    addr_update         = 1'b0;
    ctrl_update         = 1'b0;
    rdata_update        = 1'b0;
    perf_load_o         = 1'b0;
    perf_store_o        = 1'b0;
    unique case (ls_fsm_cs)
      IDLE: begin
        pmp_err_d = 1'b0;
        if (lsu_req_i) begin
          data_req_o   = 1'b1;
          pmp_err_d    = data_pmp_err_i;
          lsu_err_d    = 1'b0;
          perf_load_o  = ~lsu_we_i;
          perf_store_o = lsu_we_i;
          if (data_gnt_i) begin
            ctrl_update         = 1'b1;
            addr_update         = 1'b1;
            handle_misaligned_d = split_misaligned_access;
            ls_fsm_ns           = split_misaligned_access ? WAIT_RVALID_MIS : IDLE;
          end else begin
            ls_fsm_ns           = split_misaligned_access ? WAIT_GNT_MIS    : WAIT_GNT;
          end
        end
      end
      WAIT_GNT_MIS: begin
        data_req_o = 1'b1;
        if (data_gnt_i || pmp_err_q) begin
          addr_update         = 1'b1;
          ctrl_update         = 1'b1;
          handle_misaligned_d = 1'b1;
          ls_fsm_ns           = WAIT_RVALID_MIS;
        end
      end
      WAIT_RVALID_MIS: begin
        data_req_o = 1'b1;
        addr_incr_req_o = 1'b1;
        if (data_rvalid_i || pmp_err_q) begin
          pmp_err_d = data_pmp_err_i;
          lsu_err_d = data_bus_err_i | pmp_err_q;
          rdata_update = ~data_we_q;
          ls_fsm_ns = data_gnt_i ? IDLE : WAIT_GNT;
          addr_update = data_gnt_i & ~(data_bus_err_i | pmp_err_q);
          handle_misaligned_d = ~data_gnt_i;
        end else begin
          if (data_gnt_i) begin
            ls_fsm_ns = WAIT_RVALID_MIS_GNTS_DONE;
            handle_misaligned_d = 1'b0;
          end
        end
      end
      WAIT_GNT: begin
        addr_incr_req_o = handle_misaligned_q;
        data_req_o      = 1'b1;
        if (data_gnt_i || pmp_err_q) begin
          ctrl_update         = 1'b1;
          addr_update         = ~lsu_err_q;
          ls_fsm_ns           = IDLE;
          handle_misaligned_d = 1'b0;
        end
      end
      WAIT_RVALID_MIS_GNTS_DONE: begin
        addr_incr_req_o = 1'b1;
        if (data_rvalid_i) begin
          pmp_err_d = data_pmp_err_i;
          lsu_err_d = data_bus_err_i;
          addr_update = ~data_bus_err_i;
          rdata_update = ~data_we_q;
          ls_fsm_ns = IDLE;
        end
      end
      default: begin
        ls_fsm_ns = IDLE;
      end
    endcase
  end
  assign lsu_req_done_o = (lsu_req_i | (ls_fsm_cs != IDLE)) & (ls_fsm_ns == IDLE);
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      ls_fsm_cs           <= IDLE;
      handle_misaligned_q <= '0;
      pmp_err_q           <= '0;
      lsu_err_q           <= '0;
    end else begin
      ls_fsm_cs           <= ls_fsm_ns;
      handle_misaligned_q <= handle_misaligned_d;
      pmp_err_q           <= pmp_err_d;
      lsu_err_q           <= lsu_err_d;
    end
  end
  assign data_or_pmp_err    = lsu_err_q | data_bus_err_i | pmp_err_q;
  assign lsu_resp_valid_o   = (data_rvalid_i | pmp_err_q) & (ls_fsm_cs == IDLE);
  assign lsu_rdata_valid_o  =
    (ls_fsm_cs == IDLE) & data_rvalid_i & ~data_or_pmp_err & ~data_we_q & ~data_intg_err;
  assign lsu_rdata_o = data_rdata_ext;
  assign data_addr_w_aligned = {data_addr[31:2], 2'b00};
  assign data_addr_o   = data_addr_w_aligned;
  assign data_we_o     = lsu_we_i;
  assign data_be_o     = data_be;
  if (MemECC) begin : g_mem_wdata_ecc
    prim_secded_inv_39_32_enc u_data_gen (
      .data_i (data_wdata),
      .data_o (data_wdata_o)
    );
  end else begin : g_no_mem_wdata_ecc
    assign data_wdata_o = data_wdata;
  end
  assign addr_last_o   = addr_last_q;
  assign load_err_o      = data_or_pmp_err & ~data_we_q & lsu_resp_valid_o;
  assign store_err_o     = data_or_pmp_err &  data_we_q & lsu_resp_valid_o;
  assign load_resp_intg_err_o  = data_intg_err & data_rvalid_i & ~data_we_q;
  assign store_resp_intg_err_o = data_intg_err & data_rvalid_i & data_we_q;
  assign busy_o = (ls_fsm_cs != IDLE);
  logic fcov_mis_2_en_d, fcov_mis_2_en_q;
  logic fcov_mis_rvalid_1, fcov_mis_rvalid_2;
  logic fcov_mis_bus_err_1_d, fcov_mis_bus_err_1_q;
  assign fcov_mis_rvalid_1 = ls_fsm_cs inside {WAIT_RVALID_MIS, WAIT_RVALID_MIS_GNTS_DONE} &&
                                data_rvalid_i;
  assign fcov_mis_rvalid_2 = ls_fsm_cs inside {IDLE} && fcov_mis_2_en_q && data_rvalid_i;
  assign fcov_mis_2_en_d = fcov_mis_rvalid_2 ? 1'b0            :   
                           fcov_mis_rvalid_1 ? 1'b1            :   
                                               fcov_mis_2_en_q ;
  assign fcov_mis_bus_err_1_d = fcov_mis_rvalid_2                   ? 1'b0                 :  
                                fcov_mis_rvalid_1 && data_bus_err_i ? 1'b1                 :  
                                                                      fcov_mis_bus_err_1_q ;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      fcov_mis_2_en_q <= 1'b0;
      fcov_mis_bus_err_1_q <= 1'b0;
    end else begin
      fcov_mis_2_en_q <= fcov_mis_2_en_d;
      fcov_mis_bus_err_1_q <= fcov_mis_bus_err_1_d;
    end
  end
    logic fcov_ls_error_exception; 
    assign fcov_ls_error_exception = (load_err_o | store_err_o) & ~pmp_err_q; 
    logic unused_fcov_ls_error_exception; 
    assign unused_fcov_ls_error_exception = fcov_ls_error_exception;
    logic fcov_ls_pmp_exception; 
    assign fcov_ls_pmp_exception = (load_err_o | store_err_o) & pmp_err_q; 
    logic unused_fcov_ls_pmp_exception; 
    assign unused_fcov_ls_pmp_exception = fcov_ls_pmp_exception;
    logic fcov_ls_first_req; 
    assign fcov_ls_first_req = lsu_req_i & (ls_fsm_cs == IDLE); 
    logic unused_fcov_ls_first_req; 
    assign unused_fcov_ls_first_req = fcov_ls_first_req;
    logic fcov_ls_second_req; 
    assign fcov_ls_second_req = (ls_fsm_cs inside {WAIT_RVALID_MIS}) & data_req_o & addr_incr_req_o; 
    logic unused_fcov_ls_second_req; 
    assign unused_fcov_ls_second_req = fcov_ls_second_req;
    logic fcov_ls_mis_pmp_err_1; 
    assign fcov_ls_mis_pmp_err_1 = (ls_fsm_cs inside {WAIT_RVALID_MIS, WAIT_GNT_MIS}) && pmp_err_q; 
    logic unused_fcov_ls_mis_pmp_err_1; 
    assign unused_fcov_ls_mis_pmp_err_1 = fcov_ls_mis_pmp_err_1;
    logic fcov_ls_mis_pmp_err_2; 
    assign fcov_ls_mis_pmp_err_2 = (ls_fsm_cs inside {WAIT_RVALID_MIS, WAIT_RVALID_MIS_GNTS_DONE}) && data_pmp_err_i; 
    logic unused_fcov_ls_mis_pmp_err_2; 
    assign unused_fcov_ls_mis_pmp_err_2 = fcov_ls_mis_pmp_err_2;
endmodule
module ibex_multdiv_fast #(
  parameter ibex_pkg::rv32m_e RV32M = ibex_pkg::RV32MFast
  ) (
  input  logic             clk_i,
  input  logic             rst_ni,
  input  logic             mult_en_i,   
  input  logic             div_en_i,    
  input  logic             mult_sel_i,  
  input  logic             div_sel_i,   
  input  ibex_pkg::md_op_e operator_i,
  input  logic  [1:0]      signed_mode_i,
  input  logic [31:0]      op_a_i,
  input  logic [31:0]      op_b_i,
  input  logic [33:0]      alu_adder_ext_i,
  input  logic [31:0]      alu_adder_i,
  input  logic             equal_to_zero_i,
  input  logic             data_ind_timing_i,
  output logic [32:0]      alu_operand_a_o,
  output logic [32:0]      alu_operand_b_o,
  input  logic [33:0]      imd_val_q_i[2],
  output logic [33:0]      imd_val_d_o[2],
  output logic [1:0]       imd_val_we_o,
  input  logic             multdiv_ready_id_i,
  output logic [31:0]      multdiv_result_o,
  output logic             valid_o
);
  import ibex_pkg::*;
  logic signed [34:0] mac_res_signed;
  logic        [34:0] mac_res_ext;
  logic        [33:0] accum;
  logic        sign_a, sign_b;
  logic        mult_valid;
  logic        signed_mult;
  logic [33:0] mac_res_d, op_remainder_d;
  logic [33:0] mac_res;
  logic        div_sign_a, div_sign_b;
  logic        is_greater_equal;
  logic        div_change_sign, rem_change_sign;
  logic [31:0] one_shift;
  logic [31:0] op_denominator_q;
  logic [31:0] op_numerator_q;
  logic [31:0] op_quotient_q;
  logic [31:0] op_denominator_d;
  logic [31:0] op_numerator_d;
  logic [31:0] op_quotient_d;
  logic [31:0] next_remainder;
  logic [32:0] next_quotient;
  logic [31:0] res_adder_h;
  logic        div_valid;
  logic [ 4:0] div_counter_q, div_counter_d;
  logic        multdiv_en;
  logic        mult_hold;
  logic        div_hold;
  logic        div_by_zero_d, div_by_zero_q;
  logic        mult_en_internal;
  logic        div_en_internal;
  logic        sva_mul_fsm_idle;
  typedef enum logic [2:0] {
    MD_IDLE, MD_ABS_A, MD_ABS_B, MD_COMP, MD_LAST, MD_CHANGE_SIGN, MD_FINISH
  } md_fsm_e;
  md_fsm_e md_state_q, md_state_d;
  logic unused_mult_sel_i;
  assign unused_mult_sel_i = mult_sel_i;
  assign mult_en_internal = mult_en_i & ~mult_hold;
  assign div_en_internal  = div_en_i & ~div_hold;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      div_counter_q    <= '0;
      md_state_q       <= MD_IDLE;
      op_numerator_q   <= '0;
      op_quotient_q    <= '0;
      div_by_zero_q    <= '0;
    end else if (div_en_internal) begin
      div_counter_q    <= div_counter_d;
      op_numerator_q   <= op_numerator_d;
      op_quotient_q    <= op_quotient_d;
      md_state_q       <= md_state_d;
      div_by_zero_q    <= div_by_zero_d;
    end
  end
  assign multdiv_en = mult_en_internal | div_en_internal;
  assign imd_val_d_o[0] = div_sel_i ? op_remainder_d : mac_res_d;
  assign imd_val_we_o[0] = multdiv_en;
  assign imd_val_d_o[1] = {2'b0, op_denominator_d};
  assign imd_val_we_o[1] = div_en_internal;
  assign op_denominator_q = imd_val_q_i[1][31:0];
  logic [1:0] unused_imd_val;
  assign unused_imd_val = imd_val_q_i[1][33:32];
  logic unused_mac_res_ext;
  assign unused_mac_res_ext = mac_res_ext[34];
  assign signed_mult      = (signed_mode_i != 2'b00);
  assign multdiv_result_o = div_sel_i ? imd_val_q_i[0][31:0] : mac_res_d[31:0];
  if (RV32M == RV32MSingleCycle) begin : gen_mult_single_cycle
    typedef enum logic {
      MULL, MULH
    } mult_fsm_e;
    mult_fsm_e mult_state_q, mult_state_d;
    logic signed [33:0] mult1_res, mult2_res, mult3_res;
    logic [33:0]        mult1_res_uns;
    logic [33:32]       unused_mult1_res_uns;
    logic [15:0]        mult1_op_a, mult1_op_b;
    logic [15:0]        mult2_op_a, mult2_op_b;
    logic [15:0]        mult3_op_a, mult3_op_b;
    logic               mult1_sign_a, mult1_sign_b;
    logic               mult2_sign_a, mult2_sign_b;
    logic               mult3_sign_a, mult3_sign_b;
    logic [33:0]        summand1, summand2, summand3;
    assign mult1_res = $signed({mult1_sign_a, mult1_op_a}) * $signed({mult1_sign_b, mult1_op_b});
    assign mult2_res = $signed({mult2_sign_a, mult2_op_a}) * $signed({mult2_sign_b, mult2_op_b});
    assign mult3_res = $signed({mult3_sign_a, mult3_op_a}) * $signed({mult3_sign_b, mult3_op_b});
    assign mac_res_signed = $signed(summand1) + $signed(summand2) + $signed(summand3);
    assign mult1_res_uns  = $unsigned(mult1_res);
    assign mac_res_ext    = $unsigned(mac_res_signed);
    assign mac_res        = mac_res_ext[33:0];
    assign sign_a = signed_mode_i[0] & op_a_i[31];
    assign sign_b = signed_mode_i[1] & op_b_i[31];
    assign mult1_sign_a = 1'b0;
    assign mult1_sign_b = 1'b0;
    assign mult1_op_a = op_a_i[15:0];
    assign mult1_op_b = op_b_i[15:0];
    assign mult2_sign_a = 1'b0;
    assign mult2_sign_b = sign_b;
    assign mult2_op_a = op_a_i[15:0];
    assign mult2_op_b = op_b_i[31:16];
    assign accum[17:0] = imd_val_q_i[0][33:16];
    assign accum[33:18] = {16{signed_mult & imd_val_q_i[0][33]}};
    always_comb begin
      mult3_sign_a = sign_a;
      mult3_sign_b = 1'b0;
      mult3_op_a = op_a_i[31:16];
      mult3_op_b = op_b_i[15:0];
      summand1 = {18'h0, mult1_res_uns[31:16]};
      summand2 = $unsigned(mult2_res);
      summand3 = $unsigned(mult3_res);
      mac_res_d = {2'b0, mac_res[15:0], mult1_res_uns[15:0]};
      mult_valid = mult_en_i;
      mult_state_d = MULL;
      mult_hold = 1'b0;
      unique case (mult_state_q)
        MULL: begin
          if (operator_i != MD_OP_MULL) begin
            mac_res_d = mac_res;
            mult_valid = 1'b0;
            mult_state_d = MULH;
          end else begin
            mult_hold = ~multdiv_ready_id_i;
          end
        end
        MULH: begin
          mult3_sign_a = sign_a;
          mult3_sign_b = sign_b;
          mult3_op_a = op_a_i[31:16];
          mult3_op_b = op_b_i[31:16];
          mac_res_d = mac_res;
          summand1 = '0;
          summand2 = accum;
          summand3 = $unsigned(mult3_res);
          mult_state_d = MULL;
          mult_valid = 1'b1;
          mult_hold = ~multdiv_ready_id_i;
        end
        default: begin
          mult_state_d = MULL;
        end
      endcase  
    end
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        mult_state_q <= MULL;
      end else begin
        if (mult_en_internal) begin
          mult_state_q <= mult_state_d;
        end
      end
    end
    assign unused_mult1_res_uns = mult1_res_uns[33:32];
    assign sva_mul_fsm_idle = mult_state_q == MULL;
  end else begin : gen_mult_fast
    logic [15:0] mult_op_a;
    logic [15:0] mult_op_b;
    typedef enum logic [1:0] {
      ALBL, ALBH, AHBL, AHBH
    } mult_fsm_e;
    mult_fsm_e mult_state_q, mult_state_d;
    assign mac_res_signed =
        $signed({sign_a, mult_op_a}) * $signed({sign_b, mult_op_b}) + $signed(accum);
    assign mac_res_ext    = $unsigned(mac_res_signed);
    assign mac_res        = mac_res_ext[33:0];
    always_comb begin
      mult_op_a    = op_a_i[15:0];
      mult_op_b    = op_b_i[15:0];
      sign_a       = 1'b0;
      sign_b       = 1'b0;
      accum        = imd_val_q_i[0];
      mac_res_d    = mac_res;
      mult_state_d = mult_state_q;
      mult_valid   = 1'b0;
      mult_hold    = 1'b0;
      unique case (mult_state_q)
        ALBL: begin
          mult_op_a = op_a_i[15:0];
          mult_op_b = op_b_i[15:0];
          sign_a    = 1'b0;
          sign_b    = 1'b0;
          accum     = '0;
          mac_res_d = mac_res;
          mult_state_d = ALBH;
        end
        ALBH: begin
          mult_op_a = op_a_i[15:0];
          mult_op_b = op_b_i[31:16];
          sign_a    = 1'b0;
          sign_b    = signed_mode_i[1] & op_b_i[31];
          accum     = {18'b0, imd_val_q_i[0][31:16]};
          if (operator_i == MD_OP_MULL) begin
            mac_res_d = {2'b0, mac_res[15:0], imd_val_q_i[0][15:0]};
          end else begin
            mac_res_d = mac_res;
          end
          mult_state_d = AHBL;
        end
        AHBL: begin
          mult_op_a = op_a_i[31:16];
          mult_op_b = op_b_i[15:0];
          sign_a    = signed_mode_i[0] & op_a_i[31];
          sign_b    = 1'b0;
          if (operator_i == MD_OP_MULL) begin
            accum        = {18'b0, imd_val_q_i[0][31:16]};
            mac_res_d    = {2'b0, mac_res[15:0], imd_val_q_i[0][15:0]};
            mult_valid   = 1'b1;
            mult_state_d = ALBL;
            mult_hold    = ~multdiv_ready_id_i;
          end else begin
            accum        = imd_val_q_i[0];
            mac_res_d    = mac_res;
            mult_state_d = AHBH;
          end
        end
        AHBH: begin
          mult_op_a = op_a_i[31:16];
          mult_op_b = op_b_i[31:16];
          sign_a    = signed_mode_i[0] & op_a_i[31];
          sign_b    = signed_mode_i[1] & op_b_i[31];
          accum[17: 0]  = imd_val_q_i[0][33:16];
          accum[33:18]  = {16{signed_mult & imd_val_q_i[0][33]}};
          mac_res_d    = mac_res;
          mult_valid   = 1'b1;
          mult_state_d = ALBL;
          mult_hold    = ~multdiv_ready_id_i;
        end
        default: begin
          mult_state_d = ALBL;
        end
      endcase  
    end
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        mult_state_q <= ALBL;
      end else begin
        if (mult_en_internal) begin
          mult_state_q <= mult_state_d;
        end
      end
    end
    assign sva_mul_fsm_idle = mult_state_q == ALBL;
  end  
  assign res_adder_h    = alu_adder_ext_i[32:1];
  logic [1:0] unused_alu_adder_ext;
  assign unused_alu_adder_ext = {alu_adder_ext_i[33],alu_adder_ext_i[0]};
  assign next_remainder = is_greater_equal ? res_adder_h[31:0] : imd_val_q_i[0][31:0];
  assign next_quotient  = is_greater_equal ? {1'b0, op_quotient_q} | {1'b0, one_shift} :
                                             {1'b0, op_quotient_q};
  assign one_shift      = {31'b0, 1'b1} << div_counter_q;
  always_comb begin
    if ((imd_val_q_i[0][31] ^ op_denominator_q[31]) == 1'b0) begin
      is_greater_equal = (res_adder_h[31] == 1'b0);
    end else begin
      is_greater_equal = imd_val_q_i[0][31];
    end
  end
  assign div_sign_a      = op_a_i[31] & signed_mode_i[0];
  assign div_sign_b      = op_b_i[31] & signed_mode_i[1];
  assign div_change_sign = (div_sign_a ^ div_sign_b) & ~div_by_zero_q;
  assign rem_change_sign = div_sign_a;
  always_comb begin
    div_counter_d    = div_counter_q - 5'h1;
    op_remainder_d   = imd_val_q_i[0];
    op_quotient_d    = op_quotient_q;
    md_state_d       = md_state_q;
    op_numerator_d   = op_numerator_q;
    op_denominator_d = op_denominator_q;
    alu_operand_a_o  = {32'h0  , 1'b1};
    alu_operand_b_o  = {~op_b_i, 1'b1};
    div_valid        = 1'b0;
    div_hold         = 1'b0;
    div_by_zero_d    = div_by_zero_q;
    unique case (md_state_q)
      MD_IDLE: begin
        if (operator_i == MD_OP_DIV) begin
          op_remainder_d = '1;
          md_state_d     = (!data_ind_timing_i && equal_to_zero_i) ? MD_FINISH : MD_ABS_A;
          div_by_zero_d  = equal_to_zero_i;
        end else begin
          op_remainder_d = {2'b0, op_a_i};
          md_state_d     = (!data_ind_timing_i && equal_to_zero_i) ? MD_FINISH : MD_ABS_A;
        end
        alu_operand_a_o  = {32'h0  , 1'b1};
        alu_operand_b_o  = {~op_b_i, 1'b1};
        div_counter_d    = 5'd31;
      end
      MD_ABS_A: begin
        op_quotient_d   = '0;
        op_numerator_d  = div_sign_a ? alu_adder_i : op_a_i;
        md_state_d      = MD_ABS_B;
        div_counter_d   = 5'd31;
        alu_operand_a_o = {32'h0  , 1'b1};
        alu_operand_b_o = {~op_a_i, 1'b1};
      end
      MD_ABS_B: begin
        op_remainder_d   = { 33'h0, op_numerator_q[31]};
        op_denominator_d = div_sign_b ? alu_adder_i : op_b_i;
        md_state_d       = MD_COMP;
        div_counter_d    = 5'd31;
        alu_operand_a_o  = {32'h0  , 1'b1};
        alu_operand_b_o  = {~op_b_i, 1'b1};
      end
      MD_COMP: begin
        op_remainder_d  = {1'b0, next_remainder[31:0], op_numerator_q[div_counter_d]};
        op_quotient_d   = next_quotient[31:0];
        md_state_d      = (div_counter_q == 5'd1) ? MD_LAST : MD_COMP;
        alu_operand_a_o = {imd_val_q_i[0][31:0], 1'b1};  
        alu_operand_b_o = {~op_denominator_q[31:0], 1'b1};   
      end
      MD_LAST: begin
        if (operator_i == MD_OP_DIV) begin
          op_remainder_d = {1'b0, next_quotient};
        end else begin
          op_remainder_d = {2'b0, next_remainder[31:0]};
        end
        alu_operand_a_o  = {imd_val_q_i[0][31:0], 1'b1};  
        alu_operand_b_o  = {~op_denominator_q[31:0], 1'b1};   
        md_state_d = MD_CHANGE_SIGN;
      end
      MD_CHANGE_SIGN: begin
        md_state_d  = MD_FINISH;
        if (operator_i == MD_OP_DIV) begin
          op_remainder_d = (div_change_sign) ? {2'h0, alu_adder_i} : imd_val_q_i[0];
        end else begin
          op_remainder_d = (rem_change_sign) ? {2'h0, alu_adder_i} : imd_val_q_i[0];
        end
        alu_operand_a_o  = {32'h0  , 1'b1};
        alu_operand_b_o  = {~imd_val_q_i[0][31:0], 1'b1};
      end
      MD_FINISH: begin
        md_state_d = MD_IDLE;
        div_hold   = ~multdiv_ready_id_i;
        div_valid   = 1'b1;
      end
      default: begin
        md_state_d = MD_IDLE;
      end
    endcase  
  end
  assign valid_o = mult_valid | div_valid;
  logic unused_sva_mul_fsm_idle;
  assign unused_sva_mul_fsm_idle = sva_mul_fsm_idle;
endmodule  
module ibex_multdiv_slow
(
  input  logic             clk_i,
  input  logic             rst_ni,
  input  logic             mult_en_i,   
  input  logic             div_en_i,    
  input  logic             mult_sel_i,  
  input  logic             div_sel_i,   
  input  ibex_pkg::md_op_e operator_i,
  input  logic  [1:0]      signed_mode_i,
  input  logic [31:0]      op_a_i,
  input  logic [31:0]      op_b_i,
  input  logic [33:0]      alu_adder_ext_i,
  input  logic [31:0]      alu_adder_i,
  input  logic             equal_to_zero_i,
  input  logic             data_ind_timing_i,
  output logic [32:0]      alu_operand_a_o,
  output logic [32:0]      alu_operand_b_o,
  input  logic [33:0]      imd_val_q_i[2],
  output logic [33:0]      imd_val_d_o[2],
  output logic  [1:0]      imd_val_we_o,
  input  logic             multdiv_ready_id_i,
  output logic [31:0]      multdiv_result_o,
  output logic             valid_o
);
  import ibex_pkg::*;
  typedef enum logic [2:0] {
    MD_IDLE, MD_ABS_A, MD_ABS_B, MD_COMP, MD_LAST, MD_CHANGE_SIGN, MD_FINISH
  } md_fsm_e;
  md_fsm_e md_state_q, md_state_d;
  logic [32:0] accum_window_q, accum_window_d;
  logic        unused_imd_val0;
  logic [ 1:0] unused_imd_val1;
  logic [32:0] res_adder_l;
  logic [32:0] res_adder_h;
  logic [ 4:0] multdiv_count_q, multdiv_count_d;
  logic [32:0] op_b_shift_q, op_b_shift_d;
  logic [32:0] op_a_shift_q, op_a_shift_d;
  logic [32:0] op_a_ext, op_b_ext;
  logic [32:0] one_shift;
  logic [32:0] op_a_bw_pp, op_a_bw_last_pp;
  logic [31:0] b_0;
  logic        sign_a, sign_b;
  logic [32:0] next_quotient;
  logic [31:0] next_remainder;
  logic [31:0] op_numerator_q, op_numerator_d;
  logic        is_greater_equal;
  logic        div_change_sign, rem_change_sign;
  logic        div_by_zero_d, div_by_zero_q;
  logic        multdiv_hold;
  logic        multdiv_en;
  assign res_adder_l = alu_adder_ext_i[32:0];
  assign res_adder_h = alu_adder_ext_i[33:1];
  assign imd_val_d_o[0]  = {1'b0,accum_window_d};
  assign imd_val_we_o[0] = ~multdiv_hold;
  assign accum_window_q  = imd_val_q_i[0][32:0];
  assign unused_imd_val0 = imd_val_q_i[0][33];
  assign imd_val_d_o[1]  = {2'b00, op_numerator_d};
  assign imd_val_we_o[1] = multdiv_en;
  assign op_numerator_q  = imd_val_q_i[1][31:0];
  assign unused_imd_val1 = imd_val_q_i[1][33:32];
  always_comb begin
    alu_operand_a_o = accum_window_q;
    unique case (operator_i)
      MD_OP_MULL: begin
        alu_operand_b_o = op_a_bw_pp;
      end
      MD_OP_MULH: begin
        alu_operand_b_o = (md_state_q == MD_LAST) ? op_a_bw_last_pp : op_a_bw_pp;
      end
      MD_OP_DIV,
      MD_OP_REM: begin
        unique case (md_state_q)
          MD_IDLE: begin
            alu_operand_a_o = {32'h0  , 1'b1};
            alu_operand_b_o = {~op_b_i, 1'b1};
          end
          MD_ABS_A: begin
            alu_operand_a_o = {32'h0  , 1'b1};
            alu_operand_b_o = {~op_a_i, 1'b1};
          end
          MD_ABS_B: begin
            alu_operand_a_o = {32'h0  , 1'b1};
            alu_operand_b_o = {~op_b_i, 1'b1};
          end
          MD_CHANGE_SIGN: begin
            alu_operand_a_o = {32'h0  , 1'b1};
            alu_operand_b_o = {~accum_window_q[31:0], 1'b1};
          end
          default: begin
            alu_operand_a_o = {accum_window_q[31:0], 1'b1};  
            alu_operand_b_o = {~op_b_shift_q[31:0], 1'b1};   
          end
        endcase
      end
      default: begin
        alu_operand_a_o = accum_window_q;
        alu_operand_b_o = {~op_b_shift_q[31:0], 1'b1};
      end
    endcase
  end
  assign b_0             = {32{op_b_shift_q[0]}};
  assign op_a_bw_pp      = { ~(op_a_shift_q[32] & op_b_shift_q[0]),  (op_a_shift_q[31:0] & b_0) };
  assign op_a_bw_last_pp = {  (op_a_shift_q[32] & op_b_shift_q[0]), ~(op_a_shift_q[31:0] & b_0) };
  assign sign_a   = op_a_i[31] & signed_mode_i[0];
  assign sign_b   = op_b_i[31] & signed_mode_i[1];
  assign op_a_ext = {sign_a, op_a_i};
  assign op_b_ext = {sign_b, op_b_i};
  assign is_greater_equal = (accum_window_q[31] == op_b_shift_q[31]) ?
      ~res_adder_h[31] : accum_window_q[31];
  assign one_shift      = {32'b0, 1'b1} << multdiv_count_q;
  assign next_remainder = is_greater_equal ? res_adder_h[31:0]        : accum_window_q[31:0];
  assign next_quotient  = is_greater_equal ? op_a_shift_q | one_shift : op_a_shift_q;
  assign div_change_sign  = (sign_a ^ sign_b) & ~div_by_zero_q;
  assign rem_change_sign  = sign_a;
  always_comb begin
    multdiv_count_d  = multdiv_count_q;
    accum_window_d   = accum_window_q;
    op_b_shift_d     = op_b_shift_q;
    op_a_shift_d     = op_a_shift_q;
    op_numerator_d   = op_numerator_q;
    md_state_d       = md_state_q;
    multdiv_hold     = 1'b0;
    div_by_zero_d    = div_by_zero_q;
    if (mult_sel_i || div_sel_i) begin
      unique case (md_state_q)
        MD_IDLE: begin
          unique case (operator_i)
            MD_OP_MULL: begin
              op_a_shift_d   = op_a_ext << 1;
              accum_window_d = {       ~(op_a_ext[32]   &     op_b_i[0]),
                                         op_a_ext[31:0] & {32{op_b_i[0]}}  };
              op_b_shift_d   = op_b_ext >> 1;
              md_state_d     = (!data_ind_timing_i && ((op_b_ext >> 1) == 0)) ? MD_LAST : MD_COMP;
            end
            MD_OP_MULH: begin
              op_a_shift_d   = op_a_ext;
              accum_window_d = { 1'b1, ~(op_a_ext[32]   &     op_b_i[0]),
                                         op_a_ext[31:1] & {31{op_b_i[0]}}  };
              op_b_shift_d   = op_b_ext >> 1;
              md_state_d     = MD_COMP;
            end
            MD_OP_DIV: begin
              accum_window_d = {33{1'b1}};
              md_state_d     = (!data_ind_timing_i && equal_to_zero_i) ? MD_FINISH : MD_ABS_A;
              div_by_zero_d  = equal_to_zero_i;
            end
            MD_OP_REM: begin
              accum_window_d = op_a_ext;
              md_state_d     = (!data_ind_timing_i && equal_to_zero_i) ? MD_FINISH : MD_ABS_A;
            end
            default:;
          endcase
          multdiv_count_d   = 5'd31;
        end
        MD_ABS_A: begin
          op_a_shift_d   = '0;
          op_numerator_d = sign_a ? alu_adder_i : op_a_i;
          md_state_d     = MD_ABS_B;
        end
        MD_ABS_B: begin
          accum_window_d = {32'h0, op_numerator_q[31]};
          op_b_shift_d   = sign_b ? {1'b0, alu_adder_i} : {1'b0, op_b_i};
          md_state_d     = MD_COMP;
        end
        MD_COMP: begin
          multdiv_count_d = multdiv_count_q - 5'h1;
          unique case (operator_i)
            MD_OP_MULL: begin
              accum_window_d = res_adder_l;
              op_a_shift_d   = op_a_shift_q << 1;
              op_b_shift_d   = op_b_shift_q >> 1;
              md_state_d     = ((!data_ind_timing_i && (op_b_shift_d == 0)) ||
                                (multdiv_count_q == 5'd1)) ? MD_LAST : MD_COMP;
            end
            MD_OP_MULH: begin
              accum_window_d = res_adder_h;
              op_a_shift_d   = op_a_shift_q;
              op_b_shift_d   = op_b_shift_q >> 1;
              md_state_d     = (multdiv_count_q == 5'd1) ? MD_LAST : MD_COMP;
            end
            MD_OP_DIV,
            MD_OP_REM: begin
              accum_window_d = {next_remainder[31:0], op_numerator_q[multdiv_count_d]};
              op_a_shift_d   = next_quotient;
              md_state_d     = (multdiv_count_q == 5'd1) ? MD_LAST : MD_COMP;
            end
            default: ;
          endcase
        end
        MD_LAST: begin
          unique case (operator_i)
            MD_OP_MULL: begin
              accum_window_d = res_adder_l;
              md_state_d   = MD_IDLE;
              multdiv_hold = ~multdiv_ready_id_i;
            end
            MD_OP_MULH: begin
              accum_window_d = res_adder_l;
              md_state_d     = MD_IDLE;
              md_state_d   = MD_IDLE;
              multdiv_hold = ~multdiv_ready_id_i;
            end
            MD_OP_DIV: begin
              accum_window_d = next_quotient;
              md_state_d     = MD_CHANGE_SIGN;
            end
            MD_OP_REM: begin
              accum_window_d = {1'b0, next_remainder[31:0]};
              md_state_d     = MD_CHANGE_SIGN;
            end
            default: ;
          endcase
        end
        MD_CHANGE_SIGN: begin
          md_state_d = MD_FINISH;
          unique case (operator_i)
            MD_OP_DIV:
              accum_window_d = div_change_sign ? {1'b0,alu_adder_i} : accum_window_q;
            MD_OP_REM:
              accum_window_d = rem_change_sign ? {1'b0,alu_adder_i} : accum_window_q;
            default: ;
          endcase
        end
        MD_FINISH: begin
          md_state_d   = MD_IDLE;
          multdiv_hold = ~multdiv_ready_id_i;
        end
        default: begin
          md_state_d = MD_IDLE;
        end
      endcase  
    end  
  end
  assign multdiv_en = (mult_en_i | div_en_i) & ~multdiv_hold;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      multdiv_count_q  <= 5'h0;
      op_b_shift_q     <= 33'h0;
      op_a_shift_q     <= 33'h0;
      md_state_q       <= MD_IDLE;
      div_by_zero_q    <= 1'b0;
    end else if (multdiv_en) begin
      multdiv_count_q  <= multdiv_count_d;
      op_b_shift_q     <= op_b_shift_d;
      op_a_shift_q     <= op_a_shift_d;
      md_state_q       <= md_state_d;
      div_by_zero_q    <= div_by_zero_d;
    end
  end
  assign valid_o = (md_state_q == MD_FINISH) |
                   (md_state_q == MD_LAST &
                   (operator_i == MD_OP_MULL |
                    operator_i == MD_OP_MULH));
  assign multdiv_result_o = div_en_i ? accum_window_q[31:0] : res_adder_l[31:0];
endmodule
module ibex_prefetch_buffer #(
  parameter bit ResetAll        = 1'b0
) (
  input  logic        clk_i,
  input  logic        rst_ni,
  input  logic        req_i,
  input  logic        branch_i,
  input  logic [31:0] addr_i,
  input  logic        ready_i,
  output logic        valid_o,
  output logic [31:0] rdata_o,
  output logic [31:0] addr_o,
  output logic        err_o,
  output logic        err_plus2_o,
  output logic        instr_req_o,
  input  logic        instr_gnt_i,
  output logic [31:0] instr_addr_o,
  input  logic [31:0] instr_rdata_i,
  input  logic        instr_err_i,
  input  logic        instr_rvalid_i,
  output logic        busy_o
);
  localparam int unsigned NUM_REQS  = 2;
  logic                valid_new_req, valid_req;
  logic                valid_req_d, valid_req_q;
  logic                discard_req_d, discard_req_q;
  logic [NUM_REQS-1:0] rdata_outstanding_n, rdata_outstanding_s, rdata_outstanding_q;
  logic [NUM_REQS-1:0] branch_discard_n, branch_discard_s, branch_discard_q;
  logic [NUM_REQS-1:0] rdata_outstanding_rev;
  logic [31:0]         stored_addr_d, stored_addr_q;
  logic                stored_addr_en;
  logic [31:0]         fetch_addr_d, fetch_addr_q;
  logic                fetch_addr_en;
  logic [31:0]         instr_addr, instr_addr_w_aligned;
  logic                fifo_valid;
  logic [31:0]         fifo_addr;
  logic                fifo_ready;
  logic                fifo_clear;
  logic [NUM_REQS-1:0] fifo_busy;
  assign busy_o = (|rdata_outstanding_q) | instr_req_o;
  assign fifo_clear = branch_i;
  for (genvar i = 0; i < NUM_REQS; i++) begin : gen_rd_rev
    assign rdata_outstanding_rev[i] = rdata_outstanding_q[NUM_REQS-1-i];
  end
  assign fifo_ready = ~&(fifo_busy | rdata_outstanding_rev);
  ibex_fetch_fifo #(
    .NUM_REQS (NUM_REQS),
    .ResetAll (ResetAll)
  ) fifo_i (
      .clk_i                 ( clk_i             ),
      .rst_ni                ( rst_ni            ),
      .clear_i               ( fifo_clear        ),
      .busy_o                ( fifo_busy         ),
      .in_valid_i            ( fifo_valid        ),
      .in_addr_i             ( fifo_addr         ),
      .in_rdata_i            ( instr_rdata_i     ),
      .in_err_i              ( instr_err_i       ),
      .out_valid_o           ( valid_o           ),
      .out_ready_i           ( ready_i           ),
      .out_rdata_o           ( rdata_o           ),
      .out_addr_o            ( addr_o            ),
      .out_err_o             ( err_o             ),
      .out_err_plus2_o       ( err_plus2_o       )
  );
  assign valid_new_req = req_i & (fifo_ready | branch_i) &
                         ~rdata_outstanding_q[NUM_REQS-1];
  assign valid_req = valid_req_q | valid_new_req;
  assign valid_req_d = valid_req & ~instr_gnt_i;
  assign discard_req_d = valid_req_q & (branch_i | discard_req_q);
  assign stored_addr_en = valid_new_req & ~valid_req_q & ~instr_gnt_i;
  assign stored_addr_d = instr_addr;
  if (ResetAll) begin : g_stored_addr_ra
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        stored_addr_q <= '0;
      end else if (stored_addr_en) begin
        stored_addr_q <= stored_addr_d;
      end
    end
  end else begin : g_stored_addr_nr
    always_ff @(posedge clk_i) begin
      if (stored_addr_en) begin
        stored_addr_q <= stored_addr_d;
      end
    end
  end
  assign fetch_addr_en = branch_i | (valid_new_req & ~valid_req_q);
  assign fetch_addr_d = (branch_i ? addr_i : {fetch_addr_q[31:2], 2'b00}) +
                        {{29{1'b0}},(valid_new_req & ~valid_req_q),2'b00};
  if (ResetAll) begin : g_fetch_addr_ra
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        fetch_addr_q <= '0;
      end else if (fetch_addr_en) begin
        fetch_addr_q <= fetch_addr_d;
      end
    end
  end else begin : g_fetch_addr_nr
    always_ff @(posedge clk_i) begin
      if (fetch_addr_en) begin
        fetch_addr_q <= fetch_addr_d;
      end
    end
  end
  assign instr_addr = valid_req_q ? stored_addr_q :
                      branch_i    ? addr_i :
                                    fetch_addr_q;
  assign instr_addr_w_aligned = {instr_addr[31:2], 2'b00};
  for (genvar i = 0; i < NUM_REQS; i++) begin : g_outstanding_reqs
    if (i == 0) begin : g_req0
      assign rdata_outstanding_n[i] = (valid_req & instr_gnt_i) |
                                      rdata_outstanding_q[i];
      assign branch_discard_n[i]    = (valid_req & instr_gnt_i & discard_req_d) |
                                      (branch_i & rdata_outstanding_q[i]) |
                                      branch_discard_q[i];
    end else begin : g_reqtop
      assign rdata_outstanding_n[i] = (valid_req & instr_gnt_i &
                                       rdata_outstanding_q[i-1]) |
                                      rdata_outstanding_q[i];
      assign branch_discard_n[i]    = (valid_req & instr_gnt_i & discard_req_d &
                                       rdata_outstanding_q[i-1]) |
                                      (branch_i & rdata_outstanding_q[i]) |
                                      branch_discard_q[i];
    end
  end
  assign rdata_outstanding_s = instr_rvalid_i ? {1'b0,rdata_outstanding_n[NUM_REQS-1:1]} :
                                                rdata_outstanding_n;
  assign branch_discard_s    = instr_rvalid_i ? {1'b0,branch_discard_n[NUM_REQS-1:1]} :
                                                branch_discard_n;
  assign fifo_valid = instr_rvalid_i & ~branch_discard_q[0];
  assign fifo_addr = addr_i;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      valid_req_q          <= 1'b0;
      discard_req_q        <= 1'b0;
      rdata_outstanding_q  <= 'b0;
      branch_discard_q     <= 'b0;
    end else begin
      valid_req_q          <= valid_req_d;
      discard_req_q        <= discard_req_d;
      rdata_outstanding_q  <= rdata_outstanding_s;
      branch_discard_q     <= branch_discard_s;
    end
  end
  assign instr_req_o  = valid_req;
  assign instr_addr_o = instr_addr_w_aligned;
endmodule
module ibex_pmp import ibex_pkg::*; #(
  parameter int unsigned DmBaseAddr     = 32'h1A110000,
  parameter int unsigned DmAddrMask     = 32'h00000FFF,
  parameter int unsigned PMPGranularity = 0,
  parameter int unsigned PMPNumChan     = 2,
  parameter int unsigned PMPNumRegions  = 4
) (
  input  ibex_pkg::pmp_cfg_t     csr_pmp_cfg_i     [PMPNumRegions],
  input  logic [PMP_ADDR_MSB:0]  csr_pmp_addr_i    [PMPNumRegions],
  input  ibex_pkg::pmp_mseccfg_t csr_pmp_mseccfg_i,
  input  logic                   debug_mode_i,
  input  ibex_pkg::priv_lvl_e    priv_mode_i    [PMPNumChan],
  input  logic [PMP_ADDR_MSB:0]  pmp_req_addr_i [PMPNumChan],
  input  ibex_pkg::pmp_req_e     pmp_req_type_i [PMPNumChan],
  output logic                   pmp_req_err_o  [PMPNumChan]
);
  logic [PMP_ADDR_MSB:0]                           region_start_addr [PMPNumRegions];
  logic [PMP_ADDR_MSB:PMPGranularity+PMP_ADDR_LSB] region_addr_mask  [PMPNumRegions];
  logic [PMPNumChan-1:0][PMPNumRegions-1:0]        region_match_gt;
  logic [PMPNumChan-1:0][PMPNumRegions-1:0]        region_match_lt;
  logic [PMPNumChan-1:0][PMPNumRegions-1:0]        region_match_eq;
  logic [PMPNumChan-1:0][PMPNumRegions-1:0]        region_match_all;
  logic [PMPNumChan-1:0][PMPNumRegions-1:0]        region_basic_perm_check;
  logic [PMPNumChan-1:0][PMPNumRegions-1:0]        region_perm_check;
  logic [PMPNumChan-1:0]                           access_fault_check_res;
  logic [PMPNumChan-1:0]                           debug_mode_allowed_access;
  function automatic logic mml_perm_check(ibex_pkg::pmp_cfg_t  region_csr_pmp_cfg,
                                          ibex_pkg::pmp_req_e  pmp_req_type,
                                          ibex_pkg::priv_lvl_e priv_mode,
                                          logic                permission_check);
    logic result = 1'b0;
    logic unused_cfg = |region_csr_pmp_cfg.mode;
    if (!region_csr_pmp_cfg.read && region_csr_pmp_cfg.write) begin
      unique case ({region_csr_pmp_cfg.lock, region_csr_pmp_cfg.exec})
        2'b00: result =
            (pmp_req_type == PMP_ACC_READ) |
            ((pmp_req_type == PMP_ACC_WRITE) & (priv_mode == PRIV_LVL_M));
        2'b01: result =
            (pmp_req_type == PMP_ACC_READ) | (pmp_req_type == PMP_ACC_WRITE);
        2'b10: result = (pmp_req_type == PMP_ACC_EXEC);
        2'b11: result =
            (pmp_req_type == PMP_ACC_EXEC) |
            ((pmp_req_type == PMP_ACC_READ) & (priv_mode == PRIV_LVL_M));
        default: ;
      endcase
    end else begin
      if (region_csr_pmp_cfg.read & region_csr_pmp_cfg.write &
          region_csr_pmp_cfg.exec & region_csr_pmp_cfg.lock) begin
        result = pmp_req_type == PMP_ACC_READ;
      end else begin
        result = permission_check &
                 (priv_mode == PRIV_LVL_M ? region_csr_pmp_cfg.lock : ~region_csr_pmp_cfg.lock);
      end
    end
    return result;
  endfunction
  function automatic logic orig_perm_check(logic                pmp_cfg_lock,
                                           ibex_pkg::priv_lvl_e priv_mode,
                                           logic                permission_check);
      return (priv_mode == PRIV_LVL_M) ?
          (~pmp_cfg_lock | permission_check) :
          permission_check;
  endfunction
  function automatic logic perm_check_wrapper(logic                csr_pmp_mseccfg_mml,
                                              ibex_pkg::pmp_cfg_t  region_csr_pmp_cfg,
                                              ibex_pkg::pmp_req_e  pmp_req_type,
                                              ibex_pkg::priv_lvl_e priv_mode,
                                              logic                permission_check);
    return csr_pmp_mseccfg_mml ? mml_perm_check(region_csr_pmp_cfg,
                                                pmp_req_type,
                                                priv_mode,
                                                permission_check) :
                                 orig_perm_check(region_csr_pmp_cfg.lock,
                                                 priv_mode,
                                                 permission_check);
  endfunction
  function automatic logic access_fault_check (logic                     csr_pmp_mseccfg_mmwp,
                                               logic                     csr_pmp_mseccfg_mml,
                                               ibex_pkg::pmp_req_e       pmp_req_type,
                                               logic [PMPNumRegions-1:0] match_all,
                                               ibex_pkg::priv_lvl_e      priv_mode,
                                               logic [PMPNumRegions-1:0] final_perm_check);
    logic access_fail = csr_pmp_mseccfg_mmwp | (priv_mode != PRIV_LVL_M) |
                        (csr_pmp_mseccfg_mml && (pmp_req_type == PMP_ACC_EXEC));
    logic matched = 1'b0;
    for (int r = 0; r < PMPNumRegions; r++) begin
      if (!matched && match_all[r]) begin
        access_fail = ~final_perm_check[r];
        matched = 1'b1;
      end
    end
    return access_fail;
  endfunction
  for (genvar r = 0; r < PMPNumRegions; r++) begin : g_addr_exp
    if (r == 0) begin : g_entry0
      assign region_start_addr[r] = (csr_pmp_cfg_i[r].mode == PMP_MODE_TOR) ? 34'h000000000 :
                                                                              csr_pmp_addr_i[r];
    end else begin : g_oth
      assign region_start_addr[r] = (csr_pmp_cfg_i[r].mode == PMP_MODE_TOR) ? csr_pmp_addr_i[r-1] :
                                                                              csr_pmp_addr_i[r];
    end
    for (genvar b = PMPGranularity + PMP_ADDR_LSB; b < 34; b++) begin : g_bitmask
      if (b == PMP_ADDR_LSB) begin : g_bit0
        assign region_addr_mask[r][b] = (csr_pmp_cfg_i[r].mode != PMP_MODE_NAPOT);
      end else begin : g_others
        if (PMPGranularity == 0) begin : g_region_addr_mask_zero_granularity
          assign region_addr_mask[r][b] = (csr_pmp_cfg_i[r].mode != PMP_MODE_NAPOT) |
                                          ~&csr_pmp_addr_i[r][b-1:PMP_ADDR_LSB];
        end else begin : g_region_addr_mask_other_granularity
          assign region_addr_mask[r][b] = (csr_pmp_cfg_i[r].mode != PMP_MODE_NAPOT) |
                                          ~&csr_pmp_addr_i[r][b-1:PMPGranularity+1];
        end
      end
    end
  end
  for (genvar c = 0; c < PMPNumChan; c++) begin : g_access_check
    for (genvar r = 0; r < PMPNumRegions; r++) begin : g_regions
      assign region_match_eq[c][r] =
        (pmp_req_addr_i[c][PMP_ADDR_MSB:PMPGranularity+PMP_ADDR_LSB] & region_addr_mask[r]) ==
        (region_start_addr[r][PMP_ADDR_MSB:PMPGranularity+PMP_ADDR_LSB] & region_addr_mask[r]);
      assign region_match_gt[c][r] =
        pmp_req_addr_i[c][PMP_ADDR_MSB:PMPGranularity+PMP_ADDR_LSB] >
        region_start_addr[r][PMP_ADDR_MSB:PMPGranularity+PMP_ADDR_LSB];
      assign region_match_lt[c][r] =
        pmp_req_addr_i[c][PMP_ADDR_MSB:PMPGranularity+PMP_ADDR_LSB] <
        csr_pmp_addr_i[r][PMP_ADDR_MSB:PMPGranularity+PMP_ADDR_LSB];
      always_comb begin
        region_match_all[c][r] = 1'b0;
        unique case (csr_pmp_cfg_i[r].mode)
          PMP_MODE_OFF:   region_match_all[c][r] = 1'b0;
          PMP_MODE_NA4:   region_match_all[c][r] = region_match_eq[c][r];
          PMP_MODE_NAPOT: region_match_all[c][r] = region_match_eq[c][r];
          PMP_MODE_TOR: begin
            region_match_all[c][r] = (region_match_eq[c][r] | region_match_gt[c][r]) &
                                     region_match_lt[c][r];
          end
          default:        region_match_all[c][r] = 1'b0;
        endcase
      end
      assign region_basic_perm_check[c][r] =
          ((pmp_req_type_i[c] == PMP_ACC_EXEC)  & csr_pmp_cfg_i[r].exec) |
          ((pmp_req_type_i[c] == PMP_ACC_WRITE) & csr_pmp_cfg_i[r].write) |
          ((pmp_req_type_i[c] == PMP_ACC_READ)  & csr_pmp_cfg_i[r].read);
      assign region_perm_check[c][r] = perm_check_wrapper(csr_pmp_mseccfg_i.mml,
                                                          csr_pmp_cfg_i[r],
                                                          pmp_req_type_i[c],
                                                          priv_mode_i[c],
                                                          region_basic_perm_check[c][r]);
      logic unused_sigs;
      assign unused_sigs = ^{region_start_addr[r][PMPGranularity+PMP_ADDR_LSB-1:0],
                             pmp_req_addr_i[c][PMPGranularity+PMP_ADDR_LSB-1:0]};
    end
    assign debug_mode_allowed_access[c] = debug_mode_i &
                                          ((pmp_req_addr_i[c][31:0] & ~DmAddrMask) == DmBaseAddr);
    assign access_fault_check_res[c] = access_fault_check(csr_pmp_mseccfg_i.mmwp,
                                                          csr_pmp_mseccfg_i.mml,
                                                          pmp_req_type_i[c],
                                                          region_match_all[c],
                                                          priv_mode_i[c],
                                                          region_perm_check[c]);
    assign pmp_req_err_o[c] = ~debug_mode_allowed_access[c] & access_fault_check_res[c];
    logic fcov_pmp_region_override; 
    assign fcov_pmp_region_override = ~pmp_req_err_o[c] & |(region_match_all[c] & ~region_perm_check[c]); 
    logic unused_fcov_pmp_region_override; 
    assign unused_fcov_pmp_region_override = fcov_pmp_region_override;
  end
  logic unused_csr_pmp_mseccfg_rlb;
  assign unused_csr_pmp_mseccfg_rlb = csr_pmp_mseccfg_i.rlb;
endmodule
module ibex_wb_stage #(
  parameter bit ResetAll          = 1'b0,
  parameter bit WritebackStage    = 1'b0,
  parameter bit DummyInstructions = 1'b0
) (
  input  logic                     clk_i,
  input  logic                     rst_ni,
  input  logic                     en_wb_i,
  input  ibex_pkg::wb_instr_type_e instr_type_wb_i,
  input  logic [31:0]              pc_id_i,
  input  logic                     instr_is_compressed_id_i,
  input  logic                     instr_perf_count_id_i,
  output logic                     ready_wb_o,
  output logic                     rf_write_wb_o,
  output logic                     outstanding_load_wb_o,
  output logic                     outstanding_store_wb_o,
  output logic [31:0]              pc_wb_o,
  output logic                     perf_instr_ret_wb_o,
  output logic                     perf_instr_ret_compressed_wb_o,
  output logic                     perf_instr_ret_wb_spec_o,
  output logic                     perf_instr_ret_compressed_wb_spec_o,
  input  logic [4:0]               rf_waddr_id_i,
  input  logic [31:0]              rf_wdata_id_i,
  input  logic                     rf_we_id_i,
  input  logic                     dummy_instr_id_i,
  input  logic [31:0]              rf_wdata_lsu_i,
  input  logic                     rf_we_lsu_i,
  output logic [31:0]              rf_wdata_fwd_wb_o,
  output logic [4:0]               rf_waddr_wb_o,
  output logic [31:0]              rf_wdata_wb_o,
  output logic                     rf_we_wb_o,
  output logic                     dummy_instr_wb_o,
  input logic                      lsu_resp_valid_i,
  input logic                      lsu_resp_err_i,
  output logic                     instr_done_wb_o
);
  import ibex_pkg::*;
  logic [31:0] rf_wdata_wb_mux    [2];
  logic [1:0]  rf_wdata_wb_mux_we;
  if (WritebackStage) begin : g_writeback_stage
    logic [31:0]    rf_wdata_wb_q;
    logic           rf_we_wb_q;
    logic [4:0]     rf_waddr_wb_q;
    logic           wb_done;
    logic           wb_valid_q;
    logic [31:0]    wb_pc_q;
    logic           wb_compressed_q;
    logic           wb_count_q;
    wb_instr_type_e wb_instr_type_q;
    logic           wb_valid_d;
    assign wb_valid_d = (en_wb_i & ready_wb_o) | (wb_valid_q & ~wb_done);
    assign wb_done = (wb_instr_type_q == WB_INSTR_OTHER) | lsu_resp_valid_i;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        wb_valid_q <= 1'b0;
      end else begin
        wb_valid_q <= wb_valid_d;
      end
    end
    if (ResetAll) begin : g_wb_regs_ra
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          rf_we_wb_q      <= '0;
          rf_waddr_wb_q   <= '0;
          rf_wdata_wb_q   <= '0;
          wb_instr_type_q <= wb_instr_type_e'(0);
          wb_pc_q         <= '0;
          wb_compressed_q <= '0;
          wb_count_q      <= '0;
        end else if (en_wb_i) begin
          rf_we_wb_q      <= rf_we_id_i;
          rf_waddr_wb_q   <= rf_waddr_id_i;
          rf_wdata_wb_q   <= rf_wdata_id_i;
          wb_instr_type_q <= instr_type_wb_i;
          wb_pc_q         <= pc_id_i;
          wb_compressed_q <= instr_is_compressed_id_i;
          wb_count_q      <= instr_perf_count_id_i;
        end
      end
    end else begin : g_wb_regs_nr
      always_ff @(posedge clk_i) begin
        if (en_wb_i) begin
          rf_we_wb_q      <= rf_we_id_i;
          rf_waddr_wb_q   <= rf_waddr_id_i;
          rf_wdata_wb_q   <= rf_wdata_id_i;
          wb_instr_type_q <= instr_type_wb_i;
          wb_pc_q         <= pc_id_i;
          wb_compressed_q <= instr_is_compressed_id_i;
          wb_count_q      <= instr_perf_count_id_i;
        end
      end
    end
    assign rf_waddr_wb_o         = rf_waddr_wb_q;
    assign rf_wdata_wb_mux[0]    = rf_wdata_wb_q;
    assign rf_wdata_wb_mux_we[0] = rf_we_wb_q & wb_valid_q;
    assign ready_wb_o = ~wb_valid_q | wb_done;
    assign rf_write_wb_o = wb_valid_q & (rf_we_wb_q | (wb_instr_type_q == WB_INSTR_LOAD));
    assign outstanding_load_wb_o  = wb_valid_q & (wb_instr_type_q == WB_INSTR_LOAD);
    assign outstanding_store_wb_o = wb_valid_q & (wb_instr_type_q == WB_INSTR_STORE);
    assign pc_wb_o = wb_pc_q;
    assign instr_done_wb_o = wb_valid_q & wb_done;
    assign perf_instr_ret_wb_spec_o            = wb_count_q & wb_valid_q;
    assign perf_instr_ret_compressed_wb_spec_o = perf_instr_ret_wb_spec_o & wb_compressed_q;
    assign perf_instr_ret_wb_o                 = instr_done_wb_o & wb_count_q &
                                                 ~(lsu_resp_valid_i & lsu_resp_err_i);
    assign perf_instr_ret_compressed_wb_o      = perf_instr_ret_wb_o & wb_compressed_q;
    assign rf_wdata_fwd_wb_o = rf_wdata_wb_q;
    assign rf_wdata_wb_mux_we[1] = rf_we_lsu_i;
    if (DummyInstructions) begin : g_dummy_instr_wb
      logic dummy_instr_wb_q;
      if (ResetAll) begin : g_dummy_instr_wb_regs_ra
        always_ff @(posedge clk_i or negedge rst_ni) begin
          if (!rst_ni) begin
            dummy_instr_wb_q <= 1'b0;
          end else if (en_wb_i) begin
            dummy_instr_wb_q <= dummy_instr_id_i;
          end
        end
      end else begin : g_dummy_instr_wb_regs_nr
        always_ff @(posedge clk_i) begin
          if (en_wb_i) begin
            dummy_instr_wb_q <= dummy_instr_id_i;
          end
        end
      end
      assign dummy_instr_wb_o = dummy_instr_wb_q;
    end else begin : g_no_dummy_instr_wb
      logic  unused_dummy_instr_id;
      assign unused_dummy_instr_id = dummy_instr_id_i;
      assign dummy_instr_wb_o = 1'b0;
    end
  end else begin : g_bypass_wb
    assign rf_waddr_wb_o         = rf_waddr_id_i;
    assign rf_wdata_wb_mux[0]    = rf_wdata_id_i;
    assign rf_wdata_wb_mux_we[0] = rf_we_id_i;
    assign rf_wdata_wb_mux_we[1] = rf_we_lsu_i;
    assign dummy_instr_wb_o = dummy_instr_id_i;
    assign perf_instr_ret_wb_spec_o            = 1'b0;
    assign perf_instr_ret_compressed_wb_spec_o = 1'b0;
    assign perf_instr_ret_wb_o                 = instr_perf_count_id_i & en_wb_i &
                                                 ~(lsu_resp_valid_i & lsu_resp_err_i);
    assign perf_instr_ret_compressed_wb_o      = perf_instr_ret_wb_o & instr_is_compressed_id_i;
    assign ready_wb_o    = 1'b1;
    logic           unused_clk;
    logic           unused_rst;
    wb_instr_type_e unused_instr_type_wb;
    logic [31:0]    unused_pc_id;
    logic           unused_dummy_instr_id;
    assign unused_clk            = clk_i;
    assign unused_rst            = rst_ni;
    assign unused_instr_type_wb  = instr_type_wb_i;
    assign unused_pc_id          = pc_id_i;
    assign unused_dummy_instr_id = dummy_instr_id_i;
    assign outstanding_load_wb_o  = 1'b0;
    assign outstanding_store_wb_o = 1'b0;
    assign pc_wb_o                = '0;
    assign rf_write_wb_o          = 1'b0;
    assign rf_wdata_fwd_wb_o      = 32'b0;
    assign instr_done_wb_o        = 1'b0;
  end
  assign rf_wdata_wb_mux[1] = rf_wdata_lsu_i;
  assign rf_wdata_wb_o = ({32{rf_wdata_wb_mux_we[0]}} & rf_wdata_wb_mux[0]) |
                         ({32{rf_wdata_wb_mux_we[1]}} & rf_wdata_wb_mux[1]);
  assign rf_we_wb_o    = |rf_wdata_wb_mux_we;
    logic fcov_wb_valid; 
    if (WritebackStage) begin : g_fcov_wb_valid 
      assign fcov_wb_valid = g_writeback_stage.wb_valid_q; 
    end else begin : g_no_fcov_wb_valid 
      assign fcov_wb_valid =  '0; 
    end 
    logic unused_fcov_wb_valid; 
    assign unused_fcov_wb_valid = fcov_wb_valid;
endmodule
module ibex_dummy_instr import ibex_pkg::*; #(
    parameter lfsr_seed_t RndCnstLfsrSeed = RndCnstLfsrSeedDefault,
    parameter lfsr_perm_t RndCnstLfsrPerm = RndCnstLfsrPermDefault
) (
  input  logic        clk_i,
  input  logic        rst_ni,
  input  logic        dummy_instr_en_i,
  input  logic [2:0]  dummy_instr_mask_i,
  input  logic        dummy_instr_seed_en_i,
  input  logic [31:0] dummy_instr_seed_i,
  input  logic        fetch_valid_i,
  input  logic        id_in_ready_i,
  output logic        insert_dummy_instr_o,
  output logic [31:0] dummy_instr_data_o
);
  localparam int unsigned TIMEOUT_CNT_W = 5;
  localparam int unsigned OP_W          = 5;
  typedef enum logic [1:0] {
    DUMMY_ADD = 2'b00,
    DUMMY_MUL = 2'b01,
    DUMMY_DIV = 2'b10,
    DUMMY_AND = 2'b11
  } dummy_instr_e;
  typedef struct packed {
    dummy_instr_e             instr_type;
    logic [OP_W-1:0]          op_b;
    logic [OP_W-1:0]          op_a;
    logic [TIMEOUT_CNT_W-1:0] cnt;
  } lfsr_data_t;
  localparam int unsigned LFSR_OUT_W = $bits(lfsr_data_t);
  lfsr_data_t               lfsr_data;
  logic [TIMEOUT_CNT_W-1:0] dummy_cnt_incr, dummy_cnt_threshold;
  logic [TIMEOUT_CNT_W-1:0] dummy_cnt_d, dummy_cnt_q;
  logic                     dummy_cnt_en;
  logic                     lfsr_en;
  logic [LFSR_OUT_W-1:0]    lfsr_state;
  logic                     insert_dummy_instr;
  logic [6:0]               dummy_set;
  logic [2:0]               dummy_opcode;
  logic [31:0]              dummy_instr;
  logic [31:0]              dummy_instr_seed_q, dummy_instr_seed_d;
  assign lfsr_en = insert_dummy_instr & id_in_ready_i;
  assign dummy_instr_seed_d = dummy_instr_seed_q ^ dummy_instr_seed_i;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      dummy_instr_seed_q <= '0;
    end else if (dummy_instr_seed_en_i) begin
      dummy_instr_seed_q <= dummy_instr_seed_d;
    end
  end
  prim_lfsr #(
      .LfsrDw      ( LfsrWidth       ),
      .StateOutDw  ( LFSR_OUT_W      ),
      .DefaultSeed ( RndCnstLfsrSeed ),
      .StatePermEn ( 1'b1            ),
      .StatePerm   ( RndCnstLfsrPerm )
  ) lfsr_i (
      .clk_i     ( clk_i                 ),
      .rst_ni    ( rst_ni                ),
      .seed_en_i ( dummy_instr_seed_en_i ),
      .seed_i    ( dummy_instr_seed_d    ),
      .lfsr_en_i ( lfsr_en               ),
      .entropy_i ( '0                    ),
      .state_o   ( lfsr_state            )
  );
  assign lfsr_data = lfsr_data_t'(lfsr_state);
  assign dummy_cnt_threshold = lfsr_data.cnt & {dummy_instr_mask_i,{TIMEOUT_CNT_W-3{1'b1}}};
  assign dummy_cnt_incr      = dummy_cnt_q + {{TIMEOUT_CNT_W-1{1'b0}},1'b1};
  assign dummy_cnt_d         = insert_dummy_instr ? '0 : dummy_cnt_incr;
  assign dummy_cnt_en        = dummy_instr_en_i & id_in_ready_i &
                               (fetch_valid_i | insert_dummy_instr);
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      dummy_cnt_q <= '0;
    end else if (dummy_cnt_en) begin
      dummy_cnt_q <= dummy_cnt_d;
    end
  end
  assign insert_dummy_instr = dummy_instr_en_i & (dummy_cnt_q == dummy_cnt_threshold);
  always_comb begin
    unique case (lfsr_data.instr_type)
      DUMMY_ADD: begin
        dummy_set    = 7'b0000000;
        dummy_opcode = 3'b000;
      end
      DUMMY_MUL: begin
        dummy_set    = 7'b0000001;
        dummy_opcode = 3'b000;
      end
      DUMMY_DIV: begin
        dummy_set    = 7'b0000001;
        dummy_opcode = 3'b100;
      end
      DUMMY_AND: begin
        dummy_set    = 7'b0000000;
        dummy_opcode = 3'b111;
      end
      default: begin
        dummy_set    = 7'b0000000;
        dummy_opcode = 3'b000;
      end
    endcase
  end
  assign dummy_instr = {dummy_set, lfsr_data.op_b, lfsr_data.op_a, dummy_opcode, 5'h00, 7'h33};
  assign insert_dummy_instr_o = insert_dummy_instr;
  assign dummy_instr_data_o   = dummy_instr;
endmodule
module ibex_core import ibex_pkg::*; #(
  parameter bit                     PMPEnable                   = 1'b0,
  parameter int unsigned            PMPGranularity              = 0,
  parameter int unsigned            PMPNumRegions               = 4,
  parameter ibex_pkg::pmp_cfg_t     PMPRstCfg[PMP_MAX_REGIONS]  = ibex_pkg::PmpCfgRst,
  parameter logic [PMP_ADDR_MSB:0]  PMPRstAddr[PMP_MAX_REGIONS] = ibex_pkg::PmpAddrRst,
  parameter ibex_pkg::pmp_mseccfg_t PMPRstMsecCfg               = ibex_pkg::PmpMseccfgRst,
  parameter int unsigned            MHPMCounterNum              = 0,
  parameter int unsigned            MHPMCounterWidth            = 40,
  parameter bit                     RV32E                       = 1'b0,
  parameter rv32m_e                 RV32M                       = RV32MFast,
  parameter rv32b_e                 RV32B                       = RV32BNone,
  parameter rv32zc_e                RV32ZC                      = RV32ZcaZcbZcmp,
  parameter bit                     BranchTargetALU             = 1'b0,
  parameter bit                     WritebackStage              = 1'b0,
  parameter bit                     ICache                      = 1'b0,
  parameter bit                     ICacheECC                   = 1'b0,
  parameter bit                     ICacheTweakInfection        = 1'b0,
  parameter int unsigned            BusSizeECC                  = BUS_SIZE,
  parameter int unsigned            TagSizeECC                  = IC_TAG_SIZE,
  parameter int unsigned            LineSizeECC                 = IC_LINE_SIZE,
  parameter bit                     BranchPredictor             = 1'b0,
  parameter bit                     DbgTriggerEn                = 1'b0,
  parameter int unsigned            DbgHwBreakNum               = 1,
  parameter bit                     ResetAll                    = 1'b0,
  parameter lfsr_seed_t             RndCnstLfsrSeed             = RndCnstLfsrSeedDefault,
  parameter lfsr_perm_t             RndCnstLfsrPerm             = RndCnstLfsrPermDefault,
  parameter bit                     SecureIbex                  = 1'b0,
  parameter bit                     DummyInstructions           = 1'b0,
  parameter bit                     RegFileECC                  = 1'b0,
  parameter int unsigned            RegFileDataWidth            = 32,
  parameter bit                     MemECC                      = 1'b0,
  parameter int unsigned            MemDataWidth                = MemECC ? 32 + 7 : 32,
  parameter int unsigned            DmBaseAddr                  = 32'h1A110000,
  parameter int unsigned            DmAddrMask                  = 32'h00000FFF,
  parameter int unsigned            DmHaltAddr                  = 32'h1A110800,
  parameter int unsigned            DmExceptionAddr             = 32'h1A110808,
  parameter logic [31:0]            CsrMvendorId                = 32'b0,
  parameter logic [31:0]            CsrMimpId                   = 32'b0
) (
  input  logic                         clk_i,
  input  logic                         rst_ni,
  input  logic [31:0]                  hart_id_i,
  input  logic [31:0]                  boot_addr_i,
  output logic                         instr_req_o,
  input  logic                         instr_gnt_i,
  input  logic                         instr_rvalid_i,
  output logic [31:0]                  instr_addr_o,
  input  logic [MemDataWidth-1:0]      instr_rdata_i,
  input  logic                         instr_err_i,
  output logic                         data_req_o,
  input  logic                         data_gnt_i,
  input  logic                         data_rvalid_i,
  output logic                         data_we_o,
  output logic [3:0]                   data_be_o,
  output logic [31:0]                  data_addr_o,
  output logic [MemDataWidth-1:0]      data_wdata_o,
  input  logic [MemDataWidth-1:0]      data_rdata_i,
  input  logic                         data_err_i,
  output logic                         dummy_instr_id_o,
  output logic                         dummy_instr_wb_o,
  output logic [4:0]                   rf_raddr_a_o,
  output logic [4:0]                   rf_raddr_b_o,
  output logic [4:0]                   rf_waddr_wb_o,
  output logic                         rf_we_wb_o,
  output logic [RegFileDataWidth-1:0]  rf_wdata_wb_ecc_o,
  input  logic [RegFileDataWidth-1:0]  rf_rdata_a_ecc_i,
  input  logic [RegFileDataWidth-1:0]  rf_rdata_b_ecc_i,
  output logic [IC_NUM_WAYS-1:0]       ic_tag_req_o,
  output logic                         ic_tag_write_o,
  output logic [IC_INDEX_W-1:0]        ic_tag_addr_o,
  output logic [TagSizeECC-1:0]        ic_tag_wdata_o,
  input  logic [TagSizeECC-1:0]        ic_tag_rdata_i [IC_NUM_WAYS],
  output logic [IC_NUM_WAYS-1:0]       ic_data_req_o,
  output logic                         ic_data_write_o,
  output logic [IC_INDEX_W-1:0]        ic_data_addr_o,
  output logic [LineSizeECC-1:0]       ic_data_wdata_o,
  input  logic [LineSizeECC-1:0]       ic_data_rdata_i [IC_NUM_WAYS],
  input  logic                         ic_scr_key_valid_i,
  output logic                         ic_scr_key_req_o,
  input  logic                         irq_software_i,
  input  logic                         irq_timer_i,
  input  logic                         irq_external_i,
  input  logic [14:0]                  irq_fast_i,
  input  logic                         irq_nm_i,        
  output logic                         irq_pending_o,
  input  logic                         debug_req_i,
  output crash_dump_t                  crash_dump_o,
  output logic                         double_fault_seen_o,
  output logic                         rvfi_valid,
  output logic [63:0]                  rvfi_order,
  output logic [31:0]                  rvfi_insn,
  output logic                         rvfi_trap,
  output logic                         rvfi_halt,
  output logic                         rvfi_intr,
  output logic [ 1:0]                  rvfi_mode,
  output logic [ 1:0]                  rvfi_ixl,
  output logic [ 4:0]                  rvfi_rs1_addr,
  output logic [ 4:0]                  rvfi_rs2_addr,
  output logic [ 4:0]                  rvfi_rs3_addr,
  output logic [31:0]                  rvfi_rs1_rdata,
  output logic [31:0]                  rvfi_rs2_rdata,
  output logic [31:0]                  rvfi_rs3_rdata,
  output logic [ 4:0]                  rvfi_rd_addr,
  output logic [31:0]                  rvfi_rd_wdata,
  output logic [31:0]                  rvfi_pc_rdata,
  output logic [31:0]                  rvfi_pc_wdata,
  output logic [31:0]                  rvfi_mem_addr,
  output logic [ 3:0]                  rvfi_mem_rmask,
  output logic [ 3:0]                  rvfi_mem_wmask,
  output logic [31:0]                  rvfi_mem_rdata,
  output logic [31:0]                  rvfi_mem_wdata,
  output logic [31:0]                  rvfi_ext_pre_mip,
  output logic [31:0]                  rvfi_ext_post_mip,
  output logic                         rvfi_ext_nmi,
  output logic                         rvfi_ext_nmi_int,
  output logic                         rvfi_ext_debug_req,
  output logic                         rvfi_ext_debug_mode,
  output logic                         rvfi_ext_rf_wr_suppress,
  output logic [63:0]                  rvfi_ext_mcycle,
  output logic [31:0]                  rvfi_ext_mhpmcounters [10],
  output logic [31:0]                  rvfi_ext_mhpmcountersh [10],
  output logic                         rvfi_ext_ic_scr_key_valid,
  output logic                         rvfi_ext_irq_valid,
  output logic                         rvfi_ext_expanded_insn_valid,
  output logic [15:0]                  rvfi_ext_expanded_insn,
  output logic                         rvfi_ext_expanded_insn_last,
  input  ibex_mubi_t                   fetch_enable_i,
  input  ibex_mubi_t                   mcounteren_writable_i,
  output logic                         alert_minor_o,
  output logic                         alert_major_internal_o,
  output logic                         alert_major_bus_o,
  output ibex_mubi_t                   core_busy_o
);
  localparam int unsigned PMPNumChan      = 3;
  localparam bit          DataIndTiming     = SecureIbex;
  localparam bit          PCIncrCheck       = SecureIbex;
  localparam bit          ShadowCSR         = 1'b0;
  logic        dummy_instr_id;
  logic        instr_valid_id;
  logic        instr_new_id;
  logic [31:0] instr_rdata_id;                  
  logic [31:0] instr_rdata_alu_id;              
  logic [15:0] instr_rdata_c_id;                
  logic        instr_is_compressed_id;
  instr_exp_e  instr_gets_expanded_id;
  logic [15:0] instr_expanded_id;
  logic        instr_perf_count_id;
  logic        instr_bp_taken_id;
  logic        instr_fetch_err;                 
  logic        instr_fetch_err_plus2;           
  logic        illegal_c_insn_id;               
  logic [31:0] pc_if;                           
  logic [31:0] pc_id;                           
  logic [31:0] pc_wb;                           
  logic [33:0] imd_val_d_ex[2];                 
  logic [33:0] imd_val_q_ex[2];                 
  logic [1:0]  imd_val_we_ex;
  logic        data_ind_timing;
  logic        dummy_instr_en;
  logic [2:0]  dummy_instr_mask;
  logic        dummy_instr_seed_en;
  logic [31:0] dummy_instr_seed;
  logic        icache_enable;
  logic        icache_inval;
  logic        icache_ecc_error;
  logic        pc_mismatch_alert;
  logic        csr_shadow_err;
  logic        instr_first_cycle_id;
  logic        instr_valid_clear;
  logic        pc_set;
  logic        nt_branch_mispredict;
  logic [31:0] nt_branch_addr;
  pc_sel_e     pc_mux_id;                       
  exc_pc_sel_e exc_pc_mux_id;                   
  exc_cause_t  exc_cause;                       
  logic        instr_intg_err;
  logic        lsu_load_err, lsu_load_err_raw;
  logic        lsu_store_err, lsu_store_err_raw;
  logic        lsu_load_resp_intg_err;
  logic        lsu_store_resp_intg_err;
  logic        expecting_load_resp_id;
  logic        expecting_store_resp_id;
  logic        lsu_addr_incr_req;
  logic [31:0] lsu_addr_last;
  logic [31:0] branch_target_ex;
  logic        branch_decision;
  logic        ctrl_busy;
  logic        if_busy;
  logic        lsu_busy;
  logic [4:0]  rf_raddr_a;
  logic [31:0] rf_rdata_a;
  logic [4:0]  rf_raddr_b;
  logic [31:0] rf_rdata_b;
  logic        rf_ren_a;
  logic        rf_ren_b;
  logic [4:0]  rf_waddr_wb;
  logic [31:0] rf_wdata_wb;
  logic [31:0] rf_wdata_fwd_wb;
  logic [31:0] rf_wdata_lsu;
  logic        rf_we_wb;
  logic        rf_we_lsu;
  logic        rf_ecc_err_comb;
  logic [4:0]  rf_waddr_id;
  logic [31:0] rf_wdata_id;
  logic        rf_we_id;
  logic        rf_rd_a_wb_match;
  logic        rf_rd_b_wb_match;
  alu_op_e     alu_operator_ex;
  logic [31:0] alu_operand_a_ex;
  logic [31:0] alu_operand_b_ex;
  logic [31:0] bt_a_operand;
  logic [31:0] bt_b_operand;
  logic [31:0] alu_adder_result_ex;     
  logic [31:0] result_ex;
  logic        mult_en_ex;
  logic        div_en_ex;
  logic        mult_sel_ex;
  logic        div_sel_ex;
  md_op_e      multdiv_operator_ex;
  logic [1:0]  multdiv_signed_mode_ex;
  logic [31:0] multdiv_operand_a_ex;
  logic [31:0] multdiv_operand_b_ex;
  logic        multdiv_ready_id;
  logic        csr_access;
  csr_op_e     csr_op;
  logic        csr_op_en;
  csr_num_e    csr_addr;
  logic [31:0] csr_rdata;
  logic [31:0] csr_wdata;
  logic        illegal_csr_insn_id;     
  logic        lsu_we;
  logic [1:0]  lsu_type;
  logic        lsu_sign_ext;
  logic        lsu_req;
  logic        lsu_rdata_valid;
  logic [31:0] lsu_wdata;
  logic        lsu_req_done;
  logic        id_in_ready;
  logic        ex_valid;
  logic        lsu_resp_valid;
  logic        lsu_resp_err;
  logic        instr_req_int;           
  logic        instr_req_gated;
  logic        instr_exec;
  logic           en_wb;
  wb_instr_type_e instr_type_wb;
  logic           ready_wb;
  logic           rf_write_wb;
  logic           outstanding_load_wb;
  logic           outstanding_store_wb;
  logic           dummy_instr_wb;
  logic        nmi_mode;
  irqs_t       irqs;
  logic        csr_mstatus_mie;
  logic [31:0] csr_mepc, csr_depc;
  logic [PMP_ADDR_MSB:0]  csr_pmp_addr [PMPNumRegions];
  pmp_cfg_t               csr_pmp_cfg  [PMPNumRegions];
  pmp_mseccfg_t           csr_pmp_mseccfg;
  logic                   pmp_req_err  [PMPNumChan];
  logic                   data_req_out;
  logic        csr_save_if;
  logic        csr_save_id;
  logic        csr_save_wb;
  logic        csr_restore_mret_id;
  logic        csr_restore_dret_id;
  logic        csr_save_cause;
  logic        csr_mtvec_init;
  logic [31:0] csr_mtvec;
  logic [31:0] csr_mtval;
  logic        csr_mstatus_tw;
  priv_lvl_e   priv_mode_id;
  priv_lvl_e   priv_mode_lsu;
  logic        debug_mode;
  logic        debug_mode_entering;
  dbg_cause_e  debug_cause;
  logic        debug_csr_save;
  logic        debug_single_step;
  logic        debug_ebreakm;
  logic        debug_ebreaku;
  logic        trigger_match;
  logic        instr_id_done;
  logic        instr_done_wb;
  logic        perf_instr_ret_wb;
  logic        perf_instr_ret_compressed_wb;
  logic        perf_instr_ret_wb_spec;
  logic        perf_instr_ret_compressed_wb_spec;
  logic        perf_iside_wait;
  logic        perf_dside_wait;
  logic        perf_mul_wait;
  logic        perf_div_wait;
  logic        perf_jump;
  logic        perf_branch;
  logic        perf_tbranch;
  logic        perf_load;
  logic        perf_store;
  logic        illegal_insn_id, unused_illegal_insn_id;  
  if (SecureIbex) begin : g_core_busy_secure
    localparam int unsigned NumBusySignals = 3;
    localparam int unsigned NumBusyBits = $bits(ibex_mubi_t) * NumBusySignals;
    logic [NumBusyBits-1:0] busy_bits_buf;
    prim_buf #(
      .Width(NumBusyBits)
    ) u_fetch_enable_buf (
      .in_i ({$bits(ibex_mubi_t){ctrl_busy, if_busy, lsu_busy}}),
      .out_o(busy_bits_buf)
    );
    for (genvar i = 0; i < $bits(ibex_mubi_t); i++) begin : g_core_busy_bits
      if (IbexMuBiOn[i] == 1'b1) begin : g_pos
        assign core_busy_o[i] =  |busy_bits_buf[i*NumBusySignals +: NumBusySignals];
      end else begin : g_neg
        assign core_busy_o[i] = ~|busy_bits_buf[i*NumBusySignals +: NumBusySignals];
      end
    end
  end else begin : g_core_busy_non_secure
    assign core_busy_o = (ctrl_busy || if_busy || lsu_busy) ? IbexMuBiOn : IbexMuBiOff;
  end
  ibex_if_stage #(
    .DmHaltAddr           (DmHaltAddr),
    .DmExceptionAddr      (DmExceptionAddr),
    .DummyInstructions    (DummyInstructions),
    .ICache               (ICache),
    .RV32ZC               (RV32ZC),
    .ICacheECC            (ICacheECC),
    .ICacheTweakInfection (ICacheTweakInfection),
    .BusSizeECC           (BusSizeECC),
    .TagSizeECC           (TagSizeECC),
    .LineSizeECC          (LineSizeECC),
    .PCIncrCheck          (PCIncrCheck),
    .ResetAll             (ResetAll),
    .RndCnstLfsrSeed      (RndCnstLfsrSeed),
    .RndCnstLfsrPerm      (RndCnstLfsrPerm),
    .BranchPredictor      (BranchPredictor),
    .MemECC               (MemECC),
    .MemDataWidth         (MemDataWidth)
  ) if_stage_i (
    .clk_i (clk_i),
    .rst_ni(rst_ni),
    .boot_addr_i(boot_addr_i),
    .req_i      (instr_req_gated),   
    .instr_req_o       (instr_req_o),
    .instr_addr_o      (instr_addr_o),
    .instr_gnt_i       (instr_gnt_i),
    .instr_rvalid_i    (instr_rvalid_i),
    .instr_rdata_i     (instr_rdata_i),
    .instr_bus_err_i   (instr_err_i),
    .instr_intg_err_o  (instr_intg_err),
    .ic_tag_req_o      (ic_tag_req_o),
    .ic_tag_write_o    (ic_tag_write_o),
    .ic_tag_addr_o     (ic_tag_addr_o),
    .ic_tag_wdata_o    (ic_tag_wdata_o),
    .ic_tag_rdata_i    (ic_tag_rdata_i),
    .ic_data_req_o     (ic_data_req_o),
    .ic_data_write_o   (ic_data_write_o),
    .ic_data_addr_o    (ic_data_addr_o),
    .ic_data_wdata_o   (ic_data_wdata_o),
    .ic_data_rdata_i   (ic_data_rdata_i),
    .ic_scr_key_valid_i(ic_scr_key_valid_i),
    .ic_scr_key_req_o  (ic_scr_key_req_o),
    .instr_valid_id_o        (instr_valid_id),
    .instr_new_id_o          (instr_new_id),
    .instr_rdata_id_o        (instr_rdata_id),
    .instr_rdata_alu_id_o    (instr_rdata_alu_id),
    .instr_rdata_c_id_o      (instr_rdata_c_id),
    .instr_is_compressed_id_o(instr_is_compressed_id),
    .instr_gets_expanded_id_o(instr_gets_expanded_id),
    .instr_expanded_id_o     (instr_expanded_id),
    .instr_bp_taken_o        (instr_bp_taken_id),
    .instr_fetch_err_o       (instr_fetch_err),
    .instr_fetch_err_plus2_o (instr_fetch_err_plus2),
    .illegal_c_insn_id_o     (illegal_c_insn_id),
    .dummy_instr_id_o        (dummy_instr_id),
    .pc_if_o                 (pc_if),
    .pc_id_o                 (pc_id),
    .pmp_err_if_i            (pmp_req_err[PMP_I]),
    .pmp_err_if_plus2_i      (pmp_req_err[PMP_I2]),
    .instr_valid_clear_i   (instr_valid_clear),
    .pc_set_i              (pc_set),
    .pc_mux_i              (pc_mux_id),
    .nt_branch_mispredict_i(nt_branch_mispredict),
    .exc_pc_mux_i          (exc_pc_mux_id),
    .exc_cause             (exc_cause),
    .dummy_instr_en_i      (dummy_instr_en),
    .dummy_instr_mask_i    (dummy_instr_mask),
    .dummy_instr_seed_en_i (dummy_instr_seed_en),
    .dummy_instr_seed_i    (dummy_instr_seed),
    .icache_enable_i       (icache_enable),
    .icache_inval_i        (icache_inval),
    .icache_ecc_error_o    (icache_ecc_error),
    .branch_target_ex_i(branch_target_ex),
    .nt_branch_addr_i  (nt_branch_addr),
    .csr_mepc_i      (csr_mepc),   
    .csr_depc_i      (csr_depc),   
    .csr_mtvec_i     (csr_mtvec),   
    .csr_mtvec_init_o(csr_mtvec_init),
    .id_in_ready_i(id_in_ready),
    .pc_mismatch_alert_o(pc_mismatch_alert),
    .if_busy_o          (if_busy)
  );
  assign perf_iside_wait = id_in_ready & ~instr_valid_id;
  if (SecureIbex) begin : g_instr_req_gated_secure
    assign instr_req_gated = instr_req_int & (fetch_enable_i == IbexMuBiOn);
    assign instr_exec      = fetch_enable_i == IbexMuBiOn;
  end else begin : g_instr_req_gated_non_secure
    logic unused_fetch_enable;
    assign unused_fetch_enable = ^fetch_enable_i[$bits(ibex_mubi_t)-1:1];
    assign instr_req_gated = instr_req_int & fetch_enable_i[0];
    assign instr_exec      = fetch_enable_i[0];
  end
  ibex_id_stage #(
    .RV32E          (RV32E),
    .RV32M          (RV32M),
    .RV32B          (RV32B),
    .BranchTargetALU(BranchTargetALU),
    .DataIndTiming  (DataIndTiming),
    .WritebackStage (WritebackStage),
    .BranchPredictor(BranchPredictor),
    .MemECC         (MemECC)
  ) id_stage_i (
    .clk_i (clk_i),
    .rst_ni(rst_ni),
    .ctrl_busy_o   (ctrl_busy),
    .illegal_insn_o(illegal_insn_id),
    .instr_valid_i        (instr_valid_id),
    .instr_rdata_i        (instr_rdata_id),
    .instr_rdata_alu_i    (instr_rdata_alu_id),
    .instr_rdata_c_i      (instr_rdata_c_id),
    .instr_is_compressed_i(instr_is_compressed_id),
    .instr_gets_expanded_i(instr_gets_expanded_id),
    .instr_bp_taken_i     (instr_bp_taken_id),
    .branch_decision_i(branch_decision),
    .instr_first_cycle_id_o(instr_first_cycle_id),
    .instr_valid_clear_o   (instr_valid_clear),
    .id_in_ready_o         (id_in_ready),
    .instr_exec_i          (instr_exec),
    .instr_req_o           (instr_req_int),
    .pc_set_o              (pc_set),
    .pc_mux_o              (pc_mux_id),
    .nt_branch_mispredict_o(nt_branch_mispredict),
    .nt_branch_addr_o      (nt_branch_addr),
    .exc_pc_mux_o          (exc_pc_mux_id),
    .exc_cause_o           (exc_cause),
    .icache_inval_o        (icache_inval),
    .instr_fetch_err_i      (instr_fetch_err),
    .instr_fetch_err_plus2_i(instr_fetch_err_plus2),
    .illegal_c_insn_i       (illegal_c_insn_id),
    .pc_id_i(pc_id),
    .ex_valid_i      (ex_valid),
    .lsu_resp_valid_i(lsu_resp_valid),
    .alu_operator_ex_o (alu_operator_ex),
    .alu_operand_a_ex_o(alu_operand_a_ex),
    .alu_operand_b_ex_o(alu_operand_b_ex),
    .imd_val_q_ex_o (imd_val_q_ex),
    .imd_val_d_ex_i (imd_val_d_ex),
    .imd_val_we_ex_i(imd_val_we_ex),
    .bt_a_operand_o(bt_a_operand),
    .bt_b_operand_o(bt_b_operand),
    .mult_en_ex_o            (mult_en_ex),
    .div_en_ex_o             (div_en_ex),
    .mult_sel_ex_o           (mult_sel_ex),
    .div_sel_ex_o            (div_sel_ex),
    .multdiv_operator_ex_o   (multdiv_operator_ex),
    .multdiv_signed_mode_ex_o(multdiv_signed_mode_ex),
    .multdiv_operand_a_ex_o  (multdiv_operand_a_ex),
    .multdiv_operand_b_ex_o  (multdiv_operand_b_ex),
    .multdiv_ready_id_o      (multdiv_ready_id),
    .csr_access_o         (csr_access),
    .csr_op_o             (csr_op),
    .csr_addr_o           (csr_addr),
    .csr_op_en_o          (csr_op_en),
    .csr_save_if_o        (csr_save_if),   
    .csr_save_id_o        (csr_save_id),   
    .csr_save_wb_o        (csr_save_wb),   
    .csr_restore_mret_id_o(csr_restore_mret_id),   
    .csr_restore_dret_id_o(csr_restore_dret_id),   
    .csr_save_cause_o     (csr_save_cause),
    .csr_mtval_o          (csr_mtval),
    .priv_mode_i          (priv_mode_id),
    .csr_mstatus_tw_i     (csr_mstatus_tw),
    .illegal_csr_insn_i   (illegal_csr_insn_id),
    .data_ind_timing_i    (data_ind_timing),
    .lsu_req_o     (lsu_req),   
    .lsu_we_o      (lsu_we),   
    .lsu_type_o    (lsu_type),   
    .lsu_sign_ext_o(lsu_sign_ext),   
    .lsu_wdata_o   (lsu_wdata),   
    .lsu_req_done_i(lsu_req_done),   
    .lsu_addr_incr_req_i(lsu_addr_incr_req),
    .lsu_addr_last_i    (lsu_addr_last),
    .lsu_load_err_i           (lsu_load_err),
    .lsu_load_resp_intg_err_i (lsu_load_resp_intg_err),
    .lsu_store_err_i          (lsu_store_err),
    .lsu_store_resp_intg_err_i(lsu_store_resp_intg_err),
    .expecting_load_resp_o (expecting_load_resp_id),
    .expecting_store_resp_o(expecting_store_resp_id),
    .csr_mstatus_mie_i(csr_mstatus_mie),
    .irq_pending_i    (irq_pending_o),
    .irqs_i           (irqs),
    .irq_nm_i         (irq_nm_i),
    .nmi_mode_o       (nmi_mode),
    .debug_mode_o         (debug_mode),
    .debug_mode_entering_o(debug_mode_entering),
    .debug_cause_o        (debug_cause),
    .debug_csr_save_o     (debug_csr_save),
    .debug_req_i          (debug_req_i),
    .debug_single_step_i  (debug_single_step),
    .debug_ebreakm_i      (debug_ebreakm),
    .debug_ebreaku_i      (debug_ebreaku),
    .trigger_match_i      (trigger_match),
    .result_ex_i(result_ex),
    .csr_rdata_i(csr_rdata),
    .rf_raddr_a_o      (rf_raddr_a),
    .rf_rdata_a_i      (rf_rdata_a),
    .rf_raddr_b_o      (rf_raddr_b),
    .rf_rdata_b_i      (rf_rdata_b),
    .rf_ren_a_o        (rf_ren_a),
    .rf_ren_b_o        (rf_ren_b),
    .rf_waddr_id_o     (rf_waddr_id),
    .rf_wdata_id_o     (rf_wdata_id),
    .rf_we_id_o        (rf_we_id),
    .rf_rd_a_wb_match_o(rf_rd_a_wb_match),
    .rf_rd_b_wb_match_o(rf_rd_b_wb_match),
    .rf_waddr_wb_i    (rf_waddr_wb),
    .rf_wdata_fwd_wb_i(rf_wdata_fwd_wb),
    .rf_write_wb_i    (rf_write_wb),
    .en_wb_o               (en_wb),
    .instr_type_wb_o       (instr_type_wb),
    .instr_perf_count_id_o (instr_perf_count_id),
    .ready_wb_i            (ready_wb),
    .outstanding_load_wb_i (outstanding_load_wb),
    .outstanding_store_wb_i(outstanding_store_wb),
    .perf_jump_o      (perf_jump),
    .perf_branch_o    (perf_branch),
    .perf_tbranch_o   (perf_tbranch),
    .perf_dside_wait_o(perf_dside_wait),
    .perf_mul_wait_o  (perf_mul_wait),
    .perf_div_wait_o  (perf_div_wait),
    .instr_id_done_o  (instr_id_done)
  );
  assign unused_illegal_insn_id = illegal_insn_id;
  ibex_ex_block #(
    .RV32M          (RV32M),
    .RV32B          (RV32B),
    .BranchTargetALU(BranchTargetALU)
  ) ex_block_i (
    .clk_i (clk_i),
    .rst_ni(rst_ni),
    .alu_operator_i         (alu_operator_ex),
    .alu_operand_a_i        (alu_operand_a_ex),
    .alu_operand_b_i        (alu_operand_b_ex),
    .alu_instr_first_cycle_i(instr_first_cycle_id),
    .bt_a_operand_i(bt_a_operand),
    .bt_b_operand_i(bt_b_operand),
    .multdiv_operator_i   (multdiv_operator_ex),
    .mult_en_i            (mult_en_ex),
    .div_en_i             (div_en_ex),
    .mult_sel_i           (mult_sel_ex),
    .div_sel_i            (div_sel_ex),
    .multdiv_signed_mode_i(multdiv_signed_mode_ex),
    .multdiv_operand_a_i  (multdiv_operand_a_ex),
    .multdiv_operand_b_i  (multdiv_operand_b_ex),
    .multdiv_ready_id_i   (multdiv_ready_id),
    .data_ind_timing_i    (data_ind_timing),
    .imd_val_we_o(imd_val_we_ex),
    .imd_val_d_o (imd_val_d_ex),
    .imd_val_q_i (imd_val_q_ex),
    .alu_adder_result_ex_o(alu_adder_result_ex),   
    .result_ex_o          (result_ex),   
    .branch_target_o  (branch_target_ex),   
    .branch_decision_o(branch_decision),   
    .ex_valid_o(ex_valid)
  );
  assign data_req_o   = data_req_out & ~pmp_req_err[PMP_D];
  assign lsu_resp_err = lsu_load_err | lsu_store_err;
  ibex_load_store_unit #(
    .MemECC(MemECC),
    .MemDataWidth(MemDataWidth)
  ) load_store_unit_i (
    .clk_i (clk_i),
    .rst_ni(rst_ni),
    .data_req_o    (data_req_out),
    .data_gnt_i    (data_gnt_i),
    .data_rvalid_i (data_rvalid_i),
    .data_bus_err_i(data_err_i),
    .data_pmp_err_i(pmp_req_err[PMP_D]),
    .data_addr_o      (data_addr_o),
    .data_we_o        (data_we_o),
    .data_be_o        (data_be_o),
    .data_wdata_o     (data_wdata_o),
    .data_rdata_i     (data_rdata_i),
    .lsu_we_i      (lsu_we),
    .lsu_type_i    (lsu_type),
    .lsu_wdata_i   (lsu_wdata),
    .lsu_sign_ext_i(lsu_sign_ext),
    .lsu_rdata_o      (rf_wdata_lsu),
    .lsu_rdata_valid_o(lsu_rdata_valid),
    .lsu_req_i        (lsu_req),
    .lsu_req_done_o   (lsu_req_done),
    .adder_result_ex_i(alu_adder_result_ex),
    .addr_incr_req_o(lsu_addr_incr_req),
    .addr_last_o    (lsu_addr_last),
    .lsu_resp_valid_o(lsu_resp_valid),
    .load_err_o           (lsu_load_err_raw),
    .load_resp_intg_err_o (lsu_load_resp_intg_err),
    .store_err_o          (lsu_store_err_raw),
    .store_resp_intg_err_o(lsu_store_resp_intg_err),
    .busy_o(lsu_busy),
    .perf_load_o (perf_load),
    .perf_store_o(perf_store)
  );
  ibex_wb_stage #(
    .ResetAll         (ResetAll),
    .WritebackStage   (WritebackStage),
    .DummyInstructions(DummyInstructions)
  ) wb_stage_i (
    .clk_i                   (clk_i),
    .rst_ni                  (rst_ni),
    .en_wb_i                 (en_wb),
    .instr_type_wb_i         (instr_type_wb),
    .pc_id_i                 (pc_id),
    .instr_is_compressed_id_i(instr_is_compressed_id),
    .instr_perf_count_id_i   (instr_perf_count_id),
    .ready_wb_o                         (ready_wb),
    .rf_write_wb_o                      (rf_write_wb),
    .outstanding_load_wb_o              (outstanding_load_wb),
    .outstanding_store_wb_o             (outstanding_store_wb),
    .pc_wb_o                            (pc_wb),
    .perf_instr_ret_wb_o                (perf_instr_ret_wb),
    .perf_instr_ret_compressed_wb_o     (perf_instr_ret_compressed_wb),
    .perf_instr_ret_wb_spec_o           (perf_instr_ret_wb_spec),
    .perf_instr_ret_compressed_wb_spec_o(perf_instr_ret_compressed_wb_spec),
    .rf_waddr_id_i(rf_waddr_id),
    .rf_wdata_id_i(rf_wdata_id),
    .rf_we_id_i   (rf_we_id),
    .dummy_instr_id_i(dummy_instr_id),
    .rf_wdata_lsu_i(rf_wdata_lsu),
    .rf_we_lsu_i   (rf_we_lsu),
    .rf_wdata_fwd_wb_o(rf_wdata_fwd_wb),
    .rf_waddr_wb_o(rf_waddr_wb),
    .rf_wdata_wb_o(rf_wdata_wb),
    .rf_we_wb_o   (rf_we_wb),
    .dummy_instr_wb_o(dummy_instr_wb),
    .lsu_resp_valid_i(lsu_resp_valid),
    .lsu_resp_err_i  (lsu_resp_err),
    .instr_done_wb_o(instr_done_wb)
  );
  if (SecureIbex) begin : g_check_mem_response
    assign lsu_load_err  = lsu_load_err_raw  & (outstanding_load_wb  | expecting_load_resp_id);
    assign lsu_store_err = lsu_store_err_raw & (outstanding_store_wb | expecting_store_resp_id);
    assign rf_we_lsu     = lsu_rdata_valid   & (outstanding_load_wb  | expecting_load_resp_id);
  end else begin : g_no_check_mem_response
    assign lsu_load_err  = lsu_load_err_raw;
    assign lsu_store_err = lsu_store_err_raw;
    assign rf_we_lsu     = lsu_rdata_valid;
    logic unused_expecting_load_resp_id;
    logic unused_expecting_store_resp_id;
    assign unused_expecting_load_resp_id  = expecting_load_resp_id;
    assign unused_expecting_store_resp_id = expecting_store_resp_id;
  end
  assign dummy_instr_id_o = dummy_instr_id;
  assign dummy_instr_wb_o = dummy_instr_wb;
  assign rf_raddr_a_o     = rf_raddr_a;
  assign rf_waddr_wb_o    = rf_waddr_wb;
  assign rf_we_wb_o       = rf_we_wb;
  assign rf_raddr_b_o     = rf_raddr_b;
  if (RegFileECC) begin : gen_regfile_ecc
    logic [1:0] rf_ecc_err_a, rf_ecc_err_b;
    logic       rf_ecc_err_a_id, rf_ecc_err_b_id;
    prim_secded_inv_39_32_enc regfile_ecc_enc (
      .data_i(rf_wdata_wb),
      .data_o(rf_wdata_wb_ecc_o)
    );
    prim_secded_inv_39_32_dec regfile_ecc_dec_a (
      .data_i    (rf_rdata_a_ecc_i),
      .data_o    (),
      .syndrome_o(),
      .err_o     (rf_ecc_err_a)
    );
    prim_secded_inv_39_32_dec regfile_ecc_dec_b (
      .data_i    (rf_rdata_b_ecc_i),
      .data_o    (),
      .syndrome_o(),
      .err_o     (rf_ecc_err_b)
    );
    assign rf_rdata_a = rf_rdata_a_ecc_i[31:0];
    assign rf_rdata_b = rf_rdata_b_ecc_i[31:0];
    assign rf_ecc_err_a_id = |rf_ecc_err_a & rf_ren_a & ~(rf_rd_a_wb_match & rf_write_wb);
    assign rf_ecc_err_b_id = |rf_ecc_err_b & rf_ren_b & ~(rf_rd_b_wb_match & rf_write_wb);
    assign rf_ecc_err_comb = instr_valid_id & (rf_ecc_err_a_id | rf_ecc_err_b_id);
  end else begin : gen_no_regfile_ecc
    logic unused_rf_ren_a, unused_rf_ren_b;
    logic unused_rf_rd_a_wb_match, unused_rf_rd_b_wb_match;
    assign unused_rf_ren_a         = rf_ren_a;
    assign unused_rf_ren_b         = rf_ren_b;
    assign unused_rf_rd_a_wb_match = rf_rd_a_wb_match;
    assign unused_rf_rd_b_wb_match = rf_rd_b_wb_match;
    assign rf_wdata_wb_ecc_o       = rf_wdata_wb;
    assign rf_rdata_a              = rf_rdata_a_ecc_i;
    assign rf_rdata_b              = rf_rdata_b_ecc_i;
    assign rf_ecc_err_comb         = 1'b0;
  end
  logic [31:0] crash_dump_mtval;
  assign crash_dump_o.current_pc     = pc_id;
  assign crash_dump_o.next_pc        = pc_if;
  assign crash_dump_o.last_data_addr = lsu_addr_last;
  assign crash_dump_o.exception_pc   = csr_mepc;
  assign crash_dump_o.exception_addr = crash_dump_mtval;
  assign alert_minor_o = icache_ecc_error;
  assign alert_major_internal_o = rf_ecc_err_comb | pc_mismatch_alert | csr_shadow_err;
  assign alert_major_bus_o = lsu_load_resp_intg_err | lsu_store_resp_intg_err | instr_intg_err;
  assign csr_wdata  = alu_operand_a_ex;
  ibex_cs_registers #(
    .DbgTriggerEn     (DbgTriggerEn),
    .DbgHwBreakNum    (DbgHwBreakNum),
    .DataIndTiming    (DataIndTiming),
    .DummyInstructions(DummyInstructions),
    .ShadowCSR        (ShadowCSR),
    .ICache           (ICache),
    .MHPMCounterNum   (MHPMCounterNum),
    .MHPMCounterWidth (MHPMCounterWidth),
    .PMPEnable        (PMPEnable),
    .PMPGranularity   (PMPGranularity),
    .PMPNumRegions    (PMPNumRegions),
    .PMPRstCfg        (PMPRstCfg),
    .PMPRstAddr       (PMPRstAddr),
    .PMPRstMsecCfg    (PMPRstMsecCfg),
    .RV32E            (RV32E),
    .RV32M            (RV32M),
    .RV32B            (RV32B),
    .CsrMvendorId     (CsrMvendorId),
    .CsrMimpId        (CsrMimpId)
  ) cs_registers_i (
    .clk_i (clk_i),
    .rst_ni(rst_ni),
    .hart_id_i      (hart_id_i),
    .priv_mode_id_o (priv_mode_id),
    .priv_mode_lsu_o(priv_mode_lsu),
    .csr_mtvec_o     (csr_mtvec),
    .csr_mtvec_init_i(csr_mtvec_init),
    .boot_addr_i     (boot_addr_i),
    .csr_access_i(csr_access),
    .csr_addr_i  (csr_addr),
    .csr_wdata_i (csr_wdata),
    .csr_op_i    (csr_op),
    .csr_op_en_i (csr_op_en),
    .csr_rdata_o (csr_rdata),
    .irq_software_i   (irq_software_i),
    .irq_timer_i      (irq_timer_i),
    .irq_external_i   (irq_external_i),
    .irq_fast_i       (irq_fast_i),
    .nmi_mode_i       (nmi_mode),
    .irq_pending_o    (irq_pending_o),
    .irqs_o           (irqs),
    .csr_mstatus_mie_o(csr_mstatus_mie),
    .csr_mstatus_tw_o (csr_mstatus_tw),
    .csr_mepc_o       (csr_mepc),
    .csr_mtval_o      (crash_dump_mtval),
    .csr_pmp_cfg_o    (csr_pmp_cfg),
    .csr_pmp_addr_o   (csr_pmp_addr),
    .csr_pmp_mseccfg_o(csr_pmp_mseccfg),
    .csr_depc_o           (csr_depc),
    .debug_mode_i         (debug_mode),
    .debug_mode_entering_i(debug_mode_entering),
    .debug_cause_i        (debug_cause),
    .debug_csr_save_i     (debug_csr_save),
    .debug_single_step_o  (debug_single_step),
    .debug_ebreakm_o      (debug_ebreakm),
    .debug_ebreaku_o      (debug_ebreaku),
    .trigger_match_o      (trigger_match),
    .pc_if_i(pc_if),
    .pc_id_i(pc_id),
    .pc_wb_i(pc_wb),
    .data_ind_timing_o    (data_ind_timing),
    .dummy_instr_en_o     (dummy_instr_en),
    .dummy_instr_mask_o   (dummy_instr_mask),
    .dummy_instr_seed_en_o(dummy_instr_seed_en),
    .dummy_instr_seed_o   (dummy_instr_seed),
    .icache_enable_o      (icache_enable),
    .csr_shadow_err_o     (csr_shadow_err),
    .ic_scr_key_valid_i   (ic_scr_key_valid_i),
    .mcounteren_writable_i(mcounteren_writable_i),
    .csr_save_if_i     (csr_save_if),
    .csr_save_id_i     (csr_save_id),
    .csr_save_wb_i     (csr_save_wb),
    .csr_restore_mret_i(csr_restore_mret_id),
    .csr_restore_dret_i(csr_restore_dret_id),
    .csr_save_cause_i  (csr_save_cause),
    .csr_mcause_i      (exc_cause),
    .csr_mtval_i       (csr_mtval),
    .illegal_csr_insn_o(illegal_csr_insn_id),
    .double_fault_seen_o,
    .instr_ret_i                (perf_instr_ret_wb),
    .instr_ret_compressed_i     (perf_instr_ret_compressed_wb),
    .instr_ret_spec_i           (perf_instr_ret_wb_spec),
    .instr_ret_compressed_spec_i(perf_instr_ret_compressed_wb_spec),
    .iside_wait_i               (perf_iside_wait),
    .jump_i                     (perf_jump),
    .branch_i                   (perf_branch),
    .branch_taken_i             (perf_tbranch),
    .mem_load_i                 (perf_load),
    .mem_store_i                (perf_store),
    .dside_wait_i               (perf_dside_wait),
    .mul_wait_i                 (perf_mul_wait),
    .div_wait_i                 (perf_div_wait)
  );
  if (PMPEnable) begin : g_pmp
    logic [31:0]           pc_if_inc;
    logic [PMP_ADDR_MSB:0] pmp_req_addr [PMPNumChan];
    pmp_req_e              pmp_req_type [PMPNumChan];
    priv_lvl_e             pmp_priv_lvl [PMPNumChan];
    assign pc_if_inc            = pc_if + 32'd2;
    assign pmp_req_addr[PMP_I]  = {2'b00, pc_if};
    assign pmp_req_type[PMP_I]  = PMP_ACC_EXEC;
    assign pmp_priv_lvl[PMP_I]  = priv_mode_id;
    assign pmp_req_addr[PMP_I2] = {2'b00, pc_if_inc};
    assign pmp_req_type[PMP_I2] = PMP_ACC_EXEC;
    assign pmp_priv_lvl[PMP_I2] = priv_mode_id;
    assign pmp_req_addr[PMP_D]  = {2'b00, data_addr_o[31:0]};
    assign pmp_req_type[PMP_D]  = data_we_o ? PMP_ACC_WRITE : PMP_ACC_READ;
    assign pmp_priv_lvl[PMP_D]  = priv_mode_lsu;
    ibex_pmp #(
      .DmBaseAddr    (DmBaseAddr),
      .DmAddrMask    (DmAddrMask),
      .PMPGranularity(PMPGranularity),
      .PMPNumChan    (PMPNumChan),
      .PMPNumRegions (PMPNumRegions)
    ) pmp_i (
      .csr_pmp_cfg_i    (csr_pmp_cfg),
      .csr_pmp_addr_i   (csr_pmp_addr),
      .csr_pmp_mseccfg_i(csr_pmp_mseccfg),
      .debug_mode_i     (debug_mode),
      .priv_mode_i      (pmp_priv_lvl),
      .pmp_req_addr_i   (pmp_req_addr),
      .pmp_req_type_i   (pmp_req_type),
      .pmp_req_err_o    (pmp_req_err)
    );
  end else begin : g_no_pmp
    priv_lvl_e             unused_priv_lvl_ls;
    logic [PMP_ADDR_MSB:0] unused_csr_pmp_addr [PMPNumRegions];
    pmp_cfg_t              unused_csr_pmp_cfg  [PMPNumRegions];
    pmp_mseccfg_t          unused_csr_pmp_mseccfg;
    assign unused_priv_lvl_ls = priv_mode_lsu;
    assign unused_csr_pmp_addr = csr_pmp_addr;
    assign unused_csr_pmp_cfg = csr_pmp_cfg;
    assign unused_csr_pmp_mseccfg = csr_pmp_mseccfg;
    assign pmp_req_err[PMP_I]  = 1'b0;
    assign pmp_req_err[PMP_I2] = 1'b0;
    assign pmp_req_err[PMP_D]  = 1'b0;
  end
  localparam int RVFI_STAGES = WritebackStage ? 2 : 1;
  logic        rvfi_stage_valid     [RVFI_STAGES];
  logic [63:0] rvfi_stage_order     [RVFI_STAGES];
  logic [31:0] rvfi_stage_insn      [RVFI_STAGES];
  logic        rvfi_stage_trap      [RVFI_STAGES];
  logic        rvfi_stage_halt      [RVFI_STAGES];
  logic        rvfi_stage_intr      [RVFI_STAGES];
  logic [ 1:0] rvfi_stage_mode      [RVFI_STAGES];
  logic [ 1:0] rvfi_stage_ixl       [RVFI_STAGES];
  logic [ 4:0] rvfi_stage_rs1_addr  [RVFI_STAGES];
  logic [ 4:0] rvfi_stage_rs2_addr  [RVFI_STAGES];
  logic [ 4:0] rvfi_stage_rs3_addr  [RVFI_STAGES];
  logic [31:0] rvfi_stage_rs1_rdata [RVFI_STAGES];
  logic [31:0] rvfi_stage_rs2_rdata [RVFI_STAGES];
  logic [31:0] rvfi_stage_rs3_rdata [RVFI_STAGES];
  logic [ 4:0] rvfi_stage_rd_addr   [RVFI_STAGES];
  logic [31:0] rvfi_stage_rd_wdata  [RVFI_STAGES];
  logic [31:0] rvfi_stage_pc_rdata  [RVFI_STAGES];
  logic [31:0] rvfi_stage_pc_wdata  [RVFI_STAGES];
  logic [31:0] rvfi_stage_mem_addr  [RVFI_STAGES];
  logic [ 3:0] rvfi_stage_mem_rmask [RVFI_STAGES];
  logic [ 3:0] rvfi_stage_mem_wmask [RVFI_STAGES];
  logic [31:0] rvfi_stage_mem_rdata [RVFI_STAGES];
  logic [31:0] rvfi_stage_mem_wdata [RVFI_STAGES];
  logic        rvfi_instr_new_wb;
  logic        rvfi_intr_d;
  logic        rvfi_intr_q;
  logic        rvfi_set_trap_pc_d;
  logic        rvfi_set_trap_pc_q;
  logic [31:0] rvfi_insn_id;
  logic [4:0]  rvfi_rs1_addr_d;
  logic [4:0]  rvfi_rs1_addr_q;
  logic [4:0]  rvfi_rs2_addr_d;
  logic [4:0]  rvfi_rs2_addr_q;
  logic [4:0]  rvfi_rs3_addr_d;
  logic [31:0] rvfi_rs1_data_d;
  logic [31:0] rvfi_rs1_data_q;
  logic [31:0] rvfi_rs2_data_d;
  logic [31:0] rvfi_rs2_data_q;
  logic [31:0] rvfi_rs3_data_d;
  logic [4:0]  rvfi_rd_addr_wb;
  logic [4:0]  rvfi_rd_addr_q;
  logic [4:0]  rvfi_rd_addr_d;
  logic [31:0] rvfi_rd_wdata_wb;
  logic [31:0] rvfi_rd_wdata_d;
  logic [31:0] rvfi_rd_wdata_q;
  logic        rvfi_rd_we_wb;
  logic [3:0]  rvfi_mem_mask_int;
  logic [31:0] rvfi_mem_rdata_d;
  logic [31:0] rvfi_mem_rdata_q;
  logic [31:0] rvfi_mem_wdata_d;
  logic [31:0] rvfi_mem_wdata_q;
  logic [31:0] rvfi_mem_addr_d;
  logic [31:0] rvfi_mem_addr_q;
  logic        rvfi_trap_id;
  logic        rvfi_trap_wb;
  logic        rvfi_irq_valid;
  logic [63:0] rvfi_stage_order_d;
  logic        rvfi_id_done;
  logic        rvfi_wb_done;
  logic            new_debug_req;
  logic            new_nmi;
  logic            new_nmi_int;
  logic            new_irq;
  ibex_pkg::irqs_t captured_mip;
  logic            captured_nmi;
  logic            captured_nmi_int;
  logic            captured_debug_req;
  logic            captured_valid;
  ibex_pkg::irqs_t rvfi_ext_stage_pre_mip             [RVFI_STAGES+1];
  ibex_pkg::irqs_t rvfi_ext_stage_post_mip            [RVFI_STAGES];
  logic            rvfi_ext_stage_nmi                 [RVFI_STAGES+1];
  logic            rvfi_ext_stage_nmi_int             [RVFI_STAGES+1];
  logic            rvfi_ext_stage_debug_req           [RVFI_STAGES+1];
  logic            rvfi_ext_stage_debug_mode          [RVFI_STAGES];
  logic [63:0]     rvfi_ext_stage_mcycle              [RVFI_STAGES];
  logic [31:0]     rvfi_ext_stage_mhpmcounters        [RVFI_STAGES][10];
  logic [31:0]     rvfi_ext_stage_mhpmcountersh       [RVFI_STAGES][10];
  logic            rvfi_ext_stage_ic_scr_key_valid    [RVFI_STAGES];
  logic            rvfi_ext_stage_irq_valid           [RVFI_STAGES+1];
  logic            rvfi_ext_stage_expanded_insn_valid [RVFI_STAGES];
  logic [15:0]     rvfi_ext_stage_expanded_insn       [RVFI_STAGES];
  logic            rvfi_ext_stage_expanded_insn_last  [RVFI_STAGES];
  logic            rvfi_expanded_insn_valid;
  logic [15:0]     rvfi_expanded_insn;
  logic            rvfi_expanded_insn_last;
  logic        rvfi_stage_valid_d   [RVFI_STAGES];
  assign rvfi_valid     = rvfi_stage_valid    [RVFI_STAGES-1];
  assign rvfi_order     = rvfi_stage_order    [RVFI_STAGES-1];
  assign rvfi_insn      = rvfi_stage_insn     [RVFI_STAGES-1];
  assign rvfi_trap      = rvfi_stage_trap     [RVFI_STAGES-1];
  assign rvfi_halt      = rvfi_stage_halt     [RVFI_STAGES-1];
  assign rvfi_intr      = rvfi_stage_intr     [RVFI_STAGES-1];
  assign rvfi_mode      = rvfi_stage_mode     [RVFI_STAGES-1];
  assign rvfi_ixl       = rvfi_stage_ixl      [RVFI_STAGES-1];
  assign rvfi_rs1_addr  = rvfi_stage_rs1_addr [RVFI_STAGES-1];
  assign rvfi_rs2_addr  = rvfi_stage_rs2_addr [RVFI_STAGES-1];
  assign rvfi_rs3_addr  = rvfi_stage_rs3_addr [RVFI_STAGES-1];
  assign rvfi_rs1_rdata = rvfi_stage_rs1_rdata[RVFI_STAGES-1];
  assign rvfi_rs2_rdata = rvfi_stage_rs2_rdata[RVFI_STAGES-1];
  assign rvfi_rs3_rdata = rvfi_stage_rs3_rdata[RVFI_STAGES-1];
  assign rvfi_rd_addr   = rvfi_stage_rd_addr  [RVFI_STAGES-1];
  assign rvfi_rd_wdata  = rvfi_stage_rd_wdata [RVFI_STAGES-1];
  assign rvfi_pc_rdata  = rvfi_stage_pc_rdata [RVFI_STAGES-1];
  assign rvfi_pc_wdata  = rvfi_stage_pc_wdata [RVFI_STAGES-1];
  assign rvfi_mem_addr  = rvfi_stage_mem_addr [RVFI_STAGES-1];
  assign rvfi_mem_rmask = rvfi_stage_mem_rmask[RVFI_STAGES-1];
  assign rvfi_mem_wmask = rvfi_stage_mem_wmask[RVFI_STAGES-1];
  assign rvfi_mem_rdata = rvfi_stage_mem_rdata[RVFI_STAGES-1];
  assign rvfi_mem_wdata = rvfi_stage_mem_wdata[RVFI_STAGES-1];
  assign rvfi_rd_addr_wb  = rf_waddr_wb;
  assign rvfi_rd_wdata_wb = rf_we_wb ? rf_wdata_wb : rf_wdata_lsu;
  assign rvfi_rd_we_wb    = rf_we_wb | rf_we_lsu;
  always_comb begin
    rvfi_ext_pre_mip               = '0;
    rvfi_ext_pre_mip[CSR_MSIX_BIT] = rvfi_ext_stage_pre_mip[RVFI_STAGES].irq_software;
    rvfi_ext_pre_mip[CSR_MTIX_BIT] = rvfi_ext_stage_pre_mip[RVFI_STAGES].irq_timer;
    rvfi_ext_pre_mip[CSR_MEIX_BIT] = rvfi_ext_stage_pre_mip[RVFI_STAGES].irq_external;
    rvfi_ext_pre_mip[CSR_MFIX_BIT_HIGH:CSR_MFIX_BIT_LOW] =
      rvfi_ext_stage_pre_mip[RVFI_STAGES].irq_fast;
    rvfi_ext_post_mip               = '0;
    rvfi_ext_post_mip[CSR_MSIX_BIT] = rvfi_ext_stage_post_mip[RVFI_STAGES-1].irq_software;
    rvfi_ext_post_mip[CSR_MTIX_BIT] = rvfi_ext_stage_post_mip[RVFI_STAGES-1].irq_timer;
    rvfi_ext_post_mip[CSR_MEIX_BIT] = rvfi_ext_stage_post_mip[RVFI_STAGES-1].irq_external;
    rvfi_ext_post_mip[CSR_MFIX_BIT_HIGH:CSR_MFIX_BIT_LOW] =
      rvfi_ext_stage_post_mip[RVFI_STAGES-1].irq_fast;
  end
  assign rvfi_ext_nmi                 = rvfi_ext_stage_nmi                 [RVFI_STAGES];
  assign rvfi_ext_nmi_int             = rvfi_ext_stage_nmi_int             [RVFI_STAGES];
  assign rvfi_ext_debug_req           = rvfi_ext_stage_debug_req           [RVFI_STAGES];
  assign rvfi_ext_debug_mode          = rvfi_ext_stage_debug_mode          [RVFI_STAGES-1];
  assign rvfi_ext_mcycle              = rvfi_ext_stage_mcycle              [RVFI_STAGES-1];
  assign rvfi_ext_mhpmcounters        = rvfi_ext_stage_mhpmcounters        [RVFI_STAGES-1];
  assign rvfi_ext_mhpmcountersh       = rvfi_ext_stage_mhpmcountersh       [RVFI_STAGES-1];
  assign rvfi_ext_ic_scr_key_valid    = rvfi_ext_stage_ic_scr_key_valid    [RVFI_STAGES-1];
  assign rvfi_ext_irq_valid           = rvfi_ext_stage_irq_valid           [RVFI_STAGES];
  assign rvfi_ext_expanded_insn_valid = rvfi_ext_stage_expanded_insn_valid [RVFI_STAGES-1];
  assign rvfi_ext_expanded_insn       = rvfi_ext_stage_expanded_insn       [RVFI_STAGES-1];
  assign rvfi_ext_expanded_insn_last  = rvfi_ext_stage_expanded_insn_last  [RVFI_STAGES-1];
  assign rvfi_id_done = instr_id_done | (id_stage_i.controller_i.rvfi_flush_next &
                                         id_stage_i.controller_i.id_exception_o);
  if (WritebackStage) begin : gen_rvfi_wb_stage
    logic unused_instr_new_id;
    assign unused_instr_new_id = instr_new_id;
    assign rvfi_stage_valid_d[0] = (rvfi_id_done & ~dummy_instr_id) |
                                   (rvfi_stage_valid[0] & ~rvfi_wb_done);
    assign rvfi_stage_valid_d[1] = rvfi_wb_done;
    logic rvfi_instr_new_wb_q;
    assign rvfi_instr_new_wb = rvfi_instr_new_wb_q | (rvfi_stage_valid[0] & rvfi_stage_trap[0]);
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        rvfi_instr_new_wb_q <= 0;
      end else begin
        rvfi_instr_new_wb_q <= rvfi_id_done;
      end
    end
    assign rvfi_trap_id = id_stage_i.controller_i.id_exception_o &
      ~(id_stage_i.ebrk_insn & id_stage_i.controller_i.ebreak_into_debug);
    assign rvfi_trap_wb = id_stage_i.controller_i.exc_req_lsu;
    assign rvfi_wb_done = rvfi_stage_valid[0] & (instr_done_wb | rvfi_stage_trap[0]);
  end else begin : gen_rvfi_no_wb_stage
    assign rvfi_stage_valid_d[0] = rvfi_id_done & ~dummy_instr_id;
    assign rvfi_instr_new_wb = instr_new_id;
    assign rvfi_trap_id =
      (id_stage_i.controller_i.exc_req_d | id_stage_i.controller_i.exc_req_lsu) &
      ~(id_stage_i.ebrk_insn & id_stage_i.controller_i.ebreak_into_debug);
    assign rvfi_trap_wb = 1'b0;
    assign rvfi_wb_done = instr_done_wb;
  end
  assign rvfi_stage_order_d = dummy_instr_id ? rvfi_stage_order[0] : rvfi_stage_order[0] + 64'd1;
  assign new_debug_req = (debug_req_i & ~debug_mode);
  assign new_nmi = irq_nm_i & ~nmi_mode & ~debug_mode;
  assign new_nmi_int = id_stage_i.controller_i.irq_nm_int & ~nmi_mode & ~debug_mode;
  assign new_irq = irq_pending_o & (csr_mstatus_mie || (priv_mode_id == PRIV_LVL_U)) & ~nmi_mode &
                   ~debug_mode;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      captured_valid     <= 1'b0;
      captured_mip       <= '0;
      captured_nmi       <= 1'b0;
      captured_nmi_int   <= 1'b0;
      captured_debug_req <= 1'b0;
      rvfi_irq_valid     <= 1'b0;
    end else  begin
      if (~instr_valid_id & (new_debug_req | new_irq | new_nmi | new_nmi_int) &
          ((~captured_valid) |
           (new_debug_req & ~captured_debug_req) |
           (new_nmi & ~captured_nmi & ~captured_debug_req))) begin
        captured_valid     <= 1'b1;
        captured_nmi       <= irq_nm_i;
        captured_nmi_int   <= id_stage_i.controller_i.irq_nm_int;
        captured_mip       <= cs_registers_i.mip;
        captured_debug_req <= debug_req_i;
      end
      if (~instr_valid_id & ~new_debug_req & (new_irq | new_nmi | new_nmi_int) & ready_wb &
          ~captured_valid) begin
        rvfi_irq_valid <= 1'b1;
      end else begin
        rvfi_irq_valid <= 1'b0;
      end
      if (if_stage_i.instr_valid_id_d) begin
        captured_valid <= 1'b0;
      end
    end
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rvfi_ext_stage_pre_mip[0]       <= '0;
      rvfi_ext_stage_nmi[0]       <= '0;
      rvfi_ext_stage_nmi_int[0]   <= '0;
      rvfi_ext_stage_debug_req[0] <= '0;
    end else if ((if_stage_i.instr_valid_id_d & if_stage_i.instr_new_id_d) | rvfi_irq_valid) begin
      rvfi_ext_stage_pre_mip[0]   <= instr_valid_id | ~captured_valid ? cs_registers_i.mip :
                                                                        captured_mip;
      rvfi_ext_stage_nmi[0]       <= instr_valid_id | ~captured_valid ? irq_nm_i :
                                                                        captured_nmi;
      rvfi_ext_stage_nmi_int[0]   <=
        instr_valid_id | ~captured_valid ? id_stage_i.controller_i.irq_nm_int :
                                           captured_nmi_int;
      rvfi_ext_stage_debug_req[0] <= instr_valid_id | ~captured_valid ? debug_req_i        :
                                                                        captured_debug_req;
    end
  end
  for (genvar i = 0; i < RVFI_STAGES + 1; i = i + 1) begin : g_rvfi_irq_valid
    if (i == 0) begin : g_rvfi_irq_valid_first_stage
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          rvfi_ext_stage_irq_valid[i] <= 1'b0;
        end else begin
          rvfi_ext_stage_irq_valid[i] <= rvfi_irq_valid;
        end
      end
    end else begin : g_rvfi_irq_valid_other_stages
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          rvfi_ext_stage_irq_valid[i] <= 1'b0;
        end else begin
          rvfi_ext_stage_irq_valid[i] <= rvfi_ext_stage_irq_valid[i-1];
        end
      end
    end
  end
  for (genvar i = 0; i < RVFI_STAGES; i = i + 1) begin : g_rvfi_stages
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        rvfi_stage_halt[i]                    <= '0;
        rvfi_stage_trap[i]                    <= '0;
        rvfi_stage_intr[i]                    <= '0;
        rvfi_stage_order[i]                   <= '0;
        rvfi_stage_insn[i]                    <= '0;
        rvfi_stage_mode[i]                    <= {PRIV_LVL_M};
        rvfi_stage_ixl[i]                     <= CSR_MISA_MXL;
        rvfi_stage_rs1_addr[i]                <= '0;
        rvfi_stage_rs2_addr[i]                <= '0;
        rvfi_stage_rs3_addr[i]                <= '0;
        rvfi_stage_pc_rdata[i]                <= '0;
        rvfi_stage_pc_wdata[i]                <= '0;
        rvfi_stage_mem_rmask[i]               <= '0;
        rvfi_stage_mem_wmask[i]               <= '0;
        rvfi_stage_valid[i]                   <= '0;
        rvfi_stage_rs1_rdata[i]               <= '0;
        rvfi_stage_rs2_rdata[i]               <= '0;
        rvfi_stage_rs3_rdata[i]               <= '0;
        rvfi_stage_rd_wdata[i]                <= '0;
        rvfi_stage_rd_addr[i]                 <= '0;
        rvfi_stage_mem_rdata[i]               <= '0;
        rvfi_stage_mem_wdata[i]               <= '0;
        rvfi_stage_mem_addr[i]                <= '0;
        rvfi_ext_stage_pre_mip[i+1]           <= '0;
        rvfi_ext_stage_post_mip[i]            <= '0;
        rvfi_ext_stage_nmi[i+1]               <= '0;
        rvfi_ext_stage_nmi_int[i+1]           <= '0;
        rvfi_ext_stage_debug_req[i+1]         <= '0;
        rvfi_ext_stage_debug_mode[i]          <= '0;
        rvfi_ext_stage_mcycle[i]              <= '0;
        rvfi_ext_stage_ic_scr_key_valid[i]    <= '0;
        rvfi_ext_stage_expanded_insn_valid[i] <= '0;
        rvfi_ext_stage_expanded_insn[i]       <= '0;
        rvfi_ext_stage_expanded_insn_last[i]  <= '0;
        rvfi_ext_stage_mhpmcounters[i][0]     <= '0;
        rvfi_ext_stage_mhpmcountersh[i][0]    <= '0;
        rvfi_ext_stage_mhpmcounters[i][1]     <= '0;
        rvfi_ext_stage_mhpmcountersh[i][1]    <= '0;
        rvfi_ext_stage_mhpmcounters[i][2]     <= '0;
        rvfi_ext_stage_mhpmcountersh[i][2]    <= '0;
        rvfi_ext_stage_mhpmcounters[i][3]     <= '0;
        rvfi_ext_stage_mhpmcountersh[i][3]    <= '0;
        rvfi_ext_stage_mhpmcounters[i][4]     <= '0;
        rvfi_ext_stage_mhpmcountersh[i][4]    <= '0;
        rvfi_ext_stage_mhpmcounters[i][5]     <= '0;
        rvfi_ext_stage_mhpmcountersh[i][5]    <= '0;
        rvfi_ext_stage_mhpmcounters[i][6]     <= '0;
        rvfi_ext_stage_mhpmcountersh[i][6]    <= '0;
        rvfi_ext_stage_mhpmcounters[i][7]     <= '0;
        rvfi_ext_stage_mhpmcountersh[i][7]    <= '0;
        rvfi_ext_stage_mhpmcounters[i][8]     <= '0;
        rvfi_ext_stage_mhpmcountersh[i][8]    <= '0;
        rvfi_ext_stage_mhpmcounters[i][9]     <= '0;
        rvfi_ext_stage_mhpmcountersh[i][9]    <= '0;
      end else begin
        rvfi_stage_valid[i] <= rvfi_stage_valid_d[i];
        if (i == 0) begin
          if (rvfi_id_done) begin
            rvfi_stage_halt[i]                    <= '0;
            rvfi_stage_trap[i]                    <= rvfi_trap_id;
            rvfi_stage_intr[i]                    <= rvfi_intr_d;
            rvfi_stage_order[i]                   <= rvfi_stage_order_d;
            rvfi_stage_insn[i]                    <= rvfi_insn_id;
            rvfi_stage_mode[i]                    <= {priv_mode_id};
            rvfi_stage_ixl[i]                     <= CSR_MISA_MXL;
            rvfi_stage_rs1_addr[i]                <= rvfi_rs1_addr_d;
            rvfi_stage_rs2_addr[i]                <= rvfi_rs2_addr_d;
            rvfi_stage_rs3_addr[i]                <= rvfi_rs3_addr_d;
            rvfi_stage_pc_rdata[i]                <= pc_id;
            rvfi_stage_pc_wdata[i]                <= pc_set ? branch_target_ex : pc_if;
            rvfi_stage_mem_rmask[i]               <= data_we_o ? 4'b0000 : rvfi_mem_mask_int;
            rvfi_stage_mem_wmask[i]               <= data_we_o ? rvfi_mem_mask_int : 4'b0000;
            rvfi_stage_rs1_rdata[i]               <= rvfi_rs1_data_d;
            rvfi_stage_rs2_rdata[i]               <= rvfi_rs2_data_d;
            rvfi_stage_rs3_rdata[i]               <= rvfi_rs3_data_d;
            rvfi_stage_rd_addr[i]                 <= rvfi_rd_addr_d;
            rvfi_stage_rd_wdata[i]                <= rvfi_rd_wdata_d;
            rvfi_stage_mem_rdata[i]               <= rvfi_mem_rdata_d;
            rvfi_stage_mem_wdata[i]               <= rvfi_mem_wdata_d;
            rvfi_stage_mem_addr[i]                <= rvfi_mem_addr_d;
            rvfi_ext_stage_debug_mode[i]          <= debug_mode;
            rvfi_ext_stage_mcycle[i]              <= cs_registers_i.mcycle_counter_i.counter_val_o;
            rvfi_ext_stage_ic_scr_key_valid[i]    <= cs_registers_i.cpuctrlsts_ic_scr_key_valid_q;
            rvfi_ext_stage_expanded_insn_valid[i] <= rvfi_expanded_insn_valid;
            rvfi_ext_stage_expanded_insn[i]       <= rvfi_expanded_insn;
            rvfi_ext_stage_expanded_insn_last[i]  <= rvfi_expanded_insn_last;
            rvfi_ext_stage_mhpmcounters[i][0]     <= cs_registers_i.mhpmcounter[3][31:0];
            rvfi_ext_stage_mhpmcountersh[i][0]    <= cs_registers_i.mhpmcounter[3][63:32];
            rvfi_ext_stage_mhpmcounters[i][1]     <= cs_registers_i.mhpmcounter[4][31:0];
            rvfi_ext_stage_mhpmcountersh[i][1]    <= cs_registers_i.mhpmcounter[4][63:32];
            rvfi_ext_stage_mhpmcounters[i][2]     <= cs_registers_i.mhpmcounter[5][31:0];
            rvfi_ext_stage_mhpmcountersh[i][2]    <= cs_registers_i.mhpmcounter[5][63:32];
            rvfi_ext_stage_mhpmcounters[i][3]     <= cs_registers_i.mhpmcounter[6][31:0];
            rvfi_ext_stage_mhpmcountersh[i][3]    <= cs_registers_i.mhpmcounter[6][63:32];
            rvfi_ext_stage_mhpmcounters[i][4]     <= cs_registers_i.mhpmcounter[7][31:0];
            rvfi_ext_stage_mhpmcountersh[i][4]    <= cs_registers_i.mhpmcounter[7][63:32];
            rvfi_ext_stage_mhpmcounters[i][5]     <= cs_registers_i.mhpmcounter[8][31:0];
            rvfi_ext_stage_mhpmcountersh[i][5]    <= cs_registers_i.mhpmcounter[8][63:32];
            rvfi_ext_stage_mhpmcounters[i][6]     <= cs_registers_i.mhpmcounter[9][31:0];
            rvfi_ext_stage_mhpmcountersh[i][6]    <= cs_registers_i.mhpmcounter[9][63:32];
            rvfi_ext_stage_mhpmcounters[i][7]     <= cs_registers_i.mhpmcounter[10][31:0];
            rvfi_ext_stage_mhpmcountersh[i][7]    <= cs_registers_i.mhpmcounter[10][63:32];
            rvfi_ext_stage_mhpmcounters[i][8]     <= cs_registers_i.mhpmcounter[11][31:0];
            rvfi_ext_stage_mhpmcountersh[i][8]    <= cs_registers_i.mhpmcounter[11][63:32];
            rvfi_ext_stage_mhpmcounters[i][9]     <= cs_registers_i.mhpmcounter[12][31:0];
            rvfi_ext_stage_mhpmcountersh[i][9]    <= cs_registers_i.mhpmcounter[12][63:32];
          end
          if (rvfi_id_done | rvfi_ext_stage_irq_valid[i]) begin
            rvfi_ext_stage_pre_mip[i+1]   <= rvfi_ext_stage_pre_mip[i];
            rvfi_ext_stage_post_mip[i]    <= cs_registers_i.mip;
            rvfi_ext_stage_nmi[i+1]       <= rvfi_ext_stage_nmi[i];
            rvfi_ext_stage_nmi_int[i+1]   <= rvfi_ext_stage_nmi_int[i];
            rvfi_ext_stage_debug_req[i+1] <= rvfi_ext_stage_debug_req[i];
          end
        end else begin
          if (rvfi_wb_done) begin
            rvfi_stage_halt[i]      <= rvfi_stage_halt[i-1];
            rvfi_stage_trap[i]      <= rvfi_stage_trap[i-1] | rvfi_trap_wb;
            rvfi_stage_intr[i]      <= rvfi_stage_intr[i-1];
            rvfi_stage_order[i]     <= rvfi_stage_order[i-1];
            rvfi_stage_insn[i]      <= rvfi_stage_insn[i-1];
            rvfi_stage_mode[i]      <= rvfi_stage_mode[i-1];
            rvfi_stage_ixl[i]       <= rvfi_stage_ixl[i-1];
            rvfi_stage_rs1_addr[i]  <= rvfi_stage_rs1_addr[i-1];
            rvfi_stage_rs2_addr[i]  <= rvfi_stage_rs2_addr[i-1];
            rvfi_stage_rs3_addr[i]  <= rvfi_stage_rs3_addr[i-1];
            rvfi_stage_pc_rdata[i]  <= rvfi_stage_pc_rdata[i-1];
            rvfi_stage_pc_wdata[i]  <= rvfi_stage_pc_wdata[i-1];
            rvfi_stage_mem_rmask[i] <= rvfi_stage_mem_rmask[i-1];
            rvfi_stage_mem_wmask[i] <= rvfi_stage_mem_wmask[i-1];
            rvfi_stage_rs1_rdata[i] <= rvfi_stage_rs1_rdata[i-1];
            rvfi_stage_rs2_rdata[i] <= rvfi_stage_rs2_rdata[i-1];
            rvfi_stage_rs3_rdata[i] <= rvfi_stage_rs3_rdata[i-1];
            rvfi_stage_mem_wdata[i] <= rvfi_stage_mem_wdata[i-1];
            rvfi_stage_mem_addr[i]  <= rvfi_stage_mem_addr[i-1];
            rvfi_stage_rd_addr[i]   <= rvfi_rd_addr_d;
            rvfi_stage_rd_wdata[i]  <= rvfi_rd_wdata_d;
            rvfi_stage_mem_rdata[i] <= rvfi_mem_rdata_d;
            rvfi_ext_stage_debug_mode[i]          <= rvfi_ext_stage_debug_mode[i-1];
            rvfi_ext_stage_mcycle[i]              <= rvfi_ext_stage_mcycle[i-1];
            rvfi_ext_stage_ic_scr_key_valid[i]    <= rvfi_ext_stage_ic_scr_key_valid[i-1];
            rvfi_ext_stage_mhpmcounters[i]        <= rvfi_ext_stage_mhpmcounters[i-1];
            rvfi_ext_stage_mhpmcountersh[i]       <= rvfi_ext_stage_mhpmcountersh[i-1];
            rvfi_ext_stage_expanded_insn_valid[i] <= rvfi_ext_stage_expanded_insn_valid[i-1];
            rvfi_ext_stage_expanded_insn[i]       <= rvfi_ext_stage_expanded_insn[i-1];
            rvfi_ext_stage_expanded_insn_last[i]  <= rvfi_ext_stage_expanded_insn_last[i-1];
          end
          if (rvfi_wb_done | rvfi_ext_stage_irq_valid[i]) begin
            rvfi_ext_stage_pre_mip[i+1]   <= rvfi_ext_stage_pre_mip[i];
            rvfi_ext_stage_post_mip[i]    <= rvfi_ext_stage_post_mip[i-1];
            rvfi_ext_stage_nmi[i+1]       <= rvfi_ext_stage_nmi[i];
            rvfi_ext_stage_nmi_int[i+1]   <= rvfi_ext_stage_nmi_int[i];
            rvfi_ext_stage_debug_req[i+1] <= rvfi_ext_stage_debug_req[i];
          end
        end
      end
    end
  end
  always_comb begin
    if (instr_first_cycle_id) begin
      rvfi_mem_addr_d  = alu_adder_result_ex;
      rvfi_mem_wdata_d = lsu_wdata;
    end else begin
      rvfi_mem_addr_d  = rvfi_mem_addr_q;
      rvfi_mem_wdata_d = rvfi_mem_wdata_q;
    end
  end
  always_comb begin
    if (lsu_resp_valid) begin
      rvfi_mem_rdata_d = rf_wdata_lsu;
    end else begin
      rvfi_mem_rdata_d = rvfi_mem_rdata_q;
    end
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rvfi_mem_addr_q  <= '0;
      rvfi_mem_rdata_q <= '0;
      rvfi_mem_wdata_q <= '0;
    end else begin
      rvfi_mem_addr_q  <= rvfi_mem_addr_d;
      rvfi_mem_rdata_q <= rvfi_mem_rdata_d;
      rvfi_mem_wdata_q <= rvfi_mem_wdata_d;
    end
  end
  always_comb begin
    unique case (lsu_type)
      2'b00:   rvfi_mem_mask_int = 4'b1111;
      2'b01:   rvfi_mem_mask_int = 4'b0011;
      2'b10:   rvfi_mem_mask_int = 4'b0001;
      default: rvfi_mem_mask_int = 4'b0000;
    endcase
  end
  always_comb begin
    if (instr_is_compressed_id && (instr_gets_expanded_id == INSTR_NOT_EXPANDED)) begin
      rvfi_insn_id = {16'b0, instr_rdata_c_id};
    end else begin
      rvfi_insn_id = instr_rdata_id;
    end
  end
  always_comb begin
    rvfi_expanded_insn_valid = 1'b0;
    rvfi_expanded_insn = '0;
    rvfi_expanded_insn_last = 1'b0;
    if (instr_gets_expanded_id != INSTR_NOT_EXPANDED) begin
      rvfi_expanded_insn_valid = 1'b1;
      rvfi_expanded_insn = instr_expanded_id;
      if (instr_gets_expanded_id == INSTR_EXPANDED_LAST) begin
        rvfi_expanded_insn_last = 1'b1;
      end
    end
  end
  always_comb begin
    if (instr_first_cycle_id) begin
      rvfi_rs1_data_d = rf_ren_a ? multdiv_operand_a_ex : '0;
      rvfi_rs1_addr_d = rf_ren_a ? rf_raddr_a : '0;
      rvfi_rs2_data_d = rf_ren_b ? multdiv_operand_b_ex : '0;
      rvfi_rs2_addr_d = rf_ren_b ? rf_raddr_b : '0;
      rvfi_rs3_data_d = '0;
      rvfi_rs3_addr_d = '0;
    end else begin
      rvfi_rs1_data_d = rvfi_rs1_data_q;
      rvfi_rs1_addr_d = rvfi_rs1_addr_q;
      rvfi_rs2_data_d = rvfi_rs2_data_q;
      rvfi_rs2_addr_d = rvfi_rs2_addr_q;
      rvfi_rs3_data_d = multdiv_operand_a_ex;
      rvfi_rs3_addr_d = rf_raddr_a;
    end
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rvfi_rs1_data_q <= '0;
      rvfi_rs1_addr_q <= '0;
      rvfi_rs2_data_q <= '0;
      rvfi_rs2_addr_q <= '0;
    end else begin
      rvfi_rs1_data_q <= rvfi_rs1_data_d;
      rvfi_rs1_addr_q <= rvfi_rs1_addr_d;
      rvfi_rs2_data_q <= rvfi_rs2_data_d;
      rvfi_rs2_addr_q <= rvfi_rs2_addr_d;
    end
  end
  always_comb begin
    if (rvfi_rd_we_wb) begin
      rvfi_rd_addr_d = rvfi_rd_addr_wb;
      if (rvfi_rd_addr_wb == 5'b0) begin
        rvfi_rd_wdata_d = '0;
      end else begin
        rvfi_rd_wdata_d = rvfi_rd_wdata_wb;
      end
    end else if (rvfi_instr_new_wb) begin
      rvfi_rd_addr_d  = '0;
      rvfi_rd_wdata_d = '0;
    end else begin
      rvfi_rd_addr_d  = rvfi_rd_addr_q;
      rvfi_rd_wdata_d = rvfi_rd_wdata_q;
    end
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rvfi_rd_addr_q    <= '0;
      rvfi_rd_wdata_q   <= '0;
    end else begin
      rvfi_rd_addr_q    <= rvfi_rd_addr_d;
      rvfi_rd_wdata_q   <= rvfi_rd_wdata_d;
    end
  end
  if (WritebackStage) begin : g_rvfi_rf_wr_suppress_wb
    logic rvfi_stage_rf_wr_suppress_wb;
    logic rvfi_rf_wr_suppress_wb;
    assign rvfi_rf_wr_suppress_wb =
      instr_done_wb & ~rf_we_wb_o & outstanding_load_wb & lsu_load_resp_intg_err;
    always@(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        rvfi_stage_rf_wr_suppress_wb <= 1'b0;
      end else if (rvfi_wb_done) begin
        rvfi_stage_rf_wr_suppress_wb <= rvfi_rf_wr_suppress_wb;
      end
    end
    assign rvfi_ext_rf_wr_suppress = rvfi_stage_rf_wr_suppress_wb;
  end else begin : g_rvfi_no_rf_wr_suppress_wb
    assign rvfi_ext_rf_wr_suppress = 1'b0;
  end
  assign rvfi_intr_d = instr_first_cycle_id ? rvfi_set_trap_pc_q : rvfi_intr_q;
  always_comb begin
    rvfi_set_trap_pc_d = rvfi_set_trap_pc_q;
    if (pc_set && pc_mux_id == PC_EXC &&
        (exc_pc_mux_id == EXC_PC_EXC || exc_pc_mux_id == EXC_PC_IRQ)) begin
      rvfi_set_trap_pc_d = 1'b1;
    end else if (rvfi_set_trap_pc_q && rvfi_id_done) begin
      rvfi_set_trap_pc_d = 1'b0;
    end
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rvfi_set_trap_pc_q <= 1'b0;
      rvfi_intr_q        <= 1'b0;
    end else begin
      rvfi_set_trap_pc_q <= rvfi_set_trap_pc_d;
      rvfi_intr_q        <= rvfi_intr_d;
    end
  end
    logic fcov_rf_ecc_err_a_id; 
    if (RegFileECC) begin : g_fcov_rf_ecc_err_a_id 
      assign fcov_rf_ecc_err_a_id = gen_regfile_ecc.rf_ecc_err_a_id; 
    end else begin : g_no_fcov_rf_ecc_err_a_id 
      assign fcov_rf_ecc_err_a_id =  '0; 
    end 
    logic unused_fcov_rf_ecc_err_a_id; 
    assign unused_fcov_rf_ecc_err_a_id = fcov_rf_ecc_err_a_id;
    logic fcov_rf_ecc_err_b_id; 
    if (RegFileECC) begin : g_fcov_rf_ecc_err_b_id 
      assign fcov_rf_ecc_err_b_id = gen_regfile_ecc.rf_ecc_err_b_id; 
    end else begin : g_no_fcov_rf_ecc_err_b_id 
      assign fcov_rf_ecc_err_b_id =  '0; 
    end 
    logic unused_fcov_rf_ecc_err_b_id; 
    assign unused_fcov_rf_ecc_err_b_id = fcov_rf_ecc_err_b_id;
    logic fcov_csr_read_only; 
    assign fcov_csr_read_only = (csr_op == CSR_OP_READ) && csr_access && (csr_op_en || illegal_insn_id); 
    logic unused_fcov_csr_read_only; 
    assign unused_fcov_csr_read_only = fcov_csr_read_only;
    logic fcov_csr_write; 
    assign fcov_csr_write = cs_registers_i.csr_wr && csr_access && (csr_op_en || illegal_insn_id); 
    logic unused_fcov_csr_write; 
    assign unused_fcov_csr_write = fcov_csr_write;
  if (PMPEnable) begin : g_pmp_fcov_signals
    logic [PMPNumRegions-1:0] fcov_pmp_region_ichan_priority;
    logic [PMPNumRegions-1:0] fcov_pmp_region_ichan2_priority;
    logic [PMPNumRegions-1:0] fcov_pmp_region_dchan_priority;
    logic unused_fcov_pmp_region_priority;
    assign unused_fcov_pmp_region_priority = ^{fcov_pmp_region_ichan_priority,
                                               fcov_pmp_region_ichan2_priority,
                                               fcov_pmp_region_dchan_priority};
    for (genvar i_region = 0; i_region < PMPNumRegions; i_region += 1) begin : g_pmp_region_fcov
    logic fcov_pmp_region_ichan_access; 
    assign fcov_pmp_region_ichan_access = g_pmp.pmp_i.region_match_all[PMP_I][i_region] & if_stage_i.if_id_pipe_reg_we; 
    logic unused_fcov_pmp_region_ichan_access; 
    assign unused_fcov_pmp_region_ichan_access = fcov_pmp_region_ichan_access;
    logic fcov_pmp_region_ichan2_access; 
    assign fcov_pmp_region_ichan2_access = g_pmp.pmp_i.region_match_all[PMP_I2][i_region] & if_stage_i.if_id_pipe_reg_we; 
    logic unused_fcov_pmp_region_ichan2_access; 
    assign unused_fcov_pmp_region_ichan2_access = fcov_pmp_region_ichan2_access;
    logic fcov_pmp_region_dchan_access; 
    assign fcov_pmp_region_dchan_access = g_pmp.pmp_i.region_match_all[PMP_D][i_region] & data_req_out; 
    logic unused_fcov_pmp_region_dchan_access; 
    assign unused_fcov_pmp_region_dchan_access = fcov_pmp_region_dchan_access;
    logic fcov_warl_check_pmpcfg; 
    assign fcov_warl_check_pmpcfg = fcov_csr_write &&          (cs_registers_i.g_pmp_registers.g_pmp_csrs[i_region].u_pmp_cfg_csr.wr_data_i !=          {cs_registers_i.csr_wdata_int[(i_region%4)*PMP_CFG_W+:5],           cs_registers_i.csr_wdata_int[(i_region%4)*PMP_CFG_W+7]}); 
    logic unused_fcov_warl_check_pmpcfg; 
    assign unused_fcov_warl_check_pmpcfg = fcov_warl_check_pmpcfg;
      if (i_region > 0) begin : g_region_priority
        assign fcov_pmp_region_ichan_priority[i_region] =
          g_pmp.pmp_i.region_match_all[PMP_I][i_region] &
          ~|g_pmp.pmp_i.region_match_all[PMP_I][i_region-1:0];
        assign fcov_pmp_region_ichan2_priority[i_region] =
          g_pmp.pmp_i.region_match_all[PMP_I2][i_region] &
          ~|g_pmp.pmp_i.region_match_all[PMP_I2][i_region-1:0];
        assign fcov_pmp_region_dchan_priority[i_region] =
          g_pmp.pmp_i.region_match_all[PMP_D][i_region] &
          ~|g_pmp.pmp_i.region_match_all[PMP_D][i_region-1:0];
      end else begin : g_region_highest_priority
        assign fcov_pmp_region_ichan_priority[i_region] =
          g_pmp.pmp_i.region_match_all[PMP_I][i_region];
        assign fcov_pmp_region_ichan2_priority[i_region] =
          g_pmp.pmp_i.region_match_all[PMP_I2][i_region];
        assign fcov_pmp_region_dchan_priority[i_region] =
          g_pmp.pmp_i.region_match_all[PMP_D][i_region];
      end
    end
  end
endmodule
module prim_clock_div #(
  parameter int unsigned Divisor = 2,
  parameter logic ResetValue = 0
) (
  input clk_i,
  input rst_ni,
  input step_down_req_i,  
  output logic step_down_ack_o,  
  input test_en_i,
  output logic clk_o
);
  logic step_down_req;
  assign step_down_req = test_en_i ? '0 : step_down_req_i;
  logic clk_int;
  logic clk_muxed;
  if (Divisor == 2) begin : gen_div2
    logic q_p, q_n;
    prim_flop # (
      .Width(1),
      .ResetValue(ResetValue)
    ) u_div2 (
      .clk_i,
      .rst_ni,
      .d_i(q_n),
      .q_o(q_p)
    );
    prim_clock_inv # (
      .HasScanMode(1'b0)
    ) u_inv (
      .clk_i(q_p),
      .scanmode_i('0),
      .clk_no(q_n)
    );
    logic step_down_nq;
    always_ff @(negedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        step_down_nq <= 1'b0;
      end else begin
        step_down_nq <= step_down_req;
      end
    end
    prim_clock_mux2 #(
      .NoFpgaBufG(1'b1)
    ) u_step_down_mux (
      .clk0_i(q_p),
      .clk1_i(clk_i),
      .sel_i(step_down_nq),
      .clk_o(clk_int)
    );
  assign step_down_ack_o = step_down_nq;
  end else begin : gen_div
    localparam int unsigned ToggleCnt = Divisor / 2;
    localparam int unsigned CntWidth = $clog2(ToggleCnt);
    logic [CntWidth-1:0] cnt;
    logic [CntWidth-1:0] limit;
    assign limit = !step_down_req       ? CntWidth'(ToggleCnt - 1) :
                   (ToggleCnt / 2) == 2 ? '0 : CntWidth'((ToggleCnt / 2) - 1);
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        cnt <= '0;
        clk_int <= ResetValue;
      end else if (cnt >= limit) begin
        cnt <= '0;
        clk_int <= ~clk_muxed;
      end else begin
        cnt <= cnt + 1'b1;
      end
    end
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        step_down_ack_o <= 1'b0;
      end else begin
        step_down_ack_o <= step_down_req;
      end
    end
  end
  prim_clock_mux2 #(
    .NoFpgaBufG(1'b1)
  ) u_clk_mux (
    .clk0_i(clk_int),
    .clk1_i(clk_i),
    .sel_i('0),
    .clk_o(clk_muxed)
  );
  prim_clock_buf u_clk_div_buf (
    .clk_i(clk_muxed),
    .clk_o
  );
endmodule
module prim_rst_sync #(
  parameter bit ActiveHigh = 1'b 0,
  parameter bit SkipScan   = 1'b 0
) (
  input        clk_i,
  input        d_i,  
  output logic q_o,  
  input                        scan_rst_ni,
  input prim_mubi_pkg::mubi4_t scanmode_i
);
  logic async_rst_n, scan_rst;
  logic rst_sync;
  if (ActiveHigh == 1'b 1) begin : g_rst_inv
    assign async_rst_n = ~d_i;
    assign scan_rst    = ~scan_rst_ni;
  end else begin : g_rst_direct
    assign async_rst_n = d_i;
    assign scan_rst    = scan_rst_ni;
  end
  prim_flop_2sync #(
    .Width        (1),
    .ResetValue   (ActiveHigh)
  ) u_sync (
    .clk_i,
    .rst_ni (async_rst_n),
    .d_i    (!ActiveHigh),  
    .q_o    (rst_sync   )
  );
  if (SkipScan) begin : g_skip_scan
    logic  unused_scan;
    assign unused_scan = ^{scan_rst, scanmode_i};
    assign q_o = rst_sync;
  end else begin : g_scan_mux
    prim_clock_mux2 #(
      .NoFpgaBufG(1'b1)
    ) u_scan_mux (
      .clk0_i(rst_sync                                         ),
      .clk1_i(scan_rst                                         ),
      .sel_i (prim_mubi_pkg::mubi4_test_true_strict(scanmode_i)),
      .clk_o (q_o                                              )
    );
  end
endmodule : prim_rst_sync
module prim_ram_1p_scr import prim_ram_1p_pkg::*; #(
  parameter  int Depth               = 16*1024,  
  parameter  int InstDepth           = Depth,
  parameter  int Width               = 32,  
  parameter  int DataBitsPerMask     = 8,  
  parameter  bit EnableParity        = 1,  
  parameter  int NumPrinceRoundsHalf = 3,
  parameter  int NumDiffRounds       = 0,
  parameter  int DiffWidth           = DataBitsPerMask,
  parameter  int NumAddrScrRounds    = 2,
  parameter  bit ReplicateKeyStream  = 1'b0,
  localparam int AddrWidth           = prim_util_pkg::vbits(Depth),
  localparam int NumParScr           = (ReplicateKeyStream) ? 1 : (Width + 63) / 64,
  localparam int NumParKeystr        = (ReplicateKeyStream) ? (Width + 63) / 64 : 1,
  localparam int DataKeyWidth        = 128,
  localparam int NonceWidth          = 64 * NumParScr,
  localparam int NumRamInst          = prim_util_pkg::ceil_div(Depth, InstDepth)
) (
  input                                    clk_i,
  input                                    rst_ni,
  input                                    key_valid_i,
  input        [DataKeyWidth-1:0]          key_i,
  input        [NonceWidth-1:0]            nonce_i,
  input                                    req_i,
  output logic                             gnt_o,
  input                                    write_i,
  input        [AddrWidth-1:0]             addr_i,
  input        [Width-1:0]                 wdata_i,
  input        [Width-1:0]                 wmask_i,   
  input                                    intg_error_i,
  output logic [Width-1:0]                 rdata_o,
  output logic                             rvalid_o,  
  output logic [1:0]                       rerror_o,  
  output logic [AddrWidth-1:0]             raddr_o,   
  input  ram_1p_cfg_req_t [NumRamInst-1:0] cfg_i,
  output ram_1p_cfg_rsp_t [NumRamInst-1:0] cfg_o,
  output logic                             wr_collision_o,
  output logic                             write_pending_o,
  output logic                             alert_o
);
  import prim_mubi_pkg::mubi4_t;
  import prim_mubi_pkg::mubi4_and_hi;
  import prim_mubi_pkg::mubi4_bool_to_mubi;
  import prim_mubi_pkg::mubi4_or_hi;
  import prim_mubi_pkg::mubi4_test_invalid;
  import prim_mubi_pkg::mubi4_test_true_loose;
  import prim_mubi_pkg::MuBi4True;
  import prim_mubi_pkg::MuBi4False;
  import prim_mubi_pkg::MuBi4Width;
  mubi4_t read_en, read_en_buf;
  logic   read_en_b;
  mubi4_t write_en_d, write_en_buf_d, write_en_q;
  logic   write_en_b;
  logic [MuBi4Width-1:0] read_en_b_buf, write_en_buf_b_d;
  assign gnt_o = req_i & key_valid_i;
  assign read_en = mubi4_bool_to_mubi(gnt_o & ~write_i);
  assign write_en_d = mubi4_bool_to_mubi(gnt_o & write_i);
  prim_buf #(
    .Width(MuBi4Width)
  ) u_read_en_buf (
    .in_i (read_en),
    .out_o(read_en_b_buf)
  );
  assign read_en_buf = mubi4_t'(read_en_b_buf);
  prim_buf #(
    .Width(MuBi4Width)
  ) u_write_en_d_buf (
    .in_i (write_en_d),
    .out_o(write_en_buf_b_d)
  );
  assign write_en_buf_d = mubi4_t'(write_en_buf_b_d);
  mubi4_t write_pending_q;
  mubi4_t addr_collision_d, addr_collision_q;
  logic [AddrWidth-1:0] addr_scr;
  logic [AddrWidth-1:0] waddr_scr_q;
  mubi4_t addr_match;
  logic [MuBi4Width-1:0] addr_match_buf;
  assign addr_match = (addr_scr == waddr_scr_q) ? MuBi4True : MuBi4False;
  prim_buf #(
    .Width(MuBi4Width)
  ) u_addr_match_buf (
    .in_i (addr_match),
    .out_o(addr_match_buf)
  );
  assign addr_collision_d = mubi4_and_hi(mubi4_and_hi(mubi4_or_hi(write_en_q,
      write_pending_q), read_en_buf), mubi4_t'(addr_match_buf));
  logic intg_error_buf, intg_error_w_q;
  prim_buf u_intg_error (
    .in_i(intg_error_i),
    .out_o(intg_error_buf)
  );
  logic macro_req;
  assign macro_req   = ~intg_error_w_q & ~intg_error_buf &
      mubi4_test_true_loose(mubi4_or_hi(mubi4_or_hi(read_en_buf, write_en_q), write_pending_q));
  logic macro_write;
  assign macro_write = mubi4_test_true_loose(mubi4_or_hi(write_en_q, write_pending_q)) &
    ~mubi4_test_true_loose(read_en_buf) & ~intg_error_w_q;
  logic rw_collision;
  assign rw_collision = mubi4_test_true_loose(mubi4_and_hi(write_en_q, read_en_buf));
  assign write_pending_o = macro_write | mubi4_test_true_loose(write_en_buf_d);
  assign wr_collision_o = mubi4_test_true_loose(addr_collision_q);
  logic [AddrWidth-1:0] addr_mux;
  assign addr_mux = (mubi4_test_true_loose(read_en_buf)) ? addr_scr : waddr_scr_q;
  if (NumAddrScrRounds > 0) begin : gen_addr_scr
    logic [AddrWidth-1:0] addr_scr_nonce;
    assign addr_scr_nonce = nonce_i[NonceWidth - AddrWidth +: AddrWidth];
    prim_subst_perm #(
      .DataWidth ( AddrWidth        ),
      .NumRounds ( NumAddrScrRounds ),
      .Decrypt   ( 0                )
    ) u_prim_subst_perm (
      .data_i ( addr_i         ),
      .key_i  ( addr_scr_nonce ),
      .data_o ( addr_scr       )
    );
  end else begin : gen_no_addr_scr
    assign addr_scr = addr_i;
  end
  logic [AddrWidth-1:0] raddr_q;
  assign raddr_o = raddr_q;
  localparam int DataNonceWidth = 64 - AddrWidth;
  logic [NumParScr*64-1:0] keystream;
  logic [NumParScr-1:0][DataNonceWidth-1:0] data_scr_nonce;
  for (genvar k = 0; k < NumParScr; k++) begin : gen_par_scr
    assign data_scr_nonce[k] = nonce_i[k * DataNonceWidth +: DataNonceWidth];
    prim_prince #(
      .DataWidth      (64),
      .KeyWidth       (128),
      .NumRoundsHalf  (NumPrinceRoundsHalf),
      .UseOldKeySched (1'b0),
      .HalfwayDataReg (1'b1),  
      .HalfwayKeyReg  (1'b0)   
    ) u_prim_prince (
      .clk_i,
      .rst_ni,
      .valid_i ( gnt_o ),
      .data_i  ( {data_scr_nonce[k], addr_i} ),
      .key_i,
      .dec_i   ( 1'b0 ),
      .data_o  ( keystream[k * 64 +: 64] ),
      .valid_o ( )
    );
    if (k == NumParKeystr-1 && (Width % 64) > 0) begin : gen_unread_last
      localparam int UnusedWidth = 64 - (Width % 64);
      logic [UnusedWidth-1:0] unused_keystream;
      assign unused_keystream = keystream[(k+1) * 64 - 1 -: UnusedWidth];
    end
  end
  logic [Width-1:0] keystream_repl;
  assign keystream_repl = Width'({NumParKeystr{keystream}});
  logic [Width-1:0] rdata_scr, rdata;
  logic [Width-1:0] wdata_scr_d, wdata_scr_q, wdata_q;
  for (genvar k = 0; k < (Width + DiffWidth - 1) / DiffWidth; k++) begin : gen_diffuse_data
    localparam int LocalWidth = (Width - k * DiffWidth >= DiffWidth) ? DiffWidth :
                                                                       (Width - k * DiffWidth);
    logic [LocalWidth-1:0] wdata_xor;
    assign wdata_xor = wdata_q[k*DiffWidth +: LocalWidth] ^
                       keystream_repl[k*DiffWidth +: LocalWidth];
    prim_subst_perm #(
      .DataWidth ( LocalWidth       ),
      .NumRounds ( NumDiffRounds ),
      .Decrypt   ( 0                )
    ) u_prim_subst_perm_enc (
      .data_i ( wdata_xor ),
      .key_i  ( '0        ),
      .data_o ( wdata_scr_d[k*DiffWidth +: LocalWidth] )
    );
    logic [LocalWidth-1:0] rdata_xor;
    prim_subst_perm #(
      .DataWidth ( LocalWidth       ),
      .NumRounds ( NumDiffRounds ),
      .Decrypt   ( 1                )
    ) u_prim_subst_perm_dec (
      .data_i ( rdata_scr[k*DiffWidth +: LocalWidth] ),
      .key_i  ( '0        ),
      .data_o ( rdata_xor )
    );
    assign rdata[k*DiffWidth +: LocalWidth] = rdata_xor ^
                                              keystream_repl[k*DiffWidth +: LocalWidth];
  end
  mubi4_t write_scr_pending_d;
  assign write_scr_pending_d = (macro_write)  ? MuBi4False :
                               (rw_collision) ? MuBi4True :
                                                write_pending_q;
  logic [Width-1:0] wdata_scr;
  assign wdata_scr = (mubi4_test_true_loose(write_pending_q)) ? wdata_scr_q : wdata_scr_d;
  mubi4_t rvalid_q;
  logic intg_error_r_q;
  logic [Width-1:0] wmask_q;
  always_comb begin : p_forward_mux
    rdata_o = '0;
    rvalid_o = 1'b0;
    if (!intg_error_r_q && mubi4_test_true_loose(rvalid_q)) begin
      rvalid_o = 1'b1;
      if (mubi4_test_true_loose(addr_collision_q)) begin
        for (int k = 0; k < Width; k++) begin
          if (wmask_q[k]) begin
            rdata_o[k] = wdata_q[k];
          end else begin
            rdata_o[k] = rdata[k];
          end
        end
      end else begin
        rdata_o = rdata;
      end
    end
  end
  logic ram_alert;
  assign alert_o = mubi4_test_invalid(write_en_q) | mubi4_test_invalid(addr_collision_q) |
                   mubi4_test_invalid(write_pending_q) | mubi4_test_invalid(rvalid_q) |
                   ram_alert;
  prim_flop #(
    .Width(MuBi4Width),
    .ResetValue(MuBi4Width'(MuBi4False))
  ) u_write_en_flop (
    .clk_i,
    .rst_ni,
    .d_i(MuBi4Width'(write_en_buf_d)),
    .q_o({write_en_q})
  );
  prim_flop #(
    .Width(MuBi4Width),
    .ResetValue(MuBi4Width'(MuBi4False))
  ) u_addr_collision_flop (
    .clk_i,
    .rst_ni,
    .d_i(MuBi4Width'(addr_collision_d)),
    .q_o({addr_collision_q})
  );
  prim_flop #(
    .Width(MuBi4Width),
    .ResetValue(MuBi4Width'(MuBi4False))
  ) u_write_pending_flop (
    .clk_i,
    .rst_ni,
    .d_i(MuBi4Width'(write_scr_pending_d)),
    .q_o({write_pending_q})
  );
  prim_flop #(
    .Width(MuBi4Width),
    .ResetValue(MuBi4Width'(MuBi4False))
  ) u_rvalid_flop (
    .clk_i,
    .rst_ni,
    .d_i(MuBi4Width'(read_en_buf)),
    .q_o({rvalid_q})
  );
  assign read_en_b = mubi4_test_true_loose(read_en_buf);
  assign write_en_b = mubi4_test_true_loose(write_en_buf_d);
  always_ff @(posedge clk_i or negedge rst_ni) begin : p_wdata_buf
    if (!rst_ni) begin
      intg_error_r_q      <= 1'b0;
      intg_error_w_q      <= 1'b0;
      raddr_q             <= '0;
      waddr_scr_q         <= '0;
      wmask_q             <= '0;
      wdata_q             <= '0;
      wdata_scr_q         <= '0;
    end else begin
      intg_error_r_q      <= intg_error_buf;
      if (read_en_b) begin
        raddr_q <= addr_i;
      end
      if (write_en_b) begin
        waddr_scr_q    <= addr_scr;
        wmask_q        <= wmask_i;
        wdata_q        <= wdata_i;
        intg_error_w_q <= intg_error_buf;
      end
      if (rw_collision) begin
        wdata_scr_q <= wdata_scr_d;
      end
    end
  end
  prim_ram_1p_adv #(
    .Depth(Depth),
    .InstDepth(InstDepth),
    .Width(Width),
    .DataBitsPerMask(DataBitsPerMask),
    .EnableECC(1'b0),
    .EnableParity(EnableParity),
    .EnableInputPipeline(1'b0),
    .EnableOutputPipeline(1'b0)
  ) u_prim_ram_1p_adv (
    .clk_i,
    .rst_ni,
    .req_i    ( macro_req   ),
    .write_i  ( macro_write ),
    .addr_i   ( addr_mux    ),
    .wdata_i  ( wdata_scr   ),
    .wmask_i  ( wmask_q     ),
    .rdata_o  ( rdata_scr   ),
    .rvalid_o ( ),
    .rerror_o,
    .cfg_i,
    .cfg_o,
    .alert_o  ( ram_alert   )
  );
  export "DPI-C" function simutil_get_scramble_key;
  function int simutil_get_scramble_key(output bit [127:0] val);
    int valid;
    valid = key_valid_i && DataKeyWidth == 128 ? 1 : 0;
    if (valid == 1) val = key_i;
    return valid;
  endfunction
  export "DPI-C" function simutil_get_scramble_nonce;
  function int simutil_get_scramble_nonce(output bit [319:0] nonce);
    int valid;
    valid = key_valid_i && NonceWidth <= 320 ? 1 : 0;
    if (valid == 1) begin
       nonce = '0;
       nonce[NonceWidth-1:0] = nonce_i;
    end
    return valid;
  endfunction
endmodule : prim_ram_1p_scr
module ibex_register_file_ff #(
  parameter bit                   RV32E             = 0,
  parameter int unsigned          DataWidth         = 32,
  parameter bit                   DummyInstructions = 0,
  parameter logic [DataWidth-1:0] WordZeroVal       = '0
) (
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic                 test_en_i,
  input  logic                 dummy_instr_id_i,
  input  logic                 dummy_instr_wb_i,
  input  logic [4:0]           raddr_a_i,
  output logic [DataWidth-1:0] rdata_a_o,
  input  logic [4:0]           raddr_b_i,
  output logic [DataWidth-1:0] rdata_b_o,
  input  logic [4:0]           waddr_a_i,
  input  logic [DataWidth-1:0] wdata_a_i,
  input  logic                 we_a_i
);
  localparam int unsigned ADDR_WIDTH = RV32E ? 4 : 5;
  localparam int unsigned NUM_WORDS  = 2**ADDR_WIDTH;
  logic [DataWidth-1:0] rf_reg   [NUM_WORDS];
  logic [NUM_WORDS-1:0] we_a_dec;
  always_comb begin : we_a_decoder
    for (int unsigned i = 0; i < NUM_WORDS; i++) begin
      we_a_dec[i] = (waddr_a_i == 5'(i)) ? we_a_i : 1'b0;
    end
  end
  logic unused_strobe;
  assign unused_strobe = we_a_dec[0];  
  for (genvar i = 1; i < NUM_WORDS; i++) begin : g_rf_flops
    logic [DataWidth-1:0] rf_reg_q;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        rf_reg_q <= WordZeroVal;
      end else if (we_a_dec[i]) begin
        rf_reg_q <= wdata_a_i;
      end
    end
    assign rf_reg[i] = rf_reg_q;
  end
  if (DummyInstructions) begin : g_dummy_r0
    logic                 we_r0_dummy;
    logic [DataWidth-1:0] rf_r0_q;
    assign we_r0_dummy = we_a_i & dummy_instr_wb_i;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        rf_r0_q <= WordZeroVal;
      end else if (we_r0_dummy) begin
        rf_r0_q <= wdata_a_i;
      end
    end
    assign rf_reg[0] = dummy_instr_id_i ? rf_r0_q : WordZeroVal;
  end else begin : g_normal_r0
    logic unused_dummy_instr;
    assign unused_dummy_instr = dummy_instr_id_i ^ dummy_instr_wb_i;
    assign rf_reg[0] = WordZeroVal;
  end
  assign rdata_a_o = rf_reg[raddr_a_i];
  assign rdata_b_o = rf_reg[raddr_b_i];
  logic unused_test_en;
  assign unused_test_en = test_en_i;
endmodule
module ibex_register_file_fpga #(
    parameter bit                   RV32E             = 0,
    parameter int unsigned          DataWidth         = 32,
    parameter bit                   DummyInstructions = 0,
    parameter logic [DataWidth-1:0] WordZeroVal       = '0
) (
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic                 test_en_i,
  input  logic                 dummy_instr_id_i,
  input  logic                 dummy_instr_wb_i,
  input  logic [          4:0] raddr_a_i,
  output logic [DataWidth-1:0] rdata_a_o,
  input  logic [          4:0] raddr_b_i,
  output logic [DataWidth-1:0] rdata_b_o,
  input  logic [          4:0] waddr_a_i,
  input  logic [DataWidth-1:0] wdata_a_i,
  input  logic                 we_a_i
);
  localparam int ADDR_WIDTH = RV32E ? 4 : 5;
  localparam int NUM_WORDS = 2 ** ADDR_WIDTH;
  logic [DataWidth-1:0] mem[NUM_WORDS];
  logic we;  
  logic [DataWidth-1:0] mem_o_a, mem_o_b;
  assign rdata_a_o = (raddr_a_i == '0) ? WordZeroVal : mem[raddr_a_i];
  assign rdata_b_o = (raddr_b_i == '0) ? WordZeroVal : mem[raddr_b_i];
  assign we = (waddr_a_i == '0) ? 1'b0 : we_a_i;
  always @(posedge clk_i) begin : sync_write
    if (we == 1'b1) begin
      mem[waddr_a_i] <= wdata_a_i;
    end
  end : sync_write
  initial begin
    for (int k = 0; k < NUM_WORDS; k++) begin
      mem[k] = WordZeroVal;
    end
  end
  logic unused_rst_ni;
  assign unused_rst_ni = rst_ni;
  logic unused_dummy_instr;
  assign unused_dummy_instr = dummy_instr_id_i ^ dummy_instr_wb_i;
  logic unused_test_en;
  assign unused_test_en = test_en_i;
endmodule
module ibex_register_file_latch #(
  parameter bit                   RV32E             = 0,
  parameter int unsigned          DataWidth         = 32,
  parameter bit                   DummyInstructions = 0,
  parameter logic [DataWidth-1:0] WordZeroVal       = '0
) (
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic                 test_en_i,
  input  logic                 dummy_instr_id_i,
  input  logic                 dummy_instr_wb_i,
  input  logic [4:0]           raddr_a_i,
  output logic [DataWidth-1:0] rdata_a_o,
  input  logic [4:0]           raddr_b_i,
  output logic [DataWidth-1:0] rdata_b_o,
  input  logic [4:0]           waddr_a_i,
  input  logic [DataWidth-1:0] wdata_a_i,
  input  logic                 we_a_i
);
  localparam int unsigned ADDR_WIDTH = RV32E ? 4 : 5;
  localparam int unsigned NUM_WORDS  = 2**ADDR_WIDTH;
  logic [DataWidth-1:0] mem[NUM_WORDS];
  logic [NUM_WORDS-1:0] waddr_onehot_a;
  logic [NUM_WORDS-1:1] mem_clocks;
  logic [DataWidth-1:0] wdata_a_q;
  logic [ADDR_WIDTH-1:0] raddr_a_int, raddr_b_int, waddr_a_int;
  assign raddr_a_int = raddr_a_i[ADDR_WIDTH-1:0];
  assign raddr_b_int = raddr_b_i[ADDR_WIDTH-1:0];
  assign waddr_a_int = waddr_a_i[ADDR_WIDTH-1:0];
  logic clk_int;
  assign rdata_a_o = mem[raddr_a_int];
  assign rdata_b_o = mem[raddr_b_int];
  prim_clock_gating cg_we_global (
      .clk_i     ( clk_i     ),
      .en_i      ( we_a_i    ),
      .test_en_i ( test_en_i ),
      .clk_o     ( clk_int   )
  );
  always_ff @(posedge clk_int or negedge rst_ni) begin : sample_wdata
    if (!rst_ni) begin
      wdata_a_q   <= WordZeroVal;
    end else begin
      if (we_a_i) begin
        wdata_a_q <= wdata_a_i;
      end
    end
  end
  always_comb begin : wad
    for (int i = 0; i < NUM_WORDS; i++) begin : wad_word_iter
      if (we_a_i && (waddr_a_int == 5'(i))) begin
        waddr_onehot_a[i] = 1'b1;
      end else begin
        waddr_onehot_a[i] = 1'b0;
      end
    end
  end
  logic unused_strobe;
  assign unused_strobe = waddr_onehot_a[0];  
  for (genvar x = 1; x < NUM_WORDS; x++) begin : gen_cg_word_iter
    prim_clock_gating cg_i (
        .clk_i     ( clk_int           ),
        .en_i      ( waddr_onehot_a[x] ),
        .test_en_i ( test_en_i         ),
        .clk_o     ( mem_clocks[x]     )
    );
  end
  for (genvar i = 1; i < NUM_WORDS; i++) begin : g_rf_latches
    always_latch begin
      if (mem_clocks[i]) begin
        mem[i] = wdata_a_q;
      end
    end
  end
  if (DummyInstructions) begin : g_dummy_r0
    logic                 we_r0_dummy;
    logic                 r0_clock;
    logic [DataWidth-1:0] mem_r0;
    assign we_r0_dummy = we_a_i & dummy_instr_wb_i;
    prim_clock_gating cg_i (
        .clk_i     ( clk_int     ),
        .en_i      ( we_r0_dummy ),
        .test_en_i ( test_en_i   ),
        .clk_o     ( r0_clock    )
    );
    always_latch begin : latch_wdata
      if (r0_clock) begin
        mem_r0 = wdata_a_q;
      end
    end
    assign mem[0] = dummy_instr_id_i ? mem_r0 : WordZeroVal;
  end else begin : g_normal_r0
    logic unused_dummy_instr;
    assign unused_dummy_instr = dummy_instr_id_i ^ dummy_instr_wb_i;
    assign mem[0] = WordZeroVal;
  end
  initial begin
    $display("Latch-based register file not supported for Verilator simulation");
    $fatal;
  end
endmodule
module ibex_lockstep import ibex_pkg::*; #(
  parameter int unsigned            LockstepOffset              = 1,
  parameter bit                     PMPEnable                   = 1'b0,
  parameter int unsigned            PMPGranularity              = 0,
  parameter int unsigned            PMPNumRegions               = 4,
  parameter ibex_pkg::pmp_cfg_t     PMPRstCfg[PMP_MAX_REGIONS]  = ibex_pkg::PmpCfgRst,
  parameter logic [PMP_ADDR_MSB:0]  PMPRstAddr[PMP_MAX_REGIONS] = ibex_pkg::PmpAddrRst,
  parameter ibex_pkg::pmp_mseccfg_t PMPRstMsecCfg               = ibex_pkg::PmpMseccfgRst,
  parameter int unsigned            MHPMCounterNum              = 0,
  parameter int unsigned            MHPMCounterWidth            = 40,
  parameter bit                     RV32E                       = 1'b0,
  parameter rv32m_e                 RV32M                       = RV32MFast,
  parameter rv32b_e                 RV32B                       = RV32BNone,
  parameter rv32zc_e                RV32ZC                      = RV32ZcaZcbZcmp,
  parameter bit                     BranchTargetALU             = 1'b0,
  parameter bit                     WritebackStage              = 1'b0,
  parameter bit                     ICache                      = 1'b0,
  parameter bit                     ICacheECC                   = 1'b0,
  parameter bit                     ICacheTweakInfection        = 1'b0,
  parameter int unsigned            BusSizeECC                  = BUS_SIZE,
  parameter int unsigned            TagSizeECC                  = IC_TAG_SIZE,
  parameter int unsigned            LineSizeECC                 = IC_LINE_SIZE,
  parameter bit                     BranchPredictor             = 1'b0,
  parameter bit                     DbgTriggerEn                = 1'b0,
  parameter int unsigned            DbgHwBreakNum               = 1,
  parameter bit                     ResetAll                    = 1'b0,
  parameter lfsr_seed_t             RndCnstLfsrSeed             = RndCnstLfsrSeedDefault,
  parameter lfsr_perm_t             RndCnstLfsrPerm             = RndCnstLfsrPermDefault,
  parameter bit                     SecureIbex                  = 1'b0,
  parameter bit                     DummyInstructions           = 1'b0,
  parameter bit                     RegFileECC                  = 1'b0,
  parameter int unsigned            RegFileDataWidth            = 32,
  parameter int unsigned            RegFileDataEccWidth         = 39,
  parameter regfile_e               RegFile                     = RegFileFF,
  parameter bit                     MemECC                      = 1'b0,
  parameter int unsigned            MemDataWidth                = MemECC ? 32 + 7 : 32,
  parameter int unsigned            DmBaseAddr                  = 32'h1A110000,
  parameter int unsigned            DmAddrMask                  = 32'h00000FFF,
  parameter int unsigned            DmHaltAddr                  = 32'h1A110800,
  parameter int unsigned            DmExceptionAddr             = 32'h1A110808,
  parameter logic [31:0]            CsrMvendorId                = 32'b0,
  parameter logic [31:0]            CsrMimpId                   = 32'b0
) (
  input  logic                         clk_i,
  input  logic                         rst_ni,
  input  logic [31:0]                  hart_id_i,
  input  logic [31:0]                  boot_addr_i,
  input  logic                         instr_req_i,
  input  logic                         instr_gnt_i,
  input  logic                         instr_rvalid_i,
  input  logic [31:0]                  instr_addr_i,
  input  logic [MemDataWidth-1:0]      instr_rdata_i,
  input  logic                         instr_err_i,
  input  logic                         data_req_i,
  input  logic                         data_gnt_i,
  input  logic                         data_rvalid_i,
  input  logic                         data_we_i,
  input  logic [3:0]                   data_be_i,
  input  logic [31:0]                  data_addr_i,
  input  logic [31:0]                  data_wdata_i,
  input  logic [MemDataWidth-1:0]      data_rdata_i,
  input  logic                         data_err_i,
  input  logic [RegFileDataWidth-1:0]  rf_rdata_a_i,
  input  logic [RegFileDataWidth-1:0]  rf_rdata_b_i,
  input  logic [IC_NUM_WAYS-1:0]       ic_tag_req_i,
  input  logic                         ic_tag_write_i,
  input  logic [IC_INDEX_W-1:0]        ic_tag_addr_i,
  input  logic [TagSizeECC-1:0]        ic_tag_wdata_i,
  input  logic [TagSizeECC-1:0]        ic_tag_rdata_i [IC_NUM_WAYS],
  input  logic [IC_NUM_WAYS-1:0]       ic_data_req_i,
  input  logic                         ic_data_write_i,
  input  logic [IC_INDEX_W-1:0]        ic_data_addr_i,
  input  logic [LineSizeECC-1:0]       ic_data_wdata_i,
  input  logic [LineSizeECC-1:0]       ic_data_rdata_i [IC_NUM_WAYS],
  input  logic                         ic_scr_key_valid_i,
  input  logic                         ic_scr_key_req_i,
  input  logic                         irq_software_i,
  input  logic                         irq_timer_i,
  input  logic                         irq_external_i,
  input  logic [14:0]                  irq_fast_i,
  input  logic                         irq_nm_i,
  input  logic                         irq_pending_i,
  input  logic                         debug_req_i,
  input  crash_dump_t                  crash_dump_i,
  input  logic                         double_fault_seen_i,
  input  ibex_mubi_t                   fetch_enable_i,
  input  ibex_mubi_t                   mcounteren_writable_i,
  output logic                         alert_minor_o,
  output logic                         alert_major_internal_o,
  output logic                         alert_major_bus_o,
  input  ibex_mubi_t                   core_busy_i,
  input  logic                         test_en_i,
  input  logic                         scan_rst_ni,
  output ibex_mubi_t                   lockstep_cmp_en_o,
  output logic                         data_req_shadow_o,
  output logic                         data_we_shadow_o,
  output logic [3:0]                   data_be_shadow_o,
  output logic [31:0]                  data_addr_shadow_o,
  output logic [31:0]                  data_wdata_shadow_o,
  output logic [6:0]                   data_wdata_intg_shadow_o,
  output logic                         instr_req_shadow_o,
  output logic [31:0]                  instr_addr_shadow_o
);
  import prim_secded_pkg::SecdedInv3932ZeroWord;
  localparam int unsigned LockstepOffsetW = prim_util_pkg::vbits(LockstepOffset);
  localparam int unsigned OutputsOffset = LockstepOffset + 1;
  logic                       rst_shadow_cnt_err;
  ibex_mubi_t                 rst_shadow_set_d, rst_shadow_set_q;
  logic                       rst_shadow_n;
  ibex_mubi_t                 enable_cmp_d, enable_cmp_q;
  if (LockstepOffset > 1) begin : gen_reset_counter
    logic [LockstepOffsetW-1:0] rst_shadow_cnt;
    prim_count #(
      .Width      (LockstepOffsetW        ),
      .ResetValue (LockstepOffsetW'(1'b0) )
    ) u_rst_shadow_cnt (
      .clk_i              (clk_i                  ),
      .rst_ni             (rst_ni                 ),
      .clr_i              (1'b0                   ),
      .set_i              (1'b0                   ),
      .set_cnt_i          ('0                     ),
      .incr_en_i          (1'b1                   ),
      .decr_en_i          (1'b0                   ),
      .step_i             (LockstepOffsetW'(1'b1) ),
      .commit_i           (1'b1                   ),
      .cnt_o              (rst_shadow_cnt         ),
      .cnt_after_commit_o (                       ),
      .err_o              (rst_shadow_cnt_err     )
    );
    assign rst_shadow_set_d =
      (rst_shadow_cnt >= LockstepOffsetW'(LockstepOffset - 1)) ? IbexMuBiOn : IbexMuBiOff;
    assign enable_cmp_d = rst_shadow_set_q;
  end else begin : gen_no_reset_counter
    assign rst_shadow_set_d = IbexMuBiOn;
    assign rst_shadow_cnt_err = 1'b0;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        enable_cmp_d <= IbexMuBiOff;
      end else begin
        enable_cmp_d <= IbexMuBiOn;
      end
    end
    logic [2:0] unused_bits;
    assign unused_bits = rst_shadow_set_q[3:1];
  end
  prim_flop #(
    .Width(IbexMuBiWidth),
    .ResetValue(IbexMuBiOff)
  ) u_prim_rst_shadow_set_flop (
    .clk_i (clk_i),
    .rst_ni(rst_ni),
    .d_i   (rst_shadow_set_d),
    .q_o   (rst_shadow_set_q)
  );
  prim_flop #(
    .Width(IbexMuBiWidth),
    .ResetValue(IbexMuBiOff)
  ) u_prim_enable_cmp_flop (
    .clk_i (clk_i),
    .rst_ni(rst_ni),
    .d_i   (enable_cmp_d),
    .q_o   (enable_cmp_q)
  );
  prim_clock_mux2 #(
    .NoFpgaBufG(1'b1)
  ) u_prim_rst_shadow_n_mux2 (
    .clk0_i(rst_shadow_set_q[0]),
    .clk1_i(scan_rst_ni),
    .sel_i (test_en_i),
    .clk_o (rst_shadow_n)
  );
  typedef struct packed {
    logic                        instr_gnt;
    logic                        instr_rvalid;
    logic [MemDataWidth-1:0]     instr_rdata;
    logic                        instr_err;
    logic                        data_gnt;
    logic                        data_rvalid;
    logic [MemDataWidth-1:0]     data_rdata;
    logic                        data_err;
    logic [RegFileDataWidth-1:0] rf_rdata_a;
    logic [RegFileDataWidth-1:0] rf_rdata_b;
    logic                        irq_software;
    logic                        irq_timer;
    logic                        irq_external;
    logic [14:0]                 irq_fast;
    logic                        irq_nm;
    logic                        debug_req;
    ibex_mubi_t                  fetch_enable;
    ibex_mubi_t                  mcounteren_writable;
    logic                        ic_scr_key_valid;
  } delayed_inputs_t;
  delayed_inputs_t [LockstepOffset-1:0] shadow_inputs_q;
  delayed_inputs_t                      shadow_inputs_in;
  logic [TagSizeECC-1:0]                shadow_tag_rdata_delayed [IC_NUM_WAYS];
  logic [LineSizeECC-1:0]               shadow_data_rdata_delayed [IC_NUM_WAYS];
  if (LockstepOffset > 1) begin : gen_multi_cycle_delay
    logic [TagSizeECC-1:0]  shadow_tag_rdata_q [IC_NUM_WAYS][LockstepOffset];
    logic [LineSizeECC-1:0] shadow_data_rdata_q [IC_NUM_WAYS][LockstepOffset];
    assign shadow_tag_rdata_delayed = shadow_tag_rdata_q[0];
    assign shadow_data_rdata_delayed = shadow_data_rdata_q[0];
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        for (int unsigned i = 0; i < LockstepOffset; i++) begin
          shadow_inputs_q[i]     <= delayed_inputs_t'('0);
          shadow_tag_rdata_q[i]  <= '{default: 0};
          shadow_data_rdata_q[i] <= '{default: 0};
        end
      end else begin
        for (int unsigned i = 0; i < LockstepOffset - 1; i++) begin
          shadow_inputs_q[i]     <= shadow_inputs_q[i+1];
          shadow_tag_rdata_q[i]  <= shadow_tag_rdata_q[i+1];
          shadow_data_rdata_q[i] <= shadow_data_rdata_q[i+1];
        end
        shadow_inputs_q[LockstepOffset-1]     <= shadow_inputs_in;
        shadow_tag_rdata_q[LockstepOffset-1]  <= ic_tag_rdata_i;
        shadow_data_rdata_q[LockstepOffset-1] <= ic_data_rdata_i;
      end
    end
  end else begin : gen_single_cycle_delay
    logic [TagSizeECC-1:0]                shadow_tag_rdata_q [IC_NUM_WAYS];
    logic [LineSizeECC-1:0]               shadow_data_rdata_q [IC_NUM_WAYS];
    assign shadow_tag_rdata_delayed = shadow_tag_rdata_q;
    assign shadow_data_rdata_delayed = shadow_data_rdata_q;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        shadow_inputs_q     <= delayed_inputs_t'('0);
        shadow_tag_rdata_q  <= '{default: 0};
        shadow_data_rdata_q <= '{default: 0};
      end else begin
        shadow_inputs_q     <= shadow_inputs_in;
        shadow_tag_rdata_q  <= ic_tag_rdata_i;
        shadow_data_rdata_q <= ic_data_rdata_i;
      end
    end
  end
  assign shadow_inputs_in.instr_gnt           = instr_gnt_i;
  assign shadow_inputs_in.instr_rvalid        = instr_rvalid_i;
  assign shadow_inputs_in.instr_rdata         = instr_rdata_i;
  assign shadow_inputs_in.instr_err           = instr_err_i;
  assign shadow_inputs_in.data_gnt            = data_gnt_i;
  assign shadow_inputs_in.data_rvalid         = data_rvalid_i;
  assign shadow_inputs_in.data_rdata          = data_rdata_i;
  assign shadow_inputs_in.data_err            = data_err_i;
  assign shadow_inputs_in.rf_rdata_a          = rf_rdata_a_i;
  assign shadow_inputs_in.rf_rdata_b          = rf_rdata_b_i;
  assign shadow_inputs_in.irq_software        = irq_software_i;
  assign shadow_inputs_in.irq_timer           = irq_timer_i;
  assign shadow_inputs_in.irq_external        = irq_external_i;
  assign shadow_inputs_in.irq_fast            = irq_fast_i;
  assign shadow_inputs_in.irq_nm              = irq_nm_i;
  assign shadow_inputs_in.debug_req           = debug_req_i;
  assign shadow_inputs_in.fetch_enable        = fetch_enable_i;
  assign shadow_inputs_in.mcounteren_writable = mcounteren_writable_i;
  assign shadow_inputs_in.ic_scr_key_valid    = ic_scr_key_valid_i;
  typedef struct packed {
    logic                    instr_req;
    logic [31:0]             instr_addr;
    logic                    data_req;
    logic                    data_we;
    logic [3:0]              data_be;
    logic [31:0]             data_addr;
    logic [31:0]             data_wdata;
    logic [IC_NUM_WAYS-1:0]  ic_tag_req;
    logic                    ic_tag_write;
    logic [IC_INDEX_W-1:0]   ic_tag_addr;
    logic [TagSizeECC-1:0]   ic_tag_wdata;
    logic [IC_NUM_WAYS-1:0]  ic_data_req;
    logic                    ic_data_write;
    logic [IC_INDEX_W-1:0]   ic_data_addr;
    logic [LineSizeECC-1:0]  ic_data_wdata;
    logic                    ic_scr_key_req;
    logic                    irq_pending;
    crash_dump_t             crash_dump;
    logic                    double_fault_seen;
    ibex_mubi_t              core_busy;
  } delayed_outputs_t;
  delayed_outputs_t [OutputsOffset-1:0]  core_outputs_q;
  delayed_outputs_t                      core_outputs_in;
  delayed_outputs_t                      shadow_outputs_d, shadow_outputs_q;
  assign core_outputs_in.instr_req           = instr_req_i;
  assign core_outputs_in.instr_addr          = instr_addr_i;
  assign core_outputs_in.data_req            = data_req_i;
  assign core_outputs_in.data_we             = data_we_i;
  assign core_outputs_in.data_be             = data_be_i;
  assign core_outputs_in.data_addr           = data_addr_i;
  assign core_outputs_in.data_wdata          = data_wdata_i;
  assign core_outputs_in.ic_tag_req          = ic_tag_req_i;
  assign core_outputs_in.ic_tag_write        = ic_tag_write_i;
  assign core_outputs_in.ic_tag_addr         = ic_tag_addr_i;
  assign core_outputs_in.ic_tag_wdata        = ic_tag_wdata_i;
  assign core_outputs_in.ic_data_req         = ic_data_req_i;
  assign core_outputs_in.ic_data_write       = ic_data_write_i;
  assign core_outputs_in.ic_data_addr        = ic_data_addr_i;
  assign core_outputs_in.ic_data_wdata       = ic_data_wdata_i;
  assign core_outputs_in.ic_scr_key_req      = ic_scr_key_req_i;
  assign core_outputs_in.irq_pending         = irq_pending_i;
  assign core_outputs_in.crash_dump          = crash_dump_i;
  assign core_outputs_in.double_fault_seen   = double_fault_seen_i;
  assign core_outputs_in.core_busy           = core_busy_i;
  always_ff @(posedge clk_i) begin
    for (int unsigned i = 0; i < OutputsOffset - 1; i++) begin
      core_outputs_q[i] <= core_outputs_q[i+1];
    end
    core_outputs_q[OutputsOffset-1] <= core_outputs_in;
  end
  logic [RegFileDataEccWidth-1:0] shadow_rf_wdata_wb_ecc;
  logic [4:0]                     shadow_rf_raddr_a;
  logic [4:0]                     shadow_rf_raddr_b;
  logic [4:0]                     shadow_rf_waddr_wb;
  logic                           shadow_rf_we_wb;
  logic                           shadow_dummy_instr_id;
  logic                           shadow_dummy_instr_wb;
  logic [6:0]                     shadow_data_wdata_intg;
  logic shadow_alert_minor, shadow_alert_major_internal, shadow_alert_major_bus;
  logic [RegFileDataEccWidth - RegFileDataWidth - 1:0] shadow_rf_rdata_a_intg;
  logic [RegFileDataEccWidth - RegFileDataWidth - 1:0] shadow_rf_rdata_b_intg;
  ibex_core #(
    .PMPEnable            ( PMPEnable            ),
    .PMPGranularity       ( PMPGranularity       ),
    .PMPNumRegions        ( PMPNumRegions        ),
    .PMPRstCfg            ( PMPRstCfg            ),
    .PMPRstAddr           ( PMPRstAddr           ),
    .PMPRstMsecCfg        ( PMPRstMsecCfg        ),
    .MHPMCounterNum       ( MHPMCounterNum       ),
    .MHPMCounterWidth     ( MHPMCounterWidth     ),
    .RV32E                ( RV32E                ),
    .RV32M                ( RV32M                ),
    .RV32B                ( RV32B                ),
    .RV32ZC               ( RV32ZC               ),
    .BranchTargetALU      ( BranchTargetALU      ),
    .ICache               ( ICache               ),
    .ICacheECC            ( ICacheECC            ),
    .ICacheTweakInfection ( ICacheTweakInfection ),
    .BusSizeECC           ( BusSizeECC           ),
    .TagSizeECC           ( TagSizeECC           ),
    .LineSizeECC          ( LineSizeECC          ),
    .BranchPredictor      ( BranchPredictor      ),
    .DbgTriggerEn         ( DbgTriggerEn         ),
    .DbgHwBreakNum        ( DbgHwBreakNum        ),
    .WritebackStage       ( WritebackStage       ),
    .ResetAll             ( ResetAll             ),
    .RndCnstLfsrSeed      ( RndCnstLfsrSeed      ),
    .RndCnstLfsrPerm      ( RndCnstLfsrPerm      ),
    .SecureIbex           ( SecureIbex           ),
    .DummyInstructions    ( DummyInstructions    ),
    .RegFileECC           ( RegFileECC           ),
    .RegFileDataWidth     ( RegFileDataEccWidth  ),
    .MemECC               ( MemECC               ),
    .MemDataWidth         ( MemDataWidth         ),
    .DmBaseAddr           ( DmBaseAddr           ),
    .DmAddrMask           ( DmAddrMask           ),
    .DmHaltAddr           ( DmHaltAddr           ),
    .DmExceptionAddr      ( DmExceptionAddr      ),
    .CsrMvendorId         ( CsrMvendorId         ),
    .CsrMimpId            ( CsrMimpId            )
  ) u_shadow_core (
    .clk_i               (clk_i),
    .rst_ni              (rst_shadow_n),
    .hart_id_i           (hart_id_i),
    .boot_addr_i         (boot_addr_i),
    .instr_req_o         (shadow_outputs_d.instr_req),
    .instr_gnt_i         (shadow_inputs_q[0].instr_gnt),
    .instr_rvalid_i      (shadow_inputs_q[0].instr_rvalid),
    .instr_addr_o        (shadow_outputs_d.instr_addr),
    .instr_rdata_i       (shadow_inputs_q[0].instr_rdata),
    .instr_err_i         (shadow_inputs_q[0].instr_err),
    .data_req_o          (shadow_outputs_d.data_req),
    .data_gnt_i          (shadow_inputs_q[0].data_gnt),
    .data_rvalid_i       (shadow_inputs_q[0].data_rvalid),
    .data_we_o           (shadow_outputs_d.data_we),
    .data_be_o           (shadow_outputs_d.data_be),
    .data_addr_o         (shadow_outputs_d.data_addr),
    .data_wdata_o        ({shadow_data_wdata_intg, shadow_outputs_d.data_wdata}),
    .data_rdata_i        (shadow_inputs_q[0].data_rdata),
    .data_err_i          (shadow_inputs_q[0].data_err),
    .dummy_instr_id_o    (shadow_dummy_instr_id),
    .dummy_instr_wb_o    (shadow_dummy_instr_wb),
    .rf_raddr_a_o        (shadow_rf_raddr_a),
    .rf_raddr_b_o        (shadow_rf_raddr_b),
    .rf_waddr_wb_o       (shadow_rf_waddr_wb),
    .rf_we_wb_o          (shadow_rf_we_wb),
    .rf_wdata_wb_ecc_o   (shadow_rf_wdata_wb_ecc),
    .rf_rdata_a_ecc_i    ({shadow_rf_rdata_a_intg, shadow_inputs_q[0].rf_rdata_a}),
    .rf_rdata_b_ecc_i    ({shadow_rf_rdata_b_intg, shadow_inputs_q[0].rf_rdata_b}),
    .ic_tag_req_o        (shadow_outputs_d.ic_tag_req),
    .ic_tag_write_o      (shadow_outputs_d.ic_tag_write),
    .ic_tag_addr_o       (shadow_outputs_d.ic_tag_addr),
    .ic_tag_wdata_o      (shadow_outputs_d.ic_tag_wdata),
    .ic_tag_rdata_i      (shadow_tag_rdata_delayed),
    .ic_data_req_o       (shadow_outputs_d.ic_data_req),
    .ic_data_write_o     (shadow_outputs_d.ic_data_write),
    .ic_data_addr_o      (shadow_outputs_d.ic_data_addr),
    .ic_data_wdata_o     (shadow_outputs_d.ic_data_wdata),
    .ic_data_rdata_i     (shadow_data_rdata_delayed),
    .ic_scr_key_valid_i  (shadow_inputs_q[0].ic_scr_key_valid),
    .ic_scr_key_req_o    (shadow_outputs_d.ic_scr_key_req),
    .irq_software_i      (shadow_inputs_q[0].irq_software),
    .irq_timer_i         (shadow_inputs_q[0].irq_timer),
    .irq_external_i      (shadow_inputs_q[0].irq_external),
    .irq_fast_i          (shadow_inputs_q[0].irq_fast),
    .irq_nm_i            (shadow_inputs_q[0].irq_nm),
    .irq_pending_o       (shadow_outputs_d.irq_pending),
    .debug_req_i         (shadow_inputs_q[0].debug_req),
    .crash_dump_o        (shadow_outputs_d.crash_dump),
    .double_fault_seen_o (shadow_outputs_d.double_fault_seen),
    .rvfi_valid                   (),
    .rvfi_order                   (),
    .rvfi_insn                    (),
    .rvfi_trap                    (),
    .rvfi_halt                    (),
    .rvfi_intr                    (),
    .rvfi_mode                    (),
    .rvfi_ixl                     (),
    .rvfi_rs1_addr                (),
    .rvfi_rs2_addr                (),
    .rvfi_rs3_addr                (),
    .rvfi_rs1_rdata               (),
    .rvfi_rs2_rdata               (),
    .rvfi_rs3_rdata               (),
    .rvfi_rd_addr                 (),
    .rvfi_rd_wdata                (),
    .rvfi_pc_rdata                (),
    .rvfi_pc_wdata                (),
    .rvfi_mem_addr                (),
    .rvfi_mem_rmask               (),
    .rvfi_mem_wmask               (),
    .rvfi_mem_rdata               (),
    .rvfi_mem_wdata               (),
    .rvfi_ext_pre_mip             (),
    .rvfi_ext_post_mip            (),
    .rvfi_ext_nmi                 (),
    .rvfi_ext_nmi_int             (),
    .rvfi_ext_debug_req           (),
    .rvfi_ext_debug_mode          (),
    .rvfi_ext_rf_wr_suppress      (),
    .rvfi_ext_mcycle              (),
    .rvfi_ext_mhpmcounters        (),
    .rvfi_ext_mhpmcountersh       (),
    .rvfi_ext_ic_scr_key_valid    (),
    .rvfi_ext_irq_valid           (),
    .rvfi_ext_expanded_insn_valid (),
    .rvfi_ext_expanded_insn       (),
    .rvfi_ext_expanded_insn_last  (),
    .fetch_enable_i         (shadow_inputs_q[0].fetch_enable),
    .mcounteren_writable_i  (shadow_inputs_q[0].mcounteren_writable),
    .alert_minor_o          (shadow_alert_minor),
    .alert_major_internal_o (shadow_alert_major_internal),
    .alert_major_bus_o      (shadow_alert_major_bus),
    .core_busy_o            (shadow_outputs_d.core_busy)
  );
  always_ff @(posedge clk_i) begin
    shadow_outputs_q <= shadow_outputs_d;
  end
  logic [RegFileDataWidth-1:0] unused_shadow_rf_wdata_wb_ecc;
  assign unused_shadow_rf_wdata_wb_ecc = shadow_rf_wdata_wb_ecc[RegFileDataWidth-1:0];
  if (RegFile == RegFileFF) begin : gen_shadow_regfile_ff
    ibex_register_file_ff #(
      .RV32E            (RV32E),
      .DataWidth        (RegFileDataEccWidth - RegFileDataWidth),
      .DummyInstructions(DummyInstructions),
      .WordZeroVal      (SecdedInv3932ZeroWord[RegFileDataEccWidth-1:RegFileDataWidth])
    ) register_file_shadow_i (
      .clk_i            (clk_i),
      .rst_ni           (rst_shadow_n),
      .test_en_i        (test_en_i),
      .dummy_instr_id_i (shadow_dummy_instr_id),
      .dummy_instr_wb_i (shadow_dummy_instr_wb),
      .raddr_a_i        (shadow_rf_raddr_a),
      .rdata_a_o        (shadow_rf_rdata_a_intg),
      .raddr_b_i        (shadow_rf_raddr_b),
      .rdata_b_o        (shadow_rf_rdata_b_intg),
      .waddr_a_i        (shadow_rf_waddr_wb),
      .wdata_a_i        (shadow_rf_wdata_wb_ecc[RegFileDataEccWidth-1:RegFileDataWidth]),
      .we_a_i           (shadow_rf_we_wb)
    );
  end else if (RegFile == RegFileFPGA) begin : gen_regfile_fpga
    ibex_register_file_fpga #(
      .RV32E            (RV32E),
      .DataWidth        (RegFileDataEccWidth - RegFileDataWidth),
      .DummyInstructions(DummyInstructions),
      .WordZeroVal      (SecdedInv3932ZeroWord[RegFileDataEccWidth-1:RegFileDataWidth])
    ) register_file_shadow_i (
      .clk_i            (clk_i),
      .rst_ni           (rst_shadow_n),
      .test_en_i        (test_en_i),
      .dummy_instr_id_i (shadow_dummy_instr_id),
      .dummy_instr_wb_i (shadow_dummy_instr_wb),
      .raddr_a_i        (shadow_rf_raddr_a),
      .rdata_a_o        (shadow_rf_rdata_a_intg),
      .raddr_b_i        (shadow_rf_raddr_b),
      .rdata_b_o        (shadow_rf_rdata_b_intg),
      .waddr_a_i        (shadow_rf_waddr_wb),
      .wdata_a_i        (shadow_rf_wdata_wb_ecc[RegFileDataEccWidth-1:RegFileDataWidth]),
      .we_a_i           (shadow_rf_we_wb)
    );
  end else if (RegFile == RegFileLatch) begin : gen_regfile_latch
    ibex_register_file_latch #(
      .RV32E            (RV32E),
      .DataWidth        (RegFileDataEccWidth - RegFileDataWidth),
      .DummyInstructions(DummyInstructions),
      .WordZeroVal      (SecdedInv3932ZeroWord[RegFileDataEccWidth-1:RegFileDataWidth])
    ) register_file_shadow_i (
      .clk_i            (clk_i),
      .rst_ni           (rst_shadow_n),
      .test_en_i        (test_en_i),
      .dummy_instr_id_i (shadow_dummy_instr_id),
      .dummy_instr_wb_i (shadow_dummy_instr_wb),
      .raddr_a_i        (shadow_rf_raddr_a),
      .rdata_a_o        (shadow_rf_rdata_a_intg),
      .raddr_b_i        (shadow_rf_raddr_b),
      .rdata_b_o        (shadow_rf_rdata_b_intg),
      .waddr_a_i        (shadow_rf_waddr_wb),
      .wdata_a_i        (shadow_rf_wdata_wb_ecc[RegFileDataEccWidth-1:RegFileDataWidth]),
      .we_a_i           (shadow_rf_we_wb)
    );
  end
  logic outputs_mismatch;
  assign outputs_mismatch =
    (enable_cmp_q != IbexMuBiOff) & (shadow_outputs_q != core_outputs_q[0]);
  assign alert_major_internal_o
    = outputs_mismatch | shadow_alert_major_internal | rst_shadow_cnt_err;
  assign alert_major_bus_o      = shadow_alert_major_bus;
  assign alert_minor_o          = shadow_alert_minor;
  assign lockstep_cmp_en_o = enable_cmp_q;
  assign data_req_shadow_o = shadow_outputs_d.data_req;
  assign data_we_shadow_o = shadow_outputs_d.data_we;
  assign data_be_shadow_o = shadow_outputs_d.data_be;
  assign data_addr_shadow_o = shadow_outputs_d.data_addr;
  assign data_wdata_shadow_o = shadow_outputs_d.data_wdata;
  assign data_wdata_intg_shadow_o = shadow_data_wdata_intg;
  assign instr_req_shadow_o = shadow_outputs_d.instr_req;
  assign instr_addr_shadow_o = shadow_outputs_d.instr_addr;
endmodule
module ibex_top import ibex_pkg::*; #(
  parameter bit                     PMPEnable                    = 1'b0,
  parameter int unsigned            PMPGranularity               = 0,
  parameter int unsigned            PMPNumRegions                = 4,
  parameter int unsigned            MHPMCounterNum               = 0,
  parameter int unsigned            MHPMCounterWidth             = 40,
  parameter ibex_pkg::pmp_cfg_t     PMPRstCfg[PMP_MAX_REGIONS]   = ibex_pkg::PmpCfgRst,
  parameter logic [PMP_ADDR_MSB:0]  PMPRstAddr[PMP_MAX_REGIONS]  = ibex_pkg::PmpAddrRst,
  parameter ibex_pkg::pmp_mseccfg_t PMPRstMsecCfg                = ibex_pkg::PmpMseccfgRst,
  parameter bit                     RV32E                        = 1'b0,
  parameter rv32m_e                 RV32M                        = RV32MFast,
  parameter rv32b_e                 RV32B                        = RV32BNone,
  parameter rv32zc_e                RV32ZC                       = RV32ZcaZcbZcmp,
  parameter regfile_e               RegFile                      = RegFileFF,
  parameter bit                     BranchTargetALU              = 1'b0,
  parameter bit                     WritebackStage               = 1'b0,
  parameter bit                     ICache                       = 1'b0,
  parameter bit                     ICacheECC                    = 1'b0,
  parameter bit                     BranchPredictor              = 1'b0,
  parameter bit                     DbgTriggerEn                 = 1'b0,
  parameter int unsigned            DbgHwBreakNum                = 1,
  parameter bit                     SecureIbex                   = 1'b0,
  parameter int unsigned            LockstepOffset               = 1,
  parameter bit                     MemECC                       = SecureIbex,
  parameter int unsigned            MemDataWidth                 = MemECC ? 32 + 7 : 32,
  parameter bit                     ICacheScramble               = 1'b0,
  parameter int unsigned            ICacheScrNumPrinceRoundsHalf = 2,
  parameter bit                     ICacheTweakInfection         = SecureIbex,
  parameter lfsr_seed_t             RndCnstLfsrSeed              = RndCnstLfsrSeedDefault,
  parameter lfsr_perm_t             RndCnstLfsrPerm              = RndCnstLfsrPermDefault,
  parameter int unsigned            DmBaseAddr                   = 32'h1A110000,
  parameter int unsigned            DmAddrMask                   = 32'h00000FFF,
  parameter int unsigned            DmHaltAddr                   = 32'h1A110800,
  parameter int unsigned            DmExceptionAddr              = 32'h1A110808,
  parameter logic [SCRAMBLE_KEY_W-1:0]   RndCnstIbexKey          = RndCnstIbexKeyDefault,
  parameter logic [SCRAMBLE_NONCE_W-1:0] RndCnstIbexNonce        = RndCnstIbexNonceDefault,
  parameter logic [31:0]            CsrMvendorId                 = 32'b0,
  parameter logic [31:0]            CsrMimpId                    = 32'b0
) (
  input  logic                                                         clk_i,
  input  logic                                                         rst_ni,
  input  logic                                                         test_en_i,
  input  prim_ram_1p_pkg::ram_1p_cfg_req_t [ibex_pkg::IC_NUM_WAYS-1:0] ram_cfg_icache_tag_i,
  output prim_ram_1p_pkg::ram_1p_cfg_rsp_t [ibex_pkg::IC_NUM_WAYS-1:0] ram_cfg_icache_tag_o,
  input  prim_ram_1p_pkg::ram_1p_cfg_req_t [ibex_pkg::IC_NUM_WAYS-1:0] ram_cfg_icache_data_i,
  output prim_ram_1p_pkg::ram_1p_cfg_rsp_t [ibex_pkg::IC_NUM_WAYS-1:0] ram_cfg_icache_data_o,
  input  logic [31:0]                                                  hart_id_i,
  input  logic [31:0]                                                  boot_addr_i,
  output logic                                                         instr_req_o,
  input  logic                                                         instr_gnt_i,
  input  logic                                                         instr_rvalid_i,
  output logic [31:0]                                                  instr_addr_o,
  input  logic [31:0]                                                  instr_rdata_i,
  input  logic [6:0]                                                   instr_rdata_intg_i,
  input  logic                                                         instr_err_i,
  output logic                                                         data_req_o,
  input  logic                                                         data_gnt_i,
  input  logic                                                         data_rvalid_i,
  output logic                                                         data_we_o,
  output logic [3:0]                                                   data_be_o,
  output logic [31:0]                                                  data_addr_o,
  output logic [31:0]                                                  data_wdata_o,
  output logic [6:0]                                                   data_wdata_intg_o,
  input  logic [31:0]                                                  data_rdata_i,
  input  logic [6:0]                                                   data_rdata_intg_i,
  input  logic                                                         data_err_i,
  input  logic                                                         irq_software_i,
  input  logic                                                         irq_timer_i,
  input  logic                                                         irq_external_i,
  input  logic [14:0]                                                  irq_fast_i,
  input  logic                                                         irq_nm_i,
  input  logic                                                         scramble_key_valid_i,
  input  logic [SCRAMBLE_KEY_W-1:0]                                    scramble_key_i,
  input  logic [SCRAMBLE_NONCE_W-1:0]                                  scramble_nonce_i,
  output logic                                                         scramble_req_o,
  input  logic                                                         debug_req_i,
  output crash_dump_t                                                  crash_dump_o,
  output logic                                                         double_fault_seen_o,
  output logic                                                        rvfi_valid,
  output logic [63:0]                                                 rvfi_order,
  output logic [31:0]                                                 rvfi_insn,
  output logic                                                        rvfi_trap,
  output logic                                                        rvfi_halt,
  output logic                                                        rvfi_intr,
  output logic [ 1:0]                                                 rvfi_mode,
  output logic [ 1:0]                                                 rvfi_ixl,
  output logic [ 4:0]                                                 rvfi_rs1_addr,
  output logic [ 4:0]                                                 rvfi_rs2_addr,
  output logic [ 4:0]                                                 rvfi_rs3_addr,
  output logic [31:0]                                                 rvfi_rs1_rdata,
  output logic [31:0]                                                 rvfi_rs2_rdata,
  output logic [31:0]                                                 rvfi_rs3_rdata,
  output logic [ 4:0]                                                 rvfi_rd_addr,
  output logic [31:0]                                                 rvfi_rd_wdata,
  output logic [31:0]                                                 rvfi_pc_rdata,
  output logic [31:0]                                                 rvfi_pc_wdata,
  output logic [31:0]                                                 rvfi_mem_addr,
  output logic [ 3:0]                                                 rvfi_mem_rmask,
  output logic [ 3:0]                                                 rvfi_mem_wmask,
  output logic [31:0]                                                 rvfi_mem_rdata,
  output logic [31:0]                                                 rvfi_mem_wdata,
  output logic [31:0]                                                 rvfi_ext_pre_mip,
  output logic [31:0]                                                 rvfi_ext_post_mip,
  output logic                                                        rvfi_ext_nmi,
  output logic                                                        rvfi_ext_nmi_int,
  output logic                                                        rvfi_ext_debug_req,
  output logic                                                        rvfi_ext_debug_mode,
  output logic                                                        rvfi_ext_rf_wr_suppress,
  output logic [63:0]                                                 rvfi_ext_mcycle,
  output logic [31:0]                                                 rvfi_ext_mhpmcounters [10],
  output logic [31:0]                                                 rvfi_ext_mhpmcountersh [10],
  output logic                                                        rvfi_ext_ic_scr_key_valid,
  output logic                                                        rvfi_ext_irq_valid,
  output logic                                                        rvfi_ext_expanded_insn_valid,
  output logic [15:0]                                                 rvfi_ext_expanded_insn,
  output logic                                                        rvfi_ext_expanded_insn_last,
  input  ibex_mubi_t                                                  fetch_enable_i,
  input  ibex_mubi_t                                                  mcounteren_writable_i,
  output logic                                                        alert_minor_o,
  output logic                                                        alert_major_internal_o,
  output logic                                                        alert_major_bus_o,
  output logic                                                        core_sleep_o,
  input logic                                                         scan_rst_ni,
  output ibex_mubi_t                                                  lockstep_cmp_en_o,
  output logic                                                        data_req_shadow_o,
  output logic                                                        data_we_shadow_o,
  output logic [3:0]                                                  data_be_shadow_o,
  output logic [31:0]                                                 data_addr_shadow_o,
  output logic [31:0]                                                 data_wdata_shadow_o,
  output logic [6:0]                                                  data_wdata_intg_shadow_o,
  output logic                                                        instr_req_shadow_o,
  output logic [31:0]                                                 instr_addr_shadow_o
);
  localparam bit          Lockstep              = SecureIbex;
  localparam bit          ResetAll              = Lockstep;
  localparam bit          DummyInstructions     = SecureIbex;
  localparam bit          RegFileECC            = 0;
  localparam bit          RegFileLockstepECC    = Lockstep;
  localparam int unsigned RegFileDataWidth      = 32;
  localparam int unsigned RegFileDataEccWidth   = 32 + 7;
  localparam int unsigned BusSizeECC        = ICacheECC ? (BUS_SIZE + IC_DATA_ECC_SIZE) :
                                                           BUS_SIZE;
  localparam int unsigned LineSizeECC       = BusSizeECC * IC_LINE_BEATS;
  localparam int unsigned TagSizeECC        = ICacheECC ? (IC_TAG_SIZE + IC_TAG_ECC_SIZE) :
                                                           IC_TAG_SIZE;
  localparam int unsigned NumAddrScrRounds  = ICacheScramble ? 2 : 0;
  logic                        clk;
  ibex_mubi_t                  core_busy_d, core_busy_q;
  logic                        clock_en;
  logic                        irq_pending;
  logic                        dummy_instr_id;
  logic                        dummy_instr_wb;
  logic [4:0]                  rf_raddr_a;
  logic [4:0]                  rf_raddr_b;
  logic [4:0]                  rf_waddr_wb;
  logic                        rf_we_wb;
  logic [RegFileDataWidth-1:0] rf_wdata_wb;
  logic [RegFileDataWidth-1:0] rf_rdata_a;
  logic [RegFileDataWidth-1:0] rf_rdata_b;
  logic [MemDataWidth-1:0]     data_wdata_core;
  logic [MemDataWidth-1:0]     data_rdata_core;
  logic [MemDataWidth-1:0]     instr_rdata_core;
  logic [IC_NUM_WAYS-1:0]      ic_tag_req;
  logic                        ic_tag_write;
  logic [IC_INDEX_W-1:0]       ic_tag_addr;
  logic [TagSizeECC-1:0]       ic_tag_wdata;
  logic [TagSizeECC-1:0]       ic_tag_rdata [IC_NUM_WAYS];
  logic [IC_NUM_WAYS-1:0]      ic_data_req;
  logic                        ic_data_write;
  logic [IC_INDEX_W-1:0]       ic_data_addr;
  logic [LineSizeECC-1:0]      ic_data_wdata;
  logic [LineSizeECC-1:0]      ic_data_rdata [IC_NUM_WAYS];
  logic                        ic_scr_key_req;
  logic                        core_alert_major_internal, core_alert_major_bus, core_alert_minor;
  logic                        lockstep_alert_major_internal, lockstep_alert_major_bus;
  logic                        lockstep_alert_minor;
  logic [SCRAMBLE_KEY_W-1:0]   scramble_key_q;
  logic [SCRAMBLE_NONCE_W-1:0] scramble_nonce_q;
  logic                        scramble_key_valid_d, scramble_key_valid_q;
  logic                        scramble_req_d, scramble_req_q;
  ibex_mubi_t                  fetch_enable_buf;
  ibex_mubi_t                  mcounteren_writable_buf;
  if (SecureIbex) begin : g_clock_en_secure
    prim_flop #(
      .Width($bits(ibex_mubi_t)),
      .ResetValue(IbexMuBiOff)
    ) u_prim_core_busy_flop (
      .clk_i (clk_i),
      .rst_ni(rst_ni),
      .d_i   (core_busy_d),
      .q_o   (core_busy_q)
    );
    assign clock_en = (core_busy_q != IbexMuBiOff) | debug_req_i | irq_pending | irq_nm_i;
  end else begin : g_clock_en_non_secure
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        core_busy_q <= IbexMuBiOff;
      end else begin
        core_busy_q <= core_busy_d;
      end
    end
    assign clock_en = core_busy_q[0] | debug_req_i | irq_pending | irq_nm_i;
    logic unused_core_busy;
    assign unused_core_busy = ^core_busy_q[$bits(ibex_mubi_t)-1:1];
  end
  assign core_sleep_o = ~clock_en;
  prim_clock_gating core_clock_gate_i (
    .clk_i    (clk_i),
    .en_i     (clock_en),
    .test_en_i(test_en_i),
    .clk_o    (clk)
  );
  prim_buf #(.Width($bits(ibex_mubi_t))) u_fetch_enable_buf (
    .in_i (fetch_enable_i),
    .out_o(fetch_enable_buf)
  );
  prim_buf #(.Width($bits(ibex_mubi_t))) u_mcounteren_writable_buf (
    .in_i (mcounteren_writable_i),
    .out_o(mcounteren_writable_buf)
  );
  assign data_rdata_core[31:0] = data_rdata_i;
  assign instr_rdata_core[31:0] = instr_rdata_i;
  if (MemECC) begin : gen_mem_rdata_ecc
    assign data_rdata_core[38:32] = data_rdata_intg_i;
    assign instr_rdata_core[38:32] = instr_rdata_intg_i;
  end else begin : gen_non_mem_rdata_ecc
    logic unused_intg;
    assign unused_intg = ^{instr_rdata_intg_i, data_rdata_intg_i};
  end
  ibex_core #(
    .PMPEnable            (PMPEnable),
    .PMPGranularity       (PMPGranularity),
    .PMPNumRegions        (PMPNumRegions),
    .PMPRstCfg            (PMPRstCfg),
    .PMPRstAddr           (PMPRstAddr),
    .PMPRstMsecCfg        (PMPRstMsecCfg),
    .MHPMCounterNum       (MHPMCounterNum),
    .MHPMCounterWidth     (MHPMCounterWidth),
    .RV32E                (RV32E),
    .RV32M                (RV32M),
    .RV32B                (RV32B),
    .RV32ZC               (RV32ZC),
    .BranchTargetALU      (BranchTargetALU),
    .ICache               (ICache),
    .ICacheECC            (ICacheECC),
    .ICacheTweakInfection (ICacheTweakInfection),
    .BusSizeECC           (BusSizeECC),
    .TagSizeECC           (TagSizeECC),
    .LineSizeECC          (LineSizeECC),
    .BranchPredictor      (BranchPredictor),
    .DbgTriggerEn         (DbgTriggerEn),
    .DbgHwBreakNum        (DbgHwBreakNum),
    .WritebackStage       (WritebackStage),
    .ResetAll             (ResetAll),
    .RndCnstLfsrSeed      (RndCnstLfsrSeed),
    .RndCnstLfsrPerm      (RndCnstLfsrPerm),
    .SecureIbex           (SecureIbex),
    .DummyInstructions    (DummyInstructions),
    .RegFileECC           (RegFileECC),
    .RegFileDataWidth     (RegFileDataWidth),
    .MemECC               (MemECC),
    .MemDataWidth         (MemDataWidth),
    .DmBaseAddr           (DmBaseAddr),
    .DmAddrMask           (DmAddrMask),
    .DmHaltAddr           (DmHaltAddr),
    .DmExceptionAddr      (DmExceptionAddr),
    .CsrMvendorId         (CsrMvendorId),
    .CsrMimpId            (CsrMimpId)
  ) u_ibex_core (
    .clk_i(clk),
    .rst_ni,
    .hart_id_i,
    .boot_addr_i,
    .instr_req_o,
    .instr_gnt_i,
    .instr_rvalid_i,
    .instr_addr_o,
    .instr_rdata_i(instr_rdata_core),
    .instr_err_i,
    .data_req_o,
    .data_gnt_i,
    .data_rvalid_i,
    .data_we_o,
    .data_be_o,
    .data_addr_o,
    .data_wdata_o(data_wdata_core),
    .data_rdata_i(data_rdata_core),
    .data_err_i,
    .dummy_instr_id_o (dummy_instr_id),
    .dummy_instr_wb_o (dummy_instr_wb),
    .rf_raddr_a_o     (rf_raddr_a),
    .rf_raddr_b_o     (rf_raddr_b),
    .rf_waddr_wb_o    (rf_waddr_wb),
    .rf_we_wb_o       (rf_we_wb),
    .rf_wdata_wb_ecc_o(rf_wdata_wb),
    .rf_rdata_a_ecc_i (rf_rdata_a),
    .rf_rdata_b_ecc_i (rf_rdata_b),
    .ic_tag_req_o      (ic_tag_req),
    .ic_tag_write_o    (ic_tag_write),
    .ic_tag_addr_o     (ic_tag_addr),
    .ic_tag_wdata_o    (ic_tag_wdata),
    .ic_tag_rdata_i    (ic_tag_rdata),
    .ic_data_req_o     (ic_data_req),
    .ic_data_write_o   (ic_data_write),
    .ic_data_addr_o    (ic_data_addr),
    .ic_data_wdata_o   (ic_data_wdata),
    .ic_data_rdata_i   (ic_data_rdata),
    .ic_scr_key_valid_i(scramble_key_valid_q),
    .ic_scr_key_req_o  (ic_scr_key_req),
    .irq_software_i,
    .irq_timer_i,
    .irq_external_i,
    .irq_fast_i,
    .irq_nm_i,
    .irq_pending_o(irq_pending),
    .debug_req_i,
    .crash_dump_o,
    .double_fault_seen_o,
    .rvfi_valid,
    .rvfi_order,
    .rvfi_insn,
    .rvfi_trap,
    .rvfi_halt,
    .rvfi_intr,
    .rvfi_mode,
    .rvfi_ixl,
    .rvfi_rs1_addr,
    .rvfi_rs2_addr,
    .rvfi_rs3_addr,
    .rvfi_rs1_rdata,
    .rvfi_rs2_rdata,
    .rvfi_rs3_rdata,
    .rvfi_rd_addr,
    .rvfi_rd_wdata,
    .rvfi_pc_rdata,
    .rvfi_pc_wdata,
    .rvfi_mem_addr,
    .rvfi_mem_rmask,
    .rvfi_mem_wmask,
    .rvfi_mem_rdata,
    .rvfi_mem_wdata,
    .rvfi_ext_pre_mip,
    .rvfi_ext_post_mip,
    .rvfi_ext_nmi,
    .rvfi_ext_nmi_int,
    .rvfi_ext_debug_req,
    .rvfi_ext_debug_mode,
    .rvfi_ext_rf_wr_suppress,
    .rvfi_ext_mcycle,
    .rvfi_ext_mhpmcounters,
    .rvfi_ext_mhpmcountersh,
    .rvfi_ext_ic_scr_key_valid,
    .rvfi_ext_irq_valid,
    .rvfi_ext_expanded_insn_valid,
    .rvfi_ext_expanded_insn,
    .rvfi_ext_expanded_insn_last,
    .fetch_enable_i        (fetch_enable_buf),
    .mcounteren_writable_i (mcounteren_writable_buf),
    .alert_minor_o         (core_alert_minor),
    .alert_major_internal_o(core_alert_major_internal),
    .alert_major_bus_o     (core_alert_major_bus),
    .core_busy_o           (core_busy_d)
  );
  if (RegFile == RegFileFF) begin : gen_regfile_ff
    ibex_register_file_ff #(
      .RV32E            (RV32E),
      .DataWidth        (RegFileDataWidth),
      .DummyInstructions(DummyInstructions),
      .WordZeroVal      (RegFileDataWidth'(prim_secded_pkg::SecdedInv3932ZeroWord))
    ) register_file_i (
      .clk_i (clk),
      .rst_ni(rst_ni),
      .test_en_i       (test_en_i),
      .dummy_instr_id_i(dummy_instr_id),
      .dummy_instr_wb_i(dummy_instr_wb),
      .raddr_a_i(rf_raddr_a),
      .rdata_a_o(rf_rdata_a),
      .raddr_b_i(rf_raddr_b),
      .rdata_b_o(rf_rdata_b),
      .waddr_a_i(rf_waddr_wb),
      .wdata_a_i(rf_wdata_wb),
      .we_a_i   (rf_we_wb)
    );
  end else if (RegFile == RegFileFPGA) begin : gen_regfile_fpga
    ibex_register_file_fpga #(
      .RV32E            (RV32E),
      .DataWidth        (RegFileDataWidth),
      .DummyInstructions(DummyInstructions),
      .WordZeroVal      (RegFileDataWidth'(prim_secded_pkg::SecdedInv3932ZeroWord))
    ) register_file_i (
      .clk_i (clk),
      .rst_ni(rst_ni),
      .test_en_i       (test_en_i),
      .dummy_instr_id_i(dummy_instr_id),
      .dummy_instr_wb_i(dummy_instr_wb),
      .raddr_a_i(rf_raddr_a),
      .rdata_a_o(rf_rdata_a),
      .raddr_b_i(rf_raddr_b),
      .rdata_b_o(rf_rdata_b),
      .waddr_a_i(rf_waddr_wb),
      .wdata_a_i(rf_wdata_wb),
      .we_a_i   (rf_we_wb)
    );
  end else if (RegFile == RegFileLatch) begin : gen_regfile_latch
    ibex_register_file_latch #(
      .RV32E            (RV32E),
      .DataWidth        (RegFileDataWidth),
      .DummyInstructions(DummyInstructions),
      .WordZeroVal      (RegFileDataWidth'(prim_secded_pkg::SecdedInv3932ZeroWord))
    ) register_file_i (
      .clk_i (clk),
      .rst_ni(rst_ni),
      .test_en_i       (test_en_i),
      .dummy_instr_id_i(dummy_instr_id),
      .dummy_instr_wb_i(dummy_instr_wb),
      .raddr_a_i(rf_raddr_a),
      .rdata_a_o(rf_rdata_a),
      .raddr_b_i(rf_raddr_b),
      .rdata_b_o(rf_rdata_b),
      .waddr_a_i(rf_waddr_wb),
      .wdata_a_i(rf_wdata_wb),
      .we_a_i   (rf_we_wb)
    );
  end
  if (ICacheScramble) begin : gen_scramble
    assign scramble_key_valid_d = scramble_req_q ? scramble_key_valid_i :
                                  ic_scr_key_req ? 1'b0                 :
                                                   scramble_key_valid_q;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        scramble_key_q       <= RndCnstIbexKey;
        scramble_nonce_q     <= RndCnstIbexNonce;
      end else if (scramble_key_valid_i) begin
        scramble_key_q       <= scramble_key_i;
        scramble_nonce_q     <= scramble_nonce_i;
      end
    end
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        scramble_key_valid_q <= 1'b1;
        scramble_req_q       <= '0;
      end else begin
        scramble_key_valid_q <= scramble_key_valid_d;
        scramble_req_q       <= scramble_req_d;
      end
    end
    assign scramble_req_d = scramble_req_q ? ~scramble_key_valid_i : ic_scr_key_req;
    assign scramble_req_o = scramble_req_q;
  end else begin : gen_noscramble
    logic unused_scramble_inputs = scramble_key_valid_i & (|scramble_key_i) & (|RndCnstIbexKey) &
                                   (|scramble_nonce_i) & (|RndCnstIbexNonce) & scramble_req_q &
                                   ic_scr_key_req & scramble_key_valid_d & scramble_req_d &
                                   (|scramble_key_q) & (|scramble_nonce_q) & scramble_key_valid_q &
                                   scramble_key_valid_d;
    assign scramble_req_d       = 1'b0;
    assign scramble_req_q       = 1'b0;
    assign scramble_req_o       = 1'b0;
    assign scramble_key_q       = '0;
    assign scramble_nonce_q     = '0;
    assign scramble_key_valid_q = 1'b1;
    assign scramble_key_valid_d = 1'b1;
  end
  logic [IC_NUM_WAYS-1:0] icache_tag_alert;
  logic [IC_NUM_WAYS-1:0] icache_data_alert;
  if (ICache) begin : gen_rams
    for (genvar way = 0; way < IC_NUM_WAYS; way++) begin : gen_rams_inner
      if (ICacheScramble) begin : gen_scramble_rams
        prim_ram_1p_scr #(
          .Width              (TagSizeECC),
          .Depth              (IC_NUM_LINES),
          .DataBitsPerMask    (TagSizeECC),
          .EnableParity       (0),
          .NumPrinceRoundsHalf(ICacheScrNumPrinceRoundsHalf),
          .NumAddrScrRounds   (NumAddrScrRounds)
        ) tag_bank (
          .clk_i,
          .rst_ni,
          .key_valid_i      (scramble_key_valid_q),
          .key_i            (scramble_key_q),
          .nonce_i          (scramble_nonce_q),
          .req_i            (ic_tag_req[way]),
          .gnt_o            (),
          .write_i          (ic_tag_write),
          .addr_i           (ic_tag_addr),
          .wdata_i          (ic_tag_wdata),
          .wmask_i          ({TagSizeECC{1'b1}}),
          .intg_error_i     (1'b0),
          .rdata_o          (ic_tag_rdata[way]),
          .rvalid_o         (),
          .raddr_o          (),
          .rerror_o         (),
          .cfg_i            (ram_cfg_icache_tag_i[way]),
          .cfg_o            (ram_cfg_icache_tag_o[way]),
          .wr_collision_o   (),
          .write_pending_o  (),
          .alert_o          (icache_tag_alert[way])
        );
        prim_ram_1p_scr #(
          .Width              (LineSizeECC),
          .Depth              (IC_NUM_LINES),
          .DataBitsPerMask    (LineSizeECC),
          .ReplicateKeyStream (1),
          .EnableParity       (0),
          .NumPrinceRoundsHalf(ICacheScrNumPrinceRoundsHalf),
          .NumAddrScrRounds   (NumAddrScrRounds)
        ) data_bank (
          .clk_i,
          .rst_ni,
          .key_valid_i      (scramble_key_valid_q),
          .key_i            (scramble_key_q),
          .nonce_i          (scramble_nonce_q),
          .req_i            (ic_data_req[way]),
          .gnt_o            (),
          .write_i          (ic_data_write),
          .addr_i           (ic_data_addr),
          .wdata_i          (ic_data_wdata),
          .wmask_i          ({LineSizeECC{1'b1}}),
          .intg_error_i     (1'b0),
          .rdata_o          (ic_data_rdata[way]),
          .rvalid_o         (),
          .raddr_o          (),
          .rerror_o         (),
          .cfg_i            (ram_cfg_icache_data_i[way]),
          .cfg_o            (ram_cfg_icache_data_o[way]),
          .wr_collision_o   (),
          .write_pending_o  (),
          .alert_o          (icache_data_alert[way])
        );
      end else begin : gen_noscramble_rams
        prim_ram_1p #(
          .Width            (TagSizeECC),
          .Depth            (IC_NUM_LINES),
          .DataBitsPerMask  (TagSizeECC)
        ) tag_bank (
          .clk_i,
          .rst_ni,
          .req_i       (ic_tag_req[way]),
          .write_i     (ic_tag_write),
          .addr_i      (ic_tag_addr),
          .wdata_i     (ic_tag_wdata),
          .wmask_i     ({TagSizeECC{1'b1}}),
          .rdata_o     (ic_tag_rdata[way]),
          .cfg_i       (ram_cfg_icache_tag_i[way]),
          .cfg_o       (ram_cfg_icache_tag_o[way])
        );
        prim_ram_1p #(
          .Width              (LineSizeECC),
          .Depth              (IC_NUM_LINES),
          .DataBitsPerMask    (LineSizeECC)
        ) data_bank (
          .clk_i,
          .rst_ni,
          .req_i       (ic_data_req[way]),
          .write_i     (ic_data_write),
          .addr_i      (ic_data_addr),
          .wdata_i     (ic_data_wdata),
          .wmask_i     ({LineSizeECC{1'b1}}),
          .rdata_o     (ic_data_rdata[way]),
          .cfg_i       (ram_cfg_icache_data_i[way]),
          .cfg_o       (ram_cfg_icache_data_o[way])
        );
        assign icache_tag_alert  = '{default:'b0};
        assign icache_data_alert = '{default:'b0};
      end
    end
  end else begin : gen_norams
    logic unused_ram_cfg;
    logic unused_ram_inputs;
    assign unused_ram_cfg        = |{ram_cfg_icache_tag_i, ram_cfg_icache_data_i};
    assign ram_cfg_icache_tag_o  = '{default: prim_ram_1p_pkg::RAM_1P_CFG_RSP_DEFAULT};
    assign ram_cfg_icache_data_o = '{default: prim_ram_1p_pkg::RAM_1P_CFG_RSP_DEFAULT};
    assign unused_ram_inputs     = (|ic_tag_req) & ic_tag_write & (|ic_tag_addr) &
                                   (|ic_tag_wdata) & (|ic_data_req) & ic_data_write &
                                   (|ic_data_addr) & (|ic_data_wdata) & (|NumAddrScrRounds);
    assign ic_tag_rdata      = '{default:'b0};
    assign ic_data_rdata     = '{default:'b0};
    assign icache_tag_alert  = '{default:'b0};
    assign icache_data_alert = '{default:'b0};
  end
  assign data_wdata_o = data_wdata_core[31:0];
  if (MemECC) begin : gen_mem_wdata_ecc
    prim_buf #(.Width(7)) u_prim_buf_data_wdata_intg (
      .in_i (data_wdata_core[38:32]),
      .out_o(data_wdata_intg_o)
    );
  end else begin : gen_no_mem_ecc
    assign data_wdata_intg_o = '0;
  end
  if (Lockstep) begin : gen_lockstep
    localparam int NumBufferBits = $bits({
      hart_id_i,
      boot_addr_i,
      instr_req_o,
      instr_gnt_i,
      instr_rvalid_i,
      instr_addr_o,
      instr_rdata_core,
      instr_err_i,
      data_req_o,
      data_gnt_i,
      data_rvalid_i,
      data_we_o,
      data_be_o,
      data_addr_o,
      data_wdata_o,
      data_rdata_core,
      data_err_i,
      rf_rdata_a,
      rf_rdata_b,
      ic_tag_req,
      ic_tag_write,
      ic_tag_addr,
      ic_tag_wdata,
      ic_data_req,
      ic_data_write,
      ic_data_addr,
      ic_data_wdata,
      scramble_key_valid_i,
      ic_scr_key_req,
      irq_software_i,
      irq_timer_i,
      irq_external_i,
      irq_fast_i,
      irq_nm_i,
      irq_pending,
      debug_req_i,
      crash_dump_o,
      double_fault_seen_o,
      fetch_enable_i,
      mcounteren_writable_i,
      core_busy_d
    });
    logic [NumBufferBits-1:0] buf_in, buf_out;
    logic [31:0]                  hart_id_local;
    logic [31:0]                  boot_addr_local;
    logic                         instr_req_local;
    logic                         instr_gnt_local;
    logic                         instr_rvalid_local;
    logic [31:0]                  instr_addr_local;
    logic [MemDataWidth-1:0]      instr_rdata_local;
    logic                         instr_err_local;
    logic                         data_req_local;
    logic                         data_gnt_local;
    logic                         data_rvalid_local;
    logic                         data_we_local;
    logic [3:0]                   data_be_local;
    logic [31:0]                  data_addr_local;
    logic [31:0]                  data_wdata_local;
    logic [MemDataWidth-1:0]      data_rdata_local;
    logic                         data_err_local;
    logic [RegFileDataWidth-1:0]  rf_rdata_a_local;
    logic [RegFileDataWidth-1:0]  rf_rdata_b_local;
    logic [IC_NUM_WAYS-1:0]       ic_tag_req_local;
    logic                         ic_tag_write_local;
    logic [IC_INDEX_W-1:0]        ic_tag_addr_local;
    logic [TagSizeECC-1:0]        ic_tag_wdata_local;
    logic [IC_NUM_WAYS-1:0]       ic_data_req_local;
    logic                         ic_data_write_local;
    logic [IC_INDEX_W-1:0]        ic_data_addr_local;
    logic [LineSizeECC-1:0]       ic_data_wdata_local;
    logic                         scramble_key_valid_local;
    logic                         ic_scr_key_req_local;
    logic                         irq_software_local;
    logic                         irq_timer_local;
    logic                         irq_external_local;
    logic [14:0]                  irq_fast_local;
    logic                         irq_nm_local;
    logic                         irq_pending_local;
    logic                         debug_req_local;
    crash_dump_t                  crash_dump_local;
    logic                         double_fault_seen_local;
    ibex_mubi_t                   fetch_enable_local;
    ibex_mubi_t                   mcounteren_writable_local;
    ibex_mubi_t                   core_busy_local;
    assign buf_in = {
      hart_id_i,
      boot_addr_i,
      instr_req_o,
      instr_gnt_i,
      instr_rvalid_i,
      instr_addr_o,
      instr_rdata_core,
      instr_err_i,
      data_req_o,
      data_gnt_i,
      data_rvalid_i,
      data_we_o,
      data_be_o,
      data_addr_o,
      data_wdata_o,
      data_rdata_core,
      data_err_i,
      rf_rdata_a,
      rf_rdata_b,
      ic_tag_req,
      ic_tag_write,
      ic_tag_addr,
      ic_tag_wdata,
      ic_data_req,
      ic_data_write,
      ic_data_addr,
      ic_data_wdata,
      scramble_key_valid_q,
      ic_scr_key_req,
      irq_software_i,
      irq_timer_i,
      irq_external_i,
      irq_fast_i,
      irq_nm_i,
      irq_pending,
      debug_req_i,
      crash_dump_o,
      double_fault_seen_o,
      fetch_enable_i,
      mcounteren_writable_i,
      core_busy_d
    };
    assign {
      hart_id_local,
      boot_addr_local,
      instr_req_local,
      instr_gnt_local,
      instr_rvalid_local,
      instr_addr_local,
      instr_rdata_local,
      instr_err_local,
      data_req_local,
      data_gnt_local,
      data_rvalid_local,
      data_we_local,
      data_be_local,
      data_addr_local,
      data_wdata_local,
      data_rdata_local,
      data_err_local,
      rf_rdata_a_local,
      rf_rdata_b_local,
      ic_tag_req_local,
      ic_tag_write_local,
      ic_tag_addr_local,
      ic_tag_wdata_local,
      ic_data_req_local,
      ic_data_write_local,
      ic_data_addr_local,
      ic_data_wdata_local,
      scramble_key_valid_local,
      ic_scr_key_req_local,
      irq_software_local,
      irq_timer_local,
      irq_external_local,
      irq_fast_local,
      irq_nm_local,
      irq_pending_local,
      debug_req_local,
      crash_dump_local,
      double_fault_seen_local,
      fetch_enable_local,
      mcounteren_writable_local,
      core_busy_local
    } = buf_out;
    prim_buf #(.Width(NumBufferBits)) u_signals_prim_buf (
      .in_i(buf_in),
      .out_o(buf_out)
    );
    logic [TagSizeECC-1:0]  ic_tag_rdata_local [IC_NUM_WAYS];
    logic [LineSizeECC-1:0] ic_data_rdata_local [IC_NUM_WAYS];
    for (genvar k = 0; k < IC_NUM_WAYS; k++) begin : gen_ways
      prim_buf #(.Width(TagSizeECC)) u_tag_prim_buf (
        .in_i(ic_tag_rdata[k]),
        .out_o(ic_tag_rdata_local[k])
      );
      prim_buf #(.Width(LineSizeECC)) u_data_prim_buf (
        .in_i(ic_data_rdata[k]),
        .out_o(ic_data_rdata_local[k])
      );
    end
    logic lockstep_alert_minor_local, lockstep_alert_major_internal_local;
    logic lockstep_alert_major_bus_local;
    ibex_lockstep #(
      .PMPEnable            (PMPEnable),
      .PMPGranularity       (PMPGranularity),
      .PMPNumRegions        (PMPNumRegions),
      .PMPRstCfg            (PMPRstCfg),
      .PMPRstAddr           (PMPRstAddr),
      .PMPRstMsecCfg        (PMPRstMsecCfg),
      .MHPMCounterNum       (MHPMCounterNum),
      .MHPMCounterWidth     (MHPMCounterWidth),
      .RV32E                (RV32E),
      .RV32M                (RV32M),
      .RV32B                (RV32B),
      .RV32ZC               (RV32ZC),
      .BranchTargetALU      (BranchTargetALU),
      .ICache               (ICache),
      .ICacheECC            (ICacheECC),
      .ICacheTweakInfection (ICacheTweakInfection),
      .BusSizeECC           (BusSizeECC),
      .TagSizeECC           (TagSizeECC),
      .LineSizeECC          (LineSizeECC),
      .BranchPredictor      (BranchPredictor),
      .DbgTriggerEn         (DbgTriggerEn),
      .DbgHwBreakNum        (DbgHwBreakNum),
      .WritebackStage       (WritebackStage),
      .ResetAll             (ResetAll),
      .RndCnstLfsrSeed      (RndCnstLfsrSeed),
      .RndCnstLfsrPerm      (RndCnstLfsrPerm),
      .SecureIbex           (SecureIbex),
      .LockstepOffset       (LockstepOffset),
      .DummyInstructions    (DummyInstructions),
      .RegFileECC           (RegFileLockstepECC),
      .RegFileDataWidth     (RegFileDataWidth),
      .RegFileDataEccWidth  (RegFileDataEccWidth),
      .RegFile              (RegFile),
      .MemECC               (MemECC),
      .DmBaseAddr           (DmBaseAddr),
      .DmAddrMask           (DmAddrMask),
      .DmHaltAddr           (DmHaltAddr),
      .DmExceptionAddr      (DmExceptionAddr),
      .CsrMvendorId         (CsrMvendorId),
      .CsrMimpId            (CsrMimpId)
    ) u_ibex_lockstep (
      .clk_i                    (clk),
      .rst_ni                   (rst_ni),
      .hart_id_i                (hart_id_local),
      .boot_addr_i              (boot_addr_local),
      .instr_req_i              (instr_req_local),
      .instr_gnt_i              (instr_gnt_local),
      .instr_rvalid_i           (instr_rvalid_local),
      .instr_addr_i             (instr_addr_local),
      .instr_rdata_i            (instr_rdata_local),
      .instr_err_i              (instr_err_local),
      .data_req_i               (data_req_local),
      .data_gnt_i               (data_gnt_local),
      .data_rvalid_i            (data_rvalid_local),
      .data_we_i                (data_we_local),
      .data_be_i                (data_be_local),
      .data_addr_i              (data_addr_local),
      .data_wdata_i             (data_wdata_local),
      .data_rdata_i             (data_rdata_local),
      .data_err_i               (data_err_local),
      .rf_rdata_a_i             (rf_rdata_a_local),
      .rf_rdata_b_i             (rf_rdata_b_local),
      .ic_tag_req_i             (ic_tag_req_local),
      .ic_tag_write_i           (ic_tag_write_local),
      .ic_tag_addr_i            (ic_tag_addr_local),
      .ic_tag_wdata_i           (ic_tag_wdata_local),
      .ic_tag_rdata_i           (ic_tag_rdata_local),
      .ic_data_req_i            (ic_data_req_local),
      .ic_data_write_i          (ic_data_write_local),
      .ic_data_addr_i           (ic_data_addr_local),
      .ic_data_wdata_i          (ic_data_wdata_local),
      .ic_data_rdata_i          (ic_data_rdata_local),
      .ic_scr_key_valid_i       (scramble_key_valid_local),
      .ic_scr_key_req_i         (ic_scr_key_req_local),
      .irq_software_i           (irq_software_local),
      .irq_timer_i              (irq_timer_local),
      .irq_external_i           (irq_external_local),
      .irq_fast_i               (irq_fast_local),
      .irq_nm_i                 (irq_nm_local),
      .irq_pending_i            (irq_pending_local),
      .debug_req_i              (debug_req_local),
      .crash_dump_i             (crash_dump_local),
      .double_fault_seen_i      (double_fault_seen_local),
      .fetch_enable_i           (fetch_enable_local),
      .mcounteren_writable_i    (mcounteren_writable_local),
      .alert_minor_o            (lockstep_alert_minor_local),
      .alert_major_internal_o   (lockstep_alert_major_internal_local),
      .alert_major_bus_o        (lockstep_alert_major_bus_local),
      .core_busy_i              (core_busy_local),
      .test_en_i                (test_en_i),
      .scan_rst_ni              (scan_rst_ni),
      .lockstep_cmp_en_o        (lockstep_cmp_en_o),
      .data_req_shadow_o        (data_req_shadow_o),
      .data_we_shadow_o         (data_we_shadow_o),
      .data_be_shadow_o         (data_be_shadow_o),
      .data_addr_shadow_o       (data_addr_shadow_o),
      .data_wdata_shadow_o      (data_wdata_shadow_o),
      .data_wdata_intg_shadow_o (data_wdata_intg_shadow_o),
      .instr_req_shadow_o       (instr_req_shadow_o),
      .instr_addr_shadow_o      (instr_addr_shadow_o)
    );
    prim_buf u_prim_buf_alert_minor (
      .in_i (lockstep_alert_minor_local),
      .out_o(lockstep_alert_minor)
    );
    prim_buf u_prim_buf_alert_major_internal (
      .in_i (lockstep_alert_major_internal_local),
      .out_o(lockstep_alert_major_internal)
    );
    prim_buf u_prim_buf_alert_major_bus (
      .in_i (lockstep_alert_major_bus_local),
      .out_o(lockstep_alert_major_bus)
    );
  end else begin : gen_no_lockstep
    assign lockstep_alert_major_internal = 1'b0;
    assign lockstep_alert_major_bus      = 1'b0;
    assign lockstep_alert_minor          = 1'b0;
    assign lockstep_cmp_en_o             = IbexMuBiOff;
    assign data_req_shadow_o             = 1'b0;
    assign data_we_shadow_o              = 1'b0;
    assign data_be_shadow_o              = '0;
    assign data_addr_shadow_o            = '0;
    assign data_wdata_shadow_o           = '0;
    assign data_wdata_intg_shadow_o      = '0;
    assign instr_req_shadow_o            = 1'b0;
    assign instr_addr_shadow_o           = '0;
    logic unused_scan;
    assign unused_scan = scan_rst_ni;
  end
  logic icache_alert_major_internal;
  assign icache_alert_major_internal = (|icache_tag_alert) | (|icache_data_alert);
  assign alert_major_internal_o = core_alert_major_internal |
                                  lockstep_alert_major_internal |
                                  icache_alert_major_internal;
  assign alert_major_bus_o      = core_alert_major_bus | lockstep_alert_major_bus;
  assign alert_minor_o          = core_alert_minor | lockstep_alert_minor;
endmodule
