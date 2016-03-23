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
--		This is a shift and extend for load control unit of the processor
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

entity shiftextend is
port(
loadcontrol:	IN std_logic_vector(2 downto 0);
in32:		IN std_logic_vector (31 downto 0);
out32:		OUT std_logic_vector(31 downto 0)
);
end shiftextend;

architecture logic of shiftextend is
--signal lbfilling: std_logic_vector (31 downto 7):= (others => '0');
--signal lhfilling: std_logic_vector (31 downto 16):= (others => '0');
--signal lbfilling1: std_logic_vector (31 downto 8) := (others => '1');
--signal lhfilling1: std_logic_vector (31 downto 16) := (others => '1');
signal lbs: std_logic_vector (31 downto 0);
--signal lb: std_logic_vector (7 downto 0);
signal lbu: std_logic_vector (31 downto 0);
signal lhs: std_logic_vector (31 downto 0);
signal lhu: std_logic_vector (31 downto 0);
begin

---lbfilling <= lbfilling1 when (loadcontrol = "000") and (in32(7) = '1');

--lbs(31 downto 0)<= "000000000000000000000000" & in32(7 downto 0);
lbs <= std_logic_vector(resize(signed((in32(7 downto 0))),32));
lbu <= std_logic_vector(resize(unsigned((in32(7 downto 0))),32));
lhs <= std_logic_vector(resize(signed((in32(15 downto 0))),32));
lhu <= std_logic_vector(resize(unsigned((in32(15 downto 0))),32));
--sign_extension_out <= std_logic_vector(resize(signed(immediate), 32));

--lhfilling <= lhfilling1 when (loadcontrol = "001") and (in32(15) = '1');
--lbex <= std_logic_vector(resize(signed(in32(7 downto 0)), 32);

out32 <= lbs when (loadcontrol = "000") else
	 lhs when (loadcontrol = "001") else
	 lbu when (loadcontrol = "010") else
	 lhu when (loadcontrol = "011") else
	 in32(31 downto 0) when (loadcontrol = "100");
	 --(lbfilling & in32(7 downto 0)) when (loadcontrol = "010") else
	 --(lhfilling & in32(15 downto 0)) when (loadcontrol = "011") else
	

end logic;