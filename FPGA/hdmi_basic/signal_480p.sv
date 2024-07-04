module signal_480p (
    input  wire clk_pix,   // pixel clock
    input  wire rst_pix,   // reset in pixel clock domain
    output reg  [9:0] sx,  // horizontal screen position
    output reg  [9:0] sy,  // vertical screen position
    output      hsync,     // horizontal sync
    output      vsync,     // vertical sync
    output      de         // data enable (low in blanking interval)
);


// 640x480 25.2Mhz
// (640 + 16 + 96 + 48) * (480 + 10 + 2 + 33) * 60 = 25.2Mhz
parameter H_ACTIVE  = 640; 
parameter H_FP      = 16;      
parameter H_SYNC    = 96;    
parameter H_BP      = 48;      
parameter V_ACTIVE  = 480; 
parameter V_FP      = 10;    
parameter V_SYNC    = 2;    
parameter V_BP      = 33;    
// parameter HS_POL = 0;
// parameter VS_POL = 0;


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
assign hsync = ~(sx >= HS_STA && sx < HS_END);  // invert: negative polarity
assign vsync = ~(sy >= VS_STA && sy < VS_END);  // invert: negative polarity
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
