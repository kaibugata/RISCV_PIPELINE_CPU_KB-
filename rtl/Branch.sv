module Branch(
    input logic zero,
    input logic ltz, //less than zero
    input logic [2:0] funct3,
    input logic [$clog2(6)-1:0] I_Type,
    output logic  branchtaken);

    always_comb begin
        if (I_Type == 4) begin
            case(funct3)
            3'b000: branchtaken = zero;
            3'b001: branchtaken = ~zero;
            3'b100: branchtaken = ltz;
            3'b101: branchtaken = zero | ~ltz;
            default: branchtaken = 1'b0;
            endcase
        end else begin
            branchtaken = 1'b0;
        end
    end

endmodule
