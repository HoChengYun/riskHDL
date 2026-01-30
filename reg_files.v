`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:20:21 11/05/2025 
// Design Name: 
// Module Name:    reg_files 
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
module reg_files(
input [15:0] din,
input [2:0] wr_addr, rd_addr_a, rd_addr_b,
input wr_E, CLK, CLR,
output [15:0] out_a, out_b);

wire [7:0] toDFF;
wire [15:0] toMUX [7:0];

decoder_3to8 d0(.B2(wr_addr[2]), .B1(wr_addr[1]), .B0(wr_addr[0]), .E(wr_E),
    .O7(toDFF[7]), .O6(toDFF[6]), .O5(toDFF[5]), .O4(toDFF[4]),
	 .O3(toDFF[3]), .O2(toDFF[2]), .O1(toDFF[1]), .O0(toDFF[0]) );

genvar i;
generate for(i=0;i<8;i=i+1) begin:DFFgen
    DFF_16bits dff0(.D(din), .C(CLK), .CE(toDFF[i]), .CLR(CLR), .O(toMUX[i]));
end endgenerate

mux_8to1_16bits m0(.B(rd_addr_a), .OUT0(out_a),
    .IN7(toMUX[7]), .IN6(toMUX[6]), .IN5(toMUX[5]), .IN4(toMUX[4]), 
	 .IN3(toMUX[3]), .IN2(toMUX[2]), .IN1(toMUX[1]), .IN0(toMUX[0]));

mux_8to1_16bits m1(.B(rd_addr_b), .OUT0(out_b),
    .IN7(toMUX[7]), .IN6(toMUX[6]), .IN5(toMUX[5]), .IN4(toMUX[4]), 
	 .IN3(toMUX[3]), .IN2(toMUX[2]), .IN1(toMUX[1]), .IN0(toMUX[0]));
	 


endmodule
