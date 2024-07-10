module test_count_to;

reg clk;
wire [3:0] value;

count_to uut (.value(value), .clk(clk));

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, test_count_to);

    clk = 0;

    #300 $finish;
end

always #5 clk = ~clk;

endmodule
