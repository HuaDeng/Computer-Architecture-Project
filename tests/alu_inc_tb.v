module ALU_16_inc_tb;

    reg[2:0] alu_op;
    reg[15:0] alu_a,alu_b;
    wire z,v,n;
    wire[15:0] alu_out;
    reg fail;

    ALU_16 a1(alu_op,alu_a,alu_b,alu_out,z,v,n);

    initial begin
        fail = 0;
        alu_op = `ALU_INC;
        test_inc_normal();
        test_inc_overflow();
        test_inc_negative();
        test_inc_zero();
        $finish;
    end

    task test_inc_normal;
        begin
            alu_a = 16'b1;
            alu_b = 16'b1;
            #1;
            if(alu_out !== 16'h2) begin
                $display("Fail test_inc_normal: Expected 2, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_inc_normal: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_inc_normal: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_inc_normal: Overflow flag");
                fail = 1;
            end
        end
    endtask

    task test_inc_overflow;
        begin
            alu_a = 16'b0111111111111111;
            alu_b = 16'b1;
            #1;
            if(alu_out !== 16'h8000) begin
                $display("Fail test_inc_overflow: Expected 0x8000, got %h",alu_out);
                fail = 1;
            end
            if(!n) begin
                $display("Fail test_inc_overflow: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_inc_overflow: Zero flag");
                fail = 1;
            end
            if(!v) begin
                $display("Fail test_inc_overflow: Overflow flag");
                fail = 1;
            end
        end
    endtask

    task test_inc_negative;
        begin
            alu_a = -16'd1;
            alu_b = -16'b1;
            #1;
            if(alu_out !== -16'h2) begin
                $display("Fail test_inc_negative: Expected -2, got %h",alu_out);
                fail = 1;
            end
            if(!n) begin
                $display("Fail test_inc_negative: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_inc_negative: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_inc_negative: Overflow flag");
                fail = 1;
            end
        end
    endtask
    
    task test_inc_zero;
        begin
            alu_a = -16'd1;
            alu_b = 16'b1;
            #1;
            if(alu_out !== 16'h0) begin
                $display("Fail test_inc_zero: Expected 0, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_inc_zero: Sign flag");
                fail = 1;
            end
            if(!z) begin
                $display("Fail test_inc_zero: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_inc_zero: Overflow flag");
                fail = 1;
            end
        end
    endtask

endmodule
