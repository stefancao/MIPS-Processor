-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: shiftextend.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is a shift and extend of lui for load control unit of the processor
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	02/05/2016		Created						TH, NS, LV, SC
--
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity shiftlui is
port(
	in32: IN std_logic_vector (31 downto 0);
	out32: OUT std_logic_vector (31 downto 0)
);
end shiftlui;
architecture logic of shiftlui is

begin
	out32 <= std_logic_vector(resize(unsigned((in32(31 downto 16))),32));

end logic;



