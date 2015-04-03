/*CS 552 Project FLAG register unit*/
`include "cond_code.h"
`include "opcode.h"
module flag_rf(out, clk, alu_z, alu_v, alu_n, instr);
    output reg out;

    input clk;
    input alu_z, alu_v, alu_n;
    input[15:0] instr;

    reg z, v, n; 
    reg nxt_n, nxt_v, nxt_z;

    wire[2:0] cond;

    assign cond = (instr[15:12] == `B)? instr[10:8] : 3'bxxx;

    always @(*) begin
        // Hold by default
        nxt_n = n;
        nxt_z = z;
        nxt_v = v;
        case(instr[15:12])
            // If arithemtic instruction, clock in the new flags
            `ADD: begin
                nxt_n = alu_n;
                nxt_v = alu_v;
                nxt_z = alu_z;
            end
            `SUB:begin
                nxt_n = alu_n;
                nxt_v = alu_v;
                nxt_z = alu_z;
            end

            `NAND:begin
                nxt_n = alu_n;
                nxt_v = alu_v;
                nxt_z = alu_z;
            end

            `XOR:begin
                nxt_n = alu_n;
                nxt_v = alu_v;
                nxt_z = alu_z;
            end

            `INC:begin
                nxt_n = alu_n;
                nxt_v = alu_v;
                nxt_z = alu_z;
            end
            default: begin end
        endcase
    end

    always @(posedge clk) begin
        n <= nxt_n;
        v <= nxt_v;
        z <= nxt_z;
    end
    
    always @(*) begin
        case(cond)
            `EQUAL: begin
                out = z;
            end
            `LESS: begin
                out = (~v) && n;
            end
            `GREATER: begin
                out = ~z && ~n && ~v;
            end
            `OVERFLOW: begin
                out = v;
            end
            `NOT_EQUAL: begin
                out = ~z;
            end
            `GREATER_OR_EQUAL: begin
                out = ~v && ~n;
            end
            `LESS_OR_EQUAL: begin
                out = (n && ~v) || z;
            end
            `TRUE: begin
                out = 1'b1;
            end
        endcase
        if(instr[15:12] != `B)
            out = 0;
    end
endmodule 
