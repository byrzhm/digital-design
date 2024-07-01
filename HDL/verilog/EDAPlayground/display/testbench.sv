module test_display;

    reg [8*300:0] my_string;
    reg [15:0] my_number;
    real my_time;

    my_design my_design();

    initial begin
        // Display string
        $display("Hello World!");

        my_string = "This is my string";
        $display("my_string: %s", my_string);
        $display("my_string: %20s", my_string);
        $display("my_string: %0s", my_string);

        // Display decimal, binary, hex
        my_number = 8'h1a;
        $display("Decimal: %0d", my_number);
        $display("Decimal: %d", my_number);
        $display("Decimal: %3d", my_number);
        $display("Binary: %0b", my_number);
        $display("Binary: %b", my_number);
        $display("Binary: %3b", my_number);
        $display("Hex: %0h", my_number);
        $display("Hex: %h", my_number);
        $display("Hex: %3h", my_number);
          
        // Display hierarchical name
        $display("I'm at %m");
        my_design.print;
          
        // Display time
        my_time = 123;
        $display("Current time: %0t, and dummy time %0t", $time, my_time);
        #10;
        $display("Current time: %0t, and dummy time %0t", $time, my_time);
          
        // Long message display
        my_string = {
            "01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20",
            "21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40",
            "41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60",
            "61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80"
            };
        $display("my_string: %0s, my_number: %0d, my_time: %0t",
            my_string, my_number, my_time);

    end

endmodule
