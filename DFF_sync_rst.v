`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:13 12/06/2025 
// Design Name: 
// Module Name:    DFF_sync_rst 
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
module DFF_sync_rst
#(parameter WIDTH = 1)(
input  wire                  clk,        // 時脈
input  wire                  rst,        // 同步 reset，高有效
input  wire                  ce,         // clock enable
input  wire [WIDTH-1:0]      d,          // 輸入資料
output reg  [WIDTH-1:0]      q );           // 輸出資料

always @(posedge clk) begin
    if (rst)
        q <= 1'b0;                   // 同步 reset
    else if (ce)
        q <= d;                             // 有 enable 才更新
end

endmodule

