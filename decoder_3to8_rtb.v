`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:23:39 11/04/2025
// Design Name:   decoder_3to8
// Module Name:   /media/workdk/riskHDL/decoder_3to8_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: decoder_3to8
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module decoder_3to8_rtb;

	// Inputs
	reg B0;
	reg B1;
	reg B2;
	reg E;

	// Outputs
	wire O0;
	wire O1;
	wire O2;
	wire O3;
	wire O4;
	wire O5;
	wire O6;
	wire O7;

	// Instantiate the Unit Under Test (UUT)
	decoder_3to8 uut (
		.B0(B0), 
		.B1(B1), 
		.B2(B2), 
		.E(E), 
		.O0(O0), 
		.O1(O1), 
		.O2(O2), 
		.O3(O3), 
		.O4(O4), 
		.O5(O5), 
		.O6(O6), 
		.O7(O7)
	);


integer i;
initial begin
	B1 = 0;
	B0 = 0;
	B2 = 0;
	E=0;
	#20;
	E = 1;
	for( i=0;i<8;i=i+1)begin
		{B2,B1,B0}=i;
		#20;
	end
	#20;
	E = 0;
	for( i=0;i<8;i=i+1)begin
		{B2,B1,B0}=i;
		#20;
	end
	$finish;
end
      
endmodule

