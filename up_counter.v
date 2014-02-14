`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:35:35 02/14/2014 
// Design Name: 
// Module Name:    up_counter 
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
module up_counter
	#(parameter MAX=8)
	(
		input clk,
		input clk_en,
		input reset,
		
		output reg [7:0] q,
		output tc
    );

	reg [7:0] q_next;
	
	always @(posedge clk, posedge reset)
		if (reset)
			q <= 0;
		else if (clk_en)
			q <= q_next;
			
	always @(q)
		if (q < MAX)
			q_next = q + 1'b1;
		else
			q_next = q;
		
	assign tc = (q == MAX);
endmodule
