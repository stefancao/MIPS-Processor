-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: buffer_2_woe.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		buffer with 2 inputs and 2 outputs without enable
--
-- History:
--     Date	    Update Description	            Developer
--  -----------   ----------------------   	  -------------
--   2/20/2016		Created			  TH, NS, LV, SC
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY buffer_2_woe IS 
	PORT (
		ref_clk : IN std_logic;
		DataI_A : IN std_logic_vector(31 DOWNTO 0);
		DataI_B : IN std_logic_vector(31 DOWNTO 0);
		DataO_A : OUT std_logic_vector(31 DOWNTO 0);
		DataO_B: OUT std_logic_vector(31 DOWNTO 0)
	);
END buffer_2_woe;

architecture behavior of buffer_2_woe is

begin
	process(ref_clk, DataI_A, DataI_B)
	variable temp_A : std_logic_vector(31 DOWNTO 0);
	variable temp_B : std_logic_vector(31 DOWNTO 0);
	begin

		-- SC 2016-02-20: Changed ref_clk='1' to ref_clk='0'
		if(ref_clk'event AND ref_clk='0') then 
			temp_A := std_logic_vector(unsigned(DataI_A));
			temp_B := std_logic_vector(unsigned(DataI_B));
		end if;
		DataO_A <= temp_A;
		DataO_B <= temp_B;
	end process;
end;











