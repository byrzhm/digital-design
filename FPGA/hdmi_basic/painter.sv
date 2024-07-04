`define SQUARE

module painter (
    input      [10:0] sx,     // horizontal screen position
    input      [10:0] sy,     // vertical screen position
    output reg [7:0] rgb_r,  // red
    output reg [7:0] rgb_g,  // green
    output reg [7:0] rgb_b   // blue
);

`ifdef SQUARE
// define a square with screen coordinates
wire square;
assign square = (sx > 220 && sx < 420) && (sy > 140 && sy < 340);

// paint colour: white inside square, blue outside
always_comb begin
    rgb_r = (square) ? 8'hFF : 8'h11;
    rgb_g = (square) ? 8'hFF : 8'h33;
    rgb_b = (square) ? 8'hFF : 8'h77;
end

`elsif COLOR_BAR
//define the RGB values for 8 colors
parameter WHITE_R       = 8'hff;
parameter WHITE_G       = 8'hff;
parameter WHITE_B       = 8'hff;
parameter YELLOW_R      = 8'hff;
parameter YELLOW_G      = 8'hff;
parameter YELLOW_B      = 8'h00;                                
parameter CYAN_R        = 8'h00;
parameter CYAN_G        = 8'hff;
parameter CYAN_B        = 8'hff;                                
parameter GREEN_R       = 8'h00;
parameter GREEN_G       = 8'hff;
parameter GREEN_B       = 8'h00;
parameter MAGENTA_R     = 8'hff;
parameter MAGENTA_G     = 8'h00;
parameter MAGENTA_B     = 8'hff;
parameter RED_R         = 8'hff;
parameter RED_G         = 8'h00;
parameter RED_B         = 8'h00;
parameter BLUE_R        = 8'h00;
parameter BLUE_G        = 8'h00;
parameter BLUE_B        = 8'hff;
parameter BLACK_R       = 8'h00;
parameter BLACK_G       = 8'h00;
parameter BLACK_B       = 8'h00;

parameter H_ACTIVE      = 1280;

always_comb begin
        if(sx >= 12'd0 && sx < (H_ACTIVE/8) * 1) begin
                rgb_r = WHITE_R;
                rgb_g = WHITE_G;
                rgb_b = WHITE_B;
        end
        else if(sx >= (H_ACTIVE/8) * 1 && sx < (H_ACTIVE/8) * 2) begin
                rgb_r = YELLOW_R;
                rgb_g = YELLOW_G;
                rgb_b = YELLOW_B;
            end         
        else if(sx >= (H_ACTIVE/8) * 2 && sx < (H_ACTIVE/8) * 3) begin
                rgb_r = CYAN_R;
                rgb_g = CYAN_G;
                rgb_b = CYAN_B;
            end
        else if(sx >= (H_ACTIVE/8) * 3 && sx < (H_ACTIVE/8) * 4) begin
                rgb_r = GREEN_R;
                rgb_g = GREEN_G;
                rgb_b = GREEN_B;
            end
        else if(sx >= (H_ACTIVE/8) * 4 && sx < (H_ACTIVE/8) * 5) begin
                rgb_r = MAGENTA_R;
                rgb_g = MAGENTA_G;
                rgb_b = MAGENTA_B;
            end
        else if(sx >= (H_ACTIVE/8) * 5 && sx < (H_ACTIVE/8) * 6) begin
                rgb_r = RED_R;
                rgb_g = RED_G;
                rgb_b = RED_B;
            end
        else if(sx >= (H_ACTIVE/8) * 6 && sx < (H_ACTIVE/8) * 7) begin
                rgb_r = BLUE_R;
                rgb_g = BLUE_G;
                rgb_b = BLUE_B;
            end 
        else // if(sx >= (H_ACTIVE/8) * 7)
            begin
                rgb_r = BLACK_R;
                rgb_g = BLACK_G;
                rgb_b = BLACK_B;
            end
end
`endif

endmodule
