#! /bin/bash

# iverilog -D IVERILOG=1 -g2012 -gassertions -Wall -Wno-timescale \
#     src/EECS151.v src/uart_transmitter.v sim/uart_transmitter_tb.v

# iverilog -D IVERILOG=1 -g2012 -gassertions -Wall -Wno-timescale \
#     src/EECS151.v src/uart_transmitter.v src/uart_receiver.v src/uart.v sim/uart2uart_tb.v

# iverilog -D IVERILOG=1 -g2012 -gassertions -Wall -Wno-timescale \
#     src/EECS151.v src/fifo.v sim/fifo_tb.v

# iverilog -D IVERILOG=1 -g2012 -gassertions -Wall -Wno-timescale \
#     src/EECS151.v src/fifo.v src/uart_transmitter.v src/uart_receiver.v \
#     src/uart.v src/mem_controller.v sim/mem_controller_tb.v

# iverilog -D IVERILOG=1 -g2012 -gassertions -Wall -Wno-timescale \
#     src/EECS151.v src/synchronizer.v \
#     sim/sync_tb.v

# iverilog -D IVERILOG=1 -g2012 -gassertions -Wall -Wno-timescale \
#     src/EECS151.v src/edge_detector.v \
#     sim/edge_detector_tb.v

# iverilog -D IVERILOG=1 -g2012 -gassertions -Wall -Wno-timescale \
#     src/EECS151.v src/debouncer.v \
#     sim/debouncer_tb.v

iverilog -D IVERILOG=1 -g2012 -gassertions -Wall -Wno-timescale \
    src/*.v \
    sim/system_tb.v

unbuffer vvp a.out
