module painter_480p (
    input wire logic       clk_pix,
    input wire logic [9:0] sx,
    input wire logic [9:0] sy,
    output     logic [7:0] rgb_r,
    output     logic [7:0] rgb_g,
    output     logic [7:0] rgb_b
);

wire [7:0] W = {8{sx[7:0]==sy[7:0]}};
wire [7:0] A = {8{sx[7:5]==3'h2 && sy[7:5]==3'h2}};

always @(posedge clk_pix) rgb_r <= ({sx[5:0] & {6{sy[4:3]==~sx[4:3]}}, 2'b00} | W) & ~A;
always @(posedge clk_pix) rgb_g <= (sx[7:0] & {8{sy[6]}} | W) & ~A;
always @(posedge clk_pix) rgb_b <= sy[7:0] | W | A;

endmodule
