// Minimal RV64 program for the frozen XiangShan XSTop.
// Every check branches to `fail` (an infinite loop) on mismatch, so the final
// WFI is only reachable if the core executed all of it correctly.
    .section .text.init
    .globl _start
_start:
    // --- integer arithmetic ---
    li      x1, 5
    li      x2, 7
    add     x3, x1, x2
    li      x4, 12
    bne     x3, x4, fail

    sub     x5, x2, x1          // 2
    li      x6, 2
    bne     x5, x6, fail

    // --- shifts / logic ---
    li      x7, 1
    slli    x8, x7, 20          // 0x100000
    li      x9, 0x100000
    bne     x8, x9, fail

    li      x10, 0xF0F0
    li      x11, 0x0FF0
    and     x12, x10, x11       // 0x00F0
    li      x13, 0x00F0
    bne     x12, x13, fail

    xor     x14, x10, x10       // 0
    bnez    x14, fail

    // --- multiply / divide (M extension) ---
    li      x15, 6
    li      x16, 7
    mul     x17, x15, x16       // 42
    li      x18, 42
    bne     x17, x18, fail

    li      x19, 84
    div     x20, x19, x16       // 12
    li      x21, 12
    bne     x20, x21, fail

    // --- loads / stores through the cache hierarchy to DRAM ---
    li      x22, 0x81000000     // scratch address in DRAM
    li      x23, 0xDEADBEEF
    sd      x23, 0(x22)
    ld      x24, 0(x22)
    bne     x23, x24, fail

    li      x25, 0x12345678
    sw      x25, 16(x22)
    lw      x26, 16(x22)
    bne     x25, x26, fail

    // --- a real loop: sum 1..100 == 5050 ---
    li      x27, 0              // acc
    li      x28, 1              // i
    li      x29, 101
loop:
    add     x27, x27, x28
    addi    x28, x28, 1
    bne     x28, x29, loop
    li      x30, 5050
    bne     x27, x30, fail

    // --- fence, then signal completion ---
    fence
pass:
    wfi
    j       pass

fail:
    j       fail
