/*CS 552 Project LHB unit*/
module lhb_unit(in_1, in_2, out);
	input [15:0] in_1;
	input [7:0] in_2;

	output reg [15:0] out;

	always @ (in_1 or in_2) begin
		assign out = {in_2, in_1[7:0]};
	end 
endmodule 
