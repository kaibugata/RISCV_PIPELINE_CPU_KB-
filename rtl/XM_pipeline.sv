module XM_pipeline #(
    parameter int DataWidth = 8,//change
    parameter bit CaptureDataEvenIfInputInvalid = 0,
    parameter bit ClearDataOnReset = 0
) (
    input  logic clk_i,
    input  logic reset_i,

    input logic pipeline_flush,//do something with this

    input logic zero_i,
    input logic [63:0] immediate_i
    input logic [63:0] PC_i,
    input logic [63:0] result_i,
    input logic [???:0] MuxRes_i,//figure out
    input logic [63:0] immRes_i,
    input [3:0] rd_i,//used in forwarding
    input RegWrite_i, MemWrite_i, MemRead_i,//the entire control unit passes thru


    output logic zero_o,
    output logic [63:0] immediate_o,
    output logic [63:0] PC_o,
    output logic [63:0] result_o,
    output logic [???:0] MuxRes_o,
    output logic [63:0] immRes_o,
    output [3:0] rd_o,//used in forwarding
    output RegWrite_o, MemWrite_o, MemRead_o,



    input  logic                 valid_i,//the input we put is valid and we are ready to start
    output logic                 ready_o,//the machine is ready for you to start

    output logic                 valid_o,//congrats the data is transmitted
    input  logic                 ready_i//im ready to give the next input
);

typedef enum logic {EMPTY,FULL} state_t;

state_t state_d,state_q;
logic zero_d, zero_q;
logic [63:0] immediate_d, immediate_q;
logic [63:0] PC_d, PC_q;
logic [63:0] result_d, result_q;
logic [??? :0] MuxRes_d, MuxRes_q; // <- Define ??? appropriately
logic [63:0] immRes_d, immRes_q;
logic [3:0] rd_d, rd_q;

logic RegWrite_d, RegWrite_q;
logic MemWrite_d, MemWrite_q;
logic MemRead_d, MemRead_q;


always_comb begin
    ready_o = 1;
    valid_o = 0;


    state_d = state_q;
    zero_d = zero_q;
    immediate_d = immediate_q;
    PC_d = PC_q;
    result_d = result_q;
    MuxRes_d = MuxRes_q;
    immRes_d = immRes_q;
    rd_d = rd_q;
    RegWrite_d = RegWrite_q;
    MemWrite_d = MemWrite_q;
    MemRead_d = MemRead_q;

    case (state_q)
        EMPTY: begin
            if(CaptureDataEvenIfInputInvalid) begin
                if(valid_i & ready_o)begin
                    zero_d = zero_i;
                    immediate_d = immediate_i;
                    PC_d = PC_i;
                    result_d = result_i;
                    MuxRes_d = MuxRes_i;
                    immRes_d = immRes_i;
                    rd_d = rd_i;
                    RegWrite_d = RegWrite_i;
                    MemWrite_d = MemWrite_i;
                    MemRead_d = MemRead_i;

                    state_d = FULL;
                end
            end else begin
                if(ready_o) begin
                    zero_d = zero_i;
                    immediate_d = immediate_i;
                    PC_d = PC_i;
                    result_d = result_i;
                    MuxRes_d = MuxRes_i;
                    immRes_d = immRes_i;
                    rd_d = rd_i;
                    RegWrite_d = RegWrite_i;
                    MemWrite_d = MemWrite_i;
                    MemRead_d = MemRead_i;

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
                    zero_d = zero_i;
                    immediate_d = immediate_i;
                    PC_d = PC_i;
                    result_d = result_i;
                    MuxRes_d = MuxRes_i;
                    immRes_d = immRes_i;
                    rd_d = rd_i;
                    RegWrite_d = RegWrite_i;
                    MemWrite_d = MemWrite_i;
                    MemRead_d = MemRead_i;

                    state_d = FULL;
                end
            end
        end
    endcase
end


always_ff @(posedge clk_i) begin
    if(reset_i) begin
        if(ClearDataOnReset) begin
            zero_q <= 0;
            immediate_q <= '0;
            PC_q <= '0;
            result_q <= '0;
            MuxRes_q <= '0;
            immRes_q <= '0;
            rd_q <= '0;
            RegWrite_q <= 0;
            MemWrite_q <= 0;
            MemRead_q <= 0;
        end
        state_q <= EMPTY;

    end else begin
        state_q <= state_d;
        zero_q <= zero_d;
        immediate_q <= immediate_d;
        PC_q <= PC_d;
        result_q <= result_d;
        MuxRes_q <= MuxRes_d;
        immRes_q <= immRes_d;
        rd_q <= rd_d;
        RegWrite_q <= RegWrite_d;
        MemWrite_q <= MemWrite_d;
        MemRead_q <= MemRead_d;
    end
end

assign zero_o = zero_q;
assign immediate_o = immediate_q;
assign PC_o = PC_q;
assign result_o = result_q;
assign MuxRes_o = MuxRes_q;
assign immRes_o = immRes_q;
assign rd_o = rd_q;
assign RegWrite_o = RegWrite_q;
assign MemWrite_o = MemWrite_q;
assign MemRead_o = MemRead_q;


endmodule
