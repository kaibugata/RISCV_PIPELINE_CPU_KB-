`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/04/2025 07:01:23 PM
// Design Name: 
// Module Name: FetchTb
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


module FetchTb(

    );
    // Inputs
  logic clk;
  logic reset;
  logic [63:0] BranchALUXpipe_out;
  logic branchtaken;

  // Output
  logic [31:0] InstructionMem_out;

  // Instantiate the FetchStage
  FetchStage uut (
    .clk_i(clk),
    .reset_i(reset),
    .BranchALUXpipe_out(BranchALUXpipe_out),
    .branchtaken(branchtaken),
    .InstructionMem_out(InstructionMem_out)
  );

  // Clock generation
  always #5 clk = ~clk; // 100 MHz clock

  initial begin
    // Initial values
    clk = 0;
    reset = 1;
    BranchALUXpipe_out = 64'd16;
    branchtaken = 0;

    // Apply reset
    #10;
    reset = 0;

    // Let it run for a few cycles with no branch
    #20;

   
  end

  // Optional: monitor output
  initial begin
    $monitor("Time=%0t | PCmuxOut=%0d | Instruction=0x%h | BranchTaken=%b",
              $time, uut.PCMuxOut, InstructionMem_out, branchtaken);
  end

endmodule