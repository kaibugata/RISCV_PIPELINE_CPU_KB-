`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2025 02:04:23 PM
// Design Name: 
// Module Name: FDXtb
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

module FDXtb;

    // Inputs
    logic clk_i;
    logic reset_i;
    logic [63:0] BranchALUXpipe_out;
    logic branchtaken;
    logic FD_pipeready; // remove if needed and set as input

    // Outputs
    logic [63:0] BranchALU_out;
    logic [63:0] rs2ImmediateMuxOut;
    logic zeroSignal;
    logic ltzSignal;
    logic [63:0] ALUresultOut;
    logic [2:0] funct3_o;
    logic [$clog2(6)-1:0] I_Type_o;

    // Instantiate the Unit Under Test (UUT)
    DF_Stage uut (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .BranchALUXpipe_out(BranchALUXpipe_out),
        .branchtaken(branchtaken),
        .BranchALU_out(BranchALU_out),
        .rs2ImmediateMuxOut(rs2ImmediateMuxOut),
        .zeroSignal(zeroSignal),
        .ltzSignal(ltzSignal),
        .ALUresultOut(ALUresultOut),
        .funct3_o(funct3_o),
        .I_Type_o(I_Type_o),
        .FD_pipeready(FD_pipeready) // test
    );

    // Clock generation
    always #10 clk_i = ~clk_i;

    // Initial block
    initial begin
        clk_i = 0;
        reset_i = 1;
        BranchALUXpipe_out = 64'd16;
        branchtaken = 0;
        FD_pipeready = 1;

        #15;
        reset_i = 0;

        #20;
        //FD_pipeready = 0;

        // Add more stimulus as needed
    end

endmodule
