`include "opcode.h"
module hazard_detection_tb;
    wire hazard;
    reg[15:0] if_instr, id_instr, ex_instr, mem_instr;
    
    hazard_detection h1(hazard, if_instr, id_instr, ex_instr, mem_instr);

    initial begin
        mem_instr = 0;
        test1();
        test2();
        test3();
        test4();
        test5();
        test6();
        test7();
        test8();
    end

    task test1;
        begin
            if_instr = {`ADD, 12'h0};
            id_instr = {`ADD, 12'h0};
            ex_instr = {`ADD, 12'h0};
            #1;
            if(hazard !== 0)
                $display("Fail test1 hazard: %h",hazard);
        end
    endtask

    task test2;
        begin
            if_instr = {`ADD, 4'h4, 4'h4, 4'h0};
            id_instr = {`ADD, 12'h0};
            ex_instr = {`ADD, 4'h4, 4'h4, 4'h0};
            #1;
            if(hazard !== 1)
                $display("Fail test2 hazard: %h",hazard);
        end
    endtask

    task test3;
        begin
            if_instr = {`ADD, 4'h4, 4'h4, 4'h0};
            id_instr = {`ADD, 4'h4, 4'h4, 4'h0};
            ex_instr = {`ADD, 12'h0};
            #1;
            if(hazard !== 1)
                $display("Fail test3 hazard: %h",hazard);
        end
    endtask

    task test4;
        begin
            ex_instr = {`ADD, 4'h4, 4'h4, 4'h0};
            id_instr = {`ADD, 12'h0};
            if_instr = {`SW, 4'h5, 8'h00};
            #1;
            if(hazard !== 0)
                $display("Fail test4 hazard: %h",hazard);
        end
    endtask

    task test5;
        begin
            ex_instr = {`ADD, 4'h4, 4'h4, 4'h0};
            id_instr = {`ADD, 12'h0};
            if_instr = {`SW, 4'h4, 8'h00};
            #1;
            if(hazard !== 1)
                $display("Fail test5 hazard: %h",hazard);
        end
    endtask

    task test6;
        begin
            ex_instr = {`ADD, 4'd14, 4'h4, 4'h0};
            id_instr = {`ADD, 12'h0};
            if_instr = {`SW, 4'h5, 8'h00};
            #1;
            if(hazard !== 1) begin
                $display("Fail test6 hazard: %h",hazard);
                $display("test6 if_uses_read1: %h",h1.if_uses_read1);
            end
        end
    endtask

    task test7;
        begin
            ex_instr = {`LW, 4'd14, 8'h40};
            id_instr = {`ADD, 12'h0};
            if_instr = {`SW, 4'h5, 8'h00};
            #1;
            if(hazard !== 1)
                $display("Fail test7 hazard: %h",hazard);
        end
    endtask

    task test8;
        begin
            mem_instr = {`RET, 12'hx};
            ex_instr = 0;
            id_instr = 0;
            if_instr = 0;
            #1;
            if(hazard !== 1)
                $display("Fail test8 hazard: %h",hazard);
        end
    endtask

endmodule
