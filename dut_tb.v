module all_tb;
    reg clk;
    reg rst;

    All a1(clk,rst);

    initial begin
        clk = 0;
        #50;
        $finish;
    end

    always @(clk) #1 clk <= ~clk;
endmodule
