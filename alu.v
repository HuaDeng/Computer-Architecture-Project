/*CS 552 Project ALU units*/

module ALU_16(alu_op, alu_a, alu_b, alu_result, z, v, n);

	input [2:0] alu_op;
	input [15:0] alu_a;
	input [15:0] alu_b;

	output [15:0] alu_result;
	output z, v, n;

	wire [15:0] alu_result;
	wire [15:0] alu_xb;

	parameter alu_add = 3'b000;
	parameter alu_sub = 3'b001;
	parameter alu_nand = 3'b010;
	parameter alu_xor = 3'b011;
	parameter alu_inc = 3'b100;
	parameter alu_sra = 3'b101;
	parameter alu_srl = 3'b110;
	parameter alu_sll = 3'b111;

	assign alu_xb = (alu_op == alu_sub) ? (~alu_b + 1'b1) : alu_b; // a - b = a + (-b)

	assign alu_result = (alu_op == alu_add || alu_op == alu_sub)? alu_a + alu_xb:
											(alu_op == alu_nand) ? ~(alu_a | alu_b):
											(alu_op == alu_xor) ? alu_a ^ alu_b:
											(alu_op == alu_inc) ? alu_a + alu_b:
											(alu_op == alu_sra) ? ($signed (alu_a) >>> alu_b):
											(alu_op == alu_srl) ? alu_a >> alu_b:
											(alu_op == alu_sll) ? alu_a << alu_b:
											16'hxxxx;

	assign n = alu_result[15]; //Sign of alu result
	assign z = ~|alu_result; // Zero
	assign v = (alu_a[15] && alu_xb[15] && ~n) | (~alu_a[15] && ~alu_xb[15] && n); //overflow

endmodule
