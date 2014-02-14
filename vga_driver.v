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
		input button,
		
		output HS,
		output VS,
		output [7:0] rgb
    );

	wire [10:0] hcnt, vcnt;
	wire blank;
	
	clk_div 
		#(.DIV(2500000))
	clk_div_inst (
		.clk_in(clk), 
		.reset(reset), 
		.clk_out(clk_en)
   );
	
	clk_div 
		#(.DIV(25000000))
	clk_div_inst1 (
		.clk_in(clk), 
		.reset(reset), 
		.clk_out(clk_1h)
   );
	
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
	reg [MODULES-1:0] enable;
	
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
		#(.OFFSET_X(224),
		  .OFFSET_Y(144),
		  .SCALE(2),
	          .FILE("i.dat"),
		  .LENGTH(1))
	I_inst (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(enable[0]), 
		.display_length(1),
		.rgb(rgb_mux[0]), 
		.active(rgb_sel[0])
	);

	//Heart (centered)
	string_display 
		#(.OFFSET_X(288),
		  .OFFSET_Y(208),
		  .SCALE(3),
	     .FILE("heart.dat"),
		  .COLOR(8'b11100000),
		  .LENGTH(1))
	Heart_inst (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(enable[1]),
		.display_length(1),
		.rgb(rgb_mux[1]), 
		.active(rgb_sel[1])
	);
	
	//Katrina
	string_display 
		#(.OFFSET_X(272),
		  .OFFSET_Y(304),
		  .SCALE(2),
        .FILE("katrina.dat"),
		  .LENGTH(7))
	Katrina_inst (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(enable[2]), 
		.display_length(7),
		.rgb(rgb_mux[2]), 
		.active(rgb_sel[2])
	);
	
	wire [7:0] disp_cnt [0:3];
	wire tc[0:3];

	//line1
	string_display 
		#(.OFFSET_X(432),
		  .OFFSET_Y(8),
		  .FILE("line1.dat"),
		  .LENGTH(18))
	line1_inst (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.display_length(disp_cnt[0]),
		.enable(enable[3]), 
		.rgb(rgb_mux[3]), 
		.active(rgb_sel[3])
	);
	
	up_counter
		#(.MAX(18))
	cnt_inst0 (
		 .clk(clk), 
		 .clk_en(clk_en & enable[3]), 
		 .reset(reset), 
		 .q(disp_cnt[0]), 
		 .tc(tc[0])
    );

	//line2
	string_display 
		#(.OFFSET_X(432),
		  .OFFSET_Y(18),
		  .FILE("line2.dat"),
		  .LENGTH(23))
	line2_inst (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(enable[4]), 
		.display_length(disp_cnt[1]),
		.rgb(rgb_mux[4]), 
		.active(rgb_sel[4])
	);
	
	up_counter
		#(.MAX(23))
	cnt_inst1 (
		 .clk(clk), 
		 .clk_en(clk_en & tc[0]), 
		 .reset(reset), 
		 .q(disp_cnt[1]), 
		 .tc(tc[1])
    );

	//line3
	string_display 
		#(.OFFSET_X(432),
		  .OFFSET_Y(28),
		  .FILE("line3.dat"),
		  .LENGTH(21))
	line3_inst (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(enable[5]), 
		.display_length(disp_cnt[2]),
		.rgb(rgb_mux[5]), 
		.active(rgb_sel[5])
	);
	
	up_counter
		#(.MAX(21))
	cnt_inst2 (
		 .clk(clk), 
		 .clk_en(clk_en & tc[1]), 
		 .reset(reset), 
		 .q(disp_cnt[2]), 
		 .tc(tc[2])
    );

	//line4
	string_display 
		#(.OFFSET_X(432),
		  .OFFSET_Y(38),
		  .FILE("line4.dat"),
		  .LENGTH(24))
	line4_inst (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(enable[6]), 
		.display_length(disp_cnt[3]),
		.rgb(rgb_mux[6]), 
		.active(rgb_sel[6])
	);
	
	up_counter
		#(.MAX(24))
	cnt_inst3 (
		 .clk(clk), 
		 .clk_en(clk_en & tc[2]), 
		 .reset(reset), 
		 .q(disp_cnt[3]), 
		 .tc(tc[3])
    );

	localparam [3:0] start = 0,
			 s_i = 1,
			 s_heart = 2,
			 s_katrina = 3,
			 s_msg = 4;

	reg [3:0] s_reg, s_next;

	always @(posedge clk, posedge reset)
		if (reset)
			s_reg <= start;
		else if (clk_1h)
			s_reg <= s_next;

	always @(s_reg, button)
	begin
		//defaults
		s_next = s_reg;
		enable = 0;
		case (s_reg)
			start:
				if (button)
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
