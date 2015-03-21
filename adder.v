/*CS 552 Project Adder*/
module adder(in_1, in_2, out);
	input [15:0] in_1;
	input [15:0] in_2;

	output reg [15:0] out;

	always @ (in_1 or in_2) begin
		assign out = in_1 + in_2;
	end
endmodule 
