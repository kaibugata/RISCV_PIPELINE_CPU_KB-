module DX_pipeline #(
    parameter int DataWidth = 8,//change
    parameter bit CaptureDataEvenIfInputInvalid = 0,
    parameter bit ClearDataOnReset = 0
) (
    input  logic clk_i,
    input  logic reset_i,

    input logic pipeline_flush,//do something with this

    input  logic [31:0] readData1_i, readData2_i,
    input logic [63:0] immediate_i
    input logic [63:0] PC_i,
    input [3:0] rd_i,rs1_i,rs2_i,//used in forwarding

//the entire control unit passes thru
    input RegWrite_i, MemWrite_i, MemRead_i, ALUSrc_i,
    input [2:0] ALUOp_i,


    output logic [63:0] immediate_o,
    output logic [63:0] PC_o,
    output  logic [31:0] readData1_o, readData2_o,
    output [3:0] rd_o,rs1_o,rs2_o,//used in forwarding
    output RegWrite_o, MemWrite_o, MemRead_o, ALUSrc_o,
    output [2:0] ALUOp_o,


    input  logic                 valid_i,//the input we put is valid and we are ready to start
    output logic                 ready_o,//the machine is ready for you to start

    output logic                 valid_o,//congrats the data is transmitted
    input  logic                 ready_i//im ready to give the next input
);

typedef enum logic {EMPTY,FULL} state_t;

state_t state_d,state_q;
logic [63:0] PC_d, PC_q;
logic [31:0] readData1_d, readData1_q;
logic [31:0] readData2_d, readData2_q;
logic [63:0] immediate_d, immediate_q;
logic [3:0] rd_d, rd_q, rs1_d, rs1_q, rs2_d, rs2_q;
logic RegWrite_d, RegWrite_q;
logic MemWrite_d, MemWrite_q;
logic MemRead_d, MemRead_q;
logic ALUSrc_d, ALUSrc_q;
logic [2:0] ALUOp_d, ALUOp_q;


always_comb begin
    ready_o = 1;
    valid_o = 0;


    state_d = state_q;
    PC_d = PC_q;
    readData1_d = readData1_q;
    readData2_d = readData2_q;
    immediate_d = immediate_q;
    rd_d = rd_q;
    rs1_d = rs1_q;
    rs2_d = rs2_q;
    RegWrite_d = RegWrite_q;
    MemWrite_d = MemWrite_q;
    MemRead_d = MemRead_q;
    ALUSrc_d = ALUSrc_q;
    ALUOp_d = ALUOp_q;

    case (state_q)
        EMPTY: begin
            if(CaptureDataEvenIfInputInvalid) begin
                if(valid_i & ready_o)begin
                    PC_d = PC_i;
                    readData1_d = readData1_i;
                    readData2_d = readData2_i;
                    immediate_d = immediate_i;
                    rd_d = rd_i;
                    rs1_d = rs1_i;
                    rs2_d = rs2_i;
                    RegWrite_d = RegWrite_i;
                    MemWrite_d = MemWrite_i;
                    MemRead_d = MemRead_i;
                    ALUSrc_d = ALUSrc_i;
                    ALUOp_d = ALUOp_i;

                    state_d = FULL;
                end
            end else begin
                if(ready_o) begin
                    PC_d = PC_i;
                    readData1_d = readData1_i;
                    readData2_d = readData2_i;
                    immediate_d = immediate_i;
                    rd_d = rd_i;
                    rs1_d = rs1_i;
                    rs2_d = rs2_i;
                    RegWrite_d = RegWrite_i;
                    MemWrite_d = MemWrite_i;
                    MemRead_d = MemRead_i;
                    ALUSrc_d = ALUSrc_i;
                    ALUOp_d = ALUOp_i;

                    if(valid_i) begin
                        state_d = FULL;
                    end
                end
            end
        end

        FULL: begin
            valid_o = 1;
            ready_o = 0;
            if(ready_i) begin
                ready_o = 1;
                state_d = EMPTY;
                if(valid_i) begin
                    PC_d = PC_i;
                    readData1_d = readData1_i;
                    readData2_d = readData2_i;
                    immediate_d = immediate_i;
                    rd_d = rd_i;
                    rs1_d = rs1_i;
                    rs2_d = rs2_i;
                    RegWrite_d = RegWrite_i;
                    MemWrite_d = MemWrite_i;
                    MemRead_d = MemRead_i;
                    ALUSrc_d = ALUSrc_i;
                    ALUOp_d = ALUOp_i;

                    state_d = FULL;
                end
            end
        end
    endcase
end


always_ff @(posedge clk_i) begin
    if(reset_i) begin
        if(ClearDataOnReset) begin
            PC_q <= '0;
            readData1_q <= '0;
            readData2_q <= '0;
            immediate_q <= '0;
            rd_q <= '0;
            rs1_q <= '0;
            rs2_q <= '0;
            RegWrite_q <= 0;
            MemWrite_q <= 0;
            MemRead_q <= 0;
            ALUSrc_q <= 0;
            ALUOp_q <= '0;

        end
        state_q <= EMPTY;

    end else begin
        state_q <= state_d;
        PC_q <= PC_d;
        readData1_q <= readData1_d;
        readData2_q <= readData2_d;
        immediate_q <= immediate_d;
        rd_q <= rd_d;
        rs1_q <= rs1_d;
        rs2_q <= rs2_d;
        RegWrite_q <= RegWrite_d;
        MemWrite_q <= MemWrite_d;
        MemRead_q <= MemRead_d;
        ALUSrc_q <= ALUSrc_d;
        ALUOp_q <= ALUOp_d;
    end
end

assign PC_o = PC_q;
assign readData1_o = readData1_q;
assign readData2_o = readData2_q;
assign immediate_o = immediate_q;
assign rd_o = rd_q;
assign rs1_o = rs1_q;
assign rs2_o = rs2_q;
assign RegWrite_o = RegWrite_q;
assign MemWrite_o = MemWrite_q;
assign MemRead_o = MemRead_q;
assign ALUSrc_o = ALUSrc_q;
assign ALUOp_o = ALUOp_q;



endmodule
