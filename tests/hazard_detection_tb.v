`include "opcode.h"
module hazard_detection_tb;
    wire data_hazard, control_hazard;
    reg[15:0] id_instr, ex_instr, mem_instr;
    
    hazard_detection h1(data_hazard, control_hazard, id_instr, ex_instr, mem_instr);

    initial begin
        test1();
        test2();
        test3();
        test4();
        test5();
        test6();
        test7();
        test8();
        test9();
        test10();
        test11();
        test12();
        test13();
        test14();
    end

    task test1;
        begin
            mem_instr = {`ADD, 12'h0};
            ex_instr = {`ADD, 12'h0};
            id_instr = {`ADD, 12'h0};
            #1;
            if(data_hazard !== 0)
                $display("Fail test1 data_hazard: %h",data_hazard);
            if(control_hazard !== 0)
                $display("Fail test1 control_hazard: %h",control_hazard);
        end
    endtask

    task test2;
        begin
            mem_instr = {`ADD, 4'h4, 4'h4, 4'h0};
            ex_instr = {`ADD, 12'h0};
            id_instr = {`ADD, 4'h4, 4'h4, 4'h0};
            #1;
            if(data_hazard !== 1)
                $display("Fail test2 data_hazard: %h",data_hazard);
            if(control_hazard !== 0)
                $display("Fail test2 control_hazard: %h",control_hazard);
        end
    endtask

    task test3;
        begin
            mem_instr = {`ADD, 12'h0};
            ex_instr = {`ADD, 4'h4, 4'h4, 4'h0};
            id_instr = {`ADD, 4'h4, 4'h4, 4'h0};
            #1;
            if(data_hazard !== 1)
                $display("Fail test3 data_hazard: %h",data_hazard);
            if(control_hazard !== 0)
                $display("Fail test3 control_hazard: %h",control_hazard);
        end
    endtask

    task test4;
        begin
            mem_instr = {`ADD, 4'h4, 4'h4, 4'h0};
            ex_instr = {`ADD, 12'h0};
            id_instr = {`SW, 4'h5, 8'h00};
            #1;
            if(data_hazard !== 0)
                $display("Fail test4 data_hazard: %h",data_hazard);
            if(control_hazard !== 0)
                $display("Fail test4 control_hazard: %h",control_hazard);
        end
    endtask

    task test5;
        begin
            mem_instr = {`ADD, 4'h4, 4'h4, 4'h0};
            ex_instr = {`ADD, 12'h0};
            id_instr = {`SW, 4'h4, 8'h00};
            #1;
            if(data_hazard !== 1)
                $display("Fail test5 data_hazard: %h",data_hazard);
            if(control_hazard !== 0)
                $display("Fail test5 control_hazard: %h",control_hazard);
        end
    endtask

    task test6;
        begin
            mem_instr = {`ADD, 4'd14, 4'h4, 4'h0};
            ex_instr = {`ADD, 12'h0};
            id_instr = {`SW, 4'h5, 8'h00};
            #1;
            if(data_hazard !== 1)
                $display("Fail test6 data_hazard: %h",data_hazard);
            if(control_hazard !== 0)
                $display("Fail test6 control_hazard: %h",control_hazard);
        end
    endtask

    task test7;
        begin
            mem_instr = {`LW, 4'd14, 8'h40};
            ex_instr = {`ADD, 12'h0};
            id_instr = {`SW, 4'h5, 8'h00};
            #1;
            if(data_hazard !== 1)
                $display("Fail test7 data_hazard: %h",data_hazard);
            if(control_hazard !== 0)
                $display("Fail test7 control_hazard: %h",data_hazard);
        end
    endtask

    task test8;
        begin
            mem_instr = {`RET, 12'hx};
            ex_instr = 0;
            id_instr = 0;
            #1;
            if(data_hazard !== 0)
                $display("Fail test8 data_hazard: %h",data_hazard);
            if(control_hazard !== 1)
                $display("Fail test8 control_hazard: %h",control_hazard);
        end
    endtask

    task test9;
        begin
            mem_instr = 0;
            ex_instr = 0;
            id_instr = {`CALL, 12'hx};
            #1;
            if(data_hazard !== 0)
                $display("Fail test9 data_hazard: %h",data_hazard);
            if(control_hazard !== 1)
                $display("Fail test9 control_hazard: %h",control_hazard);
        end
    endtask

    task test10;
        begin
            mem_instr = 0;
            ex_instr = {`CALL, 12'hx};
            id_instr = 0;
            #1;
            if(data_hazard !== 0)
                $display("Fail test10 data_hazard: %h",data_hazard);
            if(control_hazard !== 1)
                $display("Fail test10 control_hazard: %h",control_hazard);
        end
    endtask

    task test11;
        begin
            mem_instr = {`CALL, 12'hx};
            ex_instr = 0;
            id_instr = 0;
            #1;
            if(data_hazard !== 0)
                $display("Fail test11 data_hazard: %h",data_hazard);
            if(control_hazard !== 0)
                $display("Fail test11 control_hazard: %h",control_hazard);
        end
    endtask

    task test12;
        begin
            mem_instr = 0;
            ex_instr = 0;
            id_instr = {`RET, 12'hx};
            #1;
            if(data_hazard !== 0)
                $display("Fail test12 data_hazard: %h",data_hazard);
            if(control_hazard !== 1)
                $display("Fail test12 control_hazard: %h",control_hazard);
        end
    endtask

    task test13;
        begin
            mem_instr = 0;
            ex_instr = {`RET, 12'hx};
            id_instr = 0;
            #1;
            if(data_hazard !== 0)
                $display("Fail test13 data_hazard: %h",data_hazard);
            if(control_hazard !== 1)
                $display("Fail test13 control_hazard: %h",control_hazard);
        end
    endtask

    task test14;
        begin
            mem_instr = {`RET, 12'hx};
            ex_instr = 0;
            id_instr = 0;
            #1;
            if(data_hazard !== 0)
                $display("Fail test14 data_hazard: %h",data_hazard);
            if(control_hazard !== 1)
                $display("Fail test14 control_hazard: %h",control_hazard);
        end
    endtask

endmodule
