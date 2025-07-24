`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2025 09:48:59 PM
// Design Name: 
// Module Name: FDtb
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


module FDtb(

    );
    logic clk_i;
    logic reset_i;
    logic [63:0] BranchALUXpipe_out;
    logic branchtaken;
    logic RegWrite, MemRead, MemWrite, ALUSrc, MemToReg;
    logic [2:0] ALUOp;
    logic [4:0] rd,rs1,rs2;
    logic [63:0] immediate64bit;
    logic [2:0] funct3;
    logic [$clog2(6)-1:0] I_Type;
    logic [31:0] rs1Out, rs2Out;
    logic FD_pipeready;//test
    
    
    DF_Stage uut
    (.clk_i,                                            
      .reset_i,                                          
      .BranchALUXpipe_out,                        
      .branchtaken,                                      
      .RegWrite,
      .MemRead,
      .MemWrite,
      .ALUSrc,
      .MemToReg,    
      .ALUOp,                                      
      .rd,
      .rs1,
      .rs2,                                 
      .immediate64bit,                    
      .funct3,                                 
      .I_Type,                         
      .rs1Out, 
      .rs2Out
      ,.FD_pipeready//test
      );
      
      
      always #10 clk_i = ~clk_i;
      
      initial begin
        clk_i = 0;
        reset_i = 1;
        BranchALUXpipe_out = 64'd16;
        branchtaken = 0;
        FD_pipeready = 1;
        
        #15;
        reset_i = 0;
        #20;
        FD_pipeready = 0;
        
        
      
      end
      
      
      
      
      endmodule                   
