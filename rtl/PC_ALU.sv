module PC_ALU(
    input [63:0] PC_in,
    output [63:0] PC_next
);


assign PC_next = PC_in + 4;


endmodule
