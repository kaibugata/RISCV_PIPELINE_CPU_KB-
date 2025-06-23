module Control (
    input [2:0] funct3,
    input [3:0] opcode,
    input [5:0] funct7,
    input [$clog2(6)-1:0] I_Type,
    output RegWrite, MemWrite, MemRead, ALUSrc,
    output [2:0] ALUOp

);


assign RegWrite = (I_Type == 3) || (I_Type == 0) || (I_Type == 5) || (I_Type == 1);
assign MemWrite = (I_Type == 2);
assign MemRead = (I_Type == 0) && (opcode == 4'h3);
assign ALUSrc = (I_Type == 3) || (I_Type == 4) || (I_Type == 2); //1 for taking from rs2, 0 taking from immidiate


//ALU depends on the instruction type, so will need lots of logic for this
//ALU op
//000 = ADD
//001 = SUB
//010 = AND
//011 = OR
//100 = XOR


endmodule
