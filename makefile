ALL_TESTS= alu_add_tb\
		   alu_sub_tb\
		   alu_nand_tb\
		   alu_xor_tb\
		   alu_inc_tb\
		   alu_sra_tb\
		   alu_srl_tb\
		   alu_sll_tb\
		   flag_rf_tb\
		   WB_tb\
		   MEM_tb\
		   ID_tb\
		   EX_tb\
		   jump_tb\
		   hazard_detection_tb\
		   dut_tb

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

jump_tb: tests/jump_tb.v jump.v
	iverilog $^ -o $@
	./$@

hazard_detection_tb:tests/hazard_detection_tb.v hazard_detection.v 
	iverilog $^ -o $@
	./$@

dut_tb: tests/dut_tb.v program_counter.v instr_mem.v ID.v rf_pipelined.v EX.v alu.v flag_rf.v jump.v data_mem.v MEM.v WB.v hazard_detection.v tests/instr.hex dut.v
	iverilog $(filter %.v, $^) -o $@

.PHONY: clean
clean:
	rm -f $(ALL_TESTS)
	rm -f variables.dump
