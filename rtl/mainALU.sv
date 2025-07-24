module mainALU(
    input logic [63:0] op1,
    input logic [63:0] op2,
    input logic [2:0] operand,
    output logic [63:0] out,
    output logic zero,
    output logic ltz);


always_comb begin
case(operand)
3'b000: begin out = op1 + op2;
            zero = (op1+op2) == 0;
        end
3'b001: begin out = op1 - op2;
            zero = (op1-op2) == 0;
            ltz = (op1-op2) < 0;
        end
3'b010: begin out = op1 & op2;
            zero = (op1&op2) == 0;
        end
3'b011: begin out = op1 | op2;
            zero = (op1|op2) == 0;
        end
3'b100: begin out = op1 ^ op2;
            zero = (op1^op2) == 0;
        end
3'b101: begin out = op1 << op2;
            zero = (op1<<op2) == 0;
        end
3'b110: begin out = op1 >> op2;
            zero = (op1>>op2) == 0;
        end

endcase
end

endmodule
