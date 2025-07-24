`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2025 09:22:15 PM
// Design Name: 
// Module Name: DF_Stage
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


module DF_Stage(
    //F stage inputs
    input logic clk_i,
    input logic reset_i,
    //input logic [63:0] BranchALUXpipe_out, //NO LONGER NEEDED WITH M STAGE DONE
    //input logic branchtaken, //NO LONGER NEEDED WITH M STAGE DONE
    
    input logic FD_pipeready//remove if needed and set as input
    




    
    
    );
    
    
    //----------------------------------------------
    //D stage outputs 
    logic RegWrite, MemRead, MemWrite, ALUSrc, MemToReg;
    logic [2:0] ALUOp;
    logic [4:0] rd,rs1,rs2;
    logic [63:0] immediate64bit;
    logic [2:0] funct3;
    logic [$clog2(6)-1:0] I_Type;
    logic [31:0] rs1Out, rs2Out;
    //----------------------------------------------
    //X stage outputs
    logic [63:0] BranchALU_out;
    logic [63:0] rs2ImmediateMuxOut;
    logic zeroSignal;
    logic ltzSignal;
    logic [63:0] ALUresultOut;
    logic [2:0] funct3_o;
    logic [$clog2(6)-1:0] I_Type_o;
    //-------------------------------------------------
    //M stage outputs
    logic branchTaken;
    logic [63:0] BranchPC_oM;//THE OUTPUT FROM THE XM PIPELINE(Used in Fetch)
    logic [31:0] Read_Data;
    logic [63:0] Mem_Addr;
    logic MemToReg_o;
    //logic [4:0] rd_o;
    //-------------------------------------------------
    //W stage outputs
    logic [31:0] WBMuxOut;
    logic RegWrite_oW;
    logic [4:0] rd_oW;
    
    
    //logic FD_pipeready;
    //assign FP_pipeready = 1'b0;
    logic [63:0] PC_o;
    logic [31:0] instmemFout;
    FetchStage fetch
    (.clk_i,
    .reset_i,
    .BranchALUXpipe_out(BranchPC_oM),
    .branchtaken(branchTaken),
    .PCready(FD_pipeready),
    .PC_o(PC_o),
    .InstructionMem_out(instmemFout));
    
    logic [31:0] InstructionFPipe_out;
    logic [63:0] PC_FPipe_out;
    FD_pipeline FDPipe
    (.clk_i,
    .reset_i,
    .pipeline_flush(branchTaken),//set as branchtaken as a test
    .instruction_i(instmemFout),
    .PC_i(PC_o),
    .valid_i(|(instmemFout ^ InstructionFPipe_out)),
    .ready_o(),
    .valid_o(),
    .ready_i(FD_pipeready), //SHOULD BE DECIDED BY THE CONSUMER(AKA THE LATER STAGES IF THERE NEEDS TO BE A STALL)
    .instruction_o(InstructionFPipe_out),
    .PC_o(PC_FPipe_out));
    
    DecodeStage Decode (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .Instruction(InstructionFPipe_out),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemToReg(MemToReg),
        .ALUOp(ALUOp),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .WriteValid(RegWrite_oW),
        .WriteData(WBMuxOut),
        .WriteAddress(rd_oW),
        .immediate64bit(immediate64bit),
        .funct3(funct3),
        .I_Type(I_Type),
        .rs1Out(rs1Out),
        .rs2Out(rs2Out)
    );
    
    
    
    //DX pipe outputs
    //-----------------------------------------
    logic [63:0] immediate_oX; 
    logic [63:0] PC_oX;        
    logic [31:0] readData1_oX; 
    logic [31:0] readData2_oX; 
    logic [4:0] rd_oX;        
    logic [4:0] rs1_oX;       
    logic [4:0] rs2_oX;       
    logic RegWrite_oX;  
    logic MemWrite_oX;  
    logic MemRead_oX;   
    logic ALUSrc_oX;    
    logic MemToReg_oX;  
    logic [2:0] ALUOp_oX;     
    logic [2:0] funct3_oX;    
    logic [$clog2(6)-1:0] I_Type_oX; 
       
    DX_pipeline DXPipe 
    (.clk_i(clk_i),
    .reset_i(reset_i),
    .pipeline_flush(branchTaken),
    .readData1_i(rs1Out),
    .readData2_i(rs2Out),
    .immediate_i(immediate64bit),
    .PC_i(PC_FPipe_out),
    .rd_i(rd),
    .rs1_i(rs1),
    .rs2_i(rs2),
    .RegWrite_i(RegWrite),
    .MemWrite_i(MemWrite),
    .MemRead_i(MemRead),
    .ALUSrc_i(ALUSrc),
    .MemToReg_i(MemToReg),
    .ALUOp_i(ALUOp),
    .funct3_i(funct3),
    .I_Type_i(I_Type),
    .immediate_o(immediate_oX),
    .PC_o(PC_oX),
    .readData1_o(readData1_oX),
    .readData2_o(readData2_oX),
    .rd_o(rd_oX),
    .rs1_o(rs1_oX),
    .rs2_o(rs2_oX),
    .RegWrite_o(RegWrite_oX),
    .MemWrite_o(MemWrite_oX),
    .MemRead_o(MemRead_oX),
    .ALUSrc_o(ALUSrc_oX),
    .MemToReg_o(MemToReg_oX),
    .ALUOp_o(ALUOp_oX),
    .funct3_o(funct3_oX),
    .I_Type_o(I_Type_oX),
    .valid_i(|(rs1Out ^ rs1_oX) | |(rs2Out ^ rs2_oX)), //or something idk 
    //THIS VALID_i causes problems maybe put a bandaid fix or something more concrete. IT WONT HOLD UP FOR ALL INSTRUCTS
    .ready_o(),
    .valid_o(),
    .ready_i(FD_pipeready)
    
    );
    logic [4:0] rd_oM;
    logic RegWrite_oM;
    logic [63:0] ALUResult_oM;
    //-----------------------------------------
    
    ExecuteStage execute
    (.clk_i(clk_i),
    .reset_i(reset_i),
    .rd(rd_oX),
    .rs1(rs1_oX),
    .rs2(rs2_oX),
    .immediate64bit(immediate_oX),
    .rs1Out(readData1_oX),
    .rs2Out(readData2_oX),
    .PC_i(PC_oX),
    .RegWrite(RegWrite_oX),
    .MemRead(MemRead_oX),
    .MemWrite(MemWrite_oX),
    .ALUSrc(ALUSrc_oX),
    .MemToReg(MemToReg_oX),
    .ALUOp(ALUOp_oX),
    .funct3(funct3_oX),
    .I_Type(I_Type_oX),
    .rd_w(rd_oW),
    .rd_x(rd_oM),
    .regwrite_w(RegWrite_oW),
    .regwrite_x(RegWrite_oM),
    .WBdata({{32{WBMuxOut[31]}}, WBMuxOut}),
    .MemAddr(ALUResult_oM),
    .BranchALU_out(BranchALU_out),
    .rs2ImmediateMuxOut(rs2ImmediateMuxOut),
    .zeroSignal(zeroSignal),
    .ltzSignal(ltzSignal),
    .ALUresultOut(ALUresultOut),
    .funct3_o(funct3_o),
    .I_Type_o(I_Type_o));
    
    
    //XM pipe outputs
    //-----------------------------------------
    logic zero_oM, ltz_oM;
    logic [63:0] MuxRes_oM;
     
    logic MemWrite_oM, MemRead_oM, MemToReg_oM;
    logic [2:0] funct3_oM;    
    logic [$clog2(6)-1:0] I_Type_oM; 
    
    
    XM_pipeline XMpipe 
    (.clk_i(clk_i),
    .reset_i(reset_i),
    .pipeline_flush(branchTaken),
    .zero_i(zeroSignal),
    .BranchPC_i(BranchALU_out),
    .result_i(ALUresultOut),
    .MuxRes_i({{59{rs2_oX[4]}}, rs2_oX}),//was rs2ImmediateMuxOut
    .rd_i(rd_oX),
    .RegWrite_i(RegWrite_oX),
    .MemWrite_i(MemWrite_oX),
    .MemRead_i(MemRead_oX),
    .MemToReg_i(MemToReg_oX),
    .funct3_i(funct3_o),
    .I_Type_i(I_Type_o),
    .ltz_i(ltzSignal),
    .zero_o(zero_oM),
    .ltz_o(ltz_oM),
    .BranchPC_o(BranchPC_oM),
    .result_o(ALUResult_oM),
    .MuxRes_o(MuxRes_oM),
    .rd_o(rd_oM),
    .RegWrite_o(RegWrite_oM),
    .MemWrite_o(MemWrite_oM),
    .MemRead_o(MemRead_oM),
    .MemToReg_o(MemToReg_oM),
    .funct3_o(funct3_oM),
    .I_Type_o(I_Type_oM),
    .valid_i(|(BranchPC_oM ^ BranchALU_out) | |(ALUresultOut ^ ALUResult_oM)),
    .ready_o(),
    .valid_o(),
    .ready_i(FD_pipeready)
    );
    
    
    MemoryStage Memory
    (.clk_i(clk_i),
    .reset_i(reset_i),
    .funct3(funct3_oM),
    .I_Type(I_Type_oM),
    .zero(zero_oM),
    .ltz(ltz_oM),
    .ALUresult(ALUResult_oM),
    .MemWrite(MemWrite_oM),
    .MemToReg(MemToReg_oM),
    .MemRead(MemRead_oM),
    .MuxResOut(MuxRes_oM[31:0]),
    .branchtaken(branchTaken),
    .mem_data_o(Read_Data),
    .ALUresultOut(Mem_Addr),
    .MemToReg_o(MemToReg_o));
    
    
    
    //MW pipe outputs
    logic MemToReg_oW;
    logic [31:0] MemAddress_oW;
    logic [31:0] MemData_oW;
    MW_pipeline MWpipe
    (.clk_i(clk_i),
    .reset_i(reset_i),
    .pipeline_flush(),
    .mem_data_i(Read_Data),
    .rd_i(rd_oM),
    .mem_address_i(Mem_Addr[31:0]),
    .RegWrite_i(RegWrite_oM), 
    .MemToReg_i(MemToReg_o),
    .mem_data_o(MemData_oW),
    .mem_address_o(MemAddress_oW),
    .rd_o(rd_oW),
    .RegWrite_o(RegWrite_oW), 
    .MemToReg_o(MemToReg_oW),
    .valid_i(|(Mem_Addr ^ MemAddress_oW) | |(Read_Data ^ MemData_oW)),
    .ready_o(),
    .valid_o(),
    .ready_i(FD_pipeready));
    
    
    two_1Mux64 WBMux
    (.a(MemAddress_oW),//mem_addr
    .b(MemData_oW),//readdata
    .sel(MemToReg_oW),//memtoreg
    .out(WBMuxOut[31:0]));
    
    
endmodule
