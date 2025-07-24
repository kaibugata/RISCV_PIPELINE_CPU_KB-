`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2025 01:38:16 PM
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(
input logic [4:0] rs1_D, rs2_D,
input logic [4:0] rd_W, rd_X,
input logic regwrite_X, regwrite_W,
output logic [1:0] ForwardA, ForwardB
 

    );
    
    
    always_comb begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;
        
        
        if(regwrite_X && rd_X != 0 && rd_X == rs1_D) begin //if rs1 needs prev rd
            ForwardA = 2'b10; //take ALU result
        end else if(regwrite_W && rd_W != 0 && rd_W == rs1_D) begin //if rs1 needs prev prev rd
            ForwardA = 2'b01; //take writeback result
        end
        
        if(regwrite_X && rd_X != 0 && rd_X == rs2_D) begin //if rs2 needs prev rd
            ForwardB = 2'b10; //take ALU result
        end else if(regwrite_W && rd_W != 0 && rd_W == rs2_D) begin //if rs2 needs prev prev rd
            ForwardB = 2'b01; //take writeback result
        end
    
        
    
    end
    
    
    
    
    
endmodule
