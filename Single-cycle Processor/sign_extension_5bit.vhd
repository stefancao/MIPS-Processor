-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: sign_extension.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is a sign extension,
--		sign extends 16 bits to 32 bits
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

entity sign_extension_5bit is
	PORT(
		shamt : IN std_logic_vector(4 DOWNTO 0);
		sign_extension_out : OUT std_logic_vector(31 DOWNTO 0)
	);
end sign_extension_5bit;

architecture Behavioral of sign_extension_5bit is

begin

	sign_extension_out <= std_logic_vector(resize(signed(shamt), 32));

end Behavioral;

