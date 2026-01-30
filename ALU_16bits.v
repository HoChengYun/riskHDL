`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:03:06 11/05/2025 
// Design Name: 
// Module Name:    ALU_16bits 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ALU_16bits(
input [15:0] a, b,
input [1:0] alu_ctrl,
input c_pre,
output [15:0] s,
output z, c, n, v);

wire cout_1;

comp_adder_16bits c0(.a(a), .b(b), .cin(c_pre),
.sign(alu_ctrl[0]), .comp_e(alu_ctrl[1]),
.s(s), .cout(c), .cout_1(cout_1));

assign n = s[15],
       z = ~(|s),
		 v = c^cout_1;

endmodule
