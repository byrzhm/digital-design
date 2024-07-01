`define MY_NUMBER 5
`define MY_STRING "Hello, World!"
`define ADD2PLUS2 2 + 2
`define ADD5(RESULT, SOURCE) \
    RESULT = SOURCE + 5; \
    $display("Inside ADD5 macro. Scope is %m");
`define MY_FEATURE // or define in command line


module test;

    reg [7:0] a, b;

    initial begin
        $display(`MY_NUMBER);
        $display(`MY_STRING);
        $display(`ADD2PLUS2);

        a = 1;
        `ifdef ADD5
            `ADD5(b, a)
            // $display("a = %0d", a);
            // $display("b = %0d", b);
            $display("a = %0d, b = %0d", a, b);
        `else
            $display("ADD5 macro is not defined.");
        `endif

        `ifdef MY_FEATURE
            $display("MY_FEATURE is defined.");
        `else
            $display("MY_FEATURE is not defined.");
        `endif
    end

endmodule
