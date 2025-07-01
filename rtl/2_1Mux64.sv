module two_1Mux64
(input [63:0] a,//sel = 0
input [63:0] b, //sel = 1
input sel,
output [63:0] out)

assign out = sel ? b : a;

endmodule
