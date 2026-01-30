`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   03:07:08 11/05/2025
// Design Name:   DFF_16bits
// Module Name:   /media/workdk/riskHDL/DFF_16bits_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DFF_16bits
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DFF_16bits_rtb;

	// Inputs
	reg [15:0] D;
	reg C;
	reg CE;
	reg CLR;

	// Outputs
	wire [15:0] O;

	// Instantiate the Unit Under Test (UUT)
	DFF_16bits uut (
		.D(D), 
		.C(C), 
		.CE(CE), 
		.CLR(CLR), 
		.O(O)
	);

task step1;
begin
  C = 0; #40;
  C = 1; #40;
end
endtask

integer errors = 0;

initial begin
  CLR = 1; CE = 1; C = 0; D = 0;
  #40;
  CLR = 0;
  #40;
  //給一筆資料
  D = 16'h1234; step1();
  if (O !== D) begin errors = errors + 1; $display("Error: O=%h expected=%h", O, D); end

  //再一筆
  D = 16'hABCD; step1();
  if (O !== D) begin errors = errors + 1; $display("Error: O=%h expected=%h", O, D); end

  //CE關掉，不該變
  CE = 0; D = 16'h5555; step1();
  if (O !== 16'hABCD) begin errors = errors + 1; $display("Error: CE off, O changed! O=%h", O); end

  //Step 4: 清除
  CE = 1; CLR = 1; step1();
  if (O !== 16'h0000) begin errors = errors + 1; $display("Error: CLR failed, O=%h", O); end
  CLR = 0;

  //總結
  $display("\nTest finished. Errors = %0d", errors);
  if (errors == 0) $display("Result: PASS");
  else             $display("Result: FAIL");

  #10 $finish;
end
      
endmodule

