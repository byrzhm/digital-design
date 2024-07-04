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

module adder (a, b, cin, s, cout);
    parameter N = 4;
    input [N-1:0] a, b;
    input cin;
    output [N-1:0] s;
    output cout;

`ifdef NO_GATES

    wire [N:0] sum;
    assign sum = a + b + cin;
    assign s = sum[N-1:0];
    assign cout = sum[N];

`else

    wire [N:0] carry;

    genvar i;

    generate
        for (i = 0; i < N; i = i + 1) begin
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .s(s[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign carry[0] = cin;
    assign cout = carry[N];
`endif

endmodule
