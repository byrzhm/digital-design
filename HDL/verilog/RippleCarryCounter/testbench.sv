module test;

    reg clk, reset;
    wire [3:0] q;

    // Instantiate
    ripple_carry_counter rcc(.clk(clk), .reset(reset), .q(q));

    initial begin
        // Dump waves
        $dumpfile("dump.vcd");
        $dumpvars(1, test); // change to 0 to see all signals

        clk = 1'b0;
        reset = 1'b1;
        #10 reset = 1'b0;

        #200;
        reset = 1'b1;
        #10 reset = 1'b0;

        #50;
        $finish;

    end

    always #5 clk = ~clk;

endmodule
