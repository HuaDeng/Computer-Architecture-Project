/*CS 552 Project Sign-extend unit (4 bit to 16 bit)*/

module sign_extension_4to16(src, out);

	input [3:0] src; //value of imm
	output [15:0] out; //sign-extended result

	reg [15:0] out;

	always @ (src) begin	
		assign out = {{12{src[3]}},src};
	end

endmodule 
