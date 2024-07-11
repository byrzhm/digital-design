module debouncer #(
    parameter WIDTH              = 1,
    parameter SAMPLE_CNT_MAX     = 62500,
    parameter PULSE_CNT_MAX      = 200,
    parameter WRAPPING_CNT_WIDTH = $clog2(SAMPLE_CNT_MAX),
    parameter SAT_CNT_WIDTH      = $clog2(PULSE_CNT_MAX) + 1
) (
    input clk,
    input [WIDTH-1:0] glitchy_signal,
    output [WIDTH-1:0] debounced_signal
);
    // TODO: fill in neccesary logic to implement the wrapping counter and the saturating counters
    // Some initial code has been provided to you, but feel free to change it however you like
    // One wrapping counter is required
    // One saturating counter is needed for each bit of glitchy_signal
    // You need to think of the conditions for reseting, clock enable, etc. those registers
    // Refer to the block diagram in the spec

    wire [WRAPPING_CNT_WIDTH-1:0] wrapping_counter_value, wrapping_counter_next;
    wire wrapping_counter_rst;
    REGISTER_R #(.N(WRAPPING_CNT_WIDTH)) wrapping_counter (
        .q(wrapping_counter_value),
        .d(wrapping_counter_next),
        .rst(wrapping_counter_rst),
        .clk(clk)
    );

    wire sample = (wrapping_counter_value == SAMPLE_CNT_MAX - 1);
    assign wrapping_counter_next = wrapping_counter_value + 1;
    assign wrapping_counter_rst = sample;


    reg [SAT_CNT_WIDTH-1:0] saturating_counter [WIDTH-1:0];

    genvar i;
    generate;
        for (i = 0; i < WIDTH; i = i + 1) begin
            REGISTER_R_CE #(.N(SAT_CNT_WIDTH), .INIT({SAT_CNT_WIDTH{1'b0}})) saturating_counter_inst_i (
                .q(saturating_counter[i]),
                .d(saturating_counter[i] + {{(SAT_CNT_WIDTH-1){1'b0}}, 1'b1}),
                .ce(glitchy_signal[i] & (saturating_counter[i] < PULSE_CNT_MAX) & sample),
                .rst(~glitchy_signal[i]),
                .clk(clk)
            );

            assign debounced_signal[i] = (saturating_counter[i] == PULSE_CNT_MAX);
        end
    endgenerate

endmodule
