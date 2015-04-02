`include "opcode.h"
module ID_tb;
    reg clk;
    reg[15:0] instr;

    wire re0, re1, hlt;
    wire[15:0] alu1, alu2, p0, p1, dst;
    wire[3:0] p0_addr, p1_addr, dst_addr;
    
    wire we;

    assign we = 0;
    assign hlt = 0;

    ID id(alu1, alu2, p0_addr, p1_addr, re0, re1, p0, p1, instr);
    rf rf1(clk,p0_addr,p1_addr,p0,p1,re0,re1,dst_addr,dst,we,hlt);

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
        //test_b(); nothing to test
        test_call();
        test_ret();
        $finish;
    end

    task test_add;
        begin
            @(posedge clk);
            rf1.mem[2] = 16'hABCD;
            rf1.mem[3] = 16'hDEAD;
            instr = {`ADD, 4'h1, 4'h2, 4'h3};
            @(posedge clk)
            if(alu1 !== 16'hABCD)
                $display("Failed test_add alu1: %h", alu1);
            if(alu2 !== 16'hDEAD)
                $display("Failed test_add alu2: %h", alu2);
        end
    endtask

    task test_sub;
        begin
            @(posedge clk);
            rf1.mem[2] = 16'hBEEF;
            rf1.mem[3] = 16'hFACE;
            instr = {`SUB, 4'h1, 4'h2, 4'h3};
            @(posedge clk)
            if(alu1 !== 16'hBEEF)
                $display("Failed test_sub alu1: %h", alu1);
            if(alu2 !== 16'hFACE)
                $display("Failed test_sub alu2: %h", alu2);
        end
    endtask

    task test_nand;
        begin
            @(posedge clk);
            rf1.mem[2] = 16'hFEE1;
            rf1.mem[3] = 16'hC0DE;
            instr = {`NAND, 4'h1, 4'h2, 4'h3};
            @(posedge clk)
            if(alu1 !== 16'hFEE1)
                $display("Failed test_nand alu1: %h", alu1);
            if(alu2 !== 16'hC0DE)
                $display("Failed test_nand alu2: %h", alu2);
        end
    endtask

    task test_xor;
        begin
            @(posedge clk);
            rf1.mem[2] = 16'hCAFE;
            rf1.mem[3] = 16'hD00D;
            instr = {`XOR, 4'h1, 4'h2, 4'h3};
            @(posedge clk)
            if(alu1 !== 16'hCAFE)
                $display("Failed test_xor alu1: %h", alu1);
            if(alu2 !== 16'hD00D)
                $display("Failed test_xor alu2: %h", alu2);
        end
    endtask

    task test_inc;
        begin
            @(posedge clk);
            rf1.mem[2] = 16'hBABE;
            instr = {`INC, 4'h1, 4'h2, -4'h1};
            @(posedge clk)
            if(alu1 !== 16'hBABE)
                $display("Failed test_inc alu1: %h", alu1);
            if(alu2 !== -16'd1)
                $display("Failed test_inc alu2: %h", alu2);
        end
    endtask

    task test_sra;
        begin
            @(posedge clk);
            rf1.mem[2] = 16'h0001;
            instr = {`SRA, 4'h1, 4'h2, 4'h8};
            @(posedge clk)
            if(alu1 !== 16'h0001)
                $display("Failed test_sra alu1: %h", alu1);
            if(alu2 !== 16'h8)
                $display("Failed test_sra alu2: %h", alu2);
        end
    endtask

    task test_srl;
        begin
            @(posedge clk);
            rf1.mem[2] = 16'h1001;
            instr = {`SRL, 4'h1, 4'h2, 4'h8};
            @(posedge clk)
            if(alu1 !== 16'h1001)
                $display("Failed test_srl alu1: %h", alu1);
            if(alu2 !== 16'h8)
                $display("Failed test_srl alu2: %h", alu2);
        end
    endtask

    task test_sll;
        begin
            @(posedge clk);
            rf1.mem[2] = 16'h1011;
            instr = {`SLL, 4'h1, 4'h2, 4'h8};
            @(posedge clk)
            if(alu1 !== 16'h1011)
                $display("Failed test_sll alu1: %h", alu1);
            if(alu2 !== 16'h8)
                $display("Failed test_sll alu2: %h", alu2);
        end
    endtask

    task test_sw;
        begin
            @(posedge clk);
            rf1.mem[2] = 16'hF00D;
            rf1.mem[14] = 16'hB00B; // set DS
            instr = {`SW, 4'h2, 8'hAD};
            @(posedge clk)
            if(alu1 !== 16'hF00D)
                $display("Failed test_sw alu1: %h", alu1);
            if(alu2 !== 16'hB00B)
                $display("Failed test_sw alu2: %h", alu2);
        end
    endtask

    task test_lw;
        begin
            @(posedge clk);
            rf1.mem[14] = 16'hB105; // set DS
            instr = {`LW, 4'h2, 8'h55};
            @(posedge clk)
            if(alu2 !== 16'hB105)
                $display("Failed test_lw alu2: %h", alu2);
        end
    endtask

    task test_lhb;
        begin
            @(posedge clk);
            rf1.mem[2] = 16'hBEAF;
            instr = {`LHB, 4'h2, 8'hEB};
            @(posedge clk)
            if(alu1 !== 16'hBEAF)
                $display("Failed test_lhb alu1: %h", alu1);
            if(alu2 !== 16'hEB)
                $display("Failed test_lhb alu2: %h", alu2);
        end
    endtask

    task test_llb;
        begin
            @(posedge clk);
            rf1.mem[2] = 16'hFA11;
            instr = {`LLB, 4'h2, 8'h1B};
            @(posedge clk)
            if(alu1 !== 16'hFA11)
                $display("Failed test_llb alu1: %h", alu1);
            if(alu2 !== 16'h1B)
                $display("Failed test_llb alu2: %h", alu2);
        end
    endtask

    task test_call;
        begin
            @(posedge clk);
            rf1.mem[15] = 16'h10CC;
            instr = {`CALL, 12'h012};
            @(posedge clk);
            if(alu1 !== 16'h10CC)
                $display("Failed test_call alu1: %h", alu1);
            if(alu2 !== 16'd1)
                $display("Failed test_call alu2: %h", alu2);
        end
    endtask

    task test_ret;
        begin
            @(posedge clk);
            rf1.mem[15] = 16'h4B1D;
            instr = {`RET, 12'hxxx};
            @(posedge clk);
            if(alu1 !== 16'h4B1D)
                $display("Failed test_ret alu1: %h", alu1);
            if(alu2 !== 16'd1)
                $display("Failed test_ret alu2: %h", alu2);
        end
    endtask

endmodule
