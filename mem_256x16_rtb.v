`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:00:22 11/05/2025
// Design Name:   mem_256x16
// Module Name:   /media/workdk/riskHDL/mem_256x16_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mem_256x16
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mem_256x16_rtb;

	// Inputs
	reg clk;
	reg we_a;
	reg we_b;
	reg port_sel;
	reg [7:0] addr_wa;
	reg [7:0] addr_wb;
	reg [15:0] data_wa;
	reg [15:0] data_wb;

	// Outputs
	wire [15:0] data_q;

	// Instantiate the Unit Under Test (UUT)
	mem_256x16 uut (
		.clk(clk), 
		.we_a(we_a), 
		.we_b(we_b), 
		.port_sel(port_sel), 
		.addr_wa(addr_wa), 
		.addr_wb(addr_wb), 
		.data_wa(data_wa), 
		.data_wb(data_wb), 
		.data_q(data_q)
	);

   initial begin
		 // 初始化
        we_a = 0; we_b = 0;
        addr_wa = 0; addr_wb = 0;
        data_wa = 0; data_wb = 0;
        port_sel = 0; // port_sel = 0 使用 port A
		  clk = 0;
        #10;

        // ============================
        // 同時寫入資料到 port A
        // ============================
        we_a = 1; port_sel = 0;
        addr_wa = 8'h00; data_wa = 16'hAAAA;#10; clk = ~clk; #20; clk = ~clk; #10;
        addr_wa = 8'h01; data_wa = 16'h5555;#10; clk = ~clk; #20; clk = ~clk; #10;
        addr_wa = 8'h02; data_wa = 16'h1234;#10; clk = ~clk; #20; clk = ~clk; #10;
        addr_wa = 8'h03; data_wa = 16'hABCD;#10; clk = ~clk; #20; clk = ~clk; #10;
        we_a = 0; port_sel = 0;

        // ============================
        // 同時讀取 port A 與 port B
        // ============================
        // port A 讀取
        addr_wa = 8'h00;#10; clk = ~clk; #20; clk = ~clk; #10;
        addr_wa = 8'h01;#10; clk = ~clk; #20; clk = ~clk; #10;
        addr_wa = 8'h02;#10; clk = ~clk; #20; clk = ~clk; #10;
        addr_wa = 8'h03;#10; clk = ~clk; #20; clk = ~clk; #10;

        // ============================
        // 同時寫入 port B
        // ============================
        we_b = 1; port_sel = 1;
        addr_wb = 8'h14; data_wb = 16'hDEAD;#10; clk = ~clk; #20; clk = ~clk; #10;
        addr_wb = 8'h15; data_wb = 16'hBEEF;#10; clk = ~clk; #20; clk = ~clk; #10;
        we_b = 0;

        // 再讀回 port A 和 port B 資料
		  port_sel = 0;
        addr_wa = 8'h02;#10; clk = ~clk; #20; clk = ~clk; #10; // 讀 port A 位置 4
		  port_sel = 1;
        addr_wb = 8'h15;#10; clk = ~clk; #20; clk = ~clk; #10; // 讀 port B 位置 5

        #20;$finish;
	end
      
endmodule

