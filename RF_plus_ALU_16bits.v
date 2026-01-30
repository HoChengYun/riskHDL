`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:37:49 11/05/2025 
// Design Name: 
// Module Name:    RF_plus_ALU_16bits 
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
module RF_plus_ALU_16bits(
input [15:0] wr_data, pc,
input [7:0] instr,
input [2:0] wr_addr, rd_addr_a, rd_addr_b,
input [1:0] alu_srcb, alu_ctrl,
input wr_e, e_flag, alu_srca, clr, clk,
output [15:0] rd_a, rd_b, alu_out, mem_wd,
output c, n, z, v);

//rd_a trans :regfiles -> dff -> dffA -> srcAtoALU
wire [15:0] dffA, dffB, srcAtoALU, srcBtoALU, srcBD2, srcBD3;
wire nn, zz, cc, vv;
parameter vcc = 1'b1,
          gnd = 1'b0;
//regfiles
reg_files r0(.din(wr_data), .wr_addr(wr_addr),
.rd_addr_a(rd_addr_a), .rd_addr_b(rd_addr_b),
.wr_E(wr_e), .CLK(clk), .CLR(clr), .out_a(rd_a), .out_b(rd_b));

//lock - after read regfile
DFF_16bits RtoMa(.D(rd_a), .C(clk), .CE(vcc), .CLR(gnd), .O(dffA));
DFF_16bits RtoMb(.D(rd_b), .C(clk), .CE(vcc), .CLR(gnd), .O(dffB));

//sel pc or reg
assign srcAtoALU = (alu_srca)? dffA : pc,
       srcBtoALU = (alu_srcb==2'b00) ? dffB :
		             (alu_srcb==2'b01) ? 16'h0001 :
						 (alu_srcb==2'b10) ? srcBD2 :srcBD3 ,
		 srcBD2 = {11'b0, instr[4:0]}, //0..+imm5
		 srcBD3 = {{8{instr[7]}}, instr}, // signextend + disp8
//back to memory
       mem_wd = dffB;
		 
//to ALU
ALU_16bits a0(.a(srcAtoALU), .b(srcBtoALU), .alu_ctrl(alu_ctrl), .c_pre(c),
.s(alu_out), .z(zz), .c(cc), .n(nn), .v(vv));

//lock flags
DFF_16bits #(1) fn(.D(nn), .C(clk), .CE(e_flag), .CLR(clr), .O(n));
DFF_16bits #(1) fz(.D(zz), .C(clk), .CE(e_flag), .CLR(clr), .O(z));
DFF_16bits #(1) fc(.D(cc), .C(clk), .CE(e_flag), .CLR(clr), .O(c));
DFF_16bits #(1) fv(.D(vv), .C(clk), .CE(e_flag), .CLR(clr), .O(v));

endmodule
