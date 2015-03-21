module ALU_16_add_tb;

    reg[2:0] alu_op;
    reg[15:0] alu_a,alu_b;
    wire z,v,n;
    wire[15:0] alu_out;
    reg fail;

    ALU_16 a1(alu_op,alu_a,alu_b,alu_out,z,v,n);

    initial begin
        fail = 0;
        test_add_normal();
        test_add_overflow();
        test_add_negative();
        test_add_zero();
        $finish;
    end

    task test_add_normal;
        begin
            alu_op = 3'b0;
            alu_a = 16'b1;
            alu_b = 16'b1;
            #1;
            if(alu_out !== 16'h2) begin
                $display("Fail test_add_normal: Expected 2, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_add_normal: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_add_normal: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_add_normal: Overflow flag");
                fail = 1;
            end
        end
    endtask

    task test_add_overflow;
        begin
            alu_op = 3'b0;
            alu_a = 16'b0111111111111111;
            alu_b = 16'b1;
            #1;
            if(alu_out !== 16'h8000) begin
                $display("Fail test_add_normal: Expected 0x8000, got %h",alu_out);
                fail = 1;
            end
            if(!n) begin
                $display("Fail test_add_normal: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_add_normal: Zero flag");
                fail = 1;
            end
            if(!v) begin
                $display("Fail test_add_normal: Overflow flag");
                fail = 1;
            end
        end
    endtask

    task test_add_negative;
        begin
            alu_op = 3'b0;
            alu_a = -16'd1;
            alu_b = -16'b1;
            #1;
            if(alu_out !== -16'h2) begin
                $display("Fail test_add_normal: Expected -2, got %h",alu_out);
                fail = 1;
            end
            if(!n) begin
                $display("Fail test_add_normal: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_add_normal: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_add_normal: Overflow flag");
                fail = 1;
            end
        end
    endtask
    
    task test_add_zero;
        begin
            alu_op = 3'b0;
            alu_a = -16'd1;
            alu_b = 16'b1;
            #1;
            if(alu_out !== 16'h0) begin
                $display("Fail test_add_normal: Expected 0, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_add_normal: Sign flag");
                fail = 1;
            end
            if(!z) begin
                $display("Fail test_add_normal: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_add_normal: Overflow flag");
                fail = 1;
            end
        end
    endtask

endmodule
