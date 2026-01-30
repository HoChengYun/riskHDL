`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:42:23 11/05/2025
// Design Name:   comp_adder_16bits
// Module Name:   /media/workdk/riskHDL/comp_adder_16bits_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: comp_adder_16bits
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module comp_adder_16bits_rtb;

	// Inputs
	reg [15:0] a;
	reg [15:0] b;
	reg cin;
	reg sign;
	reg comp_e;

	// Outputs
	wire [15:0] s;
	wire cout;
	wire cout_1;

	// Instantiate the Unit Under Test (UUT)
	comp_adder_16bits uut (
		.a(a), 
		.b(b), 
		.cin(cin), 
		.sign(sign), 
		.comp_e(comp_e), 
		.s(s), 
		.cout(cout), 
		.cout_1(cout_1)
	);

  integer i, errors;
  reg [15:0] b_eff;
  reg cin_eff;
  reg [16:0] sum17;
  reg [15:0] s_exp;
  reg cout_exp;

  initial begin
    errors = 0;
    a=0; b=0; sign=0; cin=0; comp_e=0;

    for (i = 0; i < 400; i = i + 1) begin
      a = $random & 16'hFFFF;
      b = $random & 16'hFFFF;
      sign   = $random & 1;
      cin    = $random & 1;
      comp_e = $random & 1;

      b_eff   = b ^ {16{sign}};
      cin_eff = (comp_e) ? sign : cin;

      sum17   = {1'b0, a} + {1'b0, b_eff} + cin_eff;
      s_exp   = sum17[15:0];
      cout_exp= sum17[16];

      #20;
      if (s !== s_exp) begin
        $display("ERR s  : a=%h b=%h sign=%b cin=%b comp_e=%b -> s=%h exp=%h", 
                 a,b,sign,cin,comp_e,s,s_exp);
        errors = errors + 1;
      end
      if (cout !== cout_exp) begin
        $display("ERR cout: a=%h b=%h sign=%b cin=%b comp_e=%b -> cout=%b exp=%b", 
                 a,b,sign,cin,comp_e,cout,cout_exp);
        errors = errors + 1;
      end
      #20;
    end

    if (errors==0)
      $display("PASS: all tests passed.");
    else
      $display("DONE with %0d errors.", errors);
    $finish;
  end
      
endmodule

