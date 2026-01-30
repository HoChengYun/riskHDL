`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:52:17 11/04/2025 
// Design Name: 
// Module Name:    mux_8to1 
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
module mux_8to1(
input I0, I1, I2, I3, I4, I5, I6, I7,
input B0, B1, B2,
output reg O);

always @(*) begin
case ({B2,B1,B0})
3'b000:O=I0;
3'b001:O=I1;
3'b010:O=I2;
3'b011:O=I3;
3'b100:O=I4;
3'b101:O=I5;
3'b110:O=I6;
3'b111:O=I7;
default:O=1'b0;
endcase
end

endmodule
