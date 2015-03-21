/*CS 552 Project ALU units*/
`define ALU_ADD 3'b000
`define ALU_SUB 3'b001
`define ALU_NAND 3'b010
`define ALU_XOR 3'b011
`define ALU_INC 3'b100
`define ALU_SRA 3'b101
`define ALU_SRL 3'b110
`define ALU_SLL 3'b111

module ALU_16(alu_op, alu_a, alu_b, alu_result, z, v, n);

	input [2:0] alu_op;
	input [15:0] alu_a;
	input [15:0] alu_b;

	output [15:0] alu_result;
	output z, v, n;

	wire [15:0] alu_result;
	wire [15:0] alu_xb;


	assign alu_xb = (alu_op == `ALU_SUB) ? (~alu_b + 1'b1) : alu_b; // a - b = a + (-b)

	assign alu_result = (alu_op == `ALU_ADD || alu_op == `ALU_SUB)? alu_a + alu_xb:
											(alu_op == `ALU_NAND) ? ~(alu_a | alu_b):
											(alu_op == `ALU_XOR) ? alu_a ^ alu_b:
											(alu_op == `ALU_INC) ? alu_a + alu_b:
											(alu_op == `ALU_SRA) ? ($signed (alu_a) >>> alu_b):
											(alu_op == `ALU_SRL) ? alu_a >> alu_b:
											(alu_op == `ALU_SLL) ? alu_a << alu_b:
											16'hxxxx;

	assign n = alu_result[15]; //Sign of alu result
	assign z = ~|alu_result; // Zero
	assign v = (alu_a[15] && alu_xb[15] && ~n) | (~alu_a[15] && ~alu_xb[15] && n); //overflow

endmodule
