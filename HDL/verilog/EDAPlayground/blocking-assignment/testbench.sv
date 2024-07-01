module test;

    reg a, b, c, d, e;
    reg clk, reset;
    wire [3:0] f, g, h;

    dut dut (
        .clk(clk),
        .reset(reset),
        .f(f),
        .g(g),
        .h(h));

    initial begin
        $dumpvars(1, test);

        clk = 0;
        reset <= 1;
        reset <= #5 0;

        `ifdef NONBLOCKING
            a <= 0;
            b <= 1;
            // c <= b;
            c <= 1;

            d <= #15 1;
            e <= #20 1;
            // a <= a + 1;

            #25;
        `else
            a = 0;
            b = 1;
            c = b;

            #15 d = 1;
            #5 e = 1;
            a = a + 1;

            #5;
        `endif


        $finish;

    end

    always #2 clk = ~clk;

endmodule

