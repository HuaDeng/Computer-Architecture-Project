module dut_tb;
    reg clk;
    reg rst;

    DUT a1(clk,rst);

    initial begin
        $dumpfile("variables.dump");
        $dumpvars;
        rst = 1;
        #1;
        rst = 0;
        clk = 0;
        repeat(7) @(posedge clk);
        $finish;
    end

    always @(clk) #1 clk <= ~clk;

endmodule
