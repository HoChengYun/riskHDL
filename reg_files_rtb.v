`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:07:33 11/05/2025
// Design Name:   reg_files
// Module Name:   /media/workdk/riskHDL/reg_files_rtb.v
// Project Name:  riskHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: reg_files
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module reg_files_rtb;

	// Inputs
	reg [15:0] din;
	reg [2:0] wr_addr;
	reg [2:0] rd_addr_a;
	reg [2:0] rd_addr_b;
	reg wr_E;
	reg CLK;
	reg CLR;

	// Outputs
	wire [15:0] out_a;
	wire [15:0] out_b;

	// Instantiate the Unit Under Test (UUT)
	reg_files uut (
		.din(din), 
		.wr_addr(wr_addr), 
		.rd_addr_a(rd_addr_a), 
		.rd_addr_b(rd_addr_b), 
		.wr_E(wr_E), 
		.CLK(CLK), 
		.CLR(CLR), 
		.out_a(out_a), 
		.out_b(out_b)
	);

  // clock
  localparam CLK_PERIOD = 80;
  always #(CLK_PERIOD/2) CLK = ~CLK;

  // helpers
  integer i;
  integer error_cnt;
  reg [2:0] temp_addr;
  reg [15:0] base, expect_a, expect_b;

  // 在下一個 posedge 寫入 (同步寫)
  task wr_once(input [2:0] a, input [15:0] d);
  begin
    wr_addr <= a;
    din     <= d;
    wr_E    <= 1'b1;
    @(posedge CLK); #40;     // 等待上升沿完成寫入
    wr_E    <= 1'b0;
  end
  endtask

  // 設定read address
  task rd_pair(input [2:0] a, input [2:0] b);
  begin
    rd_addr_a <= a;
    rd_addr_b <= b;
    #40;
  end
  endtask

  initial begin
    // 初值
    wr_E = 0; CLK = 0; CLR = 0;
    wr_addr = 0; din = 0;
    rd_addr_a = 0; rd_addr_b = 0;
    error_cnt = 0;

    // reset
    #5;  CLR = 1;
    #(CLK_PERIOD/4);
    CLR = 0;
    @(posedge CLK);

    // ========= Phase 1: 寫入已知樣式資料 =========
    // pattern: R0=BASE, R1=BASE+50, R2=BASE+100, ...（每格 +50）
    base = 16'h0123;
    temp_addr = 3'd0;
    for (i = 0; i < 8; i = i + 1) begin
      wr_once(temp_addr, base);
      temp_addr = temp_addr + 3'd1;
      base = base + 16'd50;
    end

    // ========= Phase 2: 測試 write_enable 關閉時不可寫 =========
    // 嘗試用另一組資料去覆寫，但 wr_E 維持 0，資料應保持不變
    base = 16'hA000;
    temp_addr = 3'd0;
    for (i = 0; i < 8; i = i + 1) begin
      wr_addr <= temp_addr;
      din     <= base;
      wr_E    <= 1'b0;           // 關閉 write enable
      @(posedge CLK); #40;        // 經過一個上升沿，若正確不會寫入
      temp_addr = temp_addr + 3'd1;
      base = base + 16'd50;
    end

    // ========= Phase 3: 逐對讀兩個 port，檢查內容 =========
    // 讀 {(R0,R1), (R2,R3), (R4,R5), (R6,R7)}，並比對分別為 BASE+0 與 BASE+50 的關係
    base = 16'h0123;
    temp_addr = 3'd0;
    for (i = 0; i < 4; i = i + 1) begin
      rd_pair(temp_addr, temp_addr + 3'd1);

      expect_a = base;
      expect_b = base + 16'd50;

      if (out_a !== expect_a) begin
        $display("[%0t] ERROR A: addr=%0d got=%h expect=%h",
                  $time, temp_addr, out_a, expect_a);
        error_cnt = error_cnt + 1;
      end
      if (out_b !== expect_b) begin
        $display("[%0t] ERROR B: addr=%0d got=%h expect=%h",
                  $time, temp_addr+1, out_b, expect_b);
        error_cnt = error_cnt + 1;
      end

      temp_addr = temp_addr + 3'd2;
      base = base + 16'd100; // 下一對相差兩格，所以基底加 100
      @(posedge CLK);        // 換一拍再檢下一對
    end

    // ========= 結果總結 =========
    if (error_cnt == 0)
      $display("module correct");
    else
      $display("module have %0d error", error_cnt);

    $finish;
  end
      
endmodule

