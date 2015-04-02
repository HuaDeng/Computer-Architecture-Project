/*CS 552 Project FLAG register unit*/
`define EQUAL 4'bz000
`include "cond_code.h"
module flag_rf(clk, cond, nxt_z, nxt_v, nxt_n, out);
    input clk;
    input [3:0] cond;
    input nxt_z, nxt_v, nxt_n;

    output reg out;

    reg z, v, n; 

    always @(posedge clk) begin
        n <= nxt_n;
        v <= nxt_v;
        z <= nxt_z;
    end
    
    always @(*) begin
        casez(cond)
            `EQUAL: begin
                out <= z;
            end
            `LESS: begin
                out <= (~v) && n;
            end
            `GREATER: begin
                out <= ~z && ~n && ~v;
            end
            `OVERFLOW: begin
                out <= v;
            end
            `NOT_EQUAL: begin
                out <= ~z;
            end
            `GREATER_OR_EQUAL: begin
                out <= ~v && ~n;
            end
            `LESS_OR_EQUAL: begin
                out <= (n && ~v) || z;
            end
            `TRUE: begin
                out <= 1'b1;
            end
        endcase
    end
endmodule 
