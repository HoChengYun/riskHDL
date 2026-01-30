`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:25:40 11/12/2025 
// Design Name: 
// Module Name:    datapath 
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
module datapath(
input [15:0] data_tb,
input [7:0] addr_tb,
input [1:0] alu_ctrl, alu_srcb, pc_jp,
input e_pc, rst_pc, clk, IorD, we_tb, we_mem, cpu_on, we_ir, mixMR, MtoR,
      rd_read, PCtoR, we_reg, alu_srca, e_flag, pc_src, e_out_r,
output [15:0] instr, out_r,
output n_flag, z_flag, c_flag, v_flag);

wire [15:0] JPSET_out, PC_out, IorD_in1, 
            MEM_addr, MEM_data_in, MEM_out, MEM_out_data,
				ALU_wr_data, MtoR_out, ALU_out, ALU_out_dff,
				rd_a, rd_b, JPSET_in0, we_mem_in0, we_mem_in1,
				zzd8, d8rd, jpbit;
wire [2:0] ALU_addrb;
wire high, low;
assign high = 1'b1,
       low = 1'b0;
//pc
pc_circuit p0(.pc_pre(JPSET_out), .pc_ld(e_pc), .pc_rst(rst_pc), .clk(clk), .pc(PC_out));

//instr or data
assign MEM_addr = IorD ?  IorD_in1 : PC_out;

//mem
mem_256x16 m0(.addr_wa(addr_tb), .addr_wb(MEM_addr[7:0]), .data_wa(data_tb), .data_wb(MEM_data_in), 
              .we_a(we_tb), .we_b(we_mem), .port_sel(cpu_on), .clk(clk), .data_q(MEM_out));
				  
//dff
DFF_16bits di(.D(MEM_out), .C(clk), .CE(we_ir), .CLR(low), .O(instr));
DFF_16bits dm(.D(MEM_out), .C(clk), .CE(high), .CLR(low), .O(MEM_out_data));

//instr process
assign ALU_addrb = rd_read ? instr[10:8] : instr[4:2],
       ALU_wr_data = PCtoR ? MEM_data_in : MtoR_out,
		 MtoR_out = mixMR ? (MtoR ? d8rd : zzd8)
		                  : (MtoR ? MEM_out_data : ALU_out_dff);
//rf + alu
RF_plus_ALU_16bits r0(.pc(PC_out), .rd_addr_a(instr[7:5]), .rd_addr_b(ALU_addrb), .wr_addr(instr[10:8]), .wr_data(ALU_wr_data),
                      .alu_srca(alu_srca), .alu_srcb(alu_srcb), .alu_ctrl(alu_ctrl), .instr(instr[7:0]), .wr_e(we_reg),
							 .e_flag(e_flag), .clk(clk), .clr(low), .alu_out(ALU_out), .n(n_flag), .z(z_flag), .c(c_flag), .v(v_flag),
							 .mem_wd(MEM_data_in), .rd_a(rd_a), .rd_b(rd_b));
//dff
DFF_16bits da(.D(ALU_out), .C(clk), .CE(high), .CLR(low), .O(ALU_out_dff));
//to pc in
assign JPSET_in0 = pc_src ? ALU_out_dff : ALU_out,
       JPSET_out = pc_jp[1] ? (pc_jp[0] ? rd_b : rd_a)
		                      : (pc_jp[0] ? jpbit : JPSET_in0);
//to pc out
DFF_16bits dc(.D(ALU_out_dff), .C(clk), .CE(high), .CLR(low), .O(we_mem_in1));
assign IorD_in1 = we_mem ? we_mem_in1 : ALU_out_dff;

//out r
DFF_16bits dr(.D(rd_a), .C(clk), .CE(e_out_r), .CLR(low), .O(out_r));

//wire merge
assign zzd8 = {8'h00, instr[7:0]},
       d8rd = {instr[7:0], rd_b[7:0]},
		 jpbit = {MEM_addr[15:11], instr[12:2]};

endmodule



