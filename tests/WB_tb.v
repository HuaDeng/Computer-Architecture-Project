`include "opcode.h"
module WB_tb;
    reg[15:0] instr;
    reg we;
    reg[15:0] wb;
    reg[15:0] ret_addr;
    reg[15:0] nxt_PC;

    wire[15:0] wb_addr;
    wire[15:0] nxt_ret_PC;


    WB w1(wb_addr, nxt_ret_PC, instr, we, wb, ret_addr, nxt_PC);

    initial begin
        test_one();
    end

    task test_one;
        begin
            instr = {`ADD, 12'h0};
            we = 1;
            wb = 1;
            ret_addr = 1;
            nxt_PC = 1;
            #1
            if(wb_addr !== 0)
                $display("test_one wb_addr failed");
            if(nxt_ret_PC !== 1)
                $display("test one nxt_ret_PC failed");
        end
    endtask

endmodule
