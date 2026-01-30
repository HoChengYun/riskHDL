`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:55:12 11/05/2025 
// Design Name: 
// Module Name:    DFF_16bits 
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
module DFF_16bits
#(parameter N=16)(
input [N-1:0] D,
input C, CE, CLR,
output reg [N-1:0] O);

always @(posedge C or posedge CLR) begin
	if (CLR) 
	    O <= {N{1'b0}};
	else if (CE)
	    O <= D;
	else
	    O <= O;
end

endmodule
