// always, @, event, wait

module test;

    reg changes, clk;
    event my_event;

    always @(posedge clk) begin
        $display("@ posedge clk at %0t", $time);
    end

    // identical to upper code
    //  always begin
    //      @(posedge clk) begin
    //          $display("@ posedge clk at %0t", $time);
    //      end
    //  end

    always @(changes) begin
        $display("@ changes %0d at %0t", changes, $time);
    end

    always begin
        wait(changes);
        $display("@ wait changes %0d at %0t", changes, $time);
        #1;
    end

    //  always begin
    //      $display("in always");
    //      #1;
    //  end
      
    always @(my_event) begin
        $display("@ my_event at %0t", $time);
    end

    initial begin
        wait(changes);
        @(posedge clk);
        @(my_event);
        $display("Arrived at %0t", $time);
    end

    initial begin
        $dumpvars(1, test);

        #5;
        changes = 0;
        clk = 0;

        #5 changes = 1;
        #5 changes = 0;

        #5 clk = 1;
        #5 clk = 0;

        -> my_event;
        #10 ->my_event;

        #10;
        $finish;
    end

endmodule
