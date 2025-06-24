module BranchALU(
    input [63:0] PC_val,
    input [63:0] immediate,
    output [63:0] ALU_out
)

wire immedx2;
assign immedx2 = immediate<<1;

always_comb begin : alu
    ALU_out = immedx2 + PC_val;
end


endmodule
