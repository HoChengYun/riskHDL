`timescale 1ns / 1ps

module control_rtb;

	// Inputs
	reg [15:0] instr;
	reg cpu_on;
	reg reset;
	reg clk;
	reg n_flag;
	reg z_flag;
	reg c_flag;
	reg v_flag;

	// Outputs
	wire e_pc;
	wire IorD;
	wire we_mem;
	wire we_ir;
	wire rd_read;
	wire MtoR;
	wire mixMR;
	wire PCtoR;
	wire we_reg;
	wire alu_srca;
	wire e_flag;
	wire pc_src;
	wire e_out_r;
	wire done;
	wire [1:0] alu_srcb;
	wire [1:0] alu_ctrl;
	wire [1:0] pc_jp;

	// Instantiate the Unit Under Test (UUT)
	control uut (
		.instr(instr), 
		.cpu_on(cpu_on), 
		.reset(reset), 
		.clk(clk), 
		.n_flag(n_flag), 
		.z_flag(z_flag), 
		.c_flag(c_flag), 
		.v_flag(v_flag), 
		.e_pc(e_pc), 
		.IorD(IorD), 
		.we_mem(we_mem), 
		.we_ir(we_ir), 
		.rd_read(rd_read), 
		.MtoR(MtoR), 
		.mixMR(mixMR), 
		.PCtoR(PCtoR), 
		.we_reg(we_reg), 
		.alu_srca(alu_srca), 
		.e_flag(e_flag), 
		.pc_src(pc_src), 
		.e_out_r(e_out_r), 
		.done(done), 
		.alu_srcb(alu_srcb), 
		.alu_ctrl(alu_ctrl), 
		.pc_jp(pc_jp)
	);



// Initialize Inputs
initial clk = 0;
always #40 clk = ~clk;
task step1; begin @(posedge clk); #40;end endtask
   initial begin
	cpu_on = 0;
	reset = 1;
	n_flag=0;z_flag=0;c_flag=0;v_flag=0;
	step1();
	reset = 0;
	cpu_on = 1;
	//LHI
		step1();
		instr = 16'b0000_1000_0000_0000;
		step1();
		step1();
		step1();
	//LLI
		step1();
		instr = 16'b0001_0000_0000_0000;
		step1();
		step1();
	//LDRI
		step1();
		instr = 16'b0001_1000_0000_0000;
		step1();
		step1();
		step1();
		step1();
		step1();
	//LDR
		step1();
		instr = 16'b0010_0000_0000_0000;
		step1();
		step1();
		step1();
		step1();
		step1();
	//STRI
		step1();
		instr = 16'b0010_1000_0000_0000;
		step1();
		step1();
		step1();
		step1();
		step1();
	//STR
		step1();
		instr = 16'b0011_0000_0000_0000;
		step1();
		step1();
		step1();
		step1();
		step1();
	//ADD
		step1();
		instr = 16'b0000_0000_0000_0000;
		step1();
		step1();
		step1();
		step1();
	//ADC
		step1();
		instr = 16'b0000_0000_0000_0001;
		step1();
		step1();
		step1();
		step1();
	//SUB
		step1();
		instr = 16'b0000_0000_0000_0010;
		step1();
		step1();
		step1();
		step1();
	//SBB
		step1();
		instr = 16'b0000_0000_0000_0011;
		step1();
		step1();
		step1();
		step1();
	//CMP
		step1();
		instr = 16'b0011_0000_0000_0001;
		step1();
		step1();
		step1();
	//ADDI
		step1();
		instr = 16'b0011_1000_0000_0000;
		step1();
		step1();
		step1();
		step1();
	//SUBI
		step1();
		instr = 16'b0100_0000_0000_0000;
		step1();
		step1();
		step1();
		step1();
	//MOV
		step1();
		instr = 16'b0101_1000_0000_0000;
		step1();
		step1();
		step1();
	//BCC
		step1();
		instr = 16'b1100_0011_0000_0000;
		step1();
		step1();
		step1();
	//BCS
		step1();
		instr = 16'b1100_0010_0000_0000;
		step1();
		step1();
		step1();
	//BNE
		step1();
		instr = 16'b1100_0001_0000_0000;
		step1();
		step1();
		step1();
	//BEQ
		step1();
		instr = 16'b1100_0000_0000_0000;
		step1();
		step1();
		step1();
	//BAL
		step1();
		instr = 16'b1100_1110_0000_0000;
		step1();
		step1();
		step1();
	//JMP
		step1();
		instr = 16'b1000_0000_0000_0000;
		step1();
		step1();
	//JALI
		step1();
		instr = 16'b1000_1000_0000_0000;
		step1();
		step1();
		step1();
		step1();
	//JAL
		step1();
		instr = 16'b1001_0000_0000_0000;
		step1();
		step1();
		step1();
	//JR
		step1();
		instr = 16'b1001_1000_0000_0000;
		step1();
		step1();
		step1();		
	//OUTR
		step1();
		instr = 16'b1110_0000_0000_0000;
		step1();
		step1();
		step1();	
	//HLT
		step1();
		instr = 16'b1110_0000_0000_0001;
		step1();
		step1();
		step1();	
		step1();	
		step1();	
		step1();	
		step1();	
		step1();	
		$finish;
	end
      
endmodule

