-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: mux_5bit.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		2 bit mux that takes a 5 bit input
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/20/2016		Created						TH, NS, LV, SC
--	1/27/2016		Updating to With/Select		LV
--
-------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_5bit is
	port( 
		in0: in std_logic_vector(4 downto 0);
		in1: in std_logic_vector(4 downto 0);
		sel: in std_logic;
		outb: out std_logic_vector(4 downto 0)
	);
end mux_5bit;

architecture behavior of mux_5bit is
begin
	
	outb <= in0 when (sel = '0') else 
			in1;

end behavior;
	
