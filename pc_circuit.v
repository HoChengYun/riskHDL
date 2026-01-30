`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:08:17 11/12/2025 
// Design Name: 
// Module Name:    pc_circuit 
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
module pc_circuit(
input [15:0] pc_pre,
input pc_ld, pc_rst, clk,
output [15:0] pc);

DFF_16bits p1(.D(pc_pre), .C(clk), .CE(pc_ld), .CLR(pc_rst), .O(pc));

endmodule
