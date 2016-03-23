-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: sll32.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		Shifter that takes in 32 bits input
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	02/05/2016		Created						TH, NS, LV, SC
--
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY shiftleft_32bit IS
	PORT (
		A_in : IN std_logic_vector (31 DOWNTO 0);
		O_out: OUT std_logic_vector (31 DOWNTO 0)
	);
END shiftleft_32bit ;

architecture behavior of shiftleft_32bit is


begin

		O_out <= A_in(29 downto 0) & "00";

end behavior;