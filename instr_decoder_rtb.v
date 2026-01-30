`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:08:10 11/14/2025
// Design Name:   instr_decoder
// Module Name:   /media/workdk/riskHDL/instr_decoder_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: instr_decoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module instr_decoder_rtb;

	// Inputs
	reg [15:0] instr;

	// Outputs
	wire BCC;
	wire BCS;
	wire BNE;
	wire BEQ;
	wire BAL;
	wire ADD;
	wire ADC;
	wire SUB;
	wire SBB;
	wire SUBI;
	wire MOV;
	wire STRI;
	wire STR;
	wire CMP;
	wire ADDI;
	wire LDR;
	wire LDRI;
	wire LLI;
	wire LHI;
	wire JMP;
	wire JALI;
	wire JAL;
	wire JR;
	wire OUTR;
	wire HLT;

	// Instantiate the Unit Under Test (UUT)
	instr_decoder uut (
		.instr(instr), 
		.BCC(BCC), 
		.BCS(BCS), 
		.BNE(BNE), 
		.BEQ(BEQ), 
		.BAL(BAL), 
		.ADD(ADD), 
		.ADC(ADC), 
		.SUB(SUB), 
		.SBB(SBB), 
		.SUBI(SUBI), 
		.MOV(MOV), 
		.STRI(STRI), 
		.STR(STR), 
		.CMP(CMP), 
		.ADDI(ADDI), 
		.LDR(LDR), 
		.LDRI(LDRI), 
		.LLI(LLI), 
		.LHI(LHI), 
		.JMP(JMP), 
		.JALI(JALI), 
		.JAL(JAL), 
		.JR(JR), 
		.OUTR(OUTR), 
		.HLT(HLT)
	);
// Initialize Inputs
  integer error_cnt = 0;

  task WAIT; begin #40; end endtask 

  task CHECK1; input cond; input [127:0] name;
  begin
    if (!cond) begin
      error_cnt = error_cnt + 1;
      $display("[%0t] FAIL: %s", $time, name);
    end else begin
      $display("[%0t] PASS: %s", $time, name);
    end
  end
  endtask

  // ==========================
  localparam [4:0] OPC_ALU   = 5'b00000;
  localparam [4:0] OPC_LHI   = 5'b00001;
  localparam [4:0] OPC_LLI   = 5'b00010;
  localparam [4:0] OPC_LDRI  = 5'b00011;
  localparam [4:0] OPC_LDRR  = 5'b00100;
  localparam [4:0] OPC_STRI  = 5'b00101;
  localparam [4:0] OPC_STRR_CMP = 5'b00110;
  localparam [4:0] OPC_ADDI  = 5'b00111;
  localparam [4:0] OPC_SUBI  = 5'b01000;
  localparam [4:0] OPC_MOV   = 5'b01011;
  localparam [4:0] OPC_JMP   = 5'b10000;
  localparam [4:0] OPC_JALI  = 5'b10001; // JAL with imm/disp；
  localparam [4:0] OPC_JALR  = 5'b10010; // JAL with register
  localparam [4:0] OPC_JR    = 5'b10011;
  localparam [4:0] OPC_SYS   = 5'b11100; // f2=00 OUTR, f2=01 HLT

  // ALU 類
  localparam [15:0] ENC_ADD  = {OPC_ALU, 11'b000_000_000_00}; // f2=00
  localparam [15:0] ENC_ADC  = {OPC_ALU, 11'b000_000_000_01}; // f2=01
  localparam [15:0] ENC_SUB  = {OPC_ALU, 11'b000_000_000_10}; // f2=10
  localparam [15:0] ENC_SBB  = {OPC_ALU, 11'b000_000_000_11}; // f2=11

  // LHI/LLI
  localparam [15:0] ENC_LHI  = {OPC_LHI, 11'b0};
  localparam [15:0] ENC_LLI  = {OPC_LLI, 11'b0};

  // LDR/LDRI
  localparam [15:0] ENC_LDR  = {OPC_LDRR, 11'b000_000_000_00};
  localparam [15:0] ENC_LDRI = {OPC_LDRI, 11'b000_00000};

  // STR/STRI/CMP
  localparam [15:0] ENC_STR  = {OPC_STRR_CMP, 11'b000_000_000_00}; // f2=00
  localparam [15:0] ENC_CMP  = {OPC_STRR_CMP, 11'b000_000_000_01}; // f2=01
  localparam [15:0] ENC_STRI = {OPC_STRI, 11'b000_00000};

  // ADDI/SUBI/MOV
  localparam [15:0] ENC_ADDI = {OPC_ADDI, 11'b000_00000};
  localparam [15:0] ENC_SUBI = {OPC_SUBI, 11'b000_00000};
  localparam [15:0] ENC_MOV  = {OPC_MOV,  11'b000_000_000_00};

  // Branch
  localparam [15:0] ENC_BEQ  = {4'b1100, 4'b0000, 8'h00};
  localparam [15:0] ENC_BNE  = {4'b1100, 4'b0001, 8'h00};
  localparam [15:0] ENC_BCS  = {4'b1100, 4'b0010, 8'h00};
  localparam [15:0] ENC_BCC  = {4'b1100, 4'b0011, 8'h00};
  localparam [15:0] ENC_BAL  = {4'b1100, 4'b1110, 8'h00};

  // Jumps / Link / JR
  localparam [15:0] ENC_JMP  = {OPC_JMP,  11'b0};
  localparam [15:0] ENC_JALI = {OPC_JALI, 11'b0};
  localparam [15:0] ENC_JAL  = {OPC_JALR, 11'b0};
  localparam [15:0] ENC_JR   = {OPC_JR,   11'b0};

  // OUTR / HLT
  localparam [15:0] ENC_OUTR = {OPC_SYS,  9'b000_000_000, 2'b00};
  localparam [15:0] ENC_HLT  = {OPC_SYS,  9'b000_000_000, 2'b01};

  // ============== 測試流程 ==============
  initial begin
    $timeformat(-9,1," ns",1);
    instr = 16'h0000;
    #10;

    // ---- 依序測每一個輸出 ----
    instr = ENC_LHI;  WAIT(); CHECK1(LHI , "LHI");
    instr = ENC_LLI;  WAIT(); CHECK1(LLI , "LLI");
    instr = ENC_LDRI; WAIT(); CHECK1(LDRI, "LDRI");
    instr = ENC_LDR;  WAIT(); CHECK1(LDR , "LDR");
    instr = ENC_STRI; WAIT(); CHECK1(STRI, "STRI");
    instr = ENC_STR;  WAIT(); CHECK1(STR , "STR");

    instr = ENC_ADD;  WAIT(); CHECK1(ADD , "ADD");
    instr = ENC_ADC;  WAIT(); CHECK1(ADC , "ADC");
    instr = ENC_SUB;  WAIT(); CHECK1(SUB , "SUB");
    instr = ENC_SBB;  WAIT(); CHECK1(SBB , "SBB");
    instr = ENC_CMP;  WAIT(); CHECK1(CMP , "CMP");
    instr = ENC_ADDI; WAIT(); CHECK1(ADDI, "ADDI");
    instr = ENC_SUBI; WAIT(); CHECK1(SUBI, "SUBI");
    instr = ENC_MOV;  WAIT(); CHECK1(MOV , "MOV");

    instr = ENC_BCC;  WAIT(); CHECK1(BCC , "BCC");
    instr = ENC_BCS;  WAIT(); CHECK1(BCS , "BCS");
    instr = ENC_BNE;  WAIT(); CHECK1(BNE , "BNE");
    instr = ENC_BEQ;  WAIT(); CHECK1(BEQ , "BEQ");
    instr = ENC_BAL;  WAIT(); CHECK1(BAL , "BAL");

    instr = ENC_JMP;  WAIT(); CHECK1(JMP , "JMP");
    instr = ENC_JALI; WAIT(); CHECK1(JALI, "JALI");
    instr = ENC_JAL;  WAIT(); CHECK1(JAL , "JAL");
    instr = ENC_JR;   WAIT(); CHECK1(JR  , "JR");

    instr = ENC_OUTR; WAIT(); CHECK1(OUTR, "OUTR");
    instr = ENC_HLT;  WAIT(); CHECK1(HLT , "HLT");

    // 總結
    if (error_cnt==0) $display("\n===== module correct ✅ =====");
    else              $display("\n===== module error num = %0d ❌ =====", error_cnt);

    #10; $finish;
  end
      
endmodule

