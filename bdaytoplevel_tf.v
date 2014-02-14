`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:30:55 02/14/2014
// Design Name:   bdaytoplevel
// Module Name:   M:/ECE3829/BdayProject/bdaytoplevel_tf.v
// Project Name:  BdayProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bdaytoplevel
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module bdaytoplevel_tf;

	// Inputs
	reg clk_fpga;
	reg reset;

	// Outputs
	wire HS;
	wire VS;
	wire [7:0] rgb;

	// Instantiate the Unit Under Test (UUT)
	bdaytoplevel 
		#(.OFFSET_X(432),
		  .OFFSET_Y(8),
		  .FILE("line1.dat"),
		  .LENGTH(17))
	uut (
		.clk_fpga(clk_fpga), 
		.reset(reset), 
		.HS(HS), 
		.VS(VS), 
		.rgb(rgb)
	);
	
	always
	begin
		clk_fpga = 0;
		#5;
		clk_fpga = 1;
		#5;
	end

	initial begin
		// Initialize Inputs
		reset = 1;
		// Wait 100 ns for global reset to finish
		#100;
		reset = 0;
		#200;
		
		//wait for a whole frame
		#16666666;
        
		$stop;

	end
      
endmodule

