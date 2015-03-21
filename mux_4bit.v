/*CS 552 Project 4-bit mux*/

module mux_4bit(sel, in_1, in_2, out);
	
	input sel; //mux selection signal 
	input [3:0] in_1;
	input [3:0] in_2;

	output [3:0] out;

	assign out = sel ? in_1 : in_2;

endmodule
