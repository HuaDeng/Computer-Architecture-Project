module ALU_16_srl_tb;

    reg[2:0] alu_op;
    reg[15:0] alu_a,alu_b;
    wire z,v,n;
    wire[15:0] alu_out;
    reg fail;

    ALU_16 a1(alu_op,alu_a,alu_b,alu_out,z,v,n);

    initial begin
        fail = 0;
        alu_op = `ALU_SRL;
        test_srl_normal();
        test_srl_zero();
        test_srl_negative();
        $finish;
    end

    task test_srl_normal;
        begin
            alu_a = 16'hAA00;
            alu_b = 16'd4;
            #1;
            if(alu_out !== 16'h0AA0) begin
                $display("Fail test_srl_normal: Expected 0x0AA0, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_srl_normal: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_srl_normal: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_srl_normal: Overflow flag");
                fail = 1;
            end
        end
    endtask
    
    task test_srl_zero;
        begin
            alu_a = 16'h00FF;
            alu_b = 16'd8;
            #1;
            if(alu_out !== 16'h0) begin
                $display("Fail test_srl_zero: Expected 0, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_srl_zero: Sign flag");
                fail = 1;
            end
            if(!z) begin
                $display("Fail test_srl_zero: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_srl_zero: Overflow flag");
                fail = 1;
            end
        end
    endtask

    task test_srl_negative;
        begin
            alu_a = 16'hFFFF;
            alu_b = 16'h0;
            #1;
            if(alu_out !== 16'hFFFF) begin
                $display("Fail test_srl_negative: Expected 0xFFFF, got %h",alu_out);
                fail = 1;
            end
            if(n) begin
                $display("Fail test_srl_negative: Sign flag");
                fail = 1;
            end
            if(z) begin
                $display("Fail test_srl_negative: Zero flag");
                fail = 1;
            end
            if(v) begin
                $display("Fail test_srl_negative: Overflow flag");
                fail = 1;
            end
        end
    endtask

endmodule
