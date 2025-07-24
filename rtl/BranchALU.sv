module BranchALU(
    input logic [63:0] PC_val,
    input logic [63:0] immediate,
    output logic [63:0] ALU_out
);

wire immedx2;
assign immedx2 = immediate<<1;//RECHECK IF THIS IS NECCESSARY NOW THAT WE ADDED THE 0 to the start of UJ and SB instruct

always_comb begin : alu
    ALU_out = immedx2 + PC_val;
end


endmodule
