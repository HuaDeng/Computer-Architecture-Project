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
        repeat(100) @(posedge clk);
        $finish;
    end

    always @(clk) #1 clk <= ~clk;

    always @(a1.dm_addr,clk, a1.dm_write)
        if (~clk && a1.dm_write && ~a1.dm_read)
            $display("PC%0d: MEM[%h] = %0d",a1.out_PC, a1.dm_addr, a1.dm_wrt_data);

    always @(clk, a1.rf_w, a1.dst_addr, a1.dst)
        if(clk && a1.rf_w && |a1.dst_addr)
            $display("PC%0d: R%0d = %0d", a1.out_PC, a1.dst_addr, a1.dst);

endmodule
