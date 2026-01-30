`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:29:06 11/05/2025
// Design Name:   RF_plus_ALU_16bits
// Module Name:   /media/workdk/riskHDL/RF_plus_ALU_16bits_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RF_plus_ALU_16bits
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module RF_plus_ALU_16bits_rtb;

	// Inputs
	reg [15:0] wr_data;
	reg [15:0] pc;
	reg [7:0] instr;
	reg [2:0] wr_addr;
	reg [2:0] rd_addr_a;
	reg [2:0] rd_addr_b;
	reg [1:0] alu_srcb;
	reg [1:0] alu_ctrl;
	reg wr_e;
	reg e_flag;
	reg alu_srca;
	reg clr;
	reg clk;

	// Outputs
	wire [15:0] rd_a;
	wire [15:0] rd_b;
	wire [15:0] alu_out;
	wire [15:0] mem_wd;
	wire c;
	wire n;
	wire z;
	wire v;

	// Instantiate the Unit Under Test (UUT)
	RF_plus_ALU_16bits uut (
		.wr_data(wr_data), 
		.pc(pc), 
		.instr(instr), 
		.wr_addr(wr_addr), 
		.rd_addr_a(rd_addr_a), 
		.rd_addr_b(rd_addr_b), 
		.alu_srcb(alu_srcb), 
		.alu_ctrl(alu_ctrl), 
		.wr_e(wr_e), 
		.e_flag(e_flag), 
		.alu_srca(alu_srca), 
		.clr(clr), 
		.clk(clk), 
		.rd_a(rd_a), 
		.rd_b(rd_b), 
		.alu_out(alu_out), 
		.mem_wd(mem_wd), 
		.c(c), 
		.n(n), 
		.z(z), 
		.v(v)
	);

// Initialize Inputs
always begin
    #20 clk = ~clk; 
end

initial begin
    e_flag = 1;
    wr_addr = 0;
    rd_addr_a = 0;
    rd_addr_b = 0;
    wr_data = 0;
    wr_e = 0;
    clr = 1;  // 初始時先reset
    clk = 0;
    alu_srca = 0;
    pc = 0;
    alu_srcb = 0;
	 alu_ctrl = 0;
	 instr = 0;
    
    @(posedge clk); @(posedge clk); 
	 #20
	 clr = 0;
    
    // 測試1: 寫入R1
    wr_e = 1;           // 啟用寫入
    wr_addr = 3'b001;   // 寫入地址 R1
    wr_data = 16'h1234; // 寫入
	 @(posedge clk);
    #20;  
    // 測試2: 寫入R2
    wr_e = 1;           // 啟用寫入
    wr_addr = 3'b010;   // 寫入地址 R2
    wr_data = 16'h1111; // 寫入
	 @(posedge clk);
    #20;	 
    
    // 測試3: R1+R2 預期得到alu_out = 2345
    wr_e = 0;           // 禁用寫入
    rd_addr_a = 3'b001; // 讀取 R1
    rd_addr_b = 3'b010; // 讀取 R2
    alu_srca = 1;       // 選擇REG OUTA作為ALU輸入
    alu_srcb = 2'b00;   // 選擇REG OUTB作為ALU輸入
    alu_ctrl = 2'b10;   // 選擇ALU操作
    @(posedge clk);
    #20;
    
    // 測試4: R2+imm5 預期得到alu_out = 1115
    wr_e = 0;           // 禁用寫入
    rd_addr_a = 3'b010; // 讀取 R2
    rd_addr_b = 3'b010; // 讀取 R2
	 instr = 8'b00000100;// imm5 = 4
    alu_srca = 1;       // 選擇REG OUTA作為ALU輸入
    alu_srcb = 2'b10;   // 選擇imm5作為ALU輸入
    alu_ctrl = 2'b10;   // 選擇ALU操作
    @(posedge clk);
    #20;
    
    // 測試5: 測試PC相關操作 預期得到alu_out = 1001
    pc = 16'h1000;      // 設置PC值
    alu_srca = 0;       // 選擇PC作為ALU輸入
    alu_srcb = 2'b01;   // 選擇+1作為ALU輸入	 
    @(posedge clk);
    #20;
    
    // 測試6: R2+disp8 預期得到alu_out = 1268
    wr_e = 0;           // 禁用寫入
    rd_addr_a = 3'b001; // 讀取 R1
    rd_addr_b = 3'b001; // 讀取 R1
	 instr = 8'b00110100;// disp8 = h34
    alu_srca = 1;       // 選擇REG OUTA作為ALU輸入
    alu_srcb = 2'b11;   // 選擇disp8作為ALU輸入
    alu_ctrl = 2'b10;   // 選擇ALU操作
    @(posedge clk);
    #20;
    
    // 結束測試
    #40 $finish;
end

endmodule

