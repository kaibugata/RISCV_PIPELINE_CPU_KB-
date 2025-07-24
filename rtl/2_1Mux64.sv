module two_1Mux64
(input logic [63:0] a,//sel = 0
input logic [63:0] b, //sel = 1
input logic sel,
output logic [63:0] out);

assign out = sel ? b : a;

endmodule
