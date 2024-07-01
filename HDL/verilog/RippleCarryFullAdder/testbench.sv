module test;

    reg [3:0] a, b;
    reg cin;
    wire [3:0] s;
    wire cout;

    full_adder_4 dut (
        .a(a),
        .b(b),
        .cin(cin),
        .s(s),
        .cout(cout)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1, test);

        #5;
        a = 4'b0000;
        b = 4'b0000;
        cin = 1'b0;

        #5;
        a = 2;
        b = 3;

        #5;
        cin = 1;

        #5;
        cin = 0;
        a = 4'b1000;
        b = 4'b0111;

        #5;
        cin = 1;

        #5 $finish;

    end

endmodule

