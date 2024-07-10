module tb_decoder;

  // Inputs
  reg [2:0] X;

  // Outputs
  wire [7:0] Y;

  // Instantiate the Unit Under Test (UUT)
  decoder uut (
    .X(X),
    .Y(Y)
  );

  initial begin
    // Initialize Inputs
    X = 3'b000;
    #10;
    
    X = 3'b001;
    #10;
    
    X = 3'b010;
    #10;
    
    X = 3'b011;
    #10;
    
    X = 3'b100;
    #10;
    
    X = 3'b101;
    #10;
    
    X = 3'b110;
    #10;
    
    X = 3'b111;
    #10;
    
    // Test the default case
    X = 3'bxxx;
    #10;
    
    // End of test
    $stop;
  end

  initial begin
    $monitor("At time %t, Input X = %b, Output Y = %b", $time, X, Y);
  end

endmodule

