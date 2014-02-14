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
	
	localparam MODULES = 7;
	
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
	 
	//I
	string_display 
		#(.OFFSET_X(8),
		  .OFFSET_Y(8),
		  .SCALE(2),
	          .FILE("i.dat"),
		  .LENGTH(1))
	I_inst (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(1'b1), 
		.rgb(rgb_mux[0]), 
		.active(rgb_sel[0])
	);

	//Heart (centered)
	string_display 
		#(.OFFSET_X(288),
		  .OFFSET_Y(208),
		  .SCALE(3),
	          .FILE("heart.dat"),
		  .LENGTH(1))
	Heart_inst (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(1'b1), 
		.rgb(rgb_mux[1]), 
		.active(rgb_sel[1])
	);
	
	//Katrina
	string_display 
		#(.OFFSET_X(272),
		  .OFFSET_Y(400),
		  .SCALE(2),
	          .FILE("katrina.dat"),
		  .LENGTH(1))
	Katrina_inst (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(1'b1), 
		.rgb(rgb_mux[2]), 
		.active(rgb_sel[2])
	);

	//line1
	string_display 
		#(.OFFSET_X(432),
		  .OFFSET_Y(8),
		  .SCALE(2),
	          .FILE("line1.dat"),
		  .LENGTH(1))
	line1_inst (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(1'b1), 
		.rgb(rgb_mux[3]), 
		.active(rgb_sel[3])
	);

	//line2
	string_display 
		#(.OFFSET_X(432),
		  .OFFSET_Y(18),
		  .SCALE(2),
	          .FILE("line2.dat"),
		  .LENGTH(1))
	line2_inst (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(1'b1), 
		.rgb(rgb_mux[4]), 
		.active(rgb_sel[4])
	);

	//line3
	string_display 
		#(.OFFSET_X(432),
		  .OFFSET_Y(28),
		  .SCALE(2),
	          .FILE("line3.dat"),
		  .LENGTH(1))
	line3_inst (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(1'b1), 
		.rgb(rgb_mux[5]), 
		.active(rgb_sel[5])
	);

	//line4
	string_display 
		#(.OFFSET_X(432),
		  .OFFSET_Y(38),
		  .SCALE(2),
	          .FILE("line4.dat"),
		  .LENGTH(1))
	line1_inst (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(1'b1), 
		.rgb(rgb_mux[6]), 
		.active(rgb_sel[6])
	);
	
	function [31:0] log2;
		input reg [31:0] value;
		begin
			value = value-1;
			for (log2=0; value>0; log2=log2+1)
				value = value>>1;
		end
	endfunction

endmodule
