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
--		buffer with clk, 2 inputs, and 3outputs
--
-- History:
--     Date	    Update Description	            Developer
--  -----------   ----------------------   	  -------------
--   2/25/2016		Created			  TH, NS, LV, SC
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY reg1 IS 
	PORT (
		ref_clk:	IN std_logic;
		RD:			IN std_logic_vector(31 DOWNTO 0);
		PCPlus4F:	IN std_logic_vector(31 DOWNTO 0);
		en:			IN std_logic; --enable from stallD
		clr:	  	IN std_logic; -- clear enable from PCSrc
		InstrD:		OUT std_logic_vector(31 DOWNTO 0);
		PCPlus4D: 	OUT std_logic_vector(31 DOWNTO 0)	
	);
end reg1;
architecture behavior of reg1 is
begin
	process(ref_clk, RD, PCPlus4F, en)
		variable tmpA : std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
		variable tmpB : std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
		
	begin
		-- SC 2016-03-03: Changed ref_clk='1'
		if(ref_clk'event AND ref_clk='1') then
			if(en /= '1') then
				tmpA := std_logic_vector(unsigned(RD));
				tmpB := std_logic_vector(unsigned(PCPlus4F));
			end if;
		end if;
		InstrD <= tmpA;
		PCPlus4D <= tmpB;
	end process;
end;
 
