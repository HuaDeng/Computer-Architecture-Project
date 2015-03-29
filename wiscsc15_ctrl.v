/*CS 552 Project WISC-SC15 control unit*/

//instruction: add, sub, nand, xor
`define ARITH_INSTR 4'b00??

//instruction: inc
`define INC_INSTR 4'B0100

 //instruction: sra
`define SRA_INSTR 4'B0101

//instruction: srl and sll
`define SL_INSTR 4'B011?

//instruction: lw
`define LW_INSTR 4'B1000

//instruction: sw
`define SW_INSTR 4'B1001

//instruction: lhb
`define LHB_INSTR 4'B1010

//instruction: llb
`define LLB_INSTR 4'B1011

//instruction: b
`define BRCH_INSTR 4'b1100

//instruction:call
`define CALL_INSTR 4'b1101

//instruction; return
`define RET_INSTR 4'B1110

`define PC_SRC_NOM 0
`define PC_SRC_OFF 1

`define RF_WSRC_INST 1
`define RF_WSRC_SP 0

`define RF_RSRC1_RS 2'b00
`define RF_RSRC1_SP 2'b10
`define RF_RSRC1_RD 2'b01

`define RF_RSRC2_RT 2'b00
`define RF_RSRC2_DS 2'b01
`define RF_RSRC2_R1 2'b10

`define RF_W_YES 1'b1
`define RF_W_NO 1'b0

`define ALU_SRC1_P0 1'b0
`define ALU_SRC1_P1 1'b1

`define ALU_SRC2_P1 2'b00
`define ALU_SRC2_RT_ZEXT 2'b01
`define ALU_SRC2_RT_SEXT 2'b10
`define ALU_SRC2_IMM_SEXT 2'b11

`define SEL_CALL_NO 1'b0
`define SEL_CALL_YES 1'b1

`define BRANCH_CALL_NO 1'b0
`define BRANCH_CALL_YES 1'b1

`define DM_IN_P0 1'b1
`define DM_IN_PC 1'b0

`define DM_ADDR_ALU 1'b1
`define DM_ADDR_P0 1'b0

`define DM_READ_NO 1'b0
`define DM_READ_YES 1'b1

`define DM_WRITE_NO 1'b0
`define DM_WRITE_YES 1'b1

`define RF_DATA_ALU 2'b11
`define RF_DATA_DM 2'b00
`define RF_DATA_LHB 2'b01
`define RF_DATA_LLB 2'b10

module wiscsc15_ctrl(Opcode, pc_src, rf_wsrc, rf_rsrc1, rf_rsrc2, rf_w, alu_src1, alu_src2, sel_call, sel_branch, aluop, dm_in, dm_addr, dm_read, dm_write, rf_data);

    input [3:0] Opcode;

    output reg pc_src;
    output reg rf_wsrc;
    output reg [1:0] rf_rsrc1;
    output reg [1:0] rf_rsrc2;
    output reg rf_w;
    output reg alu_src1;
    output reg [1:0] alu_src2;
    output reg sel_call;
    output reg sel_branch;
    output reg [2:0] aluop;
    output reg dm_in;
    output reg dm_addr;
    output reg dm_read;
    output reg dm_write;
    output reg [1:0] rf_data;

    always @(*) begin

        // Common outputs
        pc_src = `PC_SRC_NOM;
        rf_wsrc = `RF_WSRC_INST;
        rf_rsrc1 = `RF_RSRC1_RS;
        rf_rsrc2 = `RF_RSRC2_RT;
        rf_w = `RF_W_YES;
        alu_src1 = `ALU_SRC1_P0;
        alu_src2 = `ALU_SRC2_P1;
        sel_call = `SEL_CALL_NO;
        sel_branch = `BRANCH_CALL_NO;
        aluop = Opcode[2:0];
        dm_in = 1'bx;
        dm_addr = 1'bx;
        dm_read = `DM_READ_NO;
        dm_write = `DM_WRITE_NO;
        rf_data = `RF_DATA_ALU;

        casez (Opcode)
            `ARITH_INSTR: begin
            end

            `INC_INSTR:   begin
                alu_src2 = `ALU_SRC2_RT_SEXT;
            end

            `SRA_INSTR:   begin
                alu_src2 = `ALU_SRC2_RT_ZEXT;
            end

            `SL_INSTR:    begin
                alu_src2 = `ALU_SRC2_RT_ZEXT;
            end

            `LW_INSTR:    begin
                rf_rsrc2 = `RF_RSRC2_DS;
                alu_src1 = `ALU_SRC1_P1;
                alu_src2 = `ALU_SRC2_IMM_SEXT;
                dm_addr = `DM_ADDR_ALU;
                dm_read = `DM_READ_YES;
                rf_data = `RF_DATA_DM;
            end

            `SW_INSTR:    begin
                rf_wsrc = 1'bx;
                rf_rsrc1 = `RF_RSRC1_RD;
                rf_rsrc2 = `RF_RSRC2_DS;
                rf_w = `RF_W_NO;
                alu_src1 = `ALU_SRC1_P1;
                alu_src2 = `ALU_SRC2_IMM_SEXT;
                dm_in = `DM_IN_P0;
                dm_addr = `DM_ADDR_ALU;
                dm_write = `DM_WRITE_YES;
                rf_data = 2'bxx;
                aluop = 3'b000;
            end

            `LHB_INSTR:   begin
                rf_rsrc1 = `RF_RSRC1_RD;
                rf_rsrc2 = 2'bxx;
                alu_src1 = 1'bx;
                alu_src2 = 2'bxx;
                rf_data = `RF_DATA_LHB;
            end

            `LLB_INSTR:   begin
                rf_rsrc1 = `RF_RSRC1_RD;
                rf_rsrc2 = 2'bxx;
                alu_src1 = 1'bx;
                alu_src2 = 2'bxx;
                rf_data = `RF_DATA_LLB;
            end

            `BRCH_INSTR:  begin
                rf_w = 1'b0;
                sel_branch = `BRANCH_CALL_YES;
                aluop = 3'b000;
                dm_in = `DM_IN_PC;
                dm_addr = `DM_ADDR_P0;
                rf_data = `RF_DATA_ALU;
            end

            `CALL_INSTR:  begin
                rf_wsrc = `RF_WSRC_SP;
                rf_rsrc1 = `RF_RSRC1_SP;
                rf_rsrc2 = `RF_RSRC2_R1;
                sel_call = `SEL_CALL_YES;
                aluop = 3'b001;
                dm_in = `DM_IN_PC;
                dm_addr = `DM_ADDR_P0;
                dm_write = `DM_WRITE_YES;
            end

            `RET_INSTR:   begin
                pc_src = `PC_SRC_OFF;
                rf_wsrc = `RF_WSRC_SP;
                rf_rsrc1 = `RF_RSRC1_SP;
                rf_rsrc2 = `RF_RSRC2_R1;
                aluop = 3'b000;
                dm_addr = `DM_ADDR_ALU;
                dm_read = `DM_READ_YES;
            end
            default: begin
                pc_src = 1'bx;
                rf_wsrc = 1'bx;
                rf_rsrc1 = 2'bxx;
                rf_rsrc2 = 2'bxx;
                rf_w = 1'bx;
                alu_src1 = 1'bx;
                alu_src2 = 2'bxx;
                sel_call = 1'bx;
                sel_branch = 1'bx;
                aluop = 3'bxxx;
                dm_in = 1'bx;
                dm_addr = 1'bx;
                dm_read = 1'bx;
                dm_write = 1'bx;
                rf_data = 2'bxx;
            end
        endcase
    end
endmodule 
