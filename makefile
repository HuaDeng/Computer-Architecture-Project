ALL_TESTS= alu_add_tb\
		   alu_sub_tb\
		   alu_nand_tb\
		   alu_xor_tb\
		   alu_inc_tb\
		   alu_sra_tb\
		   alu_srl_tb\
		   alu_sll_tb\
		   ctrl_arith_tb\
		   flag_rf_tb

alu_%: alu.v alu_%.v
	iverilog $^ -o $@
	./$@

ctrl_%: wiscsc15_ctrl.v alu.v ctrl_%.v 
	iverilog $^ -o $@
	./$@

flag_rf_tb: flag_rf.v flag_rf_tb.v
	iverilog $^ -o $@
	./$@

.PHONY: clean
clean:
	rm -f $(ALL_TESTS)

test: $(ALL_TESTS)
