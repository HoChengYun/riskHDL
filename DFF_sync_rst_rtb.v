`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:12:44 12/06/2025
// Design Name:   DFF_sync_rst
// Module Name:   /media/workdk/riskHDL/DFF_sync_rst_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DFF_sync_rst
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DFF_sync_rst_rtb;

	// Inputs
	reg clk;
	reg rst;
	reg ce;
	reg [0:0] d;

	// Outputs
	wire [0:0] q;

	// Instantiate the Unit Under Test (UUT)
	DFF_sync_rst uut (
		.clk(clk), 
		.rst(rst), 
		.ce(ce), 
		.d(d), 
		.q(q)
	);

// clock generator
initial clk = 0;
always #40 clk = ~clk;          // 100MHz clock (10ns period)

// test process
initial begin
    $display("===== DFF_sync_rst Testbench Start =====");

    // Initial values
    rst = 1;
    ce  = 0;
    d   = 0;

    // Hold reset for a few cycles
	 @(posedge clk);
    #40;
    rst = 0;

    // === Test 1: ce = 1, D updates ===
    ce = 1;
    d  = 8'hAA;
 	 @(posedge clk);
    #40;

    d = 8'h55;
	 @(posedge clk);
    #40;

    // === Test 2: ce = 0, output should hold ===
    ce = 0;
    d  = 8'hFF;
	 @(posedge clk);
    #40;

    // === Test 3: apply synchronous reset ===
    rst = 1;
	 @(posedge clk);
    #40;
    rst = 0;

    // === Test 4: update again ===
    ce = 1;
    d  = 8'h0F;
	 @(posedge clk);
    #40;

    $display("===== DFF_sync_rst Testbench Finished =====");
    $stop;
end

// Monitor all signals
initial begin
    $monitor("t=%0dns | clk=%b rst=%b ce=%b | d=%h → q=%h",
             $time, clk, rst, ce, d, q);
end
      
endmodule

