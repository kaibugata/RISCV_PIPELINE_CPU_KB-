module Instruction_Parser (
    input logic [31:0] Instruction,
    output [3:0] rd,rs1,rs2,
    output [2:0] funct3,
    output [6:0] opcode,
    output [6:0] funct7,
    output [$clog2(6)-1:0] I_Type

)


//Should I output rs1,rs2,rd, opcode from this to use in a different module later in the processor
//look at the opcode and deduce the instruction from it/ Use the hexadecimal on the green card
//https://luplab.gitlab.io/rvcodecjs/
always_comb begin : parse
    //Key: I: 0x0, U:0x1, S:0x2, R:0x3, SB: 0x4,  UJ: 0x5
    case(Instruction[6:0])
        7'h3: I_Type = 0;//I
        7'h13:I_Type = 0;
        7'h1B:I_Type = 0;
        7'h67:I_Type = 0;
        7'h17:I_Type = 1;//U
        7'h37:I_Type = 1;
        7'h23:I_Type = 2;//S
        7'h33:I_Type = 3;//R
        7'h3B:I_Type = 3;
        7'h63:I_Type = 4;//SB
        7'h6F:I_Type = 5;//UF
        default:I_Type = 0;
    endcase


    //Depending on the IType, we can set any of these to invalid inputs(using mem's valid input) based on if we need it
    rd = Instruction[11:7];
    rs1 = Instruction[19:15];
    rs2 = Instruction[24:20];
    funct3 = Instruction[14:12];
    opcode = Instruction[6:0];
    funct7 = Instruction[31:25];//Only for R-Type


end

endmodule
