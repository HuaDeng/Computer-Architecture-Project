/*CS 552 Project branch adder unit*/
module branch_adder(in_Data1, in_Data2, out_Data);

	input [15:0] in_Data1;
	input [15:0] in_Data2;

	output [15:0] out_Data;

	assign out_Data = in_Data1 + in_Data2;
 
endmodule 
