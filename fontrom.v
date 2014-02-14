`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:32:56 02/13/2014 
// Design Name: 
// Module Name:    fontrom 
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
module fontrom(
		input [7:0] char,
		input [2:0] x,
		input [2:0] y,
		
		output pixel
    );
	 
	localparam ROM_SIZE = 2048;

	reg [7:0] rom[0:ROM_SIZE-1];

	initial begin
		$readmemb("fontrom.txt", rom, 0, ROM_SIZE-1);
	end

	wire [7:0] rom_byte;
	wire [10:0] addr;
	
	assign addr = char*8 + y;
	assign rom_byte = rom[addr];
	
	assign pixel = rom_byte[~x];

endmodule