/*CS 552 Project FLAG register unit*/
module flag_rf(clk, cond, z, v, n, out);
	input clk;
	input [3:0] cond;
	input z, v, n;

	output reg out;

	reg [2:0] zvn; 

	parameter equal = 4'bz000;
	parameter less = 4'bz001;
	parameter greater = 4'bz010;
	parameter overflow = 4'bz011;
	parameter not_equal = 4'bz100;
	parameter greater_or_equal = 4'bz101;
	parameter less_or_equal = 4'bz110;
	parameter true = 4'bz111;

	always @(posedge clk) begin
		zvn[0] <= n;
		zvn[1] <= v;
		zvn[2] <= z;
	end
	
	always @(cond) begin
		casez(cond)
			equal: begin
							out <= (zvn[2] == 1'b1)? 1'b1 : 1'b0;
						 end
			less: begin
									out <= (zvn[1] == 1'b0 && zvn[0] == 1)? 1'b1 : 1'b0;
								 end
			greater: begin
								out <= (zvn == 3'b000)? 1'b1 : 1'b0;
							 end
			overflow: begin
									out <= (zvn[1] == 1'b1)? 1'b1 : 1'b0;
								end
			not_equal: begin
									 out <= (zvn[2] == 1'b0)? 1'b1 : 1'b0;
								 end
			greater_or_equal: begin
													out <= (zvn[1] == 1'b1 || zvn[0] == 1'b0)? 1'b1 : 1'b0;
												end
			less_or_equal: begin
												out <= ((zvn[0] == 1'b1 && zvn[1] == 1'b0) || zvn[2] == 1'b1)? 1'b1 : 1'b0;
										 end
			true: begin
							out <= 1'b1;
						end
		endcase
	end
endmodule 
