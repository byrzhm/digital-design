module mem_controller #(
  parameter FIFO_WIDTH = 8
) (
  input clk,
  input rst,
  input rx_fifo_empty,
  input tx_fifo_full,
  input [FIFO_WIDTH-1:0] din,

  output reg rx_fifo_rd_en,
  output reg tx_fifo_wr_en,
  output [FIFO_WIDTH-1:0] dout,
  output reg [5:0] state_leds
);

  localparam MEM_WIDTH = 8;   /* Width of each mem entry (word) */
  localparam MEM_DEPTH = 256; /* Number of entries */
  localparam NUM_BYTES_PER_WORD = MEM_WIDTH/8;
  localparam MEM_ADDR_WIDTH = $clog2(MEM_DEPTH); 

  reg  [NUM_BYTES_PER_WORD-1:0] mem_we = 0;
  wire [MEM_ADDR_WIDTH-1:0] mem_addr;
  wire [MEM_WIDTH-1:0] mem_din;
  wire [MEM_WIDTH-1:0] mem_dout;

  SYNC_RAM_WBE #(
    .DWIDTH(MEM_WIDTH),
    .AWIDTH(MEM_ADDR_WIDTH)
  ) mem (
    .clk(clk),
    .en(1'b1),
    .wbe(mem_we),
    .addr(mem_addr),
    .d(mem_din),
    .q(mem_dout)
  );

  localparam 
    IDLE = 3'd0,
    READ_CMD = 3'd1,
    READ_ADDR = 3'd2,
    READ_DATA = 3'd3,
    READ_MEM_VAL = 3'd4,
    ECHO_VAL = 3'd5,
    WRITE_MEM_VAL = 3'd6;

  wire [2:0] curr_state;
  reg  [2:0] next_state;

  /* State Update */
  REGISTER_R #(.N(3), .INIT(IDLE)) state_reg (
    .q(curr_state), .d(next_state), .rst(rst), .clk(clk)
  );

  wire [2:0] pkt_rd_cnt;
  wire [MEM_WIDTH-1:0] cmd;
  wire [MEM_WIDTH-1:0] addr;
  wire [MEM_WIDTH-1:0] data;
  wire handshake;

  /* Registers for byte reading and packet counting */
  reg [2:0] pkt_rd_cnt_next;
  reg pkt_rd_cnt_ce;
  REGISTER_CE #(.N(3)) pkt_rd_cnt_reg (
    .q(pkt_rd_cnt),
    .d(pkt_rd_cnt_next),
    .ce(pkt_rd_cnt_ce),
    .clk(clk)
  );

  wire cmd_ce;
  REGISTER_CE #(.N(MEM_WIDTH)) cmd_reg (
    .q(cmd),
    .d(din),
    .ce(handshake & (curr_state == READ_CMD)),
    .clk(clk)
  );

  wire addr_ce;
  REGISTER_CE #(.N(MEM_WIDTH)) addr_reg (
    .q(addr),
    .d(din),
    .ce(handshake & (curr_state == READ_ADDR)),
    .clk(clk)
  );

  wire data_ce;
  REGISTER_CE #(.N(MEM_WIDTH)) data_reg (
    .q(data),
    .d(din),
    .ce(handshake & (curr_state == READ_DATA)),
    .clk(clk)
  );

  REGISTER_R #(.N(1), .INIT(0)) handshake_reg (
    .q(handshake),
    .d(~rx_fifo_empty & rx_fifo_rd_en),
    .rst(rst),
    .clk(clk)
  );

  always @(*) begin
    
    /* initial values to avoid latch synthesis */
    next_state = curr_state;

    case (curr_state)

      /* next state logic */
      IDLE: begin
        if (~rx_fifo_empty)
          next_state = READ_CMD;
      end
      // READ_CMD: begin
      //   if (handshake)
      //     next_state = READ_ADDR;
      // end
      READ_CMD: next_state = READ_ADDR; // READ_CMD is one cycle

      // READ / WRITE
      READ_ADDR: begin
        if (handshake) begin
          if (cmd == 8'd49) // WRITE
            next_state = READ_DATA;
          else
            next_state = READ_MEM_VAL;
        end
      end

      // WRITE branch
      READ_DATA: begin
        if (handshake)
          next_state = WRITE_MEM_VAL;
      end
      WRITE_MEM_VAL: next_state = IDLE; // WRITE_MEM_VAL is one cycle

      // READ branch
      READ_MEM_VAL: next_state = ECHO_VAL; // READ_MEM_VAL is one cycle
      ECHO_VAL: begin
        if (~tx_fifo_full)
          next_state = IDLE;
      end

      default: next_state = IDLE;

    endcase

  end

  always @(*) begin
    
    /* initial values to avoid latch synthesis */
    // IDLE
    pkt_rd_cnt_next = pkt_rd_cnt + 3'd1; // default to incrementing by 1
    pkt_rd_cnt_ce = 0;                   // enable signal for pkt_rd_cnt_reg, default to 0
    mem_we = 0;                          // write enable signal for memory, default to 0
    rx_fifo_rd_en = 1;                   // read enable signal for rx_fifo
    tx_fifo_wr_en = 0;                   // write enable signal for tx_fifo
    
    case (curr_state)

      /* output and mem signal logic */

      // one cycle state
      READ_CMD: begin
        pkt_rd_cnt_ce = 1;                   // we will read 1 packet in READ_CMD state
      end

      READ_ADDR: begin
        pkt_rd_cnt_ce = handshake;
        if (cmd == 8'd48) // READ
          rx_fifo_rd_en = ~handshake; // once handshake is high, rx_fifo_rd_en goes low
      end

      READ_DATA: begin
        pkt_rd_cnt_ce = handshake;
        rx_fifo_rd_en = ~handshake; // once handshake is high, rx_fifo_rd_en goes low
      end

      READ_MEM_VAL: begin
        pkt_rd_cnt_ce = 0;              // we will not read packtes in READ_MEM_VAL state
        rx_fifo_rd_en = 0;              // we do not want to read from rx_fifo
      end

      ECHO_VAL: begin
        pkt_rd_cnt_next = 0;            // reset packet count
        pkt_rd_cnt_ce = ~tx_fifo_full;  // when tx_fifo is not full, we will write to it
        rx_fifo_rd_en = 0;              // we do not want to read from rx_fifo
        tx_fifo_wr_en = 1;              // we want to write to tx_fifo
      end

      WRITE_MEM_VAL: begin
        pkt_rd_cnt_next = 0;            // reset packet count
        pkt_rd_cnt_ce = 1;              // when handshake is high, we will read the packet
        rx_fifo_rd_en = 0;              // we do not want to read from rx_fifo
        mem_we = 1;                     // we want to write to memory
      end
    endcase

  end

  always @(*) begin
    case (curr_state)
      IDLE:          state_leds = 6'b000000;
      READ_CMD:      state_leds = 6'b000001;
      READ_ADDR:     state_leds = 6'b000010;
      READ_DATA:     state_leds = 6'b000100;
      READ_MEM_VAL:  state_leds = 6'b001000;
      ECHO_VAL:      state_leds = 6'b010000;
      WRITE_MEM_VAL: state_leds = 6'b100000;
      default:       state_leds = 6'b111111;
    endcase
  end

  assign dout = mem_dout;
  assign mem_addr = addr;
  assign mem_din = data;

endmodule
