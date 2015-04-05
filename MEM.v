`include "opcode.h"
module MEM(wb, ret_addr, we, dm_in, dm_addr, dm_re, dm_we, instr_in, result, rt, pc, dm_out);
    output reg[15:0] wb;
    output reg[15:0] ret_addr;
    output reg we;
    output reg[15:0] dm_in;
    output reg[15:0] dm_addr;
    output reg dm_re;
    output reg dm_we;

    input[15:0] instr_in;
    input[15:0] result;
    input[15:0] rt;
    input[15:0] pc;
    input[15:0] dm_out;

    wire[3:0] op;

    assign op = instr_in[15:12];

    always @(*) begin
        // Defaults for an arithmetic op
        wb = result;
        ret_addr = 16'hxxxx;
        we = 1;
        dm_in = 16'hxxxx;
        dm_addr = 16'hxxxx;
        dm_re = 0;
        dm_we = 0;
        case(op)
            `ADD: begin end
            `SUB: begin end
            `NAND: begin end
            `XOR: begin end
            `INC: begin end
            `SRA: begin end
            `SRL: begin end
            `SLL: begin end
            `SW: begin
                    we = 0;
                    wb = 16'hxxxx;
                    dm_in = rt;
                    dm_addr = result; // result = DS + offset
                    dm_we = 1;
            end
            `LW: begin
                    wb = dm_out;
                    dm_addr = result;
                    dm_re = 1;
            end
            `LHB: begin end
            `LLB: begin end
            `B: we = 0;
            `CALL: begin
                       // Push PC to stack, decrement SP
                       dm_we = 1;
                       dm_addr = rt; // result = SP - 1, now rt = SP
                       dm_in = pc+1;
                       wb = result;
            end
            `RET: begin
                    dm_re = 1;
                    dm_addr = result; // result = SP + 1, which is what we want the data from
                    ret_addr = dm_out;
                    wb = result;
            end
            `HALT: we = 0;
            default: begin
                wb = 16'hxxxx;
                ret_addr = 16'hxxxx;
                we = 1'bx;
                dm_in = 16'hxxxx;
                dm_addr = 16'hxxxx;
                dm_re = 1'bx;
                dm_we = 1'bx;
            end
        endcase
    end

endmodule
