`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:14:17 11/12/2025
// Design Name:   pc_circuit
// Module Name:   /media/workdk/riskHDL/pc_circuit_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pc_circuit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pc_circuit_rtb;

	// Inputs
	reg [15:0] pc_pre;
	reg pc_ld;
	reg pc_rst;
	reg clk;

	// Outputs
	wire [15:0] pc;

	// Instantiate the Unit Under Test (UUT)
	pc_circuit uut (
		.pc_pre(pc_pre), 
		.pc_ld(pc_ld), 
		.pc_rst(pc_rst), 
		.clk(clk), 
		.pc(pc)
	);

// Clock generation
parameter CLK_PERIOD = 80;

always begin
   clk = 0;
   forever #(CLK_PERIOD/2) clk = ~clk;
end

   initial begin
	pc_rst = 0;
	pc_ld = 0; 
	pc_pre = 16'h0000;
	//begin
	@(posedge clk); #40;
	//write pc(with pc_load on)
	pc_ld = 1; pc_pre = 16'hABCD;@(posedge clk); #40;
	//write pc(with pc_load off)
	pc_ld = 0; pc_pre = 16'h0BAD;@(posedge clk); #40;
	//reset pc
	pc_rst = 1;;@(posedge clk); #20;
	$finish;
	end
      
endmodule

