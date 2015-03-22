ALL_TESTS= run_alu_add_tb\
		   run_alu_sub_tb\
		   run_alu_nand_tb\
		   run_alu_xor_tb\
		   run_alu_inc_tb\
		   run_alu_sra_tb\
		   run_alu_srl_tb\
		   run_alu_sll_tb\
		   run_ctrl_arith_tb

alu_%_tb: alu.v alu_%.v
	iverilog $^ -o $@

run_%: %
	./$*

test: $(ALL_TESTS)
