module test_count_down_from;

reg clk;
wire [3:0] value;

count_down_from uut (.value(value), .clk(clk));

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, test_count_down_from);

    clk = 0;

    #300 $finish;
end

always #5 clk = ~clk;

endmodule
