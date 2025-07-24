`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2025 05:14:41 PM
// Design Name: 
// Module Name: MemoryStage
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


module MemoryStage(
input logic clk_i,
input logic reset_i,
input logic [2:0] funct3,
input logic [$clog2(6)-1:0] I_Type,
input logic zero,ltz,
input logic [63:0] ALUresult,
input logic MemWrite, MemToReg, MemRead,
input logic [31:0] MuxResOut,
output logic branchtaken,
output logic [31:0] mem_data_o,
output logic [63:0] ALUresultOut,
output logic MemToReg_o
    );
    
    
    
    
Branch branchMod
(.zero(zero),
.ltz(ltz), //less than zero
.funct3(funct3),
.I_Type(I_Type),
.branchtaken(branchtaken));



mem_Rsync DataMemory
(.clk_i,//maybe issue 
.reset_i,
.wr_valid_i(MemWrite),
.wr_data_i(MuxResOut),
.wr_addr_i(ALUresult[4:0]),
.rd_valid_i(MemRead),
.rd_addr_i(ALUresult[4:0]),
.rd_data_o(mem_data_o));


assign ALUresultOut = ALUresult;
assign MemToReg_o = MemToReg;

endmodule
