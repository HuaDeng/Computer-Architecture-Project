/*CS 552 Project 4 to 1 mux(16bit)*/
module mux_16bit_4to1(sel, in_0, in_1, in_2, in_3, out);
	input [1:0] sel;
	input [15:0] in_0;
	input [15:0] in_1;
	input [15:0] in_2;
	input [15:0] in_3;

	output reg [15:0] out;

	always @ (sel or in_0 or in_1 or in_2 or in_3) begin
		case(sel)
			2'b00: out <= in_0;
			2'b01: out <= in_1;
			2'b10: out <= in_2;
			2'b11: out <= in_3;
		endcase
	end
endmodule 
