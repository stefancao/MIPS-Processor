---------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: pc.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		Program Counter for ALU_32_Bit
--		adder is incorporated with this program counter
--		features:
--			rst: resets to all the bits to 0's
--			isBranch: when set to '1', will read the addr_in and
--				output it
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/13/2016		Created						TH, NS, LV, SC
--	1/29/2016		Changed pc implementation	SC
--						+ changed to "when-else"
--  2/12/2016		made it synthesizable		SC
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY pc IS
		
	PORT (
		ref_clk: in STD_LOGIC;
      	rst: in STD_LOGIC;  
		addr_in: in STD_LOGIC_VECTOR(31 DOWNTO 0);
		addr_out: out STD_LOGIC_VECtOR(31 DOWNTO 0)
	);
end pc;
      
architecture logic of pc is
begin
	pc_process: process(ref_clk, rst)
	
	variable temp: STD_LOGIC_VECTOR(31 DOWNTO 0);

	begin
		if(rst='1') then 
			temp := (others=>'0');
		else 
			temp := addr_in;
		end if;

		if(ref_clk'event AND ref_clk='1') then 
			addr_out <= temp;
		end if;
	end process;														
end logic;





