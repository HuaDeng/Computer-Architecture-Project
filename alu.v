/*CS 552 Project ALU units*/
`include "alu_ops.h"

module ALU_16(alu_op, alu_a, alu_b, alu_result, z, v, n);

	input [2:0] alu_op;
	input [15:0] alu_a;
	input [15:0] alu_b;

	output [15:0] alu_result;
	output z, v, n;

	wire [15:0] alu_result;

	assign alu_result = (alu_op == `ALU_ADD)?  alu_a + alu_b:
                        (alu_op == `ALU_SUB)?  alu_a - alu_b:
                        (alu_op == `ALU_NAND)? ~(alu_a & alu_b):
                        (alu_op == `ALU_XOR)?  alu_a ^ alu_b:
                        (alu_op == `ALU_INC)?  alu_a + alu_b:
                        (alu_op == `ALU_SRA)?  {$signed(alu_a) >>> alu_b}:
                        (alu_op == `ALU_SRL)?  alu_a >> alu_b:
                        (alu_op == `ALU_SLL)?  alu_a << alu_b:
                        16'hxxxx;
    //Sign of alu result, only set by ADD or SUB
	assign n = ((alu_op == `ALU_ADD) || (alu_op == `ALU_SUB) || (alu_op == `ALU_INC)) && alu_result[15]; 
	assign z = ~|alu_result; // Zero
	assign v = (alu_op == `ALU_ADD || alu_op == `ALU_INC)?
           (alu_a[15] && alu_b[15] && ~n) | (~alu_a[15] && ~alu_b[15] && n): // Add overflow
       (alu_op == `ALU_SUB)?
           (alu_a[15] && ~alu_b[15] && ~n) | (~alu_a[15] && alu_b[15] && n): // Subtract overflow
           0; //Zero otherwise

endmodule
