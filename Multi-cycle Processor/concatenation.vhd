-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: concatination.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		cancatinates 28 bit input with 4 bits of GMSB of input B
--		
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	2/5/2016		Created						TH, NS, LV, SC
--
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY concatenation IS
	PORT (
		A_in : IN std_logic_vector (27 DOWNTO 0);
		B_in : IN std_logic_vector (31 DOWNTO 0);
		O_out : OUT std_logic_vector (31 DOWNTO 0)
	);
END concatenation ;

architecture behavior of concatenation is

begin

	O_out(31 downto 28) <= B_in(31 downto 28);
	O_out(27 downto 0) <= A_in(27 downto 0);
	
end behavior;