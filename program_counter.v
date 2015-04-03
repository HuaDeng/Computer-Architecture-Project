/*CS 552 Project program counter*/
module pc(clk, rst, hold, in_PC, out_PC);
	input clk;
	input rst; //reset the program counter
	input hold; //hold the current program counter value
	input [15:0] in_PC;

	output reg [15:0] out_PC;

	always @(negedge clk or posedge rst) begin
		if(rst) begin
			out_PC <= 16'h0000;
		end
		else begin
			if(hold) begin
				out_PC <= out_PC;
			end
			else begin
				out_PC <= in_PC;
			end
		end
	end
endmodule 
