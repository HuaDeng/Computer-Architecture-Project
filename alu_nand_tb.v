module ALU_16_nand_tb;

    reg[2:0] alu_op;
    reg[15:0] alu_a,alu_b;
    wire z,v,n;
    wire[15:0] alu_out;
    reg fail;

    ALU_16 a1(alu_op,alu_a,alu_b,alu_out,z,v,n);

    initial begin
        fail = 0;
        alu_op = `ALU_NAND;
        test_nand_normal();
        test_nand_zero();
        $finish;
    end

    task test_nand_normal;
        begin
            alu_a = 16'b0011;
            alu_b = 16'b0101;
            #1;
            if(alu_out !== 16'hFFFE) begin
                $display("Fail test_nand_normal: Expected 0xFFFE, got %h",alu_out);
                fail = 1;
            end
            if(!n) begin
                $display("Fail test_nand_normal: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_nand_normal: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_nand_normal: Overflow flag");
                fail = 1;
            end
        end
    endtask
    
    task test_nand_zero;
        begin
            alu_a = 16'hFFFF;
            alu_b = 16'hFFFF;
            #1;
            if(alu_out !== 16'h0) begin
                $display("Fail test_nand_zero: Expected 0, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_nand_zero: Sign flag");
                fail = 1;
            end
            if(!z) begin
                $display("Fail test_nand_zero: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_nand_zero: Overflow flag");
                fail = 1;
            end
        end
    endtask

endmodule
