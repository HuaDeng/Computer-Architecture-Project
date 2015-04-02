`include "cond_code.h"
`include "opcode.h"
module flag_rf_tb;
    reg clk;
    reg alu_z, alu_v, alu_n;
    reg[15:0] instr;
    wire out;

    flag_rf rf_flag(out, clk, alu_z,alu_v,alu_n,instr);

    initial begin
        clk = 0;
        flag_rf_equal();
        flag_rf_less();
        flag_rf_greater();
        flag_rf_greater_or_equal();
        $finish;
    end
    
    task flag_rf_equal;
        begin
            rf_flag.z = 1;
            rf_flag.v = 0;
            rf_flag.n = 0;
            instr = {`B, 1'bx, `EQUAL, 8'hxx };
            #1;
            if(out !== 1'b1) begin
                $display("Fail flag_rf_equal: expected 1, got %b",out);
            end
            rf_flag.z = 0;
            #1;
            if(out !== 0) begin
                $display("Fail flag_rf_equal: expected 0, got %b",out);
            end
        end
    endtask

    task flag_rf_less;
        begin
            rf_flag.z = 0;
            rf_flag.v = 0;
            rf_flag.n = 1;
            instr = {`B, 1'bx, `LESS, 8'hxx };
            #1;
            if(out !== 1'b1) begin
                $display("Fail flag_rf_less: expected 1, got %b",out);
            end
            rf_flag.n = 0;
            #1;
            if(out !== 0) begin
                $display("Fail flag_rf_less: expected 0, got %b",out);
            end
            rf_flag.v = 1;
            rf_flag.n = 1;
            #1;
            if(out !== 0) begin
                $display("Fail flag_rf_less: expected 0, got %b",out);
            end
        end
    endtask

    task flag_rf_greater;
        begin
            rf_flag.z = 0;
            rf_flag.v = 0;
            rf_flag.n = 0;
            instr = {`B, 1'bx, `GREATER, 8'hxx };
            #1;
            if(out !== 1'b1) begin
                $display("Fail flag_rf_greater: expected 1, got %b",out);
            end
            rf_flag.n = 1;
            #1;
            if(out !== 0) begin
                $display("Fail flag_rf_greater: expected 0, got %b",out);
            end
            rf_flag.n = 0;
            rf_flag.v = 1;
            #1;
            if(out !== 0) begin
                $display("Fail flag_rf_greater: expected 0, got %b",out);
            end
        end
    endtask

    task flag_rf_greater_or_equal;
        begin
            rf_flag.z = 0;
            rf_flag.v = 0;
            rf_flag.n = 0;
            instr = {`B, 1'bx, `GREATER_OR_EQUAL, 8'hxx };
            #1;
            if(out !== 1'b1) begin
                $display("Fail flag_rf_greater: expected 1, got %b",out);
            end
            rf_flag.n = 1;
            #1;
            if(out !== 0) begin
                $display("Fail flag_rf_greater: expected 0, got %b",out);
            end
            rf_flag.n = 0;
            rf_flag.v = 1;
            #1;
            if(out !== 0) begin
                $display("Fail flag_rf_greater: expected 0, got %b",out);
            end

            rf_flag.n = 0;
            rf_flag.v = 0;
            rf_flag.z = 1;
            #1;
            if(out !== 1) begin
                $display("Fail flag_rf_greater: expected 1, got %b",out);
            end
            #1;
        end
    endtask

endmodule
