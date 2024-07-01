`define WRITE_A 4'b0001
`define WRITE_B 4'b0010
`define READ_C  4'b1011

module dut (
    input clk,
    input [3:0] op_code,
    output reg write,
    output reg [1:0] source);

    always @(posedge clk) begin
        case (1)
            (op_code == `WRITE_A): $display("WRITE_A");
            (op_code == `WRITE_B): $display("WRITE_B");
            (op_code == `READ_C) : $display("READ_C");
            default:               $display("default");
        endcase


        `ifdef USE_CASE
            case (op_code) // casez -> z don't care, casex -> x don't care
                `WRITE_A: begin
                    write <= 1'b1;
                    source <= 2'b00;
                end
                `WRITE_B: begin
                    write <= 1'b1;
                    source <= 2'b10;
                end
                `READ_C: begin
                    write <= 1'b0;
                    source <= 2'b11;
                end
                default: begin
                    write <= 1'bx;
                    source <= 2'bxx;
                end
            endcase
        `else
            if (op_code == `WRITE_A) begin
                write <= 1'b1;
                source <= 2'b00;
            end else if (op_code == `WRITE_B) begin
                write <= 1'b1;
                source <= 2'b10;
            end else if (op_code == `READ_C) begin
                write <= 1'b0;
                source <= 2'b11;
            end else begin
                write <= 1'bx;
                source <= 2'bxx;
            end
        `endif
    end

endmodule
