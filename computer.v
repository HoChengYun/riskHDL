`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:42:28 11/16/2025 
// Design Name: 
// Module Name:    computer 
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
module computer(
input [7:0] addr_tb,
input [15:0] data_tb,
input cpu_on, reset, clk, we_tb,
output [15:0] out_r,
output done);
wire [15:0] instr;
wire n_flag, z_flag, c_flag, v_flag,
     e_pc, IorD, we_mem, we_ir, rd_read, MtoR, mixMR, PCtoR,
     we_reg, alu_srca, e_flag, pc_src, e_out_r;
wire [1:0] alu_srcb, alu_ctrl, pc_jp;

control c0(.instr(instr), .cpu_on(cpu_on), .reset(reset), .clk(clk), .n_flag(n_flag),
           .z_flag(z_flag), .c_flag(c_flag), .v_flag(v_flag), .e_pc(e_pc), .IorD(IorD),
			  .we_mem(we_mem), .we_ir(we_ir), .rd_read(rd_read), .MtoR(MtoR), .mixMR(mixMR),
			  .PCtoR(PCtoR), .we_reg(we_reg), .alu_srca(alu_srca), .e_flag(e_flag),
			  .pc_src(pc_src), .e_out_r(e_out_r), .done(done), .alu_srcb(alu_srcb), 
           .alu_ctrl(alu_ctrl), .pc_jp(pc_jp));

datapath d0(.data_tb(data_tb), .addr_tb(addr_tb), .alu_ctrl(alu_ctrl), .alu_srcb(alu_srcb), .pc_jp(pc_jp),
            .e_pc(e_pc), .rst_pc(reset), .clk(clk), .IorD(IorD), .we_tb(we_tb), 
				.we_mem(we_mem), .cpu_on(cpu_on), .we_ir(we_ir), .mixMR(mixMR), .MtoR(MtoR),
            .rd_read(rd_read), .PCtoR(PCtoR), .we_reg(we_reg), .alu_srca(alu_srca),
				.e_flag(e_flag), .pc_src(pc_src), .e_out_r(e_out_r), .instr(instr),
				.out_r(out_r), .n_flag(n_flag), .z_flag(z_flag), .c_flag(c_flag), .v_flag(v_flag));

endmodule
