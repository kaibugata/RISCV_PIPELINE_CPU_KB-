`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/14/2025 11:24:33 PM
// Design Name:
// Module Name: FullPipelineTB1
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


module FullPipelineTB1(

    );

    logic clk_i;
    logic reset_i;
    logic FD_pipeready;

     RISC_CPU uut (
    // F stage inputs
    .clk_i,
    .reset_i,
    .FD_pipeready);


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
