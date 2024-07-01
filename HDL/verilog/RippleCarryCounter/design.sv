// Toggle Flip Flop
module tff (clk, reset, q);
    input clk;
    input reset;
    output q;
    
    reg q;
    
    always @(negedge clk or posedge reset)
    begin
        if (reset) begin
            q <= 1'b0;
        end else begin
            q <= ~q;
        end
    end

endmodule


// Ripple Carry Counter
module ripple_carry_counter (clk, reset, q);
    input clk;
    input reset;
    output [3:0] q;
    
    tff tff0(clk, reset, q[0]);
    tff tff1(q[0], reset, q[1]);
    tff tff2(q[1], reset, q[2]);
    tff tff3(q[2], reset, q[3]);

endmodule
