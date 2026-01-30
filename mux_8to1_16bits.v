`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:53:40 11/04/2025 
// Design Name: 
// Module Name:    mux_8to1_16bits 
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
module mux_8to1_16bits(
input [15:0] IN0, IN1, IN2, IN3, IN4, IN5, IN6, IN7,
input [2:0] B,
output [15:0] OUT0);

genvar i;
generate
    for (i=0; i<16; i=i+1) begin:mux16
	     mux_8to1 u_mux(
		  .I0(IN0[i]), .I1(IN1[i]), .I2(IN2[i]), .I3(IN3[i]),
        .I4(IN4[i]), .I5(IN5[i]), .I6(IN6[i]), .I7(IN7[i]),
		  .B0(B[0]), .B1(B[1]), .B2(B[2]), .O(OUT0[i]) );
    end
endgenerate

endmodule
