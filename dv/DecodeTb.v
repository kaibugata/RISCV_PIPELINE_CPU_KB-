`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2025 02:13:13 PM
// Design Name: 
// Module Name: DecodeTb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DecodeTb(

    );
    logic clk;
    logic reset;

    logic [31:0] Instruction;
    logic RegWrite, MemRead, MemWrite, ALUSrc, MemToReg;
    logic [2:0] ALUOp;
    logic [4:0] rd,rs1,rs2;
    logic [63:0] immediate64bit;
    logic [2:0] funct3;
    logic [$clog2(6)-1:0] I_Type;
    logic [31:0] rs1Out, rs2Out;
    
    
    DecodeStage uut (
        .clk_i(clk),
        .reset_i(reset),
        .Instruction(Instruction),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemToReg(MemToReg),
        .ALUOp(ALUOp),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .immediate64bit(immediate64bit),
        .funct3(funct3),
        .I_Type(I_Type),
        .rs1Out(rs1Out),
        .rs2Out(rs2Out)
    );
    
    always begin
    #10 clk = ~clk;
    end
    
    initial begin
    // Initial values
    #2
    clk = 0;
    reset = 1;
    
    
    
    #12
    reset = 0;
    Instruction = 32'b00000000000100011000000100110011; //add x2, x3, x1
    #20
    Instruction = 32'b00000000010000001010000110100011; //sw x4, 3(x1)
    #20
    Instruction = 32'b00000000000000001000010101100011; //beq x1, x0, 10
    #20
    Instruction = 32'b00000001010000111110001010010011; //ori x5, x7, 20
    
    
    end
    
    
    
    
    
    
    
        
    
    
    
endmodule
