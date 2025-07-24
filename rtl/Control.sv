module Control (
    input logic [2:0] funct3,
    input logic [6:0] opcode,
    input logic [6:0] funct7,
    input logic [$clog2(6)-1:0] I_Type,
    output logic RegWrite, MemWrite, MemRead, ALUSrc, MemToReg,
    output logic [2:0] ALUOp

);


assign RegWrite = (I_Type == 3) || (I_Type == 0) || (I_Type == 5) || (I_Type == 1);
assign MemWrite = (I_Type == 2);
assign MemRead = (I_Type == 0) && (opcode == 7'h3);
assign ALUSrc = (I_Type == 3) || (I_Type == 4); //1 for taking from rs2, 0 taking from immidiate
assign MemToReg = (I_Type == 0) && (opcode == 7'h3);


//ALU depends on the instruction type, so will need lots of logic for this
//ALU op
//000 = ADD
//001 = SUB
//010 = AND
//011 = OR
//100 = XOR
//101 = SL
//110 = SR

always_comb begin : aluOP
        ALUOp = 3'b000;//default
    if((opcode == 7'h3)||(opcode == 7'h13 && funct3 == 3'b0)||(opcode == 7'h17)||(opcode == 7'h23)||(opcode == 7'h33 && funct7 == 7'b0)||(opcode == 7'h37)||(opcode == 7'h6F)||(opcode == 7'h67)) begin
        ALUOp = 3'b000;//ADD
    end else if((opcode == 7'h33 && funct7 == 7'b0100000)||(opcode == 7'h63)||(opcode == 7'h33 && (funct3 == 3'b010 || funct3 == 3'b011))||(opcode == 7'h13 && (funct3 == 3'b010 || funct3 == 3'b011)))begin
        ALUOp = 3'b001;//SUB
    end else if((opcode == 7'h13 && funct3 == 3'b111)||(opcode == 7'h33 && funct3 == 3'b111))begin
        ALUOp = 3'b010;//AND
    end else if((opcode == 7'h13 && funct3 == 3'b110)||(opcode == 7'h33 && funct3 == 3'b110))begin
        ALUOp = 3'b011;//OR
    end else if((opcode == 7'h13 && funct3 == 3'b100)||(opcode == 7'h33 && funct3 == 3'b100))begin
        ALUOp = 3'b011;//XOR
    end else if((opcode == 7'h13 && funct3 == 3'b001)||(opcode == 7'h33 && funct3 == 3'b001))begin
        ALUOp = 3'b101;//SL
    end else if((opcode == 7'h13 && funct3 == 3'b101)||(opcode == 7'h33 && funct3 == 3'b101))begin
        ALUOp = 3'b110;//SR
    end
end



endmodule
