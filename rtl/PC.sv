module PC #(
    parameter int MaxNumInstruc = 100
)(
    input logic clk_i,
    input logic reset_i,
    input logic [$clog2(MaxNumInstruc)-1:0] PC_i,
    output logic [$clog2(MaxNumInstruc)-1:0] PC_o
);

//The program counter takes in an input which is the input of the pc and passes that to the output



always_ff @(posedge clk_i) begin
if(reset_i) begin
PC_o <= '0;
end else begin
PC_o <= PC_i;
end

end
