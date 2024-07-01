// Testbench
module top;

    test my_test();
    
    defparam my_test.DW = 12;
    defparam my_test.RAM.A_WIDTH = 4;
endmodule
  
  
module test;

    parameter DW = 8;
    parameter AW = 4;

    reg clk_write;
    reg [AW-1:0] address_write;
    reg [DW-1:0] data_write;
    reg write_enable;
    reg clk_read;
    reg [AW-1:0] address_read;
    wire [DW-1:0] data_read;
    wire [3:0] data_read2;

    // Instantiate design under test
    //  ram #(.A_WIDTH(AW), .D_WIDTH(DW)) RAM (
    //      .clk_write(clk_write),
    //      .address_write(address_write),
    //      .data_write(data_write),
    //      .write_enable(write_enable),
    //      .clk_read(clk_read),
    //      .address_read(address_read),
    //      .data_read(data_read)
    //  );

    ram RAM (
        .clk_write(clk_write),
        .address_write(address_write),
        .data_write(data_write),
        .write_enable(write_enable),
        .clk_read(clk_read),
        .address_read(address_read),
        .data_read(data_read)
    );

    defparam RAM.D_WIDTH = DW;

    ram #(4, 2) NEW_RAM (
        .clk_write(clk_write),
        .address_write(address_write[1:0]),
        .data_write(data_write[3:0]),
        .write_enable(write_enable),
        .clk_read(clk_read),
        .address_read(address_read[1:0]),
        .data_read(data_read2)
    );

    initial begin
        // Dump waves
        $dumpfile("dump.vcd");
        $dumpvars(2, test);

        clk_write = 0;
        clk_read = 0;
        write_enable = 0;
        address_read = 5'h1B;
        address_write = address_read;

        $display("Read initial data.");
        toggle_clk_read;
        $display("data[%0h]: %0h",
            address_read, data_read);

        $display("Write new data.");
        write_enable = 1;
        data_write = 8'hC5;
        toggle_clk_write;
        write_enable = 0;

        $display("Read new data.");
        toggle_clk_read;
        $display("data[%0h]: %0h",
            address_read, data_read);
    end

    task toggle_clk_write;
        begin
            #10 clk_write = ~clk_write;
            #10 clk_write = ~clk_write;
        end
    endtask

    task toggle_clk_read;
        begin
            #10 clk_read = ~clk_read;
            #10 clk_read = ~clk_read;
        end
    endtask

endmodule
