module XM_pipeline #(
    parameter int DataWidth = 8,//change
    parameter bit CaptureDataEvenIfInputInvalid = 0,
    parameter bit ClearDataOnReset = 0
) (
    input  logic clk_i,
    input  logic reset_i,

    input logic pipeline_flush,//do something with this

    input logic zero_i,
    input logic [63:0] BranchPC_i,
    input logic [63:0] result_i,
    input logic [63:0] MuxRes_i,//figure out
    input logic [4:0] rd_i,//used in forwarding
    input logic RegWrite_i, MemWrite_i, MemRead_i, MemToReg_i,//the entire control unit passes thru
    input logic [2:0] funct3_i,
    input logic [$clog2(6)-1:0] I_Type_i,
    input logic ltz_i,



    output logic zero_o,
    output logic ltz_o,
    output logic [63:0] BranchPC_o,
    output logic [63:0] result_o,
    output logic [63:0] MuxRes_o,
    output logic [4:0] rd_o,//used in forwarding
    output logic RegWrite_o, MemWrite_o, MemRead_o, MemToReg_o,
    output logic [2:0] funct3_o,
    output logic [$clog2(6)-1:0] I_Type_o,




    input  logic                 valid_i,//the input we put is valid and we are ready to start
    output logic                 ready_o,//the machine is ready for you to start

    output logic                 valid_o,//congrats the data is transmitted
    input  logic                 ready_i//im ready to give the next input
);

typedef enum logic {EMPTY,FULL} state_t;

state_t state_d,state_q;
logic zero_d, zero_q;
logic [63:0] BranchPC_d, BranchPC_q;
logic [63:0] result_d, result_q;
logic [63:0] MuxRes_d, MuxRes_q; // <- Define ??? appropriately
logic [4:0] rd_d, rd_q;

logic RegWrite_d, RegWrite_q;
logic MemWrite_d, MemWrite_q;
logic MemRead_d, MemRead_q;
logic MemToReg_d, MemToReg_q;
logic [$clog2(6)-1:0] I_Type_d, I_Type_q;
logic [2:0] funct3_d, funct3_q;
logic ltz_d, ltz_q;



always_comb begin
    ready_o = 1;
    valid_o = 0;


    state_d = state_q;
    zero_d = zero_q;
    BranchPC_d = BranchPC_q;
    result_d = result_q;
    MuxRes_d = MuxRes_q;
    rd_d = rd_q;
    RegWrite_d = RegWrite_q;
    MemWrite_d = MemWrite_q;
    MemRead_d = MemRead_q;
    MemToReg_d = MemToReg_q;
    funct3_d = funct3_q;
    I_Type_d = I_Type_q;
    ltz_d = ltz_q;


    case (state_q)
        EMPTY: begin
            if(CaptureDataEvenIfInputInvalid) begin
                if(valid_i & ready_o)begin
                    zero_d = zero_i;
                    BranchPC_d = BranchPC_i;
                    result_d = result_i;
                    MuxRes_d = MuxRes_i;
                    rd_d = rd_i;
                    RegWrite_d = RegWrite_i;
                    MemWrite_d = MemWrite_i;
                    MemRead_d = MemRead_i;
                    MemToReg_d = MemToReg_i;
                    funct3_d = funct3_i;
                    I_Type_d = I_Type_i;
                    ltz_d = ltz_i;


                    state_d = FULL;
                end
            end else begin
                if(ready_o) begin
                    zero_d = zero_i;
                    BranchPC_d = BranchPC_i;
                    result_d = result_i;
                    MuxRes_d = MuxRes_i;
                    rd_d = rd_i;
                    RegWrite_d = RegWrite_i;
                    MemWrite_d = MemWrite_i;
                    MemRead_d = MemRead_i;
                    MemToReg_d = MemToReg_i;
                    funct3_d = funct3_i;
                    I_Type_d = I_Type_i;
                    ltz_d = ltz_i;


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
                    BranchPC_d = BranchPC_i;
                    result_d = result_i;
                    MuxRes_d = MuxRes_i;
                    rd_d = rd_i;
                    RegWrite_d = RegWrite_i;
                    MemWrite_d = MemWrite_i;
                    MemRead_d = MemRead_i;
                    MemToReg_d = MemToReg_i;
                    funct3_d = funct3_i;
                    I_Type_d = I_Type_i;
                    ltz_d = ltz_i;


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
            BranchPC_q <= '0;
            result_q <= '0;
            MuxRes_q <= '0;
            rd_q <= '0;
            RegWrite_q <= 0;
            MemWrite_q <= 0;
            MemRead_q <= 0;
            MemToReg_q <= 0;
            funct3_q <= '0;
            I_Type_q <= '0;
            ltz_q <= '0;
        end
        state_q <= EMPTY;

    end else begin
        state_q <= state_d;
        zero_q <= zero_d;
        BranchPC_q <= BranchPC_d;
        result_q <= result_d;
        MuxRes_q <= MuxRes_d;
        rd_q <= rd_d;
        RegWrite_q <= RegWrite_d;
        MemWrite_q <= MemWrite_d;
        MemRead_q <= MemRead_d;
        MemToReg_q <= MemToReg_d;
        funct3_q <= funct3_d;
        I_Type_q <= I_Type_d;
        ltz_q <= ltz_d;
    end
end

assign zero_o = zero_q;
assign BranchPC_o = BranchPC_q;
assign result_o = result_q;
assign MuxRes_o = MuxRes_q;
assign rd_o = rd_q;
assign RegWrite_o = RegWrite_q;
assign MemWrite_o = MemWrite_q;
assign MemRead_o = MemRead_q;
assign MemToReg_o = MemToReg_q;
assign funct3_o = funct3_q;
assign I_Type_o = I_Type_q;
assign ltz_o = ltz_q;


endmodule
