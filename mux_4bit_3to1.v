/*CS 552 project 3 to 1 mux (4 bit)*/
module mux_4bit_3to1(sel, in_0, in_1, in_2, out);
	input [1:0] sel;
	input [3:0] in_0;
	input [3:0] in_1;
	input [3:0] in_2;

	output reg [3:0] out;
	always @ (sel or in_0 or in_1 or in_2) begin
		case(sel)
			2'b00: out <= in_0;
			2'b01: out <= in_1;
			2'b10: out <= in_2;
			2'b11: out <= 3'bx;
		endcase
	end
endmodule 
