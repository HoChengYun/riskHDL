`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:28:12 11/05/2025
// Design Name:   ALU_16bits
// Module Name:   /media/workdk/riskHDL/ALU_16bits_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU_16bits
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ALU_16bits_rtb;

	// Inputs
	reg [15:0] a;
	reg [15:0] b;
	reg [1:0] alu_ctrl;
	reg c_pre;

	// Outputs
	wire [15:0] s;
	wire z;
	wire c;
	wire n;
	wire v;

	// Instantiate the Unit Under Test (UUT)
	ALU_16bits uut (
		.a(a), 
		.b(b), 
		.alu_ctrl(alu_ctrl), 
		.c_pre(c_pre), 
		.s(s), 
		.z(z), 
		.c(c), 
		.n(n), 
		.v(v)
	);


  integer i, errors;
  reg [15:0] b_eff;
  reg cin_eff;
  reg [16:0] sum17;
  reg [15:0] s_exp;
  reg sign;
  reg cin;
  reg comp_e;
  reg n_exp, z_exp, c_exp, v_exp; 

  initial begin
    errors = 0;
    a=0; b=0; sign=0; cin=0; comp_e=0;

    for (i = 0; i < 200; i = i + 1) begin
      a = $random & 16'hFFFF;
      b = $random & 16'hFFFF;
      sign   = $random & 1; alu_ctrl[0] = sign;
      cin    = $random & 1; c_pre = cin;
      comp_e = $random & 1; alu_ctrl[1] = comp_e;

      b_eff   = b ^ {16{sign}};
      cin_eff = (comp_e) ? sign : cin;

      sum17   = {1'b0, a} + {1'b0, b_eff} + cin_eff;
      s_exp   = sum17[15:0];
		n_exp = s_exp[15];
		z_exp = (s_exp==0);
		c_exp = sum17[16];
		v_exp = ~(a[15]^b_eff[15]) & (a[15]^s_exp[15]);

      #20;
      if (s !== s_exp) begin
        $display("ERR s  : a=%h b=%h sign=%b cin=%b comp_e=%b -> s=%h exp=%h", 
                 a,b,sign,cin,comp_e,s,s_exp);
        errors = errors + 1;
      end
      if (c !== c_exp) begin
        $display("ERR c: a=%h b=%h sign=%b cin=%b comp_e=%b -> c=%b exp=%b", 
                 a,b,sign,cin,comp_e,c,c_exp);
        errors = errors + 1;
      end
      if (n !== n_exp) begin
        $display("ERR n: a=%h b=%h sign=%b cin=%b comp_e=%b -> n=%b exp=%b", 
                 a,b,sign,cin,comp_e,n,n_exp);
        errors = errors + 1;
      end
      if (z !== z_exp) begin
        $display("ERR cout: a=%h b=%h sign=%b cin=%b comp_e=%b -> z=%b exp=%b", 
                 a,b,sign,cin,comp_e,z,z_exp);
        errors = errors + 1;
      end
      if (v !== v_exp) begin
        $display("ERR cout: a=%h b=%h sign=%b cin=%b comp_e=%b -> v=%b exp=%b", 
                 a,b,sign,cin,comp_e,v,v_exp);
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

