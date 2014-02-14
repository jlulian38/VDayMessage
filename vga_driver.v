`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:55:57 02/13/2014 
// Design Name: 
// Module Name:    vga_driver 
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
module vga_driver(
		input clk,
		input reset,
		
		output HS,
		output VS,
		output [7:0] rgb
    );

	wire [10:0] hcnt, vcnt;
	wire blank;
	
	vga_controller_640_60 vga_timing_inst (
		.rst(reset), 
		.pixel_clk(clk), 
		.HS(HS), 
		.VS(VS), 
		.hcount(hcnt), 
		.vcount(vcnt), 
		.blank(blank)
	);
	
	localparam MODULES = 4;
	
	wire [7:0] rgb_mux [0:MODULES-1];
	
	wire [MODULES-1:0] rgb_sel;
	wire [log2(MODULES)-1:0] rgb_addr;
	
	assign rgb = (valid && !blank) ? rgb_mux[rgb_addr] : 8'b0;
	
	priencr #(.width(MODULES))
		pri_inst (
		 .decode(rgb_sel), 
		 .encode(rgb_addr), 
		 .valid(valid)
    );
	 
	 //MODULES
	 
	string_display instance_name (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(1'b1), 
		.rgb(rgb_mux[0]), 
		.active(rgb_sel[0])
	);
	
	assign rgb_mux[1] = 8'b0;
	assign rgb_mux[2] = 8'b0;
	assign rgb_mux[3] = 8'b0;
	
	function [31:0] log2;
		input reg [31:0] value;
		begin
			value = value-1;
			for (log2=0; value>0; log2=log2+1)
				value = value>>1;
		end
	endfunction

endmodule
