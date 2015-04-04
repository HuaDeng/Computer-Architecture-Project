`include "opcode.h"
module jump_tb;
    reg[15:0] ex_instr;
    reg[15:0] pc, if_pc;
    reg branch;

    wire[15:0] nxt_pc;
    wire control_hazard;
    wire data_hazard;

    assign control_hazard = 0;
    assign data_hazard = 0;
    
    jump j1(nxt_pc, pc, ex_instr, branch, if_pc, id_pc, control_hazard, data_hazard);

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
        test_b();
        test_call();
        test_ret();
        $finish;
    end

    task test_add;
        begin
            pc = 16'hB1AB;
            if_pc = 16'hB1AB;
            ex_instr = {`ADD, 4'h0, 4'h1, 4'h2};
            branch = 0;
            #1;
            if(nxt_pc !== 16'hB1AC)
                $display("Fail test_add nxt_pc1: %h", nxt_pc);
            branch = 1;
            #1;
            if(nxt_pc !== 16'hb1AC)
                $display("Fail test_add nxt_pc2: %h", nxt_pc);
        end
    endtask

    task test_sub;
        begin
            pc = 16'h5EED;
            if_pc = 16'h5EED;
            ex_instr = {`SUB, 4'h0, 4'h1, 4'h2};
            branch = 0;
            #1;
            if(nxt_pc !== 16'h5EEE)
                $display("Fail test_sub nxt_pc1: %h", nxt_pc);
            branch = 1;
            #1;
            if(nxt_pc !== 16'h5EEE)
                $display("Fail test_sub nxt_pc2: %h", nxt_pc);
        end
    endtask

    task test_nand;
        begin
            pc = 16'hB0DE;
            if_pc = 16'hB0DE;
            ex_instr = {`NAND, 4'h0, 4'h1, 4'h2};
            branch = 0;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_nand nxt_pc1: %h", nxt_pc);
            branch = 1;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_nand nxt_pc2: %h", nxt_pc);
        end
    endtask

    task test_xor;
        begin
            pc = 16'hB0DE;
            if_pc = 16'hB0DE;
            ex_instr = {`XOR, 4'h0, 4'h1, 4'h2};
            branch = 0;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_xor nxt_pc1: %h", nxt_pc);
            branch = 1;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_xor nxt_pc2: %h", nxt_pc);
        end
    endtask

    task test_inc;
        begin
            pc = 16'hB0DE;
            if_pc = 16'hB0DE;
            ex_instr = {`INC, 4'h0, 8'h1};
            branch = 0;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_inc nxt_pc1: %h", nxt_pc);
            branch = 1;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_inc nxt_pc2: %h", nxt_pc);
        end
    endtask

    task test_sra;
        begin
            pc = 16'hB0DE;
            if_pc = 16'hB0DE;
            ex_instr = {`SRA, 4'h0, 4'h1, 4'h0};
            branch = 0;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_sra nxt_pc1: %h", nxt_pc);
            branch = 1;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_sra nxt_pc2: %h", nxt_pc);
        end
    endtask

    task test_srl;
        begin
            pc = 16'hB0DE;
            if_pc = 16'hB0DE;
            ex_instr = {`SRL, 4'h0, 4'h1, 4'h0};
            branch = 0;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_srl nxt_pc1: %h", nxt_pc);
            branch = 1;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_srl nxt_pc2: %h", nxt_pc);
        end
    endtask

    task test_sll;
        begin
            pc = 16'hB0DE;
            if_pc = 16'hB0DE;
            ex_instr = {`SLL, 4'h0, 4'h1, 4'h0};
            branch = 0;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_sll nxt_pc1: %h", nxt_pc);
            branch = 1;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_sll nxt_pc2: %h", nxt_pc);
        end
    endtask

    task test_sw;
        begin
            pc = 16'hB0DE;
            if_pc = 16'hB0DE;
            ex_instr = {`SW, 4'h0, 8'h1};
            branch = 0;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_sw nxt_pc1: %h", nxt_pc);
            branch = 1;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_sw nxt_pc2: %h", nxt_pc);
        end
    endtask

    task test_lw;
        begin
            pc = 16'hB0DE;
            if_pc = 16'hB0DE;
            ex_instr = {`LW, 4'h0, 8'h1};
            branch = 0;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_lw nxt_pc1: %h", nxt_pc);
            branch = 1;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_lw nxt_pc2: %h", nxt_pc);
        end
    endtask

    task test_lhb;
        begin
            pc = 16'hB0DE;
            if_pc = 16'hB0DE;
            ex_instr = {`LHB, 4'h0, 8'h1};
            branch = 0;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_lhb nxt_pc1: %h", nxt_pc);
            branch = 1;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_lhb nxt_pc2: %h", nxt_pc);
        end
    endtask

    task test_llb;
        begin
            pc = 16'hB0DE;
            if_pc = 16'hB0DE;
            ex_instr = {`LLB, 4'h0, 8'h1};
            branch = 0;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_llb nxt_pc1: %h", nxt_pc);
            branch = 1;
            #1;
            if(nxt_pc !== 16'hB0DF)
                $display("Fail test_llb nxt_pc2: %h", nxt_pc);
        end
    endtask

    task test_b;
        begin
            #1;
            pc = 16'h1055;
            if_pc = 16'h1055;
            ex_instr = {`B , 4'h0, 8'h00};
            branch = 0;
            #1;
            if(nxt_pc !== 16'h1056)
                $display("Fail test_b nxt_pc1: %h", nxt_pc);

            branch = 1;
            #1;
            if(nxt_pc !== 16'h1057)
                $display("Fail test_b nxt_pc2: %h", nxt_pc);

            ex_instr = {`B, 4'h0, -8'h55};
            pc = 16'h0055;
            if_pc = 16'h0055;
            #1;
            if(nxt_pc !== 16'h2)
                $display("Fail test_b nxt_pc3: %h", nxt_pc);
        end
    endtask

    task test_call;
        begin
            #1;
            pc = 16'hC0DA;
            if_pc = 16'hC0DA;
            ex_instr = {`CALL, 12'h000};
            branch = 0;
            #1;
            if(nxt_pc !== 16'hC000)
                $display("Fail test_call nxt_pc1: %h", nxt_pc);
            branch = 1;
            #1;
            if(nxt_pc !== 16'hC000)
                $display("Fail test_call nxt_pc1: %h", nxt_pc);
        end
    endtask

    task test_ret;
        begin
            pc = 16'hC0DA;
            if_pc = 16'hC0DA;
            ex_instr = {`RET, 12'hxxx};
            branch = 0;
            #1;
            if(nxt_pc !== 16'hxxxx)
                $display("Fail test_ret nxt_pc1: %h", nxt_pc);
            branch = 1;
            #1;
            if(nxt_pc !== 16'hxxxx)
                $display("Fail test_ret nxt_pc1: %h", nxt_pc);
        end
    endtask

endmodule
