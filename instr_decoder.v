`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:15:00 11/13/2025 
// Design Name: 
// Module Name:    instr_decoder 
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
module instr_decoder(
input [15:0] instr,
output BCC, BCS, BNE, BEQ, BAL, ADD, ADC, SUB, SBB, SUBI,
      MOV, STRI, STR, CMP, ADDI, LDR, LDRI, LLI, LHI, JMP,
		JALI, JAL, JR, OUTR, HLT);

wire b1, a1, l1, l2, j1, j2;
and (b1, instr[15], instr[14], ~instr[13], ~instr[12]);
and (BCC, b1, ~instr[11], ~instr[10],  instr[9],  instr[8]);
and (BCS, b1, ~instr[11], ~instr[10],  instr[9], ~instr[8]);
and (BNE, b1, ~instr[11], ~instr[10], ~instr[9],  instr[8]);
and (BEQ, b1, ~instr[11], ~instr[10], ~instr[9], ~instr[8]);
and (BAL, b1,  instr[11],  instr[10],  instr[9], ~instr[8]);
and (a1, ~instr[15], ~instr[14], ~instr[13], ~instr[12], ~instr[11]);
and (ADD, a1, ~instr[1], ~instr[0]);
and (ADC, a1, ~instr[1],  instr[0]);
and (SUB, a1,  instr[1], ~instr[0]);
and (SBB, a1,  instr[1],  instr[0]);
and (SUBI, ~instr[15],  instr[14], ~instr[13], ~instr[12], ~instr[11]);
and (MOV , ~instr[15],  instr[14], ~instr[13],  instr[12],  instr[11]);
and (l1, ~instr[15], ~instr[14]);
and (LHI , l1, ~instr[13], ~instr[12],  instr[11]);
and (LLI , l1, ~instr[13],  instr[12], ~instr[11]);
and (LDRI, l1, ~instr[13],  instr[12],  instr[11]);
and (LDR , l1,  instr[13], ~instr[12], ~instr[11]);
and (STRI, l1,  instr[13], ~instr[12],  instr[11]);
and (l2  , l1,  instr[13],  instr[12], ~instr[11]);
and (STR , l2, ~instr[1], ~instr[0]);
and (CMP , l2, ~instr[1],  instr[0]);
and (ADDI, l1,  instr[13],  instr[12],  instr[11]);
and (j1, instr[15], ~instr[14], ~instr[13]);
and (JMP , j1, ~instr[12], ~instr[11]);
and (JALI, j1, ~instr[12],  instr[11]);
and (JAL , j1,  instr[12], ~instr[11]);
and (JR  , j1,  instr[12],  instr[11]);
and (j2,  instr[15],  instr[14], instr[13], ~instr[12], ~instr[11]);
and (OUTR, j2, ~instr[1], ~instr[0]);
and (HLT , j2, ~instr[1],  instr[0]);

endmodule