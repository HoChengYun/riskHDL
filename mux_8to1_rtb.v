`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:28:15 11/04/2025
// Design Name:   mux_8to1
// Module Name:   /media/workdk/riskHDL/mux_8to1_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mux_8to1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mux_8to1_rtb;

	// Inputs
	reg I0;
	reg I1;
	reg I2;
	reg I3;
	reg I4;
	reg I5;
	reg I6;
	reg I7;
	reg B0;
	reg B1;
	reg B2;

	// Outputs
	wire O;

	// Instantiate the Unit Under Test (UUT)
	mux_8to1 uut (
		.I0(I0), 
		.I1(I1), 
		.I2(I2), 
		.I3(I3), 
		.I4(I4), 
		.I5(I5), 
		.I6(I6), 
		.I7(I7), 
		.B0(B0), 
		.B1(B1), 
		.B2(B2), 
		.O(O)
	);


        
// Add stimulus here
  reg [7:0] Ibus;
  reg [2:0] sel;
  integer i;
  integer errors, tests;
  reg exp; // 期望輸出

  // 把 Ibus 分派到 I0..I7
  task apply_inputs;
  begin
    {I7,I6,I5,I4,I3,I2,I1,I0} = Ibus;
  end
  endtask

  initial begin
    // 初始化
    {B2,B1,B0} = 3'b000;
    Ibus = 8'h00; apply_inputs();
    errors = 0;  tests = 0;

    $display("\n=== Random (200 vectors) ===");
    for (i = 0; i < 200; i = i + 1) begin
      Ibus = $random;
      apply_inputs();
      sel  = $random % 8;
      {B2,B1,B0} = sel[2:0];
		exp = Ibus[sel];
      #20;
      tests = tests + 1;
      if (O !== exp) begin
        errors = errors + 1;
        $display("[%0t] FAIL(sel=%0d rand) I=0x%02h exp=%b got=%b",
                 $time, sel, Ibus, exp, O);
      end
		#20;
    end

    // 總結
    $display("\n================ Test Summary ================");
    $display(" Total tests : %0d", tests);
    $display(" Total errors: %0d", errors);
    if (errors == 0) $display(" RESULT     : PASS ");
    else             $display(" RESULT     : FAIL ❌");
    $display("==============================================\n");

    #5 $finish;
  end
      
endmodule

