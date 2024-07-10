// 4-bit wrap-around counter
module counter(value, enable, reset, clk);

output [3:0] value;
input enable, reset, clk;
wire [3:0] next;

REGISTER_R_CE #(4) state (.q(value), .d(next), .rst(reset), .ce(enable), .clk(clk));

assign next = value + 1;

endmodule

