`include "opcode.h"
module dut(clk, rst);

    input clk;
    input rst;

    ////////////////////////////////
    //     Instruction Fetch      //
    ////////////////////////////////

    wire[15:0] in_PC;
    wire[15:0] if_pc;
    wire hold;
    wire im_rd_en;
    wire[15:0] if_instr;

    pc pc1(clk, rst, hold, in_PC, if_pc);
    IM im(clk, if_pc, im_rd_en, if_instr);


    ///////////
    // IF/ID //
    ///////////
    reg[15:0] id_pc;
    reg[15:0] id_instr;

    // PC flip-flop
    always @(posedge clk, posedge rst) begin
        if(rst)
            id_pc <= 16'h0000;
        else
            id_pc <= if_pc;
    end

    // Instruction flop-flop
    always @(posedge clk, posedge rst) begin
        if(rst)
            id_instr <= 16'h0000;
        else
            id_instr <= if_instr;
    end


    ////////////////////////////////
    //     Instruction Decode     //
    ////////////////////////////////

    wire[15:0] id_alu1, id_alu2, p0, p1;
    wire rf_re0, rf_re1;
    wire rf_hlt;
    wire[3:0] p0_addr, p1_addr;

    // Comes from writeback
    reg[15:0] wb_wb;
    wire[3:0] wb_addr;
    reg wb_we;

    reg wb_we_latched;
    reg[15:0] wb_wb_latched;
    reg[3:0] wb_addr_latched;

    assign rf_hlt = clk;

    // Make the one half of a flip-flop
    // The other half is inside the rf
    always @(clk, wb_we, wb_wb, wb_addr)
        if(~clk) begin
            wb_we_latched <= wb_we;
            wb_wb_latched <= wb_wb;
            wb_addr_latched <= wb_addr;
        end

    ID id(alu1, alu2, p0_addr, p1_addr, rf_re0, rf_re1, p0, p1, id_instr);
    rf rf1(clk,p0_addr,p1_addr,p0,p1,rf_re0,rf_re1,wb_addr_latched,wb_wb_latched,wb_we_latched,rf_hlt);


    ///////////
    // ID/EX //
    ///////////
    reg[15:0] ex_pc;
    reg[15:0] ex_instr;
    reg[15:0] alu1_reg;
    reg[15:0] alu2_reg;

    // Instruction flop-flop
    always @(posedge clk, posedge rst) begin
        if(rst)
            ex_instr <= 16'h0000;
        else
            ex_instr <= id_instr;
    end

    // PC flip-flop
    always @(posedge clk, posedge rst) begin
        if(rst)
            ex_pc <= 16'h0000;
        else
            ex_pc <= id_pc;
    end

    // alu1 flip-flop
    always @(posedge clk, posedge rst) begin
        if(rst)
            alu1_reg <= 16'h0000;
        else
            alu1_reg <= alu1;
    end

    // alu2 flip-flop
    always @(posedge clk, posedge rst) begin
        if(rst)
            alu2_reg <= 16'h0000;
        else
            alu2_reg <= alu2;
    end

    ////////////////////////////////
    //          Execute           //
    ////////////////////////////////

    wire[15:0] ex_result, ex_rt, alu_a, alu_b, alu1, alu2, alu_result, nxt_PC;
    wire[2:0] alu_op;
    wire alu_z, alu_v, alu_n, branch;

    EX ex(ex_result, ex_rt, alu_op, alu_a, alu_b, alu1, alu2, alu_result, ex_instr);
    ALU_16 alu(alu_op, alu_a, alu_b, alu_result, alu_z, alu_v, alu_n);
    flag_rf flag(branch, clk, alu_z, alu_v, alu_n, ex_instr);
    jump jump1(nxt_PC, ex_pc, ex_instr, branch, if_pc);


    ///////////
    // EX/ME //
    ///////////
    reg[15:0] mem_pc;
    reg[15:0] mem_instr;
    reg[15:0] mem_result;
    reg[15:0] mem_rt;

    // Instruction flop-flop
    always @(posedge clk, posedge rst) begin
        if(rst)
            mem_instr <= 16'h0000;
        else
            mem_instr <= ex_instr;
    end

    // PC flip-flop
    always @(posedge clk, posedge rst) begin
        if(rst)
            mem_pc <= 16'h0000;
        else
            mem_pc <= ex_pc;
    end

    // mem_result flip-flop
    always @(posedge clk, posedge rst) begin
        if(rst)
            mem_result <= 16'h0000;
        else
            mem_result <= ex_result;
    end

    // mem_rt flip-flop
    always @(posedge clk, posedge rst) begin
        if(rst)
            mem_rt <= 16'h0000;
        else
            mem_rt <= ex_rt;
    end




    ////////////////////////////////
    //       Memory Access        //
    ////////////////////////////////

    wire[15:0] dm_addr, dm_in, dm_out, mem_ret_addr, mem_wb;
    wire dm_re, dm_we, mem_we;

    DM dm(clk, dm_addr, dm_re, dm_we, dm_in, dm_out);
    MEM mem(mem_wb, mem_ret_addr, mem_we, dm_in, dm_addr, dm_re, dm_we, mem_instr, mem_result, mem_rt, mem_pc, dm_out);


    ///////////
    // ME/WB //
    ///////////
    reg[15:0] wb_instr;
    reg[15:0] wb_ret_addr;

    // Instruction flop-flop
    always @(posedge clk, posedge rst) begin
        if(rst)
            wb_instr <= 16'h0000;
        else
            wb_instr <= mem_instr;
    end

    // wb_ret_addr flip-flop
    always @(posedge clk, posedge rst) begin
        if(rst)
            wb_ret_addr <= 16'h0000;
        else
            wb_ret_addr <= mem_ret_addr;
    end

    // wb_we flip-flop
    always @(posedge clk, posedge rst) begin
        if(rst)
            wb_we <= 0;
        else
            wb_we <= mem_we;
    end

    // wb_wb flip-flop
    always @(posedge clk, posedge rst) begin
        if(rst)
            wb_wb <= 0;
        else
            wb_wb <= mem_wb;
    end


    ////////////////////////////////
    //         Write Back         //
    ////////////////////////////////

    WB wb(wb_addr, in_PC, wb_instr, wb_we, wb_wb, wb_ret_addr, nxt_PC);

    assign hold = 0;
    assign im_rd_en = 1;

endmodule
