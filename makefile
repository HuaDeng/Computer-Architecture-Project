ALL_TESTS= alu_add_tb\
		   alu_sub_tb\
		   alu_nand_tb\
		   alu_xor_tb\
		   alu_inc_tb\
		   alu_sra_tb\
		   alu_srl_tb\
		   alu_sll_tb\
		   ctrl_arith_tb\
		   flag_rf_tb\
		   WB_tb\
		   MEM_tb\
		   ID_tb\
		   EX_tb

test: $(ALL_TESTS)

alu_%: alu.v tests/alu_%.v
	iverilog $^ -o $@
	./$@

ctrl_%: wiscsc15_ctrl.v alu.v tests/ctrl_%.v 
	iverilog $^ -o $@
	./$@

flag_rf_tb: flag_rf.v tests/flag_rf_tb.v
	iverilog $^ -o $@
	./$@

dut_tb: wiscsc15_ctrl.v tests/dut_tb.v dut.v alu.v data_mem.v instr_mem.v llb_unit.v lhb_unit.v program_counter.v rf_pipelined.v flag_rf.v tests/instr.hex
	iverilog $(filter %.v, $^) -o $@
	ln tests/instr.hex ./
	./$@
	rm instr.hex

WB_tb: tests/WB_tb.v WB.v
	iverilog $^ -o $@
	./$@

MEM_tb: tests/MEM_tb.v MEM.v data_mem.v
	iverilog $^ -o $@
	./$@

ID_tb: tests/ID_tb.v ID.v rf_pipelined.v
	iverilog $^ -o $@
	./$@

EX_tb: tests/EX_tb.v EX.v alu.v
	iverilog $^ -o $@
	./$@

.PHONY: clean
clean:
	rm -f $(ALL_TESTS)
	rm -f variables.dump
