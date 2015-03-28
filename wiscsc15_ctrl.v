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

    always @(Opcode) begin

        // Common outputs
        pc_src = 1'b0;
        rf_wsrc = 1'b1;
        rf_rsrc1 = 2'b00;
        rf_rsrc2 = 2'b00;
        rf_w = 1'b1;
        alu_src1 = 1'b0;
        alu_src2 = 2'b00;
        sel_call = 1'b0;
        sel_branch = 1'b0;
        aluop = Opcode[2:0];
        dm_in = 1'bx;
        dm_addr = 1'bx;
        dm_read = 1'b0;
        dm_write = 1'b0;
        rf_data = 2'b11;

        casez (Opcode)
            `ARITH_INSTR: begin
            end

            `INC_INSTR:   begin
                alu_src2 = 2'b10;
            end

            `SRA_INSTR:   begin
                alu_src2 = 2'b01;
            end

            `SL_INSTR:    begin
                alu_src2 = 2'b01;
            end

            `LW_INSTR:    begin
                rf_rsrc2 = 2'b01;
                alu_src1 = 1'b1;
                alu_src2 = 2'b11;
                dm_addr = 1'b1;
                dm_read = 1'b1;
                rf_data = 2'b00;
            end

            `SW_INSTR:    begin
                rf_wsrc = 1'bx;
                rf_rsrc1 = 2'b01;
                rf_rsrc2 = 2'b01;
                rf_w = 1'b0;
                alu_src1 = 1'b1;
                alu_src2 = 2'b11;
                dm_in = 1'b1;
                dm_addr = 1'b1;
                dm_write = 1'b1;
                rf_data = 2'bxx;
            end

            `LHB_INSTR:   begin
                rf_rsrc1 = 2'b01;
                rf_rsrc2 = 2'bxx;
                alu_src1 = 1'bx;
                alu_src2 = 2'bxx;
                rf_data = 2'b01;
            end

            `LLB_INSTR:   begin
                rf_rsrc1 = 2'b01;
                rf_rsrc2 = 2'bxx;
                alu_src1 = 1'bx;
                alu_src2 = 2'bxx;
                rf_data = 2'b10;
            end

            `BRCH_INSTR:  begin
                rf_w = 1'b0;
                sel_branch = 1'b1;
                aluop = 3'b000;
                dm_in = 1'b0;
                dm_addr = 1'b0;
                rf_data = 2'b00;
            end

            `CALL_INSTR:  begin
                rf_wsrc = 1'b0;
                rf_rsrc1 = 2'b10;
                rf_rsrc2 = 2'b10;
                sel_call = 1'b1;
                aluop = 3'b001;
                dm_in = 1'b0;
                dm_addr = 1'b0;
                dm_write = 1'b1;
            end

            `RET_INSTR:   begin
                pc_src = 1'b1;
                rf_wsrc = 1'b0;
                rf_rsrc1 = 2'b10;
                rf_rsrc2 = 2'b10;
                aluop = 3'b000;
                dm_addr = 1'b1;
                dm_read = 1'b1;
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
