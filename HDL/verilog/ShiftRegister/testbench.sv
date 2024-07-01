module test;

    reg clk;
    reg reset;
    reg data_in;
    wire data_out;

    shift #(.DEPTH(4)) shift(
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .data_out(data_out)
        );

    always #10 clk = ~clk;

    initial begin
        $dumpvars(0, test);

        clk = 0;
        reset = 1;
        #1 reset = 0;
        data_in = 0;

        repeat (5)
            #20 $display("data_in:%b, data_out:%b",
                data_in, data_out);
        data_in = 1;
        repeat (10)
            #20 $display("data_in:%b, data_out:%b",
                data_in, data_out);
        data_in = 0;
        repeat (10)
            #20 $display("data_in:%b, data_out:%b",
                data_in, data_out);
        $finish;
    end

endmodule

