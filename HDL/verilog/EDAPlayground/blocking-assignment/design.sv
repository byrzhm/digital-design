module dut (
    input clk,
    input reset,
    output reg [3:0] f, g, h
    );

    reg [3:0] temp;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            f = 5;
            g = 8;
            h = 4'hc;
        end else begin
            `ifdef NONBLOCKING
                g <= f;
                h <= g;
                f <= h;
            `else
                // g = f;
                // h = g;
                // f = h;
                temp = g;
                g = f;
                f = h;
                h = temp;
            `endif
        end
    end

endmodule
