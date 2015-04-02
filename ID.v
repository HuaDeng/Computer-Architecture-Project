`include "opcode.h"
module ID(alu1, alu2, p0_addr, p1_addr, re0, re1, p0, p1, instr);

    output reg[15:0] alu1;
    output reg[15:0] alu2;
    output reg[3:0] p0_addr;
    output reg[3:0] p1_addr;
    output re0, re1;
    input[15:0] instr, p0, p1;
    
    assign re0 = 1;
    assign re1 = 1;

    always @(*) begin
        alu1 = p0;
        alu2 = p1;
        p0_addr = instr[7:4];
        p1_addr = instr[3:0];
        case(instr[15:12])
            `ADD: begin end
            `SUB: begin end
            `NAND: begin end
            `XOR: begin end
            `INC: begin
                alu1 = p0;
                alu2 = {{12{instr[3]}}, instr[3:0]}; // sign extend imm4
                p0_addr = instr[7:4]; // rs
                p1_addr = 4'hx;
            end
            `SRA: begin
                alu1 = p0;
                alu2 = {12'b0, instr[3:0]}; // zero extended imm4
                p0_addr = instr[7:4]; // rs
                p1_addr = 4'hx;
            end
            `SRL: begin
                alu1 = p0;
                alu2 = {12'b0, instr[3:0]}; // zero extended imm4
                p0_addr = instr[7:4]; // rs
                p1_addr = 4'hx;
            end
            `SLL: begin
                alu1 = p0;
                alu2 = {12'b0, instr[3:0]}; // zero extended imm4
                p0_addr = instr[7:4]; // rs
                p1_addr = 4'hx;
            end
            `SW: begin
                alu1 = p0;
                alu2 = p1;
                p0_addr = instr[11:8]; // rt
                p1_addr = 4'd14; // ds
            end
            `LW: begin
                alu1 = 16'hxxxx;
                alu2 = p1;
                p0_addr = 4'hx;
                p1_addr = 4'd14; // ds
            end
            `LHB: begin
                alu1 = p0;
                alu2 = {8'h00, instr[7:0]};
                p0_addr = instr[11:8];
                p1_addr = 4'hx;
            end
            `LLB: begin
                alu1 = p0;
                alu2 = {8'h00, instr[7:0]};
                p0_addr = instr[11:8];
                p1_addr = 4'hx;
            end
            `B: begin
                alu1 = 16'hxxxx;
                alu2 = instr[7:0];
                p0_addr = 4'hx;
                p1_addr = 4'hx;
            end
            `CALL: begin
                alu1 = p0;
                alu2 = -16'd1;
                p0_addr = 4'd15; // SP
                p1_addr = 4'hx;
            end
            `RET: begin
                alu1 = p0;
                alu2 = 16'd1;
                p0_addr = 4'd15; //SP
                p1_addr = 4'hx;
            end

            default: begin
                alu1 = 16'hxxxx;
                alu2 = 16'hxxxx;
                p0_addr = 16'hxxxx;
                p1_addr = 16'hxxxx;
            end
        endcase
    end

endmodule
