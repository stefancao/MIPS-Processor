-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: orgate.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is an OR-gate
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	2/20/2016		Created						TH, NS, LV, SC
--
-------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity orgate is
	Port (
		IN1 : in STD_LOGIC; 
    	IN2 : in STD_LOGIC; 
		OUT1 : out STD_LOGIC
	); 
end orgate;

architecture Behavioral of orgate is
begin
	OUT1 <= IN1 OR IN2; 
end Behavioral;
