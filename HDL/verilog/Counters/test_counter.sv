module test_counter;

reg reset, enable, clk;
wire [3:0] value;

counter uut (.value(value), .enable(enable), .reset(reset), .clk(clk));

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, test_counter);

    reset = 1;
    enable = 0;
    clk = 0;
    #10 reset = 0;
    #10 enable = 1;
    #300 $finish;
end

always #5 clk = ~clk;

endmodule
