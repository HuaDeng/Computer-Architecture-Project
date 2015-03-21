alu_add_tb: alu.v alu_add_tb.v
	iverilog $^ -o $@

alu_sub_tb: alu.v alu_sub_tb.v
	iverilog $^ -o $@

run_%: %
	./$*

test: run_alu_add_tb run_alu_sub_tb
