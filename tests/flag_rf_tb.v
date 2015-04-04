`include "cond_code.h"
`include "opcode.h"
module flag_rf_tb;
    reg clk;
    reg alu_z, alu_v, alu_n;
    reg[15:0] instr;
    wire out;

    flag_rf rf_flag(out, clk, alu_z,alu_v,alu_n,instr);

    always @(clk) #1 clk <= ~clk;

    initial begin
        flag_rf_equal();
        flag_rf_less();
        flag_rf_greater();
        flag_rf_greater_or_equal();
        clk = 0;
        test_add();
        test_sub();
        test_nand();
        test_xor();
        test_inc();
        test_sra();
        test_sll();
        test_sw();
        test_lw();
        test_lhb();
        test_llb();
        test_b();
        test_call();
        test_ret();
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

    task test_add;
        begin
            @(negedge clk)
            rf_flag.z = 1;
            rf_flag.v = 1;
            rf_flag.n = 1;
            instr = {`ADD, 12'h111 };
            alu_z = 0;
            alu_v = 0;
            alu_n = 0;
            @(negedge clk);
            if(rf_flag.z !== 0)
                $display("Fail test_add z: %h", rf_flag.z);
            if(rf_flag.v !== 0)
                $display("Fail test_add v: %h", rf_flag.v);
            if(rf_flag.n !== 0)
                $display("Fail test_add n: %h", rf_flag.n);
        end
    endtask

    task test_sub;
        begin
            @(negedge clk)
            rf_flag.z = 1;
            rf_flag.v = 1;
            rf_flag.n = 1;
            instr = {`SUB, 12'hx };
            alu_z = 0;
            alu_v = 0;
            alu_n = 0;
            @(negedge clk);
            if(rf_flag.z !== 0)
                $display("Fail test_sub z: %h", rf_flag.z);
            if(rf_flag.v !== 0)
                $display("Fail test_sub v: %h", rf_flag.v);
            if(rf_flag.n !== 0)
                $display("Fail test_sub n: %h", rf_flag.n);
        end
    endtask

    task test_nand;
        begin
            @(negedge clk)
            rf_flag.z = 1;
            rf_flag.v = 1;
            rf_flag.n = 1;
            instr = {`NAND, 12'hx };
            alu_z = 0;
            alu_v = 0;
            alu_n = 0;
            @(negedge clk);
            if(rf_flag.z !== 0)
                $display("Fail test_nand z: %h", rf_flag.z);
            if(rf_flag.v !== 0)
                $display("Fail test_nand v: %h", rf_flag.v);
            if(rf_flag.n !== 0)
                $display("Fail test_nand n: %h", rf_flag.n);
        end
    endtask

    task test_xor;
        begin
            @(negedge clk)
            rf_flag.z = 1;
            rf_flag.v = 1;
            rf_flag.n = 1;
            instr = {`XOR, 12'hx };
            alu_z = 0;
            alu_v = 0;
            alu_n = 0;
            @(negedge clk);
            if(rf_flag.z !== 0)
                $display("Fail test_xor z: %h", rf_flag.z);
            if(rf_flag.v !== 0)
                $display("Fail test_xor v: %h", rf_flag.v);
            if(rf_flag.n !== 0)
                $display("Fail test_xor n: %h", rf_flag.n);
        end
    endtask

    task test_inc;
        begin
            @(negedge clk)
            rf_flag.z = 1;
            rf_flag.v = 1;
            rf_flag.n = 1;
            instr = {`INC, 12'hx };
            alu_z = 0;
            alu_v = 0;
            alu_n = 0;
            @(negedge clk);
            if(rf_flag.z !== 0)
                $display("Fail test_inc z: %h", rf_flag.z);
            if(rf_flag.v !== 0)
                $display("Fail test_inc v: %h", rf_flag.v);
            if(rf_flag.n !== 0)
                $display("Fail test_inc n: %h", rf_flag.n);
        end
    endtask

    task test_sra;
        begin
            @(negedge clk)
            rf_flag.z = 1;
            rf_flag.v = 1;
            rf_flag.n = 1;
            instr = {`SRA, 12'hx };
            alu_z = 0;
            alu_v = 0;
            alu_n = 0;
            @(negedge clk);
            if(rf_flag.z !== 1)
                $display("Fail test_sra z: %h", rf_flag.z);
            if(rf_flag.v !== 1)
                $display("Fail test_sra v: %h", rf_flag.v);
            if(rf_flag.n !== 1)
                $display("Fail test_sra n: %h", rf_flag.n);
        end
    endtask

    task test_srl;
        begin
            @(negedge clk)
            rf_flag.z = 1;
            rf_flag.v = 1;
            rf_flag.n = 1;
            instr = {`SRL, 12'hx };
            alu_z = 0;
            alu_v = 0;
            alu_n = 0;
            @(negedge clk);
            if(rf_flag.z !== 1)
                $display("Fail test_srl z: %h", rf_flag.z);
            if(rf_flag.v !== 1)
                $display("Fail test_srl v: %h", rf_flag.v);
            if(rf_flag.n !== 1)
                $display("Fail test_srl n: %h", rf_flag.n);
        end
    endtask

    task test_sll;
        begin
            @(negedge clk)
            rf_flag.z = 1;
            rf_flag.v = 1;
            rf_flag.n = 1;
            instr = {`SLL, 12'hx };
            alu_z = 0;
            alu_v = 0;
            alu_n = 0;
            @(negedge clk);
            if(rf_flag.z !== 1)
                $display("Fail test_sll z: %h", rf_flag.z);
            if(rf_flag.v !== 1)
                $display("Fail test_sll v: %h", rf_flag.v);
            if(rf_flag.n !== 1)
                $display("Fail test_sll n: %h", rf_flag.n);
        end
    endtask

    task test_sw;
        begin
            @(negedge clk)
            rf_flag.z = 1;
            rf_flag.v = 1;
            rf_flag.n = 1;
            instr = {`SW, 12'hx };
            alu_z = 0;
            alu_v = 0;
            alu_n = 0;
            @(negedge clk);
            if(rf_flag.z !== 1)
                $display("Fail test_sw z: %h", rf_flag.z);
            if(rf_flag.v !== 1)
                $display("Fail test_sw v: %h", rf_flag.v);
            if(rf_flag.n !== 1)
                $display("Fail test_sw n: %h", rf_flag.n);
        end
    endtask

    task test_lw;
        begin
            @(negedge clk)
            rf_flag.z = 1;
            rf_flag.v = 1;
            rf_flag.n = 1;
            instr = {`LW, 12'hx };
            alu_z = 0;
            alu_v = 0;
            alu_n = 0;
            @(negedge clk);
            if(rf_flag.z !== 1)
                $display("Fail test_lw z: %h", rf_flag.z);
            if(rf_flag.v !== 1)
                $display("Fail test_lw v: %h", rf_flag.v);
            if(rf_flag.n !== 1)
                $display("Fail test_lw n: %h", rf_flag.n);
        end
    endtask

task test_lhb;
    begin
        @(negedge clk)
        rf_flag.z = 1;
        rf_flag.v = 1;
        rf_flag.n = 1;
        instr = {`LHB, 12'hx };
        alu_z = 0;
        alu_v = 0;
        alu_n = 0;
        @(negedge clk);
        if(rf_flag.z !== 1)
            $display("Fail test_lhb z: %h", rf_flag.z);
        if(rf_flag.v !== 1)
            $display("Fail test_lhb v: %h", rf_flag.v);
        if(rf_flag.n !== 1)
            $display("Fail test_lhb n: %h", rf_flag.n);
    end
endtask


task test_llb;
    begin
        @(negedge clk)
        rf_flag.z = 1;
        rf_flag.v = 1;
        rf_flag.n = 1;
        instr = {`LLB, 12'hx };
        alu_z = 0;
        alu_v = 0;
        alu_n = 0;
        @(negedge clk);
        if(rf_flag.z !== 1)
            $display("Fail test_llb z: %h", rf_flag.z);
        if(rf_flag.v !== 1)
            $display("Fail test_llb v: %h", rf_flag.v);
        if(rf_flag.n !== 1)
            $display("Fail test_llb n: %h", rf_flag.n);
    end
endtask

task test_b;
    begin
        @(negedge clk)
        rf_flag.z = 1;
        rf_flag.v = 1;
        rf_flag.n = 1;
        instr = {`B, 12'hx };
        alu_z = 0;
        alu_v = 0;
        alu_n = 0;
        @(negedge clk);
        if(rf_flag.z !== 1)
            $display("Fail test_b z: %h", rf_flag.z);
        if(rf_flag.v !== 1)
            $display("Fail test_b v: %h", rf_flag.v);
        if(rf_flag.n !== 1)
            $display("Fail test_b n: %h", rf_flag.n);
        @(negedge clk);
        rf_flag.v = 0;
        rf_flag.n = 0;
        instr = {`B, 1'bx, `EQUAL, 8'hxx };
        @(negedge clk);
        if(out !== 1)
            $display("Fail test_b out: %h", out);
    end
endtask

task test_call;
    begin
        @(negedge clk)
        rf_flag.z = 1;
        rf_flag.v = 1;
        rf_flag.n = 1;
        instr = {`CALL, 12'hx };
        alu_z = 0;
        alu_v = 0;
        alu_n = 0;
        @(negedge clk);
        if(rf_flag.z !== 1)
            $display("Fail test_call z: %h", rf_flag.z);
        if(rf_flag.v !== 1)
            $display("Fail test_call v: %h", rf_flag.v);
        if(rf_flag.n !== 1)
            $display("Fail test_call n: %h", rf_flag.n);
    end
endtask

task test_ret;
    begin
        @(negedge clk)
        rf_flag.z = 1;
        rf_flag.v = 1;
        rf_flag.n = 1;
        instr = {`CALL, 12'hx };
        alu_z = 0;
        alu_v = 0;
        alu_n = 0;
        @(negedge clk);
        if(rf_flag.z !== 1)
            $display("Fail test_ret z: %h", rf_flag.z);
        if(rf_flag.v !== 1)
            $display("Fail test_ret v: %h", rf_flag.v);
        if(rf_flag.n !== 1)
            $display("Fail test_ret n: %h", rf_flag.n);
    end
endtask

endmodule
