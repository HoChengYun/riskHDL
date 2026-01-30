`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:01:54 11/05/2025 
// Design Name: 
// Module Name:    full_adder_16bits 
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
module full_adder_16bits(
input [15:0] a, b,
input cin,
output [15:0] s,
output cout, cout_1 //cout_1 -> 15 bit's cout
);
wire [16:0] COUTtoCIN;
genvar i;

assign COUTtoCIN[0] = cin,
       cout = COUTtoCIN[16],
		 cout_1 = COUTtoCIN[15];

generate for(i=0;i<16;i=i+1)begin:adr
    full_adder a0(.a(a[i]), .b(b[i]), .cin(COUTtoCIN[i]), .s(s[i]), .cout(COUTtoCIN[i+1]));
end endgenerate

endmodule
