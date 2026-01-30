`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:13:37 11/05/2025 
// Design Name: 
// Module Name:    mem_256x16 
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
module mem_256x16(
input clk, we_a, we_b, port_sel,
input [7:0] addr_wa, addr_wb,
input [15:0] data_wa, data_wb,
output reg [15:0] data_q);

reg [15:0] mem [255:0];
reg [15:0] d;
reg [7:0] addr;
reg we;
integer i;

always @(*)begin
    if (port_sel) begin
	     d = data_wb; we = we_b; addr = addr_wb;
	 end else begin 
	     d = data_wa; we = we_a; addr = addr_wa;
	 end
	 data_q = mem[addr];
end

always @(posedge clk)begin
    if (we) mem[addr] <= d;
end

endmodule
