module ALU_16_sub_tb;

    reg[2:0] alu_op;
    reg[15:0] alu_a,alu_b;
    wire z,v,n;
    wire[15:0] alu_out;
    reg fail;

    ALU_16 a1(alu_op,alu_a,alu_b,alu_out,z,v,n);

    initial begin
        fail = 0;
        alu_op = `ALU_SUB;
        test_sub_normal();
        test_sub_overflow();
        test_sub_negative();
        test_sub_zero();
        $finish;
    end

    task test_sub_normal;
        begin
            alu_a = 16'h2;
            alu_b = 16'h1;
            #1;
            if(alu_out !== 16'h1) begin
                $display("Fail test_sub_normal: Expected 1, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_sub_normal: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_sub_normal: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_sub_normal: Overflow flag");
                fail = 1;
            end
        end
    endtask

    task test_sub_overflow;
        begin
            alu_a = 16'h8000;
            alu_b = 16'b1;
            #1;
            if(alu_out !== 16'h7fff) begin
                $display("Fail test_sub_overflow: Expected 0x7fff, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_sub_overflow: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_sub_overflow: Zero flag");
                fail = 1;
            end
            if(!v) begin
                $display("Fail test_sub_overflow: Overflow flag");
                fail = 1;
            end
        end
    endtask

    task test_sub_negative;
        begin
            alu_a = 16'd1;
            alu_b = 16'd2;
            #1;
            if(alu_out !== -16'h1) begin
                $display("Fail test_sub_negative: Expected -1, got %h",alu_out);
                fail = 1;
            end
            if(!n) begin
                $display("Fail test_sub_negative: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_sub_negative: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_sub_negative: Overflow flag");
                fail = 1;
            end
        end
    endtask
    
    task test_sub_zero;
        begin
            alu_a = 16'd1;
            alu_b = 16'b1;
            #1;
            if(alu_out !== 16'h0) begin
                $display("Fail test_sub_zero: Expected 0, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_sub_zero: Sign flag");
                fail = 1;
            end
            if(!z) begin
                $display("Fail test_sub_zero: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_sub_zero: Overflow flag");
                fail = 1;
            end
        end
    endtask

endmodule
