module painter_720p (
    input         clk_pix, // pixel clock
    input  [10:0] sx,      // horizontal screen position
    input  [10:0] sy,      // vertical screen position
    output [7:0]  rgb_r,   // red
    output [7:0]  rgb_g,   // green
    output [7:0]  rgb_b    // blue
);

parameter IMG_POS_X  = 540;
parameter IMG_POS_Y  = 304;

parameter IMG_WIDTH  = 200;
parameter IMG_HEIGHT = 112;

wire in_img_rect;
reg [14:0] addr;
wire [23:0] dout;

assign in_img_rect = (sx >= IMG_POS_X) && (sx < IMG_POS_X + IMG_WIDTH) &&
                     (sy >= IMG_POS_Y) && (sy < IMG_POS_Y + IMG_HEIGHT);

always @(posedge clk_pix) begin
    if (in_img_rect)
        addr <= (sy - IMG_POS_Y) * IMG_WIDTH + (sx - IMG_POS_X);
    else
        addr <= 0;
end

assign {rgb_r, rgb_g, rgb_b} = (in_img_rect) ? dout : 24'h113377;

// rom ip core
rom ROM (
    .clka(clk_pix),
    .ena(in_img_rect),
    .addra(addr),
    .douta(dout)
);

endmodule
