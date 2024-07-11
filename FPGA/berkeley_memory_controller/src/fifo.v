module fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 32,
    parameter POINTER_WIDTH = $clog2(DEPTH)
) (
    input clk, rst,

    // Write side
    input wr_en,
    input [WIDTH-1:0] din,
    output full,

    // Read side
    input rd_en,
    output [WIDTH-1:0] dout,
    output empty
);
    wire [POINTER_WIDTH:0] wr_ptr, wr_ptr_next;
    wire wr_ptr_ce, wr_ptr_rst;

    REGISTER_R_CE #(.N(POINTER_WIDTH + 1), .INIT(0)) wr_counter (
        .q(wr_ptr),
        .d(wr_ptr_next),
        .ce(wr_ptr_ce),
        .rst(wr_ptr_rst),
        .clk(clk)
    );

    wire [POINTER_WIDTH:0] rd_ptr, rd_ptr_next;
    wire rd_ptr_ce, rd_ptr_rst;

    REGISTER_R_CE #(.N(POINTER_WIDTH + 1), .INIT(0)) rd_counter (
        .q(rd_ptr),
        .d(rd_ptr_next),
        .ce(rd_ptr_ce),
        .rst(rd_ptr_rst),
        .clk(clk)
    );

    wire mem_wr_en = wr_en & ~full;
    wire mem_rd_en = rd_en & ~empty;

    SYNC_RAM_DP #(
        .DWIDTH(WIDTH),
        .AWIDTH(POINTER_WIDTH),
        .DEPTH(DEPTH)
    ) mem (
        .clk(clk),

        // Write side
        .addr0(wr_ptr[POINTER_WIDTH-1:0]),  // write address
        .we0(mem_wr_en), // write enable
        .en0(1'b1),
        .d0(din),        // write data
        .q0(),

        // Read side
        .addr1(rd_ptr[POINTER_WIDTH-1:0]),  // read address
        .we1(1'b0),
        .en1(mem_rd_en),
        .d1({WIDTH{1'b0}}),
        .q1(dout)        // read data
    );

    assign wr_ptr_next = wr_ptr + 1;
    assign wr_ptr_ce = mem_wr_en;
    assign wr_ptr_rst = rst;

    assign rd_ptr_next = rd_ptr + 1;
    assign rd_ptr_ce = mem_rd_en;
    assign rd_ptr_rst = rst;

    assign empty = (wr_ptr[POINTER_WIDTH] == rd_ptr[POINTER_WIDTH])
                    && (wr_ptr[POINTER_WIDTH-1:0] == rd_ptr[POINTER_WIDTH-1:0]);
    assign full = (wr_ptr[POINTER_WIDTH] != rd_ptr[POINTER_WIDTH])
                    && (wr_ptr[POINTER_WIDTH-1:0] == rd_ptr[POINTER_WIDTH-1:0]);

endmodule
