/*CS 552 Project FLAG register unit*/
`define EQUAL 4'bz000
`define LESS 4'bz001
`define GREATER 4'bz010
`define OVERFLOW 4'bz011
`define NOT_EQUAL 4'bz100
`define GREATER_OR_EQUAL 4'bz101
`define LESS_OR_EQUAL 4'bz110
`define TRUE 4'bz111

module flag_rf(clk, cond, z, v, n, out);
    input clk;
    input [3:0] cond;
    input z, v, n;

    output reg out;

    reg [2:0] zvn; 


    always @(posedge clk) begin
        zvn[0] <= n;
        zvn[1] <= v;
        zvn[2] <= z;
    end
    
    always @(*) begin
        casez(cond)
            `EQUAL: begin
                out <= (zvn[2] == 1'b1)? 1'b1 : 1'b0;
            end
            `LESS: begin
                out <= (zvn[1] == 1'b0 && zvn[0] == 1)? 1'b1 : 1'b0;
            end
            `GREATER: begin
                out <= (zvn == 3'b000)? 1'b1 : 1'b0;
            end
            `OVERFLOW: begin
                out <= (zvn[1] == 1'b1)? 1'b1 : 1'b0;
            end
            `NOT_EQUAL: begin
                out <= (zvn[2] == 1'b0)? 1'b1 : 1'b0;
            end
            `GREATER_OR_EQUAL: begin
                out <= (zvn[1] == 1'b1 || zvn[0] == 1'b0)? 1'b1 : 1'b0;
            end
            `LESS_OR_EQUAL: begin
                out <= ((zvn[0] == 1'b1 && zvn[1] == 1'b0) || zvn[2] == 1'b1)? 1'b1 : 1'b0;
            end
            `TRUE: begin
                out <= 1'b1;
            end
        endcase
    end
endmodule 
