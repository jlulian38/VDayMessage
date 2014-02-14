`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:16:32 02/13/2014 
// Design Name: 
// Module Name:    string_display 
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
module string_display
	#(parameter OFFSET_X=0,
	  parameter OFFSET_Y=0,
	  parameter SCALE = 0,
	  parameter COLOR = 8'b11111111,
	  parameter FILE = "hello.dat",
	  parameter LENGTH = 12
	)
	(input [10:0] hcnt,
	 input [10:0] vcnt,
	 input [7:0] display_length,
	 input enable,
	 
	 output [7:0] rgb,
	 output reg active
    );
	 
	reg [7:0] string_rom [0:LENGTH-1];
	
	initial begin
		$readmemh(FILE, string_rom, 0, LENGTH-1);
	end

	wire [7:0] char;
	wire [2:0] x,y;
	wire pixel;
	
	fontrom font_inst (
    .char(char), 
    .x(x), 
    .y(y), 
    .pixel(pixel)
   );
	
	wire [10:0] hcnt_offset, vcnt_offset, hcnt_scale, vcnt_scale;
	
	assign hcnt_offset = hcnt - OFFSET_X;
	assign vcnt_offset = vcnt - OFFSET_Y;
	assign hcnt_scale = hcnt_offset >> SCALE;
	assign vcnt_scale = vcnt_offset >> SCALE;
	
	//bounding box check
	always @(hcnt_offset, vcnt_offset, hcnt_scale, vcnt_scale)
		if (hcnt_offset > 0 && hcnt_scale < 8*display_length
			 && vcnt_offset > 0 && vcnt_scale < 8)
			active = 1'b1;
		else
			active = 1'b0;
	
	wire [7:0] string_pos;
	
	assign string_pos = hcnt_scale >> 3;
	assign char = string_rom[string_pos];
	
	assign x = hcnt_scale;
	assign y = vcnt_scale;
	
	assign rgb = pixel ? COLOR : 8'b0;

endmodule
