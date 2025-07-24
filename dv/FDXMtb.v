`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2025 01:08:30 PM
// Design Name: 
// Module Name: FDXMtb
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


module FDXMtb(

    );
    
     // Inputs
    logic clk_i;
    logic reset_i;
    logic [63:0] BranchALUXpipe_out;
    logic FD_pipeready; // remove if needed and set as input

    // Outputs
    logic [63:0] Mem_Addr;
    logic [31:0] Read_Data;
    logic MemToReg_o;
    logic [4:0] rd_o;

    // Instantiate the Unit Under Test (UUT)
    DF_Stage uut (
    // F stage inputs
    .clk_i,
    .reset_i,
    //.BranchALUXpipe_out(), // NO LONGER NEEDED
    //.branchtaken(),        // NO LONGER NEEDED

    .FD_pipeready,

    .Read_Data,
    .Mem_Addr,
    .MemToReg_o,
    .rd_o
);


    // Clock generation
    always #10 clk_i = ~clk_i;

    // Initial block
    initial begin
        clk_i = 0;
        reset_i = 1;
        FD_pipeready = 1;

        #15;
        reset_i = 0;

        #20;
        //FD_pipeready = 0;

        // Add more stimulus as needed
    end
endmodule
