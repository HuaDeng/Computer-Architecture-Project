/*CS 552 Project Call instruction unit*/
module call_unit(in_1, in_2, out);
	input [11:0] in_1;
	input [15:0] in_2;

	output reg [15:0] out;
	
	always @ (in_1 or in_2) begin
		assign out = {in_2[15:12], in_1};
	end

endmodule 
