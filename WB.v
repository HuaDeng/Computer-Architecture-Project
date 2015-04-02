`include "opcode.h"
module WB(wb_addr, nxt_ret_PC, instr, we, wb, ret_addr, nxt_PC);
    input[15:0] instr;
    input we;
    input[15:0] wb;
    input[15:0] ret_addr;
    input[15:0] nxt_PC;

    output reg[15:0] wb_addr;
    output reg[15:0] nxt_ret_PC;
    
    wire[4:0] op;
    wire[4:0] rd;

    assign op = instr[15:12];
    assign rd = instr[11:8];

    // Control PC during return
    always @(*) begin
        if(op == `RET )
            nxt_ret_PC = ret_addr;
        else
            nxt_ret_PC = nxt_PC;
    end

    // Control writeback address
    always @(*) begin
        case(op)
            `CALL: wb_addr = 4'hF;
            `RET: wb_addr = 4'hF;
            default: wb_addr = rd;
        endcase
    end

endmodule
