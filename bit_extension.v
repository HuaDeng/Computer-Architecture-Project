/*CS 552 Project bit extend unit*/
module bit_extension(src, out);

	input [3:0] src; //value of imm
	output [7:0] out; //sign-extended result

	reg [7:0] out;

	always @ (src) begin	
		assign out = {4'b0000,src};
	end

endmodule 
