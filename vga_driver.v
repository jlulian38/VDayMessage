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
	wire [MODULES-1:0] enable;
	
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
		.enable(enable[0]), 
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
		.enable(enable[1]), 
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
		.enable(enable[2]), 
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
		.enable(enable[3]), 
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
		.enable(enable[4]), 
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
		.enable(enable[5]), 
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
	line4_inst (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(enable[6]), 
		.rgb(rgb_mux[6]), 
		.active(rgb_sel[6])
	);

	localparam [3:0] start = 0,
			 s_i = 1,
			 s_heart = 2,
			 s_katrina = 3,
			 s_msg = 4;

	reg s_reg, s_next;
	wire clk_en = 1'b1;

	always @(posedge clk, posedge reset)
		if (reset)
			s_reg <= start;
		else if (clk_en)
			s_ref <= s_next;

	always @(s_reg)
	begin
		//defaults
		s_next = s_reg;
		enable = 0;
		case (s_reg)
			start:
				s_next = s_i;	
			s_i:
			begin
				enable[0] = 1'b1;
				s_next = s_heart;
			end
			s_heart:
			begin
				enable[1:0] = 2'b11;
				s_next = s_katrina;
			end
			s_katrina:
			begin
				enable[2:0] = 3'b11;
				s_next = s_msg;
			end
			s_msg:
				enable[6:0] = 7'b1111111;
		endcase
	end

	
	function [31:0] log2;
		input reg [31:0] value;
		begin
			value = value-1;
			for (log2=0; value>0; log2=log2+1)
				value = value>>1;
		end
	endfunction

endmodule
