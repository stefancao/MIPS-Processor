-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: mux4.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is a mux or a 4 to 1 selector.
--History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/29/2016		Created						TH, NS, LV, SC
--	
--
-------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4 is
port(   in0: in std_logic_vector(31 downto 0);
	in1: in std_logic_vector(31 downto 0);
	in2: in std_logic_vector(31 downto 0);
	in3: in std_logic_vector(31 downto 0);		
	sel: in std_logic_vector(1 downto 0);
	mux4out: out std_logic_vector(31 downto 0)
);
end mux4;

architecture logic of mux4 is
begin

	mux4out <=	in0 when sel = "00" else
			in1 when sel = "01" else
			in2 when sel = "10" else
			in3 when sel = "11";
end logic;