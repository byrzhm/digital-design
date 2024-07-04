module top (
    input        clk_50MHz,
    output       hdmi_oen,
    output       TMDS_Clk_n,
    output       TMDS_Clk_p,
    output [2:0] TMDS_Data_n,
    output [2:0] TMDS_Data_p
);

wire clk_pix;
wire clk_pix_5x;
wire hsync;       // horizontal sync
wire vsync;       // vertical sync
wire [10:0] sx;   // horizontal screen position
wire [10:0] sy;   // vertical screen position
wire de;          // data enable
wire[7:0] rgb_r;
wire[7:0] rgb_g;
wire[7:0] rgb_b;
reg [7:0] display_r;
reg [7:0] display_g;
reg [7:0] display_b;

clock_720p clock_720p_m0 (
    // Clock in ports
    .clk_in1(clk_50MHz),
    // Clock out ports
    .clk_out1(clk_pix),
    .clk_out2(clk_pix_5x),
    // Status and control signals
    .reset(1'b0),
    .locked()
);

signal_720p signal_720p_m0 (
    .clk_pix,
    .rst_pix(1'b0),
    .sx,
    .sy,
    .hsync,
    .vsync,
    .de
);

painter painter_m0 (
    .sx,
    .sy,
    .rgb_r,
    .rgb_g,
    .rgb_b
);

always_comb begin
    display_r = (de) ? rgb_r : 8'h00;
    display_g = (de) ? rgb_g : 8'h00;
    display_b = (de) ? rgb_b : 8'h00;
end

rgb2dvi_0 rgb2dvi_m0 (
    // DVI 1.0 TMDS video interface
    .TMDS_Clk_p,
    .TMDS_Clk_n,
    .TMDS_Data_p,
    .TMDS_Data_n,
    .oen(hdmi_oen),
    //Auxiliary signals 
    .aRst_n(1'b1), //-asynchronous reset; must be reset when RefClk is not within spec
    
    // Video in
    .vid_pData({display_r,display_g,display_b}),
    .vid_pVDE(de),
    .vid_pHSync(hsync),
    .vid_pVSync(vsync),
    .PixelClk(clk_pix),
    .SerialClk(clk_pix_5x)// 5x PixelClk
); 
  
endmodule
