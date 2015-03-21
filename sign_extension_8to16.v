/*CS 552 Project Sign-extend unit (8 bit to 16 bit)*/

module sign_extension_8to16(src, out);

	input [7:0] src; //value of imm
	output [15:0] out; //sign-extended result

	reg [15:0] out;

	always @ (src) begin	
		assign out = {{8{src[3]}},src};
	end

endmodule 
