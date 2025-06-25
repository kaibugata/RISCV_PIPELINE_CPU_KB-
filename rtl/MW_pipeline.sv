module MW_pipeline #(
    parameter int DataWidth = 8,//change
    parameter bit CaptureDataEvenIfInputInvalid = 0,
    parameter bit ClearDataOnReset = 0
) (
    input  logic clk_i,
    input  logic reset_i,

    input logic pipeline_flush,//do something with this


    input [31:0] mem_data_i,
    input [3:0] rd_i,//used in forwarding
    input [31:0] mem_address_i,
    input RegWrite_i,

    output [31:0] mem_data_o,
    output [31:0] mem_address_o,
    output [3:0] rd_o,//used in forwarding
    output RegWrite_o,



    input  logic                 valid_i,//the input we put is valid and we are ready to start
    output logic                 ready_o,//the machine is ready for you to start

    output logic                 valid_o,//congrats the data is transmitted
    input  logic                 ready_i//im ready to give the next input
);

typedef enum logic {EMPTY,FULL} state_t;

state_t state_d,state_q;
logic [31:0] mem_data_d, mem_data_q;
logic [3:0]  rd_d, rd_q;
logic [31:0] mem_address_d, mem_address_q;
logic        RegWrite_d, RegWrite_q;


always_comb begin
    ready_o = 1;
    valid_o = 0;


    state_d = state_q;
    mem_data_d = mem_data_q;
    rd_d = rd_q;
    mem_address_d = mem_address_q;
    RegWrite_d = RegWrite_q;

    case (state_q)
        EMPTY: begin
            if(CaptureDataEvenIfInputInvalid) begin
                if(valid_i & ready_o)begin
                    mem_data_d = mem_data_i;
                    rd_d = rd_i;
                    mem_address_d = mem_address_i;
                    RegWrite_d = RegWrite_i;

                    state_d = FULL;
                end
            end else begin
                if(ready_o) begin
                    mem_data_d = mem_data_i;
                    rd_d = rd_i;
                    mem_address_d = mem_address_i;
                    RegWrite_d = RegWrite_i;

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
                    mem_data_d = mem_data_i;
                    rd_d = rd_i;
                    mem_address_d = mem_address_i;
                    RegWrite_d = RegWrite_i;

                    state_d = FULL;
                end
            end
        end
    endcase
end


always_ff @(posedge clk_i) begin
    if (reset_i) begin
        if (ClearDataOnReset) begin
            mem_data_q <= '0;
            rd_q <= '0;
            mem_address_q <= '0;
            RegWrite_q <= 0;
        end
    state_q <= EMPTY;
end else begin
    state_q <= state_d;
    mem_data_q <= mem_data_d;
    rd_q <= rd_d;
    mem_address_q <= mem_address_d;
    RegWrite_q <= RegWrite_d;
end
end

assign mem_data_o = mem_data_q;
assign rd_o = rd_q;
assign mem_address_o = mem_address_q;
assign RegWrite_o = RegWrite_q;

endmodule
