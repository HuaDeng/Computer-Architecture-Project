module DUT(clk,rst);
    input clk;
    input rst;
    
    // Ctrl signals
    wire [3:0] Opcode;
    wire pc_src;
    wire rf_wsrc;
    wire[1:0] rf_rsrc1;
    wire[1:0] rf_rsrc2;
    wire rf_w;
    wire alu_src1;
    wire[1:0] alu_src2;
    wire sel_call;
    wire sel_branch;
    wire[2:0] aluop;
    wire dm_in_src;
    wire dm_addr_src;
    wire dm_read;
    wire dm_write;
    wire[1:0] rf_data_src;

    // ALU
    wire[2:0] alu_op;
    reg[15:0] alu_a;
    reg[15:0] alu_b;

    wire[15:0] alu_result;
    wire z;
    wire v;
    wire n;

    // Instruction mem
    wire[15:0] addr;
    wire rd_en;            // asserted when instruction read desired
    wire[15:0] instr;


    // LHB & LLB
    wire[7:0] in_2;  // Instruction -> lb_unit.in_2
    wire[15:0] lhb_out; // lhb_unit -> rf_data mux
    wire[15:0] llb_out; // llb_unit -> rf_data mux

    // PC
    wire rst; //reset the program counter
    wire hold; //hold the current program counter value, TODO
    reg[15:0] in_PC; // pc_src mux -> pc
    wire[15:0] out_PC; // pc -> instr_mem.addr and adder

    // RF
    reg[3:0] p0_addr; // rf_rsrc1 mux -> rf
    reg[3:0] p1_addr; // rf_rsrc2 mux -> rf
    wire re0;          // TODO
    wire re1;          // TODO
    reg[3:0] dst_addr;// rf_wsrc mux -> rf
    reg[15:0] dst;    // rf_data mux -> rf
    wire hlt;          // Not a functional input
    wire[15:0] p0;     // rf -> dm_in mux and alu_src1 mux 
    wire[15:0] p1;     // rf -> alu_src1 mux and alu_src2 mux

    // Data mem
    reg[15:0] dm_addr;  // dm_addr_src mux -> dm
    reg [15:0] dm_wrt_data; // dm_in mux -> dm
    wire [15:0] dm_rd_data; // dm -> rf_data mux and pc_src mux


    wire[15:0] nxt_PC;

    assign rd_en = 1;
    assign hold = 0;

    assign nxt_PC = out_PC + 1;
    assign re0 = 1;
    assign re1 = 1;
    assign Opcode = instr[15:12];

    wiscsc15_ctrl w1(Opcode,
        pc_src,
        rf_wsrc,
        rf_rsrc1,
        rf_rsrc2,
        rf_w,
        alu_src1,
        alu_src2,
        sel_call,
        sel_branch,
        aluop,
        dm_in_src,
        dm_addr_src,
        dm_read,
        dm_write,
        rf_data_src);
    ALU_16 alu(aluop, alu_a, alu_b, alu_result, z, v, n);
    IM im(clk,out_PC,rd_en,instr);
    llb_unit llb(p0, in_2, llb_out);
    lhb_unit lhb(p0, in_2, lhb_out);
    pc pc1(clk, rst, hold, in_PC, out_PC);
    rf rf1(clk,p0_addr,p1_addr,p0,p1,re0,re1,dst_addr,dst,rf_w,hlt);
    DM dm(clk,dm_addr,dm_read,dm_write,dm_wrt_data,dm_rd_data);

    // Muxes
    // rf_data mux
    always @(*) begin
        case(rf_data_src)
            `RF_DATA_ALU: dst = alu_result;
            `RF_DATA_DM: dst = dm_rd_data;
            `RF_DATA_LHB: dst = lhb_out;
            `RF_DATA_LLB: dst = llb_out;
            default: dst = 16'hxxxx;
        endcase
    end

    // pc_src mux
    always @(*) begin
        case(pc_src)
            `PC_SRC_NOM: in_PC = nxt_PC;
            `PC_SRC_OFF: in_PC = dm_rd_data;
            default: in_PC = 16'hxxx;
        endcase
    end

    // rf_wsrc mux
    always @(*) begin
        case(rf_wsrc)
            `RF_WSRC_INST: dst_addr = instr[11:8];
            `RF_WSRC_SP: dst_addr = 4'd15;
            default: dst_addr = 4'hx;
        endcase
    end

    // rf_rsrc1 mux
    always @(*) begin
        case(rf_rsrc1)
            `RF_RSRC1_SP: p0_addr = 4'd15;
            `RF_RSRC1_RS: p0_addr = instr[7:4];
            `RF_RSRC1_RD: p0_addr = instr[11:8];
            default: p0_addr = 4'hx;
        endcase
    end

    // rf_rsrc2 mux
    always @(*) begin
        case(rf_rsrc2)
            `RF_RSRC2_RT: p1_addr = instr[3:0];
            `RF_RSRC2_DS: p1_addr = 4'd14;
            `RF_RSRC2_R1: p1_addr = 1;
            default: p0_addr = 4'hx;
        endcase
    end

    // alu_src1 mux
    always @(*) begin
        case(alu_src1)
            `ALU_SRC1_P0: alu_a = p0;
            `ALU_SRC1_P1: alu_a = p1;
            default: alu_a = 16'hxxxx;
        endcase
    end

    // alu_src2 mux
    always @(*) begin
        case(alu_src2)
            `ALU_SRC2_P1: alu_b = p1;
            `ALU_SRC2_RT_ZEXT: alu_b = {{12{1'b0}}, {instr[3:0]}};
            `ALU_SRC2_RT_SEXT: alu_b = {{12{instr[3]}}, {instr[3:0]}};
            `ALU_SRC2_IMM_SEXT: alu_b = {{6{instr[7]}}, {instr[7:0]}};
            default: alu_b = 16'hxxxx;
        endcase
    end

    // dm_in mux
    always @(*) begin
        case(dm_in_src)
            `DM_IN_P0: dm_wrt_data = p0;
            `DM_IN_PC: dm_wrt_data = out_PC + 1;
            default: dm_wrt_data = 16'hxxxx;
        endcase
    end

    // dm_addr mux
    always @(*) begin
        case(dm_addr_src)
            `DM_ADDR_ALU: dm_addr = alu_result;
            `DM_ADDR_P0: dm_addr = p0;
            default: dm_addr = 16'hxxxx;
        endcase
    end

endmodule
