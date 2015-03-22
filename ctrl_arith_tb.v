`define PC_SRC_NOM 0
`define PC_SRC_OFF 1
`define RF_WSRC_INST 1
`define RF_WSRC_SP 0

module CTRL_arith_tb;

    reg [3:0] Opcode;

    wire pc_src;
    wire rf_wsrc;
    wire [1:0] rf_rsrc1;
    wire [1:0] rf_rsrc2;
    wire rf_w;
    wire alu_src1;
    wire [1:0] alu_src2;
    wire sel_call;
    wire sel_branch;
    wire [2:0] aluop;
    wire dm_in;
    wire dm_addr;
    wire dm_read;
    wire dm_write;
    wire [1:0] rf_data;

    reg fail;

    wiscsc15_ctrl w1(Opcode, pc_src, rf_wsrc, rf_rsrc1, rf_rsrc2, rf_w, alu_src1, alu_src2, sel_call, sel_branch, aluop, dm_in, dm_addr, dm_read, dm_write, rf_data);

    initial begin
        fail = 0;
        test_add_normal();
        $finish;
    end

    task test_add_normal;
        begin
            // ADD R0,R0,R0
            Opcode = {`ALU_ADD, 4'b0000,4'b0000,4'b0000};
            #1;
            if(pc_src !== `PC_SRC_NOM) begin
                $display("Fail test_add_normal: pc_src");
                fail = 1;
            end
            if(rf_wsrc !== `RF_WSRC_INST) begin
                $display("Fail test_add_normal: rf_wsrc");
                fail = 1;
            end
            if(rf_rsrc1 !== 0) begin
                $display("Fail test_add_normal: rf_rsrc1");
                fail = 1;
            end
            if(rf_rsrc2 !== 0) begin
                $display("Fail test_add_normal: rf_rsrc2");
                fail = 1;
            end
            if(rf_w !== 1) begin
                $display("Fail test_add_normal: rf_w");
                fail = 1;
            end
            if(aluop != `ALU_ADD) begin
                $display("Fail test_add_normal: aluop");
                fail = 1;
            end
        end
    endtask

endmodule
