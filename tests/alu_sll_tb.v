module ALU_16_sll_tb;

    reg[2:0] alu_op;
    reg[15:0] alu_a,alu_b;
    wire z,v,n;
    wire[15:0] alu_out;
    reg fail;

    ALU_16 a1(alu_op,alu_a,alu_b,alu_out,z,v,n);

    initial begin
        fail = 0;
        alu_op = `ALU_SLL;
        test_sll_normal();
        test_sll_zero();
        test_sll_negative();
        $finish;
    end

    task test_sll_normal;
        begin
            alu_a = 16'hAA00;
            alu_b = 16'd4;
            #1;
            if(alu_out !== 16'hA000) begin
                $display("Fail test_sll_normal: Expected 0xA000, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_sll_normal: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_sll_normal: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_sll_normal: Overflow flag");
                fail = 1;
            end
        end
    endtask
    
    task test_sll_zero;
        begin
            alu_a = 16'hFF00;
            alu_b = 16'd8;
            #1;
            if(alu_out !== 16'h0) begin
                $display("Fail test_sll_zero: Expected 0, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_sll_zero: Sign flag");
                fail = 1;
            end
            if(!z) begin
                $display("Fail test_sll_zero: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_sll_zero: Overflow flag");
                fail = 1;
            end
        end
    endtask

    task test_sll_negative;
        begin
            alu_a = 16'hFFFF;
            alu_b = 16'h0;
            #1;
            if(alu_out !== 16'hFFFF) begin
                $display("Fail test_sll_negative: Expected 0xFFFF, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_sll_negative: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_sll_negative: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_sll_negative: Overflow flag");
                fail = 1;
            end
        end
    endtask

endmodule
