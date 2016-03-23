-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: buffer.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		buffer without an enable
--
-- History:
--     Date	    Update Description	            Developer
--  -----------   ----------------------   	  -------------
--   2/19/2016		Created			  TH, NS, LV, SC
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY buffer_woe IS 
	port (
		ref_clk : IN std_logic;
		DataI: IN std_logic_vector(31 DOWNTO 0);
		DataO: OUT std_logic_vector(31 DOWNTO 0)
	
	);
END buffer_woe;

architecture behavior of buffer_woe is

begin
	process(ref_clk, DataI)
	variable temp : std_logic_vector(31 DOWNTO 0);
	begin

		-- SC 2016-02-20: Changed ref_clk='1' to ref_clk='0'
		if(ref_clk'event AND ref_clk='0') then 
			temp := std_logic_vector(unsigned(DataI));
		end if;
		DataO <= temp;
	end process;
end;











