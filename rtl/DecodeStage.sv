`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/04/2025 09:58:38 PM
// Design Name: 
// Module Name: DecodeStage
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


module DecodeStage(
input logic clk_i,
input logic reset_i,
input logic [31:0] Instruction,

input logic WriteValid,
input logic [$clog2(31)-1:0] WriteAddress,
input logic [31:0] WriteData,


output logic RegWrite, MemRead, MemWrite, ALUSrc, MemToReg,
output logic [2:0] ALUOp,
output logic [4:0] rd,rs1,rs2,
output logic [63:0] immediate64bit,
output logic [2:0] funct3,
output logic [$clog2(6)-1:0] I_Type,
output logic [31:0] rs1Out, rs2Out





    );
    

wire [6:0] opcode;
wire [6:0] funct7;
Instruction_Parser Instruction_Parser
(.Instruction(Instruction),
.rd(rd),
.rs1(rs1),
.rs2(rs2),
.funct3(funct3),
.opcode(opcode),
.funct7(funct7),
.I_Type(I_Type));
    


immediateParser immediateParser
(.Instruction(Instruction),
.I_Type(I_Type),
.constant(immediate64bit));

//wire [3:0] rd_mpipe_out;

mem_Register Registers
(.clk_i,
.reset_i,
.wr_valid_i(WriteValid),
.wr_data_i(WriteData),//write data
.wr_addr_i(WriteAddress),//rd
.rs1_valid_i(1'b1),
.rs1_addr_i(rs1),
.rs1_data_o(rs1Out),
.rs2_valid_i(1'b1),
.rs2_addr_i(rs2),
.rs2_data_o(rs2Out));

Control CtrlUnit
(.funct3(funct3),
.opcode(opcode),
.funct7(funct7),
.I_Type(I_Type),
.RegWrite(RegWrite),
.MemRead(MemRead),
.MemWrite(MemWrite),
.MemToReg(MemToReg),
.ALUSrc(ALUSrc),
.ALUOp(ALUOp));


endmodule
