module ALU_16_xor_tb;

    reg[2:0] alu_op;
    reg[15:0] alu_a,alu_b;
    wire z,v,n;
    wire[15:0] alu_out;
    reg fail;

    ALU_16 a1(alu_op,alu_a,alu_b,alu_out,z,v,n);

    initial begin
        fail = 0;
        alu_op = `ALU_XOR;
        test_xor_normal();
        test_xor_zero();
        test_xor_negative();
        $finish;
    end

    task test_xor_normal;
        begin
            alu_a = 16'b0011;
            alu_b = 16'b0101;
            #1;
            if(alu_out !== 16'b0110) begin
                $display("Fail test_xor_normal: Expected 0b0110, got %b",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_xor_normal: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_xor_normal: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_xor_normal: Overflow flag");
                fail = 1;
            end
        end
    endtask
    
    task test_xor_zero;
        begin
            alu_a = 16'hFFFF;
            alu_b = 16'hFFFF;
            #1;
            if(alu_out !== 16'h0) begin
                $display("Fail test_xor_zero: Expected 0, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_xor_zero: Sign flag");
                fail = 1;
            end
            if(!z) begin
                $display("Fail test_xor_zero: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_xor_zero: Overflow flag");
                fail = 1;
            end
        end
    endtask

    task test_xor_negative;
        begin
            alu_a = 16'hFFFF;
            alu_b = 16'h0;
            #1;
            if(alu_out !== 16'hFFFF) begin
                $display("Fail test_xor_negative: Expected 0xFFFF, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_xor_negative: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_xor_negative: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_xor_negative: Overflow flag");
                fail = 1;
            end
        end
    endtask

endmodule
