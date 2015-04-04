`include "opcode.h"
module hazard_detection(hazard, if_instr, id_instr, ex_instr, mem_instr);
    output reg hazard;
    input wire[15:0] if_instr;
    input wire[15:0] id_instr;
    input wire[15:0] ex_instr;
    input wire[15:0] mem_instr;

    reg if_uses_read1;
    reg if_uses_read2;
    reg[3:0] if_read1_addr;
    reg[3:0] if_read2_addr;

    reg id_uses_write;
    reg[3:0] id_write_addr;

    reg ex_uses_write;
    reg[3:0] ex_write_addr;

    reg mem_uses_write;
    reg[3:0] mem_write_addr;

    // Determine if there is a hazard
    always @(*) begin
        hazard = 0;
        if(if_uses_read1) begin
            if(if_read1_addr == id_write_addr)
                hazard = 1;
            if(if_read1_addr == ex_write_addr)
                hazard = 1;
            if(if_read1_addr == mem_write_addr)
                hazard = 1;
            if(if_read1_addr == 0)
                hazard = 0;
        end
        if(if_uses_read2) begin
            if(if_read2_addr == id_write_addr)
                hazard = 1;
            if(if_read2_addr == ex_write_addr)
                hazard = 1;
            if(if_read2_addr == mem_write_addr)
                hazard = 1;
            if(if_read2_addr == 0)
                hazard = 0;
        end
    end

    // Find out if the instruction in the IF stage uses read
    always @(*) begin
        if_uses_read1 = 1;
        if_uses_read2 = 1;
        case(if_instr[15:12])
            `INC: if_uses_read2 = 0;
            `SRA: if_uses_read2 = 0;
            `SRL: if_uses_read2 = 0;
            `SLL: if_uses_read2 = 0;
            `LW: if_uses_read1 = 0;
            `LHB: if_uses_read2 = 0;
            `LLB: if_uses_read2 = 0;
            `B: begin
                if_uses_read1 = 0;
                if_uses_read2 = 0;
            end
            `CALL: if_uses_read2 = 0;
            `RET: if_uses_read2 = 0;
            default: begin
                if_uses_read1 = 1;
                if_uses_read2 = 1;
            end
        endcase
    end

    // Find out if ID stage uses write
    always @(*) begin
        case(id_instr[15:12])
            `SW: id_uses_write = 0;
            `B: id_uses_write = 0;
            default: id_uses_write = 1;
        endcase
    end

    // Find out if EX stage uses write
    always @(*) begin
        case(ex_instr[15:12])
            `SW: ex_uses_write = 0;
            `B: ex_uses_write = 0;
            default: ex_uses_write = 1;
        endcase
    end

    // Find out if MEM stage uses write
    always @(*) begin
        case(mem_instr[15:12])
            `SW: mem_uses_write = 0;
            `B: mem_uses_write = 0;
            default: mem_uses_write = 1;
        endcase
    end

    // Find out ID.write addr
    always @(*) begin
        id_write_addr = 4'hx;
        if(id_uses_write) begin
            case(id_instr[15:12])
                `CALL: id_write_addr = 4'd15;
                `RET:  id_write_addr = 4'd15;
                default: id_write_addr = id_instr[11:8];
            endcase
        end
    end

    // Find out EX.write addr
    always @(*) begin
        ex_write_addr = 4'hx;
        if(ex_uses_write) begin
            case(ex_instr[15:12])
                `CALL: ex_write_addr = 4'd15;
                `RET:  ex_write_addr = 4'd15;
                default: ex_write_addr = id_instr[11:8];
            endcase
        end
    end

    // Find out MEM.write_addr
    always @(*) begin
        mem_write_addr = 4'hx;
        if(mem_uses_write) begin
            case(mem_instr[15:12])
                `CALL: mem_write_addr = 4'd15;
                `RET:  mem_write_addr = 4'd15;
                default: mem_write_addr = id_instr[11:8];
            endcase
        end
    end

endmodule
