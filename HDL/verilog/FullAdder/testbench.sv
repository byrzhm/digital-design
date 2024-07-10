module testbench;
  
  reg a, b, c_in;
  wire s, c_out;
  
  full_adder dut (
    .a, .b, .c_in,
    .s, .c_out
  );
  
  initial begin
    // 1
    a = 0;
    b = 0;
    c_in = 0;
    
    #5 $display("a=%0b, b=%0b, c_in=%0b, s=%0b, c_out=%0b",
             a, b, c_in, s, c_out);
    
	// 2
    a = 1;
    b = 0;
    c_in = 0;
    
    #5 $display("a=%0b, b=%0b, c_in=%0b, s=%0b, c_out=%0b",
             a, b, c_in, s, c_out);
    
    // 3
    a = 0;
    b = 1;
    c_in = 0;
    
    #5 $display("a=%0b, b=%0b, c_in=%0b, s=%0b, c_out=%0b",
             a, b, c_in, s, c_out);
    
    // 4
    a = 0;
    b = 0;
    c_in = 1;
    
    #5 $display("a=%0b, b=%0b, c_in=%0b, s=%0b, c_out=%0b",
             a, b, c_in, s, c_out);
    
    // 5
    a = 0;
    b = 1;
    c_in = 1;
    
    #5 $display("a=%0b, b=%0b, c_in=%0b, s=%0b, c_out=%0b",
             a, b, c_in, s, c_out);
    
    // 6
    a = 1;
    b = 0;
    c_in = 1;
    
    #5 $display("a=%0b, b=%0b, c_in=%0b, s=%0b, c_out=%0b",
             a, b, c_in, s, c_out);
    
    // 7
    a = 1;
    b = 1;
    c_in = 0;
    
    #5 $display("a=%0b, b=%0b, c_in=%0b, s=%0b, c_out=%0b",
             a, b, c_in, s, c_out);
    
    
    // 8
    a = 1;
    b = 1;
    c_in = 1;
    
    #5 $display("a=%0b, b=%0b, c_in=%0b, s=%0b, c_out=%0b",
             a, b, c_in, s, c_out);
  end
  
endmodule
