module signal_720p (
    input  wire clk_pix,   // pixel clock
    input  wire rst_pix,   // reset in pixel clock domain
    output reg  [9:0] sx,  // horizontal screen position
    output reg  [9:0] sy,  // vertical screen position
    output      hsync,     // horizontal sync
    output      vsync,     // vertical sync
    output      de         // data enable (low in blanking interval)
);


// 1280x720 74.25Mhz
// (1280 + 110 + 40 + 220) * (720 + 5 + 5 + 20) * 60 = 74.25Mhz
parameter H_ACTIVE = 1280;                // horizontal active time (pixels)
parameter H_FP     = 110;                 // horizontal front porch (pixels)
parameter H_SYNC   = 40;                  // horizontal sync time(pixels)
parameter H_BP     = 220;                 // horizontal back porch (pixels)
parameter V_ACTIVE = 720;                 // vertical active Time (lines)
parameter V_FP     = 5;                   // vertical front porch (lines)
parameter V_SYNC   = 5;                   // vertical sync time (lines)
parameter V_BP     = 20;                  // vertical back porch (lines)
// parameter HS_POL = 1;                  // horizontal sync polarity, 1 : POSITIVE,0 : NEGATIVE;
// parameter VS_POL = 1;                  // vertical sync polarity, 1 : POSITIVE,0 : NEGATIVE;

// horizontal timing
parameter HA_END = H_ACTIVE - 1;          // end of active pixels
parameter HS_STA = HA_END + H_FP;         // sync starts after front porch
parameter HS_END = HS_STA + H_SYNC;       // sync ends
parameter LINE   = HS_END + H_BP;         // last pixel on line (after back porch)


// vertical timings
parameter VA_END = V_ACTIVE - 1;          // end of active pixels
parameter VS_STA = VA_END + V_FP;         // sync starts after front porch
parameter VS_END = VS_STA + V_SYNC;       // sync ends
parameter SCREEN = VS_END + V_BP;         // last line on screen (after back porch)


// hsync, vsync and de
assign hsync = (sx >= HS_STA && sx < HS_END);  // positive polarity
assign vsync = (sy >= VS_STA && sy < VS_END);  // positive polarity
assign de = (sx <= HA_END && sy <= VA_END);


// calculate horizontal and vertical screen position
always @(posedge clk_pix or posedge rst_pix) begin
    if (rst_pix) begin
        sx <= 0;
        sy <= 0;
    end
    else if (sx == LINE) begin  // last pixel on line?
        sx <= 0;
        sy <= (sy == SCREEN) ? 0 : sy + 1;  // last line on screen?
    end
    else begin
        sx <= sx + 1;
    end
end

endmodule
