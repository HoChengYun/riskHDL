`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:14:14 11/04/2025 
// Design Name: 
// Module Name:    decoder_3to8 
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
module decoder_3to8(
input B0, B1, B2, E,
output O0, O1, O2, O3, O4, O5, O6, O7);

assign O0 = ~B2 & ~B1 & ~B0 & E,
       O1 = ~B2 & ~B1 &  B0 & E,
       O2 = ~B2 &  B1 & ~B0 & E,
       O3 = ~B2 &  B1 &  B0 & E,
       O4 =  B2 & ~B1 & ~B0 & E,
       O5 =  B2 & ~B1 &  B0 & E,
       O6 =  B2 &  B1 & ~B0 & E,
       O7 =  B2 &  B1 &  B0 & E;


endmodule
