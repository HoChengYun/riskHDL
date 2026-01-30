`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:20:20 11/14/2025 
// Design Name: 
// Module Name:    control 
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
module control(
input [15:0] instr,
input cpu_on, reset, clk, n_flag, z_flag, c_flag, v_flag,
output e_pc, IorD, we_mem, we_ir, rd_read, MtoR, mixMR, PCtoR,
       we_reg, alu_srca, e_flag, pc_src, e_out_r,done,
output [1:0] alu_srcb, alu_ctrl, pc_jp);
wire dff0, dff6, n_dff6, cyc_start, rst_ctrl, rst_xdff0, cal_set, jp_set, mem_set,
     BCC, BCS, BNE, BEQ, BAL, ADD, ADC, SUB, SBB, SUBI, MOV, STRI, STR, CMP, ADDI,
	  LDR, LDRI, LLI, LHI, JMP, JALI, JAL, JR, OUTR, HLT;
wire [5:0] cycle;
//instr input
instr_decoder i0(.instr(instr), .BCC(BCC), .BCS(BCS), .BNE(BNE), .BEQ(BEQ), .BAL(BAL), .ADD(ADD),
                 .ADC(ADC), .SUB(SUB), .SBB(SBB), .SUBI(SUBI), .MOV(MOV), .STRI(STRI), .STR(STR),
					  .CMP(CMP), .ADDI(ADDI), .LDR(LDR), .LDRI(LDRI), .LLI(LLI), .LHI(LHI), .JMP(JMP),
		           .JALI(JALI), .JAL(JAL), .JR(JR), .OUTR(OUTR), .HLT(HLT));
//cycle generate
assign cyc_start = cpu_on&~reset&~d_cpu_on,
       dff0 = cyc_start | rst_ctrl,
		 rst_xdff0 = rst_ctrl | reset,
		 n_dff6 = ~dff6;
DFF_sync_rst c0(.d(dff0), .ce(n_dff6), .clk(clk), .rst(reset), .q(cycle[0]));
DFF_sync_rst c1(.d(cycle[0]), .ce(n_dff6), .clk(clk), .rst(rst_xdff0), .q(cycle[1]));
DFF_sync_rst c2(.d(cycle[1]), .ce(n_dff6), .clk(clk), .rst(rst_xdff0), .q(cycle[2]));
DFF_sync_rst c3(.d(cycle[2]), .ce(n_dff6), .clk(clk), .rst(rst_xdff0), .q(cycle[3]));
DFF_sync_rst c4(.d(cycle[3]), .ce(n_dff6), .clk(clk), .rst(rst_xdff0), .q(cycle[4]));
DFF_sync_rst c5(.d(cycle[4]), .ce(n_dff6), .clk(clk), .rst(rst_xdff0), .q(cycle[5]));
DFF_sync_rst  c6(.d(cycle[5]), .clk(clk), .rst(rst_xdff0), .q(dff6), .ce(1'b1));
DFF_sync_rst  p0(.d(cpu_on), .clk(clk), .rst(reset), .q(d_cpu_on), .ce(1'b1));
//control signal generate
assign e_pc = (BCC&(~c_flag) | BCS&c_flag | BNE&(~z_flag) | BEQ&z_flag | BAL | JMP | JAL | JR)&cycle[3] | 
              JALI&cycle[4] | cycle[0],
		 IorD = (LDR | LDRI)&cycle[4] | we_mem,
		 we_mem = (STR | STRI)&cycle[5],
		 we_ir = cycle[0],
		 rd_read = cycle[2]&(LHI | JR | OUTR) | cycle[4]&(STR | STRI),
		 MtoR = cycle[3]&LHI | cycle[5]&(LDR | LDRI),
		 mixMR = cycle[2]&LLI | cycle[3]&LHI,
		 PCtoR = cycle[2]&(JAL | JALI),
		 cal_set = ADD | ADC | SUB | SBB | ADDI | SUBI, //intenal wire
		 we_reg = cycle[2]&LLI | PCtoR | cycle[3]&(LHI | MOV) | cycle[4]&(cal_set) | cycle[5]&(LDR | LDRI),
		 alu_srca = cycle[3]&(LDR | LDRI | STR | STRI | cal_set | CMP),
		 jp_set = BCC | BCS | BNE | BEQ | BAL, //intenal wire
		 alu_srcb[1] = cycle[2]&jp_set | cycle[3]&(LDRI | STRI | ADDI | SUBI | JALI),
		 alu_srcb[0] = cycle[0] | cycle[2]&jp_set | cycle[3]&JALI,
		 mem_set = LDR | LDRI | STR | STRI, //intenal wire
		 alu_ctrl[1] = cycle[0] | cycle[2]&jp_set | cycle[3]&(mem_set | ADD | SUB | CMP | ADDI | SUBI | JALI),
		 alu_ctrl[0] = cycle[3]&(SUB | SBB | CMP | SUBI),
		 e_flag = cycle[3]&(cal_set | CMP),
		 pc_src = cycle[2]&JMP | cycle[3]&jp_set | cycle[4]&JALI,
		 pc_jp[1] = cycle[3]&(JAL | JR),
		 pc_jp[0] = cycle[2]&JMP | cycle[3]&JR,
		 e_out_r = cycle[3]&OUTR,
		 rst_ctrl = cycle[2]&(LLI | JMP) | cycle[3]&(jp_set | LHI | CMP | MOV | JAL | JR | OUTR) |
		            cycle[4]&(cal_set | JALI) | cycle[5]&mem_set, //intenal wire
		 done = HLT;
endmodule

