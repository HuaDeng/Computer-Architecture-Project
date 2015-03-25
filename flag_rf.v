/*CS 552 Project FLAG register unit*/
`define EQUAL 4'bz000
`define LESS 4'bz001
`define GREATER 4'bz010
`define OVERFLOW 4'bz011
`define NOT_EQUAL 4'bz100
`define GREATER_OR_EQUAL 4'bz101
`define LESS_OR_EQUAL 4'bz110
`define TRUE 4'bz111

`define ZVN_NEGATIVE 0
`define ZVN_OVERFLOW 1
`define ZVN_ZERO 2

module flag_rf(clk, cond, z, v, n, out);
    input clk;
    input [3:0] cond;
    input z, v, n;

    output reg out;

    reg [2:0] zvn; 

    always @(posedge clk) begin
        zvn[`ZVN_NEGATIVE] <= n;
        zvn[`ZVN_OVERFLOW] <= v;
        zvn[`ZVN_ZERO] <= z;
    end
    
    always @(*) begin
        casez(cond)
            `EQUAL: begin
                out <= zvn[`ZVN_ZERO];
            end
            `LESS: begin
                out <= (~zvn[`ZVN_OVERFLOW]) && zvn[`ZVN_NEGATIVE];
            end
            `GREATER: begin
                out <= zvn == 3'b000;
            end
            `OVERFLOW: begin
                out <= zvn[`ZVN_OVERFLOW];
            end
            `NOT_EQUAL: begin
                out <= ~zvn[`ZVN_ZERO];
            end
            `GREATER_OR_EQUAL: begin
                out <= zvn[`ZVN_OVERFLOW] || (~zvn[`ZVN_NEGATIVE]);
            end
            `LESS_OR_EQUAL: begin
                out <= (zvn[`ZVN_NEGATIVE] && (~zvn[`ZVN_OVERFLOW])) || zvn[`ZVN_ZERO];
            end
            `TRUE: begin
                out <= 1'b1;
            end
        endcase
    end
endmodule 
