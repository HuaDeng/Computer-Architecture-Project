`include "opcode.h"
module EX_tb;

    reg[15:0] alu1, alu2, instr;
    wire[15:0] rt, result;
    
    wire[15:0] alu_a, alu_b, alu_result;
    wire z,v,n;
    wire[2:0] alu_op;

    ALU_16 alu(alu_op, alu_a, alu_b, alu_result, z, v, n);
    EX ex1(result, rt, alu_op, alu_a, alu_b, alu1, alu2, alu_result, instr);


    initial begin
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
        // test_b(); nothing to test
        test_call();
        test_ret();
        $finish;
    end

    task test_add;
        begin
            alu1 = 16'h0001;
            alu2 = 16'h0002;
            instr = {`ADD, 4'h1, 4'h2, 4'h3};
            #1
            if(result !== 16'h0003)
                $display("Fail test_add result: %h", result);
        end
    endtask

    task test_sub;
        begin
            alu1 = 16'h0002;
            alu2 = 16'h0001;
            instr = {`SUB, 4'h1, 4'h2, 4'h3};
            #1
            if(result !== 16'h0001)
                $display("Fail test_sub result: %h", result);
        end
    endtask

    task test_nand;
        begin
            alu1 = 16'hFFFF;
            alu2 = 16'hFFFE;
            instr = {`NAND, 4'h1, 4'h2, 4'h3};
            #1
            if(result !== 16'h0001)
                $display("Fail test_nand result: %h", result);
        end
    endtask

    task test_xor;
        begin
            alu1 = 16'hFFFF;
            alu2 = 16'hFFF0;
            instr = {`XOR, 4'h1, 4'h2, 4'h3};
            #1
            if(result !== 16'h000F)
                $display("Fail test_xor result: %h", result);
        end
    endtask

    task test_inc;
        begin
            alu1 = 16'h00FF;
            alu2 = 16'h0001;
            instr = {`INC, 4'h1, 4'h2, 4'h1};
            #1
            if(result !== 16'h0100)
                $display("Fail test_inc result: %h", result);
        end
    endtask

    task test_sra;
        begin
            alu1 = 16'h80FF;
            alu2 = 16'h0004;
            instr = {`SRA, 4'h1, 4'h2, 4'h4};
            #1
            if(result !== 16'hF80F)
                $display("Fail test_sra result: %h", result);
        end
    endtask

    task test_srl;
        begin
            alu1 = 16'h80FF;
            alu2 = 16'h0004;
            instr = {`SRL, 4'h1, 4'h2, 4'h4};
            #1
            if(result !== 16'h080F)
                $display("Fail test_srl result: %h", result);
        end
    endtask

    task test_sll;
        begin
            alu1 = 16'h80FF;
            alu2 = 16'h0004;
            instr = {`SLL, 4'h1, 4'h2, 4'h4};
            #1
            if(result !== 16'h0FF0)
                $display("Fail test_sll result: %h", result);
        end
    endtask

    task test_sw;
        begin
            alu1 = 16'hCAFE; // RT
            alu2 = 16'hF000; // DS
            instr = {`SW, 4'h1, 8'h44};
            #1
            // DS + 0x44
            if(result !== 16'hF044)
                $display("Fail test_sw result: %h", result);
            if(rt !== 16'hCAFE)
                $display("Fail test_sw rt: %h", rt);
        end
    endtask

    task test_lw;
        begin
            alu1 = 16'hxxxx;
            alu2 = 16'hBA00; // DS
            instr = {`LW, 4'h1, 8'h55};
            #1
            if(result !== 16'hBA55)
                $display("Fail test_lw result: %h", result);
        end
    endtask

    task test_lhb;
        begin
            alu1 = 16'h00EF; // RT
            alu2 = 16'h00BE; // imm8
            instr = {`LHB, 4'h1, 8'hBE};
            #1
            if(result !== 16'hBEEF)
                $display("Fail test_lhb result: %h", result);
        end
    endtask

    task test_llb;
        begin
            alu1 = 16'hBAAD; // RT
            alu2 = 16'h00BE; // imm8
            instr = {`LLB, 4'h1, 8'hBE};
            #1
            if(result !== 16'hBABE)
                $display("Fail test_llb result: %h", result);
        end
    endtask

    task test_call;
        begin
            alu1 = 16'h1234;
            alu2 = 16'h1;
            instr = {`CALL, 12'hFED};
            #1
            if(result !== 16'h1233)
                $display("Fail test_call result: %h", result);
            if(rt !== 16'h1234)
                $display("Fail test_call rf: %h", result);
        end
    endtask

    task test_ret;
        begin
            alu1 = 16'h1234;
            alu2 = 16'h1;
            instr = {`RET, 12'hFED};
            #1
            if(result !== 16'h1235)
                $display("Fail test_ret result: %h", result);
        end
    endtask

endmodule
