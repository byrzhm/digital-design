module testbench;

parameter N = 32;

reg rst, ce, clk;
reg [N-1:0] d;
wire [N-1:0] q, q_r, q_ce, q_r_ce;

REGISTER #(.N(N)) register(.q,.d,.clk);

REGISTER_CE #(.N(N)) register_ce(.q(q_ce),.d,.ce,.clk);

REGISTER_R #(.N(N)) register_r(.q(q_r),.d,.rst,.clk);

REGISTER_R_CE #(.N(N)) register_r_ce(.q(q_r_ce),.d,.rst,.ce,.clk);

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, testbench);

    clk = 0;
    rst = 0;
    ce = 0;
    d = 0; // registers without ce will be set to 0

    #10 rst = 1; // register_r and register_r_ce should reset to 0

    #10 rst = 0;
    #10 d = 32'hdeadbeef; // register and register_r should update to 32'hdeadbeef

    #10 ce = 1; // register_ce and register_r_ce should update to 32'hdeadbeef

    #10 ce = 0;
    #10 d = 32'hcafebabe; // register and register_r should update to 32'hcafebabe
                          // register_ce and register_r_ce should not update

    #10 rst = 1; // register_r and register_r_ce should reset to 0

    #10 rst = 0;
    #10 d = 32'hdeadbeef; // register and register_r should update to 32'hdeadbeef

    #10 ce = 1; // register_ce and register_r_ce should update to 32'hdeadbeef
    #10 ce = 0;
    #10 d = 32'hcafebabe; // register and register_r should update to 32'hcafebabe
                          // register_ce and register_r_ce should not update
    #10 $finish;
end

always #5 clk = ~clk;

endmodule
