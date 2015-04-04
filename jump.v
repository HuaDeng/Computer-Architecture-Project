`include "opcode.h"
module jump(nxt_pc, ex_pc, ex_instr, branch, if_pc, id_pc, control_hazard, data_hazard);
    output reg[15:0] nxt_pc;

    input [15:0] ex_pc;
    input [15:0] ex_instr; // instruction currently in EX
    input branch;
    input [15:0] if_pc;
    input [15:0] id_pc;
    input control_hazard;
    input data_hazard;

    always @(*) begin
        nxt_pc = (data_hazard) ? if_pc:if_pc + 1;
        nxt_pc = (control_hazard)? id_pc+1: nxt_pc;
        case(ex_instr[15:12])
            `B: begin
                if(branch)
                    nxt_pc = ex_pc + 2 + {{8{ex_instr[7]}}, ex_instr[7:0]}; // PC <= PC + 2 + signext(offset8), 2 because of delayed-branching (in spec)
            end
            `CALL: nxt_pc = {ex_pc[15:12], ex_instr[11:0]};
            `RET: nxt_pc = 16'hxxxx;
            default: begin end
        endcase
    end

endmodule
