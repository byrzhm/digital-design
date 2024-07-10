module REGISTER(q, d, clk);
    
parameter N = 1;
input [N-1:0] d;
input clk;
output reg [N-1:0] q = {N{1'b0}};

always @(posedge clk) q <= d;

endmodule


/**
 * On the rising clock edge if clock enable (ce) is 0 then the register is
 * disabled (it's state will not be changed).
 */
 module REGISTER_CE(q, d, ce, clk);

 parameter N = 1;

 input [N-1:0] d;
 input ce;
 input clk;
 output reg [N-1:0] q = {N{1'b0}};

 always @(posedge clk) begin
     if (ce == 1)
         q <= d;
     else
         q <= q;
end

endmodule


/**
 * On the rising clock edge if reset (rst) is 1 then the state is set to the
 * value of INIT. Default INIT value is all 0's.
 */
module REGISTER_R(q, d, rst, clk);

parameter N = 1;
parameter [N-1:0] INIT = {N{1'b0}};

input [N-1:0] d;
input rst;
input clk;
output reg [N-1:0] q = INIT;

always @(posedge clk) begin
    if (rst == 1)
        q <= INIT;
    else
        q <= d;
end

endmodule

/**
 * Reset (rst) has priority over clock enable (ce).
 */
module REGISTER_R_CE(q, d, rst, ce, clk);

parameter N = 1;
parameter INIT = {N{1'b0}};

input [N-1:0] d;
input rst;
input ce;
input clk;
output reg [N-1:0] q = INIT;

always @(posedge clk) begin
    if (rst == 1)
        q <= INIT;
    else if (ce == 1)
        q <= d;
    else
        q <= q;
end

endmodule

