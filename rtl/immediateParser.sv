module immediateParser (
    input logic [31:0] Instruction,
    input logic [$clog2(6)-1:0] I_Type,
    output logic [63:0] constant

);

always_comb begin
case (I_Type)
  3'h0: constant = {{52{Instruction[31]}}, Instruction[31:20]}; // I-type (sign-extend 12-bit)
  3'h1: constant = {{32{Instruction[31]}}, Instruction[31:12], 12'b0};      // U-type (sign-extend 20-bit << 12)
  3'h2: constant = {{52{Instruction[31]}}, Instruction[31:25], Instruction[11:7]}; // S-type (sign-extend 12-bit)
  3'h3: constant = 64'd0; // R-type (no immediate)
  3'h4: constant = {{51{Instruction[31]}}, Instruction[31], Instruction[7], Instruction[30:25], Instruction[11:8], 1'b0}; // SB-type (sign-extend 12-bit)
  3'h5: constant = {{43{Instruction[31]}}, Instruction[31], Instruction[19:12], Instruction[20], Instruction[30:21],1'b0}; // UJ-type (sign-extend 20-bit)
  default: constant = 64'd0;
endcase
end



endmodule
