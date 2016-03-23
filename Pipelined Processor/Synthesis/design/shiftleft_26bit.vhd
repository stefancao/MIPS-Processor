-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: sll.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		shifter that takes 26 bits input
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

ENTITY shiftleft_26bit IS
	PORT (
		A_in : IN std_logic_vector (25 DOWNTO 0);
		O_out: OUT std_logic_vector (27 DOWNTO 0)
	);
END shiftleft_26bit ;

architecture behavior of shiftleft_26bit is

begin

		O_out <= A_in & "00";

end behavior;