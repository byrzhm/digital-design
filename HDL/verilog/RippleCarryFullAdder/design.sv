module full_adder (
    input a, b, cin,
    output s, cout);

    wire net1, net2, net3;

    xor (net1, a, b);
    xor (s, net1, cin);

    and (net3, a, b);
    and (net2, net1, cin);
    or (cout, net2, net3);

endmodule

module full_adder_4 (
    input [3:0] a, b,
    input cin,
    output [3:0] s,
    output cout);

`ifdef NO_GATES
    wire [4:0] sum;
    assign sum = a + b + cin;
    assign s = sum[3:0];
    assign cout = sum[4];

`else

    wire [2:0] carry;

    full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .s(s[0]),
        .cout(carry[0])
    );

    full_adder fa1 (
        .a(a[1]),
        .b(b[1]),
        .cin(carry[0]),
        .s(s[1]),
        .cout(carry[1])
    );

    full_adder fa2 (
        .a(a[2]),
        .b(b[2]),
        .cin(carry[1]),
        .s(s[2]),
        .cout(carry[2])
    );

    full_adder fa3 (
        .a(a[3]),
        .b(b[3]),
        .cin(carry[2]),
        .s(s[3]),
        .cout(cout)
    );
`endif

endmodule
