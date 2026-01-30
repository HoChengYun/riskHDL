`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:48:50 11/12/2025
// Design Name:   datapath
// Module Name:   /media/workdk/riskHDL/datapath_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: datapath
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module datapath_rtb;

	// Inputs
	reg [15:0] data_tb;
	reg [7:0] addr_tb;
	reg [1:0] alu_ctrl;
	reg [1:0] alu_srcb;
	reg [1:0] pc_jp;
	reg e_pc;
	reg rst_pc;
	reg clk;
	reg IorD;
	reg we_tb;
	reg we_mem;
	reg cpu_on;
	reg we_ir;
	reg mixMR;
	reg MtoR;
	reg rd_read;
	reg PCtoR;
	reg we_reg;
	reg alu_srca;
	reg e_flag;
	reg pc_src;
	reg e_out_r;

	// Outputs
	wire [15:0] instr;
	wire [15:0] out_r;
	wire n_flag;
	wire z_flag;
	wire c_flag;
	wire v_flag;

	// Instantiate the Unit Under Test (UUT)
	datapath uut (
		.data_tb(data_tb), 
		.addr_tb(addr_tb), 
		.alu_ctrl(alu_ctrl), 
		.alu_srcb(alu_srcb), 
		.pc_jp(pc_jp), 
		.e_pc(e_pc), 
		.rst_pc(rst_pc), 
		.clk(clk), 
		.IorD(IorD), 
		.we_tb(we_tb), 
		.we_mem(we_mem), 
		.cpu_on(cpu_on), 
		.we_ir(we_ir), 
		.mixMR(mixMR), 
		.MtoR(MtoR), 
		.rd_read(rd_read), 
		.PCtoR(PCtoR), 
		.we_reg(we_reg), 
		.alu_srca(alu_srca), 
		.e_flag(e_flag), 
		.pc_src(pc_src), 
		.e_out_r(e_out_r), 
		.instr(instr), 
		.out_r(out_r), 
		.n_flag(n_flag), 
		.z_flag(z_flag), 
		.c_flag(c_flag), 
		.v_flag(v_flag)
	);
// Initialize Inputs
   // clock
  initial clk = 0;
  always #40 clk = ~clk;

  // helpers
  task write_mem(input [7:0] a, input [15:0] w); begin
    cpu_on=0; we_tb=1; addr_tb=a; data_tb=w; step1();
    we_tb=0; cpu_on=1; step1();
  end endtask
  task step1; begin @(posedge clk); #40;end endtask

  // 安全預設
  task idle_ctrl; begin
    IorD=0; we_mem=0; we_ir=0; we_reg=0; MtoR=0; e_pc=0; pc_src=0;
    alu_srca=0; alu_srcb=2'b00; alu_ctrl=2'b10; rd_read = 0;
  end endtask

  // 共用：取指一拍 (PC <- PC+1)
  task FETCH; begin
	 e_pc=1; IorD=0; we_mem=0; rd_read=0; pc_src=0;
	 we_ir = 1; we_reg=0; 
	 alu_srca=0; alu_srcb=2'b01; alu_ctrl=2'b10;  
	 e_out_r = 0;
	 step1();
  end endtask  

  initial begin
    // reset
	 we_ir = 0;

	 e_out_r = 0;
	 e_flag = 0;
	 pc_jp = 0;
	 PCtoR = 0;
    {MtoR,rd_read,mixMR,we_tb,we_mem,rst_pc,e_pc,cpu_on,IorD,we_reg} = 0;
    alu_ctrl=10; alu_srca=0; alu_srcb=0; pc_src=0; addr_tb=0; data_tb=0;
    rst_pc=1; step1(); rst_pc=0; cpu_on=1; idle_ctrl();

    // ========== 寫入「指令」與「資料」(示範) ==========
	write_mem(8'h00, 16'b0001_0000_0010_0101); // LLI R0,#25
	write_mem(8'h01, 16'b0000_1000_0110_0011); // LHI R0,#63
	write_mem(8'h02, 16'b1110_0000_0000_0000); // OUT R0
	write_mem(8'h03, 16'b0001_1001_0000_0000); // LDR R1,R0,#0
	write_mem(8'h04, 16'b0001_1010_0000_0001); // LDR R2,R0,#1
	write_mem(8'h05, 16'b1110_0000_0010_0000); // OUT R1 (47H)
	write_mem(8'h06, 16'b1110_0000_0100_0000); // OUT R2 (89H)
	write_mem(8'h07, 16'b0000_0011_0010_1000); // ADD R3,R1,R2
	write_mem(8'h08, 16'b1110_0000_0110_0000); // OUT R3 (D0H)
	write_mem(8'h09, 16'b0000_0011_0010_1010); // SUB R3,R1,R2
	write_mem(8'h0A, 16'b1110_0000_0110_0000); // OUT R3 (FFBEH)
	write_mem(8'h0B, 16'b1100_0000_1111_1100); // BNE -4
	//write_mem(16'hB, 16'b1110_0000_0000_0001); // HLT 
	write_mem(8'h25, 16'h47); // data (25h, 47h)
	write_mem(8'h26, 16'h89); // data (26h, 89h)

	 //start
	 rst_pc=1; step1();
	 //LLI R0,#69
	 // C1 FETCH
	 rst_pc=0;
	 FETCH();
	 //C2 decode
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //C3 write r0
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 mixMR = 1;
	 MtoR = 0;
	 we_reg = 1; 
	 step1();
	 //LHI R0,#52=======================
	 //C1 FETCH
	 FETCH();
	 //C2 decode
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //C3 read r0
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 rd_read = 1;
	 step1();
	 //C4 write r0
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 mixMR = 1;
	 MtoR = 1;
	 we_reg = 1;
	 step1();
	 //OUT R0============================
	 //C1 FETCH
	 FETCH();
	 //C2 decode
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //c3 read r0
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //c4 write outr
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 e_out_r = 1;
	 step1();
	 //LDR R1,R0,#0===================
	 //C1 FETCH
	 FETCH();
	 //C2 decode
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //c3 read r0
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //c4 r0 + imm5
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 alu_srca = 1;
	 alu_srcb = 2'b10;
	 alu_ctrl = 2'b10;
	 step1();
	 //read mem
	 e_pc = 0;
	 IorD = 1;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //write rd
	 e_pc = 0;
	 IorD = 1;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 1;
	 MtoR = 1;
	 mixMR = 0;
	 step1();
	 //LDR R2,R0,#1===================
	 //fetch
	 e_pc = 1;
	 rst_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 cpu_on = 1;
	 we_ir = 1;
	 rd_read = 0;
	 MtoR = 0;
	 mixMR = 0;
	 PCtoR = 0;
	 we_reg = 0;
	 alu_srca = 0;
	 alu_srcb = 1;
	 alu_ctrl = 2;
	 e_flag  = 0 ;
	 pc_src = 0;
	 pc_jp = 0;
	 e_out_r = 0;
	 step1();
	 //decode
	 e_pc = 0;
	 rst_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 cpu_on = 1;
	 we_ir = 0;
	 rd_read = 0;
	 MtoR = 0;
	 mixMR = 0;
	 PCtoR = 0;
	 we_reg = 0;
	 alu_srca = 0;
	 alu_srcb = 0;
	 alu_ctrl = 0;
	 e_flag  = 0 ;
	 pc_src = 0;
	 pc_jp = 0;
	 e_out_r = 0;
	 step1();
	 //read
	 step1();
	 //cal
	 e_pc = 0;
	 rst_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 cpu_on = 1;
	 we_ir = 0;
	 rd_read = 0;
	 MtoR = 0;
	 mixMR = 0;
	 PCtoR = 0;
	 we_reg = 0;
	 alu_srca = 1;
	 alu_srcb = 2;
	 alu_ctrl = 2;
	 e_flag  = 1;
	 pc_src = 0;
	 pc_jp = 0;
	 e_out_r = 0;
	 step1();
	 //mem read
	 e_pc = 0;
	 rst_pc = 0;
	 IorD = 1;
	 we_mem = 0;
	 cpu_on = 1;
	 we_ir = 0;
	 rd_read = 0;
	 MtoR = 0;
	 mixMR = 0;
	 PCtoR = 0;
	 we_reg = 0;
	 alu_srca = 0;
	 alu_srcb = 0;
	 alu_ctrl = 0;
	 e_flag  = 0 ;
	 pc_src = 0;
	 pc_jp = 0;
	 e_out_r = 0;
	 step1();
	 //write rd
	 e_pc = 0;
	 rst_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 cpu_on = 1;
	 we_ir = 0;
	 rd_read = 0;
	 MtoR = 1;
	 mixMR = 0;
	 PCtoR = 0;
	 we_reg = 1;
	 alu_srca = 0;
	 alu_srcb = 0;
	 alu_ctrl = 0;
	 e_flag  = 0 ;
	 pc_src = 0;
	 pc_jp = 0;
	 e_out_r = 0;
	 step1();
	 //OUT R1============================
	 //C1 FETCH
	 FETCH();
	 //C2 decode
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //c3 read r0
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 e_out_r = 1;
	 step1();
	 //OUT R2============================
	 //C1 FETCH
	 FETCH();
	 //C2 decode
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //c3 read r0
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //c4 write outr
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 e_out_r = 1;
	 step1();
	 //ADD R3,R1,R2============================
	 //C1 FETCH
	 FETCH();
	 //C2 decode
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //c3 read r1, r2
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 rd_read = 0;
	 step1();
	 //c4 r1+r2
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 alu_srca = 1;
	 alu_srcb = 2'b00;
	 alu_ctrl = 2'b10;
	 step1();
	 //c5 write r3
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 1;
	 MtoR = 0;
	 mixMR = 0;
	 step1();
	 //OUT R3============================
	 //C1 FETCH
	 FETCH();
	 //C2 decode
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //c3 read r0
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //c4 write outr
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 e_out_r = 1;
	 step1();
    //SUB R3,R1,R2============================
	 //C1 FETCH
	 FETCH();
	 //C2 decode
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //c3 read r1, r2
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 rd_read = 0;
	 step1();
	 //c4 r1+r2
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 alu_srca = 1;
	 alu_srcb = 2'b00;
	 alu_ctrl = 2'b11;
	 e_flag = 1;
	 step1();
	 //c5 write r3
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 1;
	 MtoR = 0;
	 mixMR = 0;
	 e_flag = 0;
	 step1();
	 //OUT R3============================
	 //C1 FETCH
	 FETCH();
	 //C2 decode
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //c3 read r0
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 step1();
	 //c4 write outr
	 e_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 we_ir = 0;
	 we_reg = 0;
	 e_out_r = 1;
	 step1();
	 //BNE===================================
	 //fetch
	 e_pc = 1;
	 rst_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 cpu_on = 1;
	 we_ir = 1;
	 rd_read = 0;
	 MtoR = 0;
	 mixMR = 0;
	 PCtoR = 0;
	 we_reg = 0;
	 alu_srca = 0;
	 alu_srcb = 1;
	 alu_ctrl = 2;
	 e_flag  = 0 ;
	 pc_src = 0;
	 pc_jp = 0;
	 e_out_r = 0;
	 step1();
	 //done = 0;
	 //decode
	 e_pc = 0;
	 rst_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 cpu_on = 1;
	 we_ir = 0;
	 rd_read = 0;
	 MtoR = 0;
	 mixMR = 0;
	 PCtoR = 0;
	 we_reg = 0;
	 alu_srca = 0;
	 alu_srcb = 0;
	 alu_ctrl = 0;
	 e_flag  = 0 ;
	 pc_src = 0;
	 pc_jp = 0;
	 e_out_r = 0;
	 step1();
	 //done = 0;	 
	 //alu_cal
	 e_pc = 0;
	 rst_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 cpu_on = 1;
	 we_ir = 0;
	 rd_read = 0;
	 MtoR = 0;
	 mixMR = 0;
	 PCtoR = 0;
	 we_reg = 0;
	 alu_srca = 0;
	 alu_srcb = 3;
	 alu_ctrl = 2;
	 e_flag  = 1;
	 pc_src = 0;
	 pc_jp = 0;
	 e_out_r = 0;
	 step1();
	 //done = 0;
	 //update pc
	 e_pc = ~z_flag;
	 rst_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 cpu_on = 1;
	 we_ir = 0;
	 rd_read = 0;
	 MtoR = 0;
	 mixMR = 0;
	 PCtoR = 0;
	 we_reg = 0;
	 alu_srca = 0;
	 alu_srcb = 0;
	 alu_ctrl = 0;
	 e_flag  = 0 ;
	 pc_src = 1;
	 pc_jp = 0;
	 e_out_r = 0;
	 step1();
	 //FETCH==========================
	 //fetch
	 e_pc = 1;
	 rst_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 cpu_on = 1;
	 we_ir = 1;
	 rd_read = 0;
	 MtoR = 0;
	 mixMR = 0;
	 PCtoR = 0;
	 we_reg = 0;
	 alu_srca = 0;
	 alu_srcb = 1;
	 alu_ctrl = 2;
	 e_flag  = 0 ;
	 pc_src = 0;
	 pc_jp = 0;
	 e_out_r = 0;
	 step1();
	 //done = 0;
	 //decode
	 e_pc = 0;
	 rst_pc = 0;
	 IorD = 0;
	 we_mem = 0;
	 cpu_on = 1;
	 we_ir = 0;
	 rd_read = 0;
	 MtoR = 0;
	 mixMR = 0;
	 PCtoR = 0;
	 we_reg = 0;
	 alu_srca = 0;
	 alu_srcb = 0;
	 alu_ctrl = 0;
	 e_flag  = 0 ;
	 pc_src = 0;
	 pc_jp = 0;
	 e_out_r = 0;
	 step1();
	 //done = 0;	
	 //HLT==================================
	 $finish;
	end

      
endmodule

