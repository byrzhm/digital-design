// Radom Access Memory (RAM) with
// 1 read port and 1 write port
module ram (
    // Write port
    input clk_write,
    input [A_WIDTH-1:0] address_write,
    input [D_WIDTH-1:0] data_write,
    input write_enable,

    // Read port
    input clk_read,
    input [A_WIDTH-1:0] address_read,
    output reg [D_WIDTH-1:0] data_read);

    parameter D_WIDTH = 16;
    parameter A_WIDTH = 4;

    // Memory as multi-dimensional array
    reg [D_WIDTH-1:0] memory [0:2**A_WIDTH-1];

    // Write data to memory
    always @(posedge clk_write) begin
        if (write_enable) begin
            memory[address_write] <= data_write;
        end
    end

    // Read data from memory
    always @(posedge clk_read) begin
        data_read <= memory[address_read];
    end

endmodule
