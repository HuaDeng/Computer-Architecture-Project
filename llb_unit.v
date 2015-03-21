/*CS 552 Project LLB unit*/
module llb_unit(in_1, in_2, out);
	input [15:0] in_1;
	input [7:0] in_2;

	output reg [15:0] out;

	always @ (in_1 or in_2) begin
		assign out = {in_1[15:8], in_2};
	end 
endmodule 
