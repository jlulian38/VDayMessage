`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:11:10 02/13/2014
// Design Name:   string_display
// Module Name:   M:/ECE3829/BdayProject/string_display_tf.v
// Project Name:  BdayProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: string_display
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module string_display_tf;

	// Inputs
	reg [10:0] hcnt;
	reg [10:0] vcnt;
	reg enable;

	// Outputs
	wire [7:0] rgb;
	wire active;

	// Instantiate the Unit Under Test (UUT)
	string_display uut (
		.hcnt(hcnt), 
		.vcnt(vcnt), 
		.enable(enable), 
		.rgb(rgb), 
		.active(active)
	);

	integer i,j;
	
	initial begin
		// Initialize Inputs
		hcnt = 0;
		vcnt = 0;
		enable = 1;

		// Wait 100 ns for global reset to finish
		#100;
		
		for(j=0; j<8; j = j+1)
		begin
			for(i=0; i<8*1; i = i+1)
			begin
				hcnt = i;
				vcnt = j;
				
				#5;
			end
		end
        
		$finish;

	end
      
endmodule

