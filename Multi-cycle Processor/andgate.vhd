-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: andgate.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is an and gate
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/27/2016		Created						TH, NS, LV, SC
--
-------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity andgate is
	Port (
		IN1 : in STD_LOGIC; -- and gate input
    	IN2 : in STD_LOGIC; -- and gate input
		OUT1 : out STD_LOGIC
	); 
end andgate;

architecture Behavioral of andgate is
begin
	OUT1 <= IN1 AND IN2; -- 2 input AND gate
end Behavioral;
