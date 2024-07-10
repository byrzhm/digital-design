module count_to(value, clk);

output [3:0] value;
input clk;
wire [3:0] next;
wire rst;

REGISTER_R #(4) state (.q(value), .d(next), .rst(rst), .clk(clk));

assign next = value + 1;
assign rst = (value == 4'h6 || reset) ? 1'b1 : 1'b0;

endmodule
