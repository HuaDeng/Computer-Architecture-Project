module flag_rf_tb;
    reg clk;
    reg [3:0] cond;
    reg z, v, n;
    wire out;

    reg fail;

    flag_rf rf_flag(clk,cond,z,v,n,out);

    initial begin
        fail = 0;
        clk = 0;
        flag_rf_equal();
        flag_rf_less();
        $finish;
    end
    
    task flag_rf_equal;
        begin
            z = 1;
            v = 0;
            n = 0;
            cond = `EQUAL;
            #1;
            clk = 1;
            #1;
            if(out !== 1'b1) begin
                $display("Fail flag_rf_equal: expected 1, got %b",out);
                fail = 1;
            end
            z = 0;
            clk = 0;
            #1;
            clk = 1;
            #1;
            if(out !== 0) begin
                $display("Fail flag_rf_equal: expected 0, got %b",out);
                fail = 1;
            end
            clk = 0;
            #1;
        end
    endtask

    task flag_rf_less;
        begin
            z = 0;
            v = 0;
            n = 1;
            cond = `LESS;
            #1;
            clk = 1;
            #1;
            if(out !== 1'b1) begin
                $display("Fail flag_rf_less: expected 1, got %b",out);
                fail = 1;
            end
            n = 0;
            clk = 0;
            #1;
            clk = 1;
            #1;
            if(out !== 0) begin
                $display("Fail flag_rf_less: expected 0, got %b",out);
                fail = 1;
            end
            v = 1;
            n = 1;
            clk = 0;
            #1;
            clk = 1;
            #1;
            if(out !== 0) begin
                $display("Fail flag_rf_less: expected 0, got %b",out);
                fail = 1;
            end
            clk = 0;
            #1;
        end
    endtask

    task flag_rf_greater;
        begin
            z = 0;
            v = 0;
            n = 0;
            cond = `GREATER;
            #1;
            clk = 1;
            #1;
            if(out !== 1'b1) begin
                $display("Fail flag_rf_greater: expected 1, got %b",out);
                fail = 1;
            end
            n = 1;
            clk = 0;
            #1;
            clk = 1;
            #1;
            if(out !== 0) begin
                $display("Fail flag_rf_greater: expected 0, got %b",out);
                fail = 1;
            end
            n = 0;
            v = 1;
            clk = 0;
            #1;
            clk = 1;
            #1;
            if(out !== 0) begin
                $display("Fail flag_rf_greater: expected 0, got %b",out);
                fail = 1;
            end
            clk = 0;
            #1;
        end
    endtask

    task flag_rf_greater_or_equal;
        begin
            z = 0;
            v = 0;
            n = 0;
            cond = `GREATER_OR_EQUAL;
            #1;
            clk = 1;
            #1;
            if(out !== 1'b1) begin
                $display("Fail flag_rf_greater: expected 1, got %b",out);
                fail = 1;
            end
            n = 1;
            clk = 0;
            #1;
            clk = 1;
            #1;
            if(out !== 0) begin
                $display("Fail flag_rf_greater: expected 0, got %b",out);
                fail = 1;
            end
            n = 0;
            v = 1;
            clk = 0;
            #1;
            clk = 1;
            #1;
            if(out !== 0) begin
                $display("Fail flag_rf_greater: expected 0, got %b",out);
                fail = 1;
            end
            clk = 0;
            #1;
            n = 0;
            v = 0;
            z = 1;
            clk = 0;
            #1;
            clk = 1;
            #1;
            if(out !== 1) begin
                $display("Fail flag_rf_greater: expected 1, got %b",out);
                fail = 1;
            end
            clk = 0;
            #1;
        end
    endtask

endmodule
