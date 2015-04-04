`include "opcode.h"
module hazard_detection(data_hazard, control_hazard, id_instr, ex_instr, mem_instr);
    output reg data_hazard;
    output reg control_hazard;
    input wire[15:0] id_instr;
    input wire[15:0] ex_instr;
    input wire[15:0] mem_instr;

    reg id_uses_read1;
    reg id_uses_read2;
    reg[3:0] id_read1_addr;
    reg[3:0] id_read2_addr;

    reg ex_uses_write;
    reg[3:0] ex_write_addr;

    reg mem_uses_write;
    reg[3:0] mem_write_addr;

    // Determine if there is a hazard
    always @(*) begin
        data_hazard = 0;
        control_hazard = 0;
        // Data hazards
        if(id_uses_read1 && (id_read1_addr != 0)) begin
            if(id_read1_addr == mem_write_addr)
                data_hazard = 1;
            if(id_read1_addr == ex_write_addr)
                data_hazard = 1;
        end
        if(id_uses_read2 && (id_read2_addr != 0)) begin
            if(id_read2_addr == mem_write_addr)
                data_hazard = 1;
            if(id_read2_addr == ex_write_addr)
                data_hazard = 1;
        end
        // Control hazards
        case(id_instr[15:12])
            `CALL: control_hazard = 1;
            `RET: control_hazard = 1;
        endcase
        case(ex_instr[15:12])
            `CALL: control_hazard = 1;
            `RET: control_hazard = 1;
        endcase
        if(mem_instr[15:12] == `RET)
            control_hazard = 1;
    end

    // Find out if the instruction in the IF stage uses read
    always @(*) begin
        id_uses_read1 = 1;
        id_uses_read2 = 1;
        case(id_instr[15:12])
            `INC: id_uses_read2 = 0;
            `SRA: id_uses_read2 = 0;
            `SRL: id_uses_read2 = 0;
            `SLL: id_uses_read2 = 0;
            `LW: id_uses_read1 = 0;
            `LHB: id_uses_read2 = 0;
            `LLB: id_uses_read2 = 0;
            `B: begin
                id_uses_read1 = 0;
                id_uses_read2 = 0;
            end
            `CALL: id_uses_read2 = 0;
            `RET: id_uses_read2 = 0;
            default: begin
                id_uses_read1 = 1;
                id_uses_read2 = 1;
            end
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

    // Find out if EX stage uses write
    always @(*) begin
        case(ex_instr[15:12])
            `SW: ex_uses_write = 0;
            `B: ex_uses_write = 0;
            default: ex_uses_write = 1;
        endcase
    end

    // Find out the IF read1 addr
    always @(*) begin
        id_read1_addr = id_instr[7:4];
        id_read2_addr = id_instr[3:0];
        case(id_instr[15:12])
            `SW: begin
                id_read1_addr = id_instr[11:8];
                id_read2_addr = 4'd14;
            end
            `LW: begin
                id_read1_addr = 4'hx;
                id_read2_addr = 4'd14;
            end
            `LHB: begin
                id_read1_addr = id_instr[11:8];
                id_read2_addr = 4'hx;
            end
            `LLB: begin
                id_read1_addr = id_instr[11:8];
                id_read2_addr = 4'hx;
            end
            `B: begin
                id_read1_addr = 4'hx;
                id_read2_addr = 4'hx;
            end
            `CALL: begin
                id_read1_addr = 4'd15;
                id_read2_addr = 4'hx;
            end
            `RET: begin
                id_read1_addr = 4'd15;
                id_read2_addr = 4'hx;
            end
            default: begin
                id_read1_addr = id_instr[7:4];
                id_read2_addr = id_instr[3:0];
            end
        endcase
    end

    // Find out MEM.write addr
    always @(*) begin
        mem_write_addr = 4'hx;
        if(mem_uses_write) begin
            case(mem_instr[15:12])
                `CALL: mem_write_addr = 4'd15;
                `RET:  mem_write_addr = 4'd15;
                default: mem_write_addr = mem_instr[11:8];
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
                default: ex_write_addr = ex_instr[11:8];
            endcase
        end
    end

endmodule
