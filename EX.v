`include "opcode.h"
`include "alu_ops.h"

module EX(result, rt, alu_op, alu_a, alu_b, alu1, alu2, alu_result, instr);

    output reg[15:0] result;
    output reg[15:0] rt;
    output reg[2:0] alu_op;
    output reg[15:0] alu_a;
    output reg[15:0] alu_b;

    input[15:0] alu1;
    input[15:0] alu2;
    input[15:0] alu_result;
    input[15:0] instr;

    always @(*) begin
        result = alu_result;
        rt = 16'hxxxx;
        alu_op = `ALU_ADD;
        alu_a = alu1;
        alu_b = alu2;
        case(instr[15:12])
            `ADD: begin
                alu_op = `ALU_ADD;
            end
            `SUB: begin
                alu_op = `ALU_SUB;
            end
            `NAND: begin
                alu_op = `ALU_NAND;
            end
            `XOR: begin
                alu_op = `ALU_XOR;
            end
            `INC: begin
                alu_op = `ALU_ADD;
            end
            `SRA: begin
                alu_op = `ALU_SRA;
            end
            `SRL: begin
                alu_op = `ALU_SRL;
            end
            `SLL: begin
                alu_op = `ALU_SLL;
            end
            `SW: begin
                alu_a = {{8{instr[7]}},instr[7:0]}; // offset8, sign-extended
                alu_b = alu2; // ds
                rt = alu1; // rt
            end
            `LW: begin
                alu_a = {{8{instr[7]}}, instr[7:0]}; // offset8, sign-extended
                alu_b = alu2; //ds
            end
            `LHB: begin
                result = {alu2[7:0], alu1[7:0]};
                alu_a = 16'hxxxx;
                alu_b = 16'hxxxx;
                alu_op = 3'bxxx;
            end
            `LLB: begin
                result = {alu1[15:8], alu2[7:0]};
                alu_a = 16'hxxxx;
                alu_b = 16'hxxxx;
                alu_op = 3'bxxx;
            end
            `B: begin
                result = 16'hxxxx;
                alu_a = 16'hxxxx;
                alu_b = 16'hxxxx;
                alu_op = 3'bxxx;
            end
            `CALL: begin
                alu_a = alu1; //SP
                alu_b = alu2; // 1
                alu_op = `ALU_SUB; // SP - 1
                rt = alu1;
            end
            `RET: begin
                alu_a = alu1; //SP
                alu_b = alu2; // 1
                alu_op = `ALU_ADD; // SP + 1
            end
            default: begin
                alu_a = 16'hxxxx;
                alu_b = 16'hxxxx;
                alu_op = 3'bxxx;
                rt = 16'hxxxx;
                result = 16'hxxxx;
            end
        endcase
    end

endmodule
