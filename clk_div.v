`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:30:44 01/30/2014 
// Design Name: 
// Module Name:    clk_div 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clk_div
	#(parameter DIV=1000)
	(input clk_in,
	 input reset,
	 output clk_out);

	//internal counter
	reg [log2(DIV/2)-1:0] cnt;
	
	always @(posedge clk_in)
		if (reset)
			cnt <= 0;
		else
			if (cnt == DIV/2)
				cnt <= 0;
			else
				cnt <= cnt + 1'b1;
				
	assign clk_out = (cnt == DIV/2);
				
	function integer log2(input integer n);
		integer i;
	begin
		log2 = 1;
		for (i=0; 2**i < n; i = i+1)
			log2 = i+ 1;
	end
	endfunction

endmodule
