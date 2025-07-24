module FD_pipeline #(
    parameter int DataWidth = 8,//change
    parameter bit CaptureDataEvenIfInputInvalid = 0,
    parameter bit ClearDataOnReset = 0
) (
    input  logic clk_i,
    input  logic reset_i,

    input logic pipeline_flush,//do something with this

    input  logic [31:0] instruction_i,
    input logic [63:0] PC_i,
    input  logic                 valid_i,//the input we put is valid and we are ready to start
    output logic                 ready_o,//the machine is ready for you to start

    output logic                 valid_o,//congrats the data is transmitted
    output logic [31:0] instruction_o,
    output logic [63:0] PC_o,
    input  logic                 ready_i//im ready to give the next input
);

typedef enum logic {EMPTY,FULL} state_t;

state_t state_d,state_q;
logic [63:0] PC_d, PC_q;
logic [31:0] instruction_d, instruction_q;

always_comb begin
    ready_o = 1;
    valid_o = 0;


    state_d = state_q;
    PC_d = PC_q;

    case (state_q)
        EMPTY: begin
            if(CaptureDataEvenIfInputInvalid) begin
                if(valid_i & ready_o)begin
                    PC_d = PC_i;
                    instruction_d = instruction_i;
                    state_d = FULL;
                end
            end else begin
                if(ready_o) begin
                    PC_d = PC_i;
                    instruction_d = instruction_i;
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
                    instruction_d = instruction_i;
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
            instruction_q <= '0;
        end
        state_q <= EMPTY;

    end else
    if(pipeline_flush) begin
        instruction_q <= 32'b00000000000000000000000000010011;
        PC_q <= '0;
    end else begin
    
    
    
        state_q <= state_d;
        PC_q <= PC_d;
        instruction_q <= instruction_d;
        
        
    end
end

assign PC_o = PC_q;
assign instruction_o = instruction_q;


endmodule
