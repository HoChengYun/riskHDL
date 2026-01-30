`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:16:51 11/05/2025
// Design Name:   full_adder_16bits
// Module Name:   /media/workdk/riskHDL/full_adder_16bits_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: full_adder_16bits
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module full_adder_16bits_rtb;

	// Inputs
	reg [15:0] a;
	reg [15:0] b;
	reg cin;

	// Outputs
	wire [15:0] s;
	wire cout;
	wire cout_1;

	// Instantiate the Unit Under Test (UUT)
	full_adder_16bits uut (
		.a(a), 
		.b(b), 
		.cin(cin), 
		.s(s), 
		.cout(cout), 
		.cout_1(cout_1)
	);

       initial begin
		 // 加法
      a = 16'h0001; b = 16'h0001; cin = 0; #20; // 1+1=2

      // 加進位
      a = 16'h0001; b = 16'h0001; cin = 1; #20; // 1+1+1=3

      // 大一點的數
      a = 16'h1234; b = 16'h1111; cin = 0; #20; // 1234+1111=2345

      // 進位
      a = 16'hFFFF; b = 16'h0001; cin = 0; #20; // FFFF+1=0000, cout=1

      // 隨機
      a = $random; b = $random; cin = $random % 2; #20;
		$finish;
		end
      
endmodule

