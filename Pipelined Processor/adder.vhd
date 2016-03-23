-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: adder.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is an adder with 1 bit
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/27/2016		Created						TH, NS, LV, SC
--
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
	port(
		a : in std_logic_vector(31 downto 0);
		b : in std_logic_vector(31 downto 0);	
		sum	: out std_logic_vector(31 downto 0)
	);
end adder;

architecture logic of adder is
begin
	sum <= std_logic_vector(signed(a) + signed(b));
end architecture; 


