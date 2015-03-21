/*CS 552 Project 16-bit mux*/

module mux_16bit(sel, in_1, in_2, out);
	
	input sel; //mux selection signal 
	input [15:0] in_1;
	input [15:0] in_2;

	output [15:0] out;

	assign out = sel ? in_1 : in_2;

endmodule
