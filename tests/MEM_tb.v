`include "opcode.h"
module MEM_tb;

    reg clk;

    wire[15:0] wb, ret_addr;
    wire we;
    wire[15:0] dm_addr, dm_in, dm_out;
    wire dm_re, dm_we;

    reg[15:0] instr_in, result, rt, pc;


    MEM m1(wb, ret_addr, we, dm_in, dm_addr, dm_re, dm_we, instr_in, result, rt, pc, dm_out);
    DM d1(clk,dm_addr,dm_re,dm_we,dm_in,dm_out);

    always @(clk) #1 clk <= ~clk;

    initial begin
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

    task test_add;
        begin
            @(posedge clk);
            instr_in = {`ADD, 12'h000};
            result = 16'd10;
            rt = 16'hxxxx;
            pc = 16'hxxxx;
            @(posedge clk);
            if(wb !== 16'd10)
                $display("Failed test_add wb: %h", wb);

            if(we !== 1)
                $display("Failed test_add we: %h", we);
        end
    endtask

    task test_sub;
        begin
            @(posedge clk);
            instr_in = {`SUB, 12'h000};
            result = 16'd10;
            rt = 16'hxxxx;
            pc = 16'hxxxx;
            @(posedge clk);
            if(wb !== 16'd10)
                $display("Failed test_sub wb: %h", wb);

            if(we !== 1)
                $display("Failed test_sub we: %h", we);
        end
    endtask

    task test_nand;
        begin
            @(posedge clk);
            instr_in = {`NAND, 12'h000};
            result = 16'd10;
            rt = 16'hxxxx;
            pc = 16'hxxxx;
            @(posedge clk);
            if(wb !== 16'd10)
                $display("Failed test_nand wb: %h", wb);

            if(we !== 1)
                $display("Failed test_nand we: %h", we);
        end
    endtask

    task test_xor;
        begin
            @(posedge clk);
            instr_in = {`XOR, 12'h000};
            result = 16'd10;
            rt = 16'hxxxx;
            pc = 16'hxxxx;
            @(posedge clk);
            if(wb !== 16'd10)
                $display("Failed test_xor wb: %h", wb);

            if(we !== 1)
                $display("Failed test_xor we: %h", we);
        end
    endtask

    task test_inc;
        begin
            @(posedge clk);
            instr_in = {`INC, 12'h000};
            result = 16'd10;
            rt = 16'hxxxx;
            pc = 16'hxxxx;
            @(posedge clk);
            if(wb !== 16'd10)
                $display("Failed test_inc wb: %h", wb);

            if(we !== 1)
                $display("Failed test_inc we: %h", we);
        end
    endtask

    task test_sra;
        begin
            @(posedge clk);
            instr_in = {`SRA, 12'h000};
            result = 16'd10;
            rt = 16'hxxxx;
            pc = 16'hxxxx;
            @(posedge clk);
            if(wb !== 16'd10)
                $display("Failed test_sra wb: %h", wb);

            if(we !== 1)
                $display("Failed test_sra we: %h", we);
        end
    endtask

    task test_srl;
        begin
            @(posedge clk);
            instr_in = {`SRL, 12'h000};
            result = 16'd10;
            rt = 16'hxxxx;
            pc = 16'hxxxx;
            @(posedge clk);
            if(wb !== 16'd10)
                $display("Failed test_srl wb: %h", wb);

            if(we !== 1)
                $display("Failed test_srl we: %h", we);
        end
    endtask

    task test_sll;
        begin
            @(posedge clk);
            instr_in = {`SLL, 12'h000};
            result = 16'd10;
            rt = 16'hxxxx;
            pc = 16'hxxxx;
            @(posedge clk);
            if(wb !== 16'd10)
                $display("Failed test_sll wb: %h", wb);

            if(we !== 1)
                $display("Failed test_sll we: %h", we);
        end
    endtask

    task test_sw;
        begin
            @(posedge clk);
            instr_in = {`SW, 12'h000};
            result = 16'h0000;
            rt = 16'hA0A0; // store A0A0 to address 0000
            pc = 16'hxxxx;
            @(posedge clk);
            if(we !== 0)
                $display("Failed test_sw we: %h", we);
            if(d1.data_mem[0] !== 16'hA0A0)
                $display("Failed test_sw data_mem: %h", d1.data_mem[0]);
        end
    endtask

    task test_lw;
        begin
            @(posedge clk);
            // Load 0000 to R1
            d1.data_mem[0] = 16'h0A0A;
            instr_in = {`LW, 12'h100};
            result = 16'h0000; // DS + offset = 0
            rt = 16'hxxxx;
            pc = 16'hxxxx;
            @(posedge clk);
            if(we !== 1)
                $display("Failed test_lw we: %h", we);
            if(wb != 16'h0A0A)
                $display("Failed test_lw wb: %h", wb);
        end
    endtask

    task test_lhb;
        begin
            @(posedge clk);
            instr_in = {`LHB, 12'h100};
            result = 16'h0A0A;
            rt = 16'hxxxx;
            pc = 16'hxxxx;
            @(posedge clk);
            if(we !== 1)
                $display("Failed test_lhb we: %h", we);
            if(wb != 16'h0A0A)
                $display("Failed test_lhb wb: %h", wb);
        end
    endtask

    task test_llb;
        begin
            @(posedge clk);
            instr_in = {`LLB, 12'h100};
            result = 16'h0B0B;
            rt = 16'hxxxx;
            pc = 16'hxxxx;
            @(posedge clk);
            if(we !== 1)
                $display("Failed test_llb we: %h", we);
            if(wb != 16'h0B0B)
                $display("Failed test_llb wb: %h", wb);
        end
    endtask

    task test_b;
        begin
            @(posedge clk);
            instr_in = {`B, 12'h100};
            result = 16'hxxxx;
            rt = 16'hxxxx;
            pc = 16'hxxxx;
            @(posedge clk);
            if(we !== 0)
                $display("Failed test_b we: %h", we);
        end
    endtask

    task test_call;
        begin
            @(posedge clk);
            // CALL with PC=BABA and SP=2
            instr_in = {`CALL, 12'h100};
            result = 16'd1; // SP - 1 = 1
            rt = 16'h0002;
            pc = 16'hBABA;
            @(posedge clk);
            if(we !== 1)
                $display("Failed test_call we: %h", we);
            if(wb !== 16'd1)
                $display("Failed test_call wb: %h", wb);
            if(d1.data_mem[2] !== 16'hBABB)
                $display("Failed test_call data_mem: %h", d1.data_mem[2]);
        end
    endtask

    task test_ret;
        begin
            @(posedge clk);
            // RET with SP=5 and ABCD at the top of the stack
            d1.data_mem[6] = 16'hABCD;
            instr_in = {`RET, 12'hxxx};
            result = 16'd6; // SP + 1 = 5
            rt = 16'hxxxx;
            pc = 16'hxxxx;
            @(posedge clk);
            if(we !== 1)
                $display("Failed test_ret we: %h", we);
            if(wb !== 16'd6)
                $display("Failed test_ret wb: %h", wb);
            if(ret_addr !== 16'hABCD)
                $display("Failed test_ret ret_addr: %h", ret_addr);
        end
    endtask


endmodule
