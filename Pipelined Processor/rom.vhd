-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: rom.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is an instruction memory with hardcoded instructions
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/27/2016		Created						TH, NS, LV, SC
-------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;
entity rom is -- instruction memory
	port(
		addr: IN STD_LOGIC_VECTOR(31 downto 0); 
		dataOut: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end rom;

architecture behavior of rom is


subtype byte is std_logic_vector(7 DOWNTO 0);
type rom_type is array (0 to 67) of byte;
constant mem_var : rom_type :=
			(
			"00100000","00000010","00000000","00000101",
			"00100000","00000011","00000000","00001100",
			"00100000","01100111","11111111","11110111",
			"00000000","11100010","00100000","00100101",
			"00000000","01100100","00101000","00100100",
			"00000000","10100100","00101000","00100000",
			"00010000","10100111","00000000","00001010",
			"00000000","01100100","00100000","00101010",
			"00010000","10000000","00000000","00000001",
			"00100000","00000101","00000000","00000000",
			"00000000","11100010","00100000","00101010",
			"00000000","10000101","00111000","00100000",
			"00000000","11100010","00111000","00100010",
			"10101100","01100111","00000000","01000100",
			"10001100","00000010","00000000","01010000",
			"00001000","00000000","00000000","00010001",
			"00100000","00000010","00000000","00000001");






			



begin

rom_process: process (addr)
      
        begin
        	dataOut <= mem_var(to_integer(unsigned(addr(7 DOWNTO 0)))) &  mem_var(to_integer(unsigned(addr(7 DOWNTO 0)))+1)
                        & mem_var(to_integer(unsigned(addr(7 DOWNTO 0)))+2) & mem_var(to_integer(unsigned(addr(7 DOWNTO 0)))+3);

        end process;
end behavior;