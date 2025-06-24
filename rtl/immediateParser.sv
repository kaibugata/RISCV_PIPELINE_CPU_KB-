module immediateParser (
    input [31:0] Instruction,
    input [$clog2(6)-1:0] I_Type,
    output [31:0] constant

);

case(I_Type)
3'h0: constant = {20{Instruction[31]},Instruction[31:20]};//I
3'h1: constant = {Instruction[31:12], 12'b0};//U
3'h2: constant = {{20{Instruction[31]}}, Instruction[31:25], Instruction[11:7]}; //S
3'h3: constant = 0;//R
3'h4: constant = {{19{Instruction[31]}}, Instruction[31], Instruction[7], Instruction[30:25], Instruction[11:8], 1'b0};//SB
3'h5: constant = {{11{Instruction[31]}}, Instruction[31], Instruction[19:12], Instruction[20], Instruction[30:21], 1'b0}//UJ
default: constant = 0;
endcase




endmodule
