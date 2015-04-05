module dut_tb;
    reg clk;
    reg rst;

    dut a1(clk,rst);

    initial begin
        $dumpfile("variables.dump");
        $dumpvars;
        rst = 1;
        a1.dm.dump = 0;
        clk = 0;
        #1;
        rst = 0;
        while(a1.mem_instr != 16'hF000) begin
            @(posedge clk);
        end
        a1.dm.dump = 1;
        @(posedge clk);
        $finish;
    end

    initial begin
        repeat(1000) @(posedge clk);
        a1.dm.dump = 1;
        $display("Timeout");
        #1;
        $finish;
    end

    always @(clk) #1 clk <= ~clk;

endmodule
