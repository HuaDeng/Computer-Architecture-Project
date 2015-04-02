`include "opcode.h"
module jump(nxt_pc, pc, ex_instr, branch);
    output reg[15:0] nxt_pc;

    input [15:0] pc;
    input [15:0] ex_instr; // instruction currently in EX
    input branch;

    always @(*) begin
        nxt_pc = pc + 1;
        case(ex_instr[15:12])
            `B: begin
                if(branch)
                    nxt_pc = pc + 2 + {{8{ex_instr[7]}}, ex_instr[7:0]}; // PC <= PC + 2 + signext(offset8), 2 because of delayed-branching (in spec)
            end
            `CALL: nxt_pc = {pc[15:12], ex_instr[11:0]};
            `RET: nxt_pc = 16'hxxxx;
            default: nxt_pc = pc + 1;
        endcase
    end

endmodule
