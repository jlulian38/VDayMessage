`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:57:26 02/13/2014 
// Design Name: 
// Module Name:    bdaytoplevel 
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
module bdaytoplevel(
		input clk_fpga,
		input reset,
		input button,
		
		output HS,
		output VS,
		output [7:0] rgb
    );
	 
	dcm_10m dcm_25m (
		// Clock in ports
		.CLK_IN1(clk_fpga),      // IN
		// Clock out ports
		.CLK_OUT1(clk_25m),     // OUT
		// Status and control signals
		.RESET(reset),// IN
		.LOCKED(LOCKED) // OUT
	);

	vga_driver vga_driver (
		.clk(clk_25m), 
		.reset(reset), 
		.button(button),
		.HS(HS), 
		.VS(VS), 
		.rgb(rgb)
	);

endmodule
