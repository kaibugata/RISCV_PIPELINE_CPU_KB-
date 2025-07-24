`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/03/2025 04:23:34 PM
// Design Name: 
// Module Name: FetchStage
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


module FetchStage(
input logic clk_i,
input logic reset_i,
input logic [63:0] BranchALUXpipe_out,
input logic branchtaken,
input logic PCready,
output logic [31:0] InstructionMem_out,
output logic [63:0] PC_o
    );
    

logic [63:0] PC_plus4;
wire [63:0] PCMuxOut;
two_1Mux64 PCinMux
(.a(PC_plus4 - 3),//pc + 4   //I ADDED -3 so its +1 (Bandaid Fix)
.b(BranchALUXpipe_out),//pc + branch offset
.sel(branchtaken),//branch taken logic
.out(PCMuxOut));

wire [63:0] PC_w;
ProgCount Program_Counter
(.clk_i,
.reset_i,
.ready_i(PCready),
.PC_i(PCMuxOut),
.PC_o(PC_w));


PC_ALU PC_ALU
(.PC_in(PC_w),
.PC_next(PC_plus4));//ISSUE IN OUR TEST WHERE PC + 4 Skips over inst memory. Maybe we should use + 1 so it doesnt skip inst

Instruction_Memory InstructionMem
 (.clk_i,
 .reset_i,
 .rd_valid_i(1'b1),//figure out logic(could be always one)
 .rd_addr_i(PC_w[4:0]),//taking only 5 bits(figure out if needed)
 .rd_data_o(InstructionMem_out));
 
 
 assign PC_o = PC_w;
 
endmodule
