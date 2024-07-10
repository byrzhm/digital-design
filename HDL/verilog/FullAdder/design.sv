module half_adder (
  input a,
  input b,
  output s,
  output c_out
);
  
  assign s = a ^ b;
  assign c_out = a & b;
  
endmodule

module full_adder (
  input a,
  input b,
  input c_in,
  output s,
  output c_out
);
  
    wire [1:0] a_i;
    wire [1:0] b_i;
    wire [1:0] sum;
    wire [1:0] c_o;

    genvar i;
    generate
        for (i = 0; i < 2; i = i + 1) begin
            half_adder ha(
                .a(a_i[i]),
                .b(b_i[i]),
                .s(sum[i]),
                .c_out(c_o[i])
            );
        end
    endgenerate

    assign a_i[0] = a;
    assign a_i[1] = b;
    assign b_i[0] = c_in;
    assign b_i[1] = sum[0];
    assign s = sum[1];

    assign c_out = c_o[0] | c_o[1];
  
endmodule
