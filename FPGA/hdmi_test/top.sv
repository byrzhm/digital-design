module top (
    input        sys_clk,
    output       TMDSn_clk,
    output       TMDSp_clk,
    output [2:0] TMDSn_data,
    output [2:0] TMDSp_data
);

////////////////////// clock generator ////////////////////
wire clk_pix, clk_TMDS;
clock_480p clock_480p_m0 (
    .clk_in1(sys_clk),
    .clk_out1(clk_pix),
    .clk_out2(clk_TMDS),
    .reset(1'b0),
    .locked()
);

////////////////////// signal generator ////////////////////
wire [9:0] sx, sy;
wire hsync, vsync, de;
signal_480p signal_480p_m0 (
    .clk_pix,
    .rst_pix(1'b0),
    .sx,
    .sy,
    .hsync,
    .vsync,
    .de
);

////////////////////// drawing logic ////////////////////
reg [7:0] rgb_r, rgb_g, rgb_b;
painter_480p painter_480p_m0 (
    .clk_pix,
    .sx,
    .sy,
    .rgb_r,
    .rgb_g,
    .rgb_b
);

////////////////////// rgb2dvi converter ////////////////////
simple_rgb2dvi simple_rgb2dvi_m0 (
    .clk_pix,
    .clk_TMDS,
    .hsync,
    .vsync,
    .de,
    .video_data({rgb_r, rgb_g, rgb_b}),
    
    // output signals
    .TMDSp_clk,
    .TMDSn_clk,
    .TMDSn_data,
    .TMDSp_data
);

endmodule
