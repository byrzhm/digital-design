module uart_transmitter #(
  parameter CLOCK_FREQ = 125_000_000,
  parameter BAUD_RATE = 115_200)
(
  input clk,
  input reset,

  input [7:0] data_in,
  input data_in_valid,
  output data_in_ready,

  output serial_out
);
  // See diagram in the lab guide
  localparam  SYMBOL_EDGE_TIME    =   CLOCK_FREQ / BAUD_RATE;
  localparam  CLOCK_COUNTER_WIDTH =   $clog2(SYMBOL_EDGE_TIME);

  wire [9:0] tx_shift_value;
  wire [9:0] tx_shift_next;
  wire tx_shift_ce, tx_shift_rst;

  REGISTER_R_CE #(.N(10), .INIT({10{1'b1}})) tx_shift (
    .q(tx_shift_value),
    .d(tx_shift_next),
    .ce(tx_shift_ce),
    .rst(tx_shift_rst),
    .clk(clk)
  );

  wire [3:0] bit_counter_value;
  wire [3:0] bit_counter_next;
  wire bit_counter_ce, bit_counter_rst;

  REGISTER_R_CE #(.N(4), .INIT(0)) bit_counter (
    .q(bit_counter_value),
    .d(bit_counter_next),
    .ce(bit_counter_ce),
    .rst(bit_counter_rst),
    .clk(clk)
  );

  wire [CLOCK_COUNTER_WIDTH-1:0] clock_counter_value;
  wire [CLOCK_COUNTER_WIDTH-1:0] clock_counter_next;
  wire clock_counter_ce, clock_counter_rst;

  REGISTER_R_CE #(.N(CLOCK_COUNTER_WIDTH), .INIT(0)) clock_counter (
    .q(clock_counter_value),
    .d(clock_counter_next),
    .ce(clock_counter_ce),
    .rst(clock_counter_rst),
    .clk(clk)
  );

  wire data_in_fired = data_in_valid & data_in_ready;

  wire symbol_edge = (clock_counter_value == SYMBOL_EDGE_TIME - 1);
  wire done = (bit_counter_value == 10 - 1) & symbol_edge;

  wire has_ready;
  REGISTER_R_CE #(.N(1), .INIT(1)) has_ready_reg (
    .q(has_ready),
    .d(1'b0),
    .ce(data_in_fired),
    .rst(done),
    .clk(clk)
  );

  wire start;
  REGISTER_R_CE #(.N(1), .INIT(0)) start_reg (
    .q(start),
    .d(1'b1),
    .ce(data_in_fired),
    .rst(done),
    .clk(clk)
  );

  assign tx_shift_next = (data_in_fired) ? {1'b1, data_in, 1'b0} : {tx_shift_value[0], tx_shift_value[9:1]};
  assign tx_shift_ce = symbol_edge | data_in_fired;
  assign tx_shift_rst = done | reset;
  
  assign bit_counter_next = bit_counter_value + 1;
  assign bit_counter_ce = symbol_edge;
  assign bit_counter_rst = done | reset;

  assign clock_counter_next = clock_counter_value + 1;
  assign clock_counter_ce = start;
  assign clock_counter_rst = symbol_edge | reset;

  assign data_in_ready = has_ready;
  assign serial_out = tx_shift_value[0];

endmodule
