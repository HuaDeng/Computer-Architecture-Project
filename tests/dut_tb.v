module dut_tb;
    reg clk;
    reg rst;

    dut a1(clk,rst);

    initial begin
        $dumpfile("variables.dump");
        $dumpvars;
        rst = 1;
        #1;
        rst = 0;
        clk = 0;
        repeat(100) @(posedge clk);
        $finish;
    end

    always @(clk) #1 clk <= ~clk;

    always @(a1.dm_addr, clk, a1.dm_we)
        if (~clk && a1.dm_we && ~a1.dm_re)
            $display("PC%0d: MEM[%h] = %0d",a1.id_pc, a1.dm_addr, a1.dm_out);

    always @(clk, a1.wb_we, a1.wb_addr, a1.wb_wb)
        if(clk && a1.wb_we && |a1.wb_addr)
            $display("PC%0d: R%0d = %0d", a1.id_pc, a1.wb_addr, a1.wb_wb);

endmodule
