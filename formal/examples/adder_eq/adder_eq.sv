// Combinational equivalence proof: the (misleadingly named) core block Adder_2
// implements 8-bit modular subtraction. Prove it matches a behavioural spec for
// ALL inputs -- unconditional, no environment model needed. This is the "miter"
// shape (same as equivalence-checking two RTL versions).
module adder_eq (input [7:0] io_a, input [7:0] io_b);
  wire [7:0] impl_c;
  Adder_2 impl (.io_a(io_a), .io_b(io_b), .io_c(impl_c));
  always @* assert (impl_c == (io_a - io_b));   // spec
endmodule
