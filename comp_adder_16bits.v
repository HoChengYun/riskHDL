`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:25:09 11/05/2025 
// Design Name: 
// Module Name:    comp_adder_16bits 
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
module comp_adder_16bits(
input [15:0] a, b,
input cin, sign, comp_e,
output [15:0] s,
output cout, cout_1);

wire [15:0] xb;
wire sel_out;
assign xb = b ^ {16{sign}},
       sel_out = (comp_e)? sign:cin;

full_adder_16bits A0(.a(a), .b(xb), .cin(sel_out), .s(s), .cout(cout), .cout_1(cout_1));

endmodule
