`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2025 02:47:38 PM
// Design Name: 
// Module Name: ExecuteState
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


module ExecuteStage(
    input logic clk_i,
    input logic reset_i,
    input logic [4:0] rd,rs1,rs2,
    input logic [63:0] immediate64bit,
    input logic [31:0] rs1Out, rs2Out,
    input logic [63:0] PC_i,
    input logic RegWrite, MemRead, MemWrite, ALUSrc, MemToReg,
    input logic [2:0] ALUOp,
    input logic [2:0] funct3,
    input logic [$clog2(6)-1:0] I_Type,
    input logic [4:0] rd_w, rd_x,
    input logic regwrite_w, regwrite_x,
    
    input logic [63:0] WBdata, 
    input logic [63:0] MemAddr,
    
    output logic [63:0] BranchALU_out,
    output logic [63:0] rs2ImmediateMuxOut,
    output logic zeroSignal,
    output logic ltzSignal,
    output logic [63:0] ALUresultOut,
    output logic [2:0] funct3_o,
    output logic [$clog2(6)-1:0] I_Type_o
    

    );
    logic [1:0] forwardA, forwardB;
    
    
//wire [63:0] BranchALU_out;
BranchALU BranchALU
(.PC_val(PC_i),
.immediate(immediate64bit),
.ALU_out(BranchALU_out));

//POTENTIAL FOR FORWARDING PATHS HERE
logic [63:0] rs13muxOut, rs23muxOut;
three_1Mux64 rs1FrwdMux
(.a({{32{rs1Out[31]}}, rs1Out}),
.b(WBdata),
.c(MemAddr),
.sel(forwardA),
.out(rs13muxOut));

three_1Mux64 rs2FrwdMux
(.a({{32{rs2Out[31]}}, rs2Out}),
.b(WBdata),
.c(MemAddr),
.sel(forwardB),
.out(rs23muxOut));

//wire [63:0] rs2ImmediateMuxOut;
two_1Mux64 rs2Mux
(.a(immediate64bit),//immediate
.b(rs23muxOut),//rs2  
.sel(ALUSrc),
.out(rs2ImmediateMuxOut));


//wire zeroSignal;
//wire ltzSignal;
//wire [63:0] ALUresultOut;
mainALU mainALU
(.op1(rs13muxOut),
.op2(rs2ImmediateMuxOut),
.operand(ALUOp),
.out(ALUresultOut),
.zero(zeroSignal),
.ltz(ltzSignal));


ForwardingUnit FU
(.rs1_D(rs1),
 .rs2_D(rs2),
 .rd_X(rd_x),
 .rd_W(rd_w),
 .regwrite_X(regwrite_x),
 .regwrite_W(regwrite_w),
 .ForwardA(forwardA),
 .ForwardB(forwardB));






assign funct3_o = funct3;
assign I_Type_o = I_Type;


endmodule
