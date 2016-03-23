-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: buffer_e.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		buffer with an enable
--
-- History:
--     Date	    Update Description	            Developer
--  -----------   ----------------------   	  -------------
--   2/19/2016		Created			  TH, NS, LV, SC
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY buffer_e IS 
	port (
		ref_clk : IN std_logic;
		WE : IN std_logic;
		DataI: IN std_logic_vector(31 DOWNTO 0);
		DataO: OUT std_logic_vector(31 DOWNTO 0)
	);
END buffer_e;

architecture behavior of buffer_e is

begin
	process(ref_clk, WE, DataI)
	variable temp : std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
	begin

		-- SC 2016-02-20: Changed ref_clk='1' to ref_clk='0'
		-- EH 2016-03-01: changed from ref_clk'event and ref_clk'0' to rising_edge from TA reg_file example
 		if rising_edge(ref_clk) then				
 			if(WE /= '1') then
				temp := std_logic_vector(unsigned(DataI));
			end if;
		end if;
		DataO <= temp;
	end process;
end;











