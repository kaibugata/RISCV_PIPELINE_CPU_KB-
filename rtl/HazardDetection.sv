`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2025 12:07:40 PM
// Design Name: 
// Module Name: HazardDetection
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


module HazardDetection(

input logic [4:0] prevRd,
input logic [4:0] CurrentRs1, CurrentRs2,
input logic THEINSTRUCTIONISINWRITEBACK,
//output logic moveon,
output logic stallPipe


    );
    
    
    always_comb begin
        stallPipe = 0;
        if(CurrentRs1 == prevRd || CurrentRs2 == prevRd) begin
            stallPipe = 1; 
        end
        
        if(THEINSTRUCTIONISINWRITEBACK) begin
            stallPipe = 0;
        end
    
    
    end
    
    
    
    
    
    
    
    //used for detecting read after write hazards
    //Should be located in decode stage
    //has an output which dictates the pipleline stall. should be 1 until the previous instruciton has made it to the writeback stage then zero.
    //
    
    
    
endmodule
