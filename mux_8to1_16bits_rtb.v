`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:17:09 11/04/2025
// Design Name:   mux_8to1_16bits
// Module Name:   /media/workdk/riskHDL/mux_8to1_16bits_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mux_8to1_16bits
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mux_8to1_16bits_rtb;

	// Inputs
	reg [15:0] IN0;
	reg [15:0] IN1;
	reg [15:0] IN2;
	reg [15:0] IN3;
	reg [15:0] IN4;
	reg [15:0] IN5;
	reg [15:0] IN6;
	reg [15:0] IN7;
	reg [2:0] B;

	// Outputs
	wire [15:0] OUT0;

	// Instantiate the Unit Under Test (UUT)
	mux_8to1_16bits uut (
		.IN0(IN0), 
		.IN1(IN1), 
		.IN2(IN2), 
		.IN3(IN3), 
		.IN4(IN4), 
		.IN5(IN5), 
		.IN6(IN6), 
		.IN7(IN7), 
		.B(B), 
		.OUT0(OUT0)
	);

  // 期望值 / 統計
  reg  [15:0] exp;
  integer i;
  integer errors, tests;
	
	// Initialize Inputs
  // 依 select 取出期望輸出
  function [15:0] pick;
    input [2:0] s;
    begin
      case (s)
        3'd0: pick = IN0;
        3'd1: pick = IN1;
        3'd2: pick = IN2;
        3'd3: pick = IN3;
        3'd4: pick = IN4;
        3'd5: pick = IN5;
        3'd6: pick = IN6;
        3'd7: pick = IN7;
        default: pick = 16'hxxxx;
      endcase
    end
  endfunction

  // 把 8 組 16-bit 輸入
  task randomize_inputs16;
  begin
    IN0 = $random;  IN1 = $random;  IN2 = $random;  IN3 = $random;
    IN4 = $random;  IN5 = $random;  IN6 = $random;  IN7 = $random;
  end
  endtask

  initial begin
    // 初始化
    B = 3'd0;
    randomize_inputs16();
    errors = 0; 
    tests  = 0;

    $display("\n=== Random (200 vectors) ===");
    for (i = 0; i < 200; i = i + 1) begin
      // 隨機產生 8 組 16-bit 輸入與一個 select
      randomize_inputs16();
      B   = $random % 8;
		exp = pick(B);
      #20;

      tests = tests + 1;
      if (OUT0 !== exp) begin
        errors = errors + 1;
        $display("[%0t] FAIL(rand) sel=%0d  ", $time, B);
        $display("  IN0=%h IN1=%h IN2=%h IN3=%h", IN0, IN1, IN2, IN3);
        $display("  IN4=%h IN5=%h IN6=%h IN7=%h", IN4, IN5, IN6, IN7);
        $display("  exp=%h  got=%h", exp, OUT0);
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

