`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:06:33 11/16/2025
// Design Name:   computer
// Module Name:   /media/workdk/riskHDL/computer_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: computer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module computer_rtb;

	// Inputs
	reg [7:0] addr_tb;
	reg [15:0] data_tb;
	reg cpu_on;
	reg reset;
	reg clk;
	reg we_tb;

	// Outputs
	wire [15:0] out_r;
	wire done;

	// Instantiate the Unit Under Test (UUT)
	computer uut (
		.addr_tb(addr_tb), 
		.data_tb(data_tb), 
		.cpu_on(cpu_on), 
		.reset(reset), 
		.clk(clk), 
		.we_tb(we_tb), 
		.out_r(out_r), 
		.done(done)
	);

// Initialize Inputs
initial clk = 0;
always #40 clk = ~clk;

task write_mem(input [7:0] a, input [15:0] w); begin
	we_tb=1; addr_tb=a; data_tb=w; step1();
end endtask

task step1; begin @(posedge clk); #40;end endtask
	 
initial begin
	clk = 0;
	reset = 1;
	cpu_on = 0;
	data_tb = 0;
	addr_tb = 0;
	step1();
	reset = 0;
/*	
	write_mem(16 'h0,16 'b0001_0000_0010_0101 ) ; // LLI R0,#25
	write_mem(16 'h1,16 'b0000_1000_0110_0011 ) ; // LHI R0,#63
	write_mem(16 'h2,16 'b1110_0000_0000_0000 ) ; // OUT R0 (6325H)
	write_mem(16 'h3,16 'b0001_1001_0000_0000 ) ; // LDR R1,R0,#0
	write_mem(16 'h4,16 'b0001_1010_0000_0001 ) ; // LDR R2,R0,#1
	write_mem(16 'h5,16 'b1110_0000_0010_0000 ) ; // OUT R1 (47H)
	write_mem(16 'h6,16 'b1110_0000_0100_0000 ) ; // OUT R2 (89H)
	write_mem(16 'h7,16 'b0000_0011_0010_1000 ) ; // ADD R3,R1,R2
	write_mem(16 'h8,16 'b1110_0000_0110_0000 ) ; // OUT R3 (D0H)
	write_mem(16 'h9,16 'b0000_0011_0010_1010 ) ; // SUB R3,R1,R2
	write_mem(16 'hA,16 'b1110_0000_0110_0000 ) ; // OUT R3 (FFBEH)
	write_mem(16 'hB,16 'b1110_0000_0000_0001 ) ; // HLT
	write_mem(16 'h25,16 'h47 ) ; // data (25h, 47h)
	write_mem(16 'h26,16 'h89 ) ; // data (26h, 89h)
*/


/*
	//  Find the minimum and maximum from two numbers in memory.
	write_mem(8'h00, 16'b0001_0000_0010_0101); // LLI R0,#0x25 (base)
	write_mem(8'h01, 16'b0001_1001_0000_0000); // LDR R1,[R0,#0] (A)
	write_mem(8'h02, 16'b0001_1010_0000_0001); // LDR R2,[R0,#1] (B)
	write_mem(8'h03, 16'b0000_0011_0010_1010); // SUB R3,R1,R2
	write_mem(8'h04, 16'b1100_0010_0000_0101); // BCS label_max
	write_mem(8'h05, 16'b0010_1001_0000_0010); // STR R1,[R0,#2] (min=R1)
	write_mem(8'h06, 16'b0010_1010_0000_0011); // STR R2,[R0,#3] (max=R2)
	write_mem(8'h07, 16'b1110_0000_0010_0000); // OUTR R1
	write_mem(8'h08, 16'b1110_0000_0100_0000); // OUTR R2
	write_mem(8'h09, 16'b1110_0000_0000_0001); // HLT
	// ---- label_max ----
	write_mem(8'h0A, 16'b0010_1010_0000_0010); // STR R2,[R0,#2] (min=R2)
	write_mem(8'h0B, 16'b0010_1001_0000_0011); // STR R1,[R0,#3] (max=R1)
	write_mem(8'h0C, 16'b1110_0000_0100_0000); // OUTR R2
	write_mem(8'h0D, 16'b1110_0000_0010_0000); // OUTR R1
	write_mem(8'h0E, 16'b1110_0000_0000_0001); // HLT
	// ============================================================

	// 初始化資料
	write_mem(8'h25, 16'h0026); // A
	write_mem(8'h26, 16'h0020); // B
*/
/*
	// Add two numbers in memory and store the result in another memory location.
	write_mem(8'h00, 16'b0001_0000_0010_0101); // LLI  R0,#0x25
	write_mem(8'h01, 16'b0001_1001_0000_0000); // LDR  R1,[R0,#0]
	write_mem(8'h02, 16'b0001_1010_0000_0001); // LDR  R2,[R0,#1]
	write_mem(8'h03, 16'b0000_0011_0100_0100); // ADD  R3,R1,R2
	write_mem(8'h04, 16'b0010_1011_0000_0010); // STR  R3,[R0,#2]
	write_mem(8'h05, 16'b0001_1100_0000_0010); // LDRI R4 [R0,#2]
	write_mem(8'h06, 16'b1110_0000_1000_0000); // OUTR R4
	write_mem(8'h07, 16'b1110_0000_0000_0001); // HLT
	// ==================================================

	// ===================== 資料區 ======================
	write_mem(8'h25, 16'h0047); // A = 0x0047 (十進制 71)
	write_mem(8'h26, 16'h0089); // B = 0x0089 (十進制 137)
	// 結果會寫進 Mem[0x27] = A+B = 0x00D0
	// ==================================================
*/
/*
	// Add ten numbers in consecutive memory locations.
	write_mem(8'h00, 16'b0001_0000_0010_0101); // LLI  R0,#0x25
	write_mem(8'h01, 16'b0001_0001_0000_0000); // LLI  R1,#0x00
	write_mem(8'h02, 16'b0001_0010_0000_0000); // LLI  R2,#0x00
	write_mem(8'h03, 16'b0001_0100_0000_1010); // LLI  R4,#0x0A
	write_mem(8'h04, 16'b0001_0101_0000_0001); // LLI  R5,#0x01

	// loop:
	write_mem(8'h05, 16'b0001_1110_0000_0000); // LDR  R6,[R0,#0]
	write_mem(8'h06, 16'b0000_0001_0011_1000); // 00000 001 001 110 00  → d=R1 m=R1 n=R6 ss=00
	write_mem(8'h07, 16'b0000_0000_0001_0100); // ADD  R0,R0,R5  → 00000 000 000 101 00
	write_mem(8'h08, 16'b0000_0010_0101_0100); // ADD  R2,R2,R5  → 00000 010 010 101 00
	write_mem(8'h09, 16'b0011_0000_0101_0001); // CMP  R2, R4
	write_mem(8'h0A, 16'b1100_0001_1111_1010); // BNE  loop      → disp8 = 1111_1010 (=-6) 跳回 0x05

	// done:
	write_mem(8'h0B, 16'b0010_1001_0000_0000); // STR  R1,[R0,#0] ; 此時 R0=base+10 → 存到 0x2F
	write_mem(8'h0C, 16'b1110_0000_0010_0000); // OUTR R1
	write_mem(8'h0D, 16'b1110_0000_0000_0001); // HLT
	// =============================================

	// ================ data @ 0x25 ================
	write_mem(8'h25, 16'h0001);
	write_mem(8'h26, 16'h0002);
	write_mem(8'h27, 16'h0003);
	write_mem(8'h28, 16'h0004);
	write_mem(8'h29, 16'h0005);
	write_mem(8'h2A, 16'h0006);
	write_mem(8'h2B, 16'h0007);
	write_mem(8'h2C, 16'h0008);
	write_mem(8'h2D, 16'h0009);
	write_mem(8'h2E, 16'h000A);
	// 結果會寫進 0x2F（應為 0x0037 = 55）
*/

	//Mov a memory block of N words from one place to another.
	write_mem(8'h00, 16'b0001_0000_0011_0000); // LLI  R0,#0x30   ; src
	write_mem(8'h01, 16'b0001_0001_0100_0000); // LLI  R1,#0x40   ; dst
	write_mem(8'h02, 16'b00010_011_0100_0000); // LLI  R3,#0x40   ; dst const
	write_mem(8'h03, 16'b0001_0010_0000_0000); // LLI  R2,#0x00   ; i=0
	write_mem(8'h04, 16'b0001_0100_0000_0101); // LLI  R4,#0x05   ; N=5
	write_mem(8'h05, 16'b0001_0101_0000_0001); // LLI  R5,#0x01   ; const 1
	
	// ----- copy loop: 搬 N 筆 src→dst -----
	write_mem(8'h06, 16'b00011_110_0000_0000); // LDR  R6,[R0,#0] ; R6=*R0
	write_mem(8'h07, 16'b00101_110_001_00000); // STR  R6,[R1,#0] ; *R1=R6
	
	// ALU per Table 1: 00000 ddd mmm nnn ss
	write_mem(8'h08, 16'b0000_0000_0001_0100); // ADD  R0,R0,R5 
	write_mem(8'h09, 16'b0000_0001_0011_0100); // ADD  R1,R1,R5
	write_mem(8'h0A, 16'b0000_0010_0101_0100); // ADD  R2,R2,R5
	write_mem(8'h0B, 16'b00110_000_010_100_01); // CMP R2,R4
	write_mem(8'h0C, 16'b1100_0001_1111_1001); // BNE disp8=0xF9=-7 回到 H06
	
	//Print dst data
	write_mem(8'h0D, 16'b00011_111_011_00000); //LDR R7 [R3,#0]
	write_mem(8'h0E, 16'b11100_000_111_000_00); // OUTR R7
	write_mem(8'h0F, 16'b00011_111_011_00001); //LDR R7 [R3,#1]
	write_mem(8'h10, 16'b11100_000_111_000_00); // OUTR R7
	write_mem(8'h11, 16'b00011_111_011_00010); //LDR R7 [R3,#2]
	write_mem(8'h12, 16'b11100_000_111_000_00); // OUTR R7
	write_mem(8'h13, 16'b00011_111_011_00011); //LDR R7 [R3,#3]
	write_mem(8'h14, 16'b11100_000_111_000_00); // OUTR R7
	write_mem(8'h15, 16'b00011_111_011_00100); //LDR R7 [R3,#4]
	write_mem(8'h16, 16'b11100_000_111_000_00); // OUTR R7
	write_mem(8'h17, 16'b1110_0000_0000_0001); // HLT
	// =============================================

	// ================ data (hex) =================
	// src @ 0x30..0x34
	write_mem(8'h30, 16'h5487);
	write_mem(8'h31, 16'h6666);
	write_mem(8'h32, 16'h00FF);
	write_mem(8'h33, 16'h0BED);
	write_mem(8'h34, 16'hABCD);
	// dst @ 0x40..0x44 (initially zero)
	write_mem(8'h40, 16'h0000);
	write_mem(8'h41, 16'h0000);
	write_mem(8'h42, 16'h0000);
	write_mem(8'h43, 16'h0000);
	write_mem(8'h44, 16'h0000);

	//open
	cpu_on = 1;
	step1();
	wait(done);
	step1();
	$finish;
end
      
endmodule

