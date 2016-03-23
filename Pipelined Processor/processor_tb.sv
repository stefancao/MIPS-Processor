/***************************************************************/
// Copyright MIPS_R_US 2016 - All Rights Reserved 
// 
// File: processor_tb.sv
// Team: MIPS_R_US
// Members:
//		Stefan Cao (ID# 79267250)
//		Ting-Yi Huang (ID# 58106363)
//		Nehme Saikali (ID# 89201494)
//		Linda Vang (ID# 71434490)
//
// Description:
//		This is test bench for the processor
//
// History:
//		Date		Update Description		Developer
//	------------	-------------------		------------
//	1/23/2016		Created					TH, NS, LV, SC
//
/***************************************************************/

module processor_tb;

  logic ref_clk;
  logic reset;
  logic[31:0] out_b;
  
processor L1(
          .ref_clk(ref_clk)
         ,.reset(reset)
         ,.out_b(out_b)
         );

always #1 ref_clk = ~ ref_clk;

initial begin
    ref_clk = 1;
	reset = 1;
	#2 reset = 0;
	#100;
	$finish;

end
endmodule
    
