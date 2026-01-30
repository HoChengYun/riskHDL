`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   07:50:07 11/05/2025
// Design Name:   full_adder
// Module Name:   /media/workdk/riskHDL/full_adder_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: full_adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module full_adder_rtb;

	// Inputs
	reg a;
	reg b;
	reg cin;

	// Outputs
	wire s;
	wire cout;

	// Instantiate the Unit Under Test (UUT)
	full_adder uut (
		.a(a), 
		.b(b), 
		.cin(cin), 
		.s(s), 
		.cout(cout)
	);
	
	initial begin
		a=0; b=0; cin=0; #10;
      a=0; b=0; cin=1; #10;
      a=0; b=1; cin=0; #10;
      a=0; b=1; cin=1; #10;
      a=1; b=0; cin=0; #10;
      a=1; b=0; cin=1; #10;
      a=1; b=1; cin=0; #10;
      a=1; b=1; cin=1; #10;
		$finish;
	end
      
endmodule

