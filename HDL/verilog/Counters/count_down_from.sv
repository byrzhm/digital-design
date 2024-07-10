module count_down_from(value, clk);

output [3:0] value;
input clk;
wire [3:0] next;
wire rst;

REGISTER_R #(.N(4), .INIT(4'd11))
    state (.q(value), .d(next), .rst(rst), .clk(clk));

assign next = value - 1;
assign rst = ~(|value);

endmodule
