module synchronizer #(parameter WIDTH = 1) (
    input [WIDTH-1:0] async_signal,
    input clk,
    output [WIDTH-1:0] sync_signal
);
    // This module takes in a vector of WIDTH-bit asynchronous
    // (from different clock domain or not clocked, such as button press) signals
    // and should output a vector of WIDTH-bit synchronous signals
    // that are synchronized to the input clk

    wire [WIDTH-1:0] dff0_q;
    REGISTER #(.N(WIDTH)) dff0 (
        .q(dff0_q),
        .d(async_signal),
        .clk(clk)
    );

    REGISTER #(.N(WIDTH)) dff1 (
        .q(sync_signal),
        .d(dff0_q),
        .clk(clk)
    );
endmodule
