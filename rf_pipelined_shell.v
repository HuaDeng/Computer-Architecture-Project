module rf(clk,p0_addr,p1_addr,p0,p1,re0,re1,dst_addr,dst,we,hlt);
//////////////////////////////////////////////////////////////////
// Triple ported register file.  Two read ports (p0 & p1), and //
// one write port (dst).  Data is written on clock high, and  //
// read on clock low //////////////////////////////////////////
//////////////////////

input clk;
input [3:0] p0_addr, p1_addr;				// two read port addresses
input re0,re1;						// read enables (power not functionality)
input [3:0] dst_addr;					// write address
input [15:0] dst;					// dst bus
input we;						// write enable
input hlt;						// not a functional input.  Used to dump register contents when
							// test is halted.

output reg [15:0] p0,p1;  				//output read ports
endmodule
  

