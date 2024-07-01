module shift (
    input clk,
    input reset,
    input data_in,
    output data_out);

    parameter DEPTH = 3;
    wire [DEPTH:0] connect_wire;

    assign data_out = connect_wire[DEPTH];
    assign connect_wire[0] = data_in;

    genvar i;
    generate
        for (i = 1; i <= DEPTH; i = i + 1) begin
            dff DFF(
                .clk(clk),
                .reset(reset),
                .d(connect_wire[i - 1]),
                .q(connect_wire[i])
                );
        end
    endgenerate

endmodule

// D Flip-Flop
module dff (
    input clk,
    input reset,
    input d,
    output reg q);

    always @(posedge clk or posedge reset)
    begin
        if (reset) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
    end
endmodule

