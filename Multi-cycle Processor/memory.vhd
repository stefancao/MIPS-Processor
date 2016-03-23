-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: memory.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is a RAM
--
-- History:
--     Date	    Update Description	            Developer
--  -----------   ----------------------   	  -------------
--   2/19/2016		Created			  TH, NS, LV, SC
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;
use ieee.numeric_std.all;

ENTITY memory IS 
	port (
		ref_clk : IN std_logic;

		-- WE='1' if write; WE='0' of read
		WE : IN std_logic;

		-- IorD='0' if instruction; IordD='1' if data
		IorD : IN std_logic; 
		addr : IN std_logic_vector(31 DOWNTO 0); 
		WD : IN std_logic_vector(31 DOWNTO 0); 
		RD : OUT std_logic_vector(31 DOWNTO 0)
	);
END memory;

architecture behavior of memory is

subtype byte is std_logic_vector(7 DOWNTO 0);
type I_memory is array (0 to 63) of byte;
type D_memory is array (0 to (2**11)-1) of byte; --size: 8 x 2048

constant I_mem: I_memory := ("00100000","00000010","00000000","00000101",
			"00100000","00000011","00000000","00001100",
			"00100000","01100111","11111111","11110111",
			"00000000","11100010","00100000","00100101",
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
			"00100000","00000010","00000000","00000001");--,
			--"10101100","00000010","00000000","01010100");


begin
	process(ref_clk, WE, IorD, addr, WD)
	variable D_mem_var: D_memory;
	begin
		if(ref_clk'event AND ref_clk='1') then 
			if(IorD='0') then
				RD<= I_mem(to_integer(addr(7 DOWNTO 0))) & 
						I_mem(to_integer(addr(7 DOWNTO 0)) + 1) & 
						I_mem(to_integer(addr(7 DOWNTO 0)) +2) & 
						I_mem(to_integer(addr(7 DOWNTO 0)) + 3);

			else 	
				if(WE='1') then
					D_mem_var(to_integer(unsigned(addr))) := WD(31 downto 24);
					D_mem_var(to_integer(unsigned(addr))+1) := WD(23 downto 16);
					D_mem_var(to_integer(unsigned(addr))+2) := WD(15 downto 8);
					D_mem_var(to_integer(unsigned(addr))+3) := WD(7 downto 0);

				else
					RD <= D_mem_var(to_integer(unsigned(addr))) &  D_mem_var(to_integer(unsigned(addr))+1)
						& D_mem_var(to_integer(unsigned(addr))+2) & D_mem_var(to_integer(unsigned(addr))+3);
				end if;
			end if;




		end if;
	end process;
end;
















--architecture behavior of memory is

--subtype byte is std_logic_vector(7 DOWNTO 0);
--type I_memory is array (0 to (2**11)-1) of byte;  
--type D_memory is array (0 to (2**11)-1) of byte; --size: 8 x 2048

--begin

--memory_process: process (ref_clk, WE, IorD, addr, WD)
--	variable I_mem_var : I_memory;
--	variable D_mem_var : D_memory;

--	file mem_file: TEXT;
--	variable L: line;
--	variable ch: character;
--	variable i, index, result: integer;

--	begin
--		for i in 0 to 63 loop 
--			I_mem_var(i) := (others => '0');
--		end loop;

--		index := 0;
--		FILE_OPEN (mem_file, "imem.h", READ_MODE);

--		while not endfile(mem_file) loop
--		readline(mem_file, L);
--		result := 0;

--			for i in 1 to 8 loop
--				read (L, ch);
--				if '0' <= ch and ch <= '9' then
--					result := character'pos(ch) - character'pos('0');
--				elsif 'a' <= ch and ch <= 'f' then
--					result := character'pos(ch) - character'pos('a') + 10;
--				else report "Format error on line" & integer'
--					image(index) severity error;
--				end if;
--				if (i = 1 OR i = 2) then
--				I_mem_var(index)(11-i*4 DOWNTO 8-i*4) := to_std_logic_vector(result,4);
--				elsif (i = 3 OR i = 4) then
--				I_mem_var(index + 1)(19-i*4 DOWNTO 16-i*4) := to_std_logic_vector(result,4);
--				elsif (i = 5 OR i = 6) then
--				I_mem_var(index + 2)(27-i*4 DOWNTO 24-i*4) := to_std_logic_vector(result,4);
--				elsif (i = 7 OR i = 8) then
--				I_mem_var(index + 3)(35-i*4 DOWNTO 32-i*4) := to_std_logic_vector(result,4);
--				end if;
--			end loop; -- end for loop
--			index := index + 4;
--		end loop; -- end while

--		if(ref_clk'event AND ref_clk='1') then 
--			if(IorD='0') then
--				RD<= I_mem_var(to_integer(addr)) & I_mem_var(to_integer(addr) + 1) 
--						& I_mem_var(to_integer(addr) +2) & I_mem_var(to_integer(addr) + 3);
--			else 	
--				if(WE='1') then
--					D_mem_var(to_integer(unsigned(addr))) := WD(31 downto 24);
--					D_mem_var(to_integer(unsigned(addr))+1) := WD(23 downto 16);
--					D_mem_var(to_integer(unsigned(addr))+2) := WD(15 downto 8);
--					D_mem_var(to_integer(unsigned(addr))+3) := WD(7 downto 0);

--				else
--					RD <= D_mem_var(to_integer(unsigned(addr))) &  D_mem_var(to_integer(unsigned(addr))+1)
--						& D_mem_var(to_integer(unsigned(addr))+2) & D_mem_var(to_integer(unsigned(addr))+3);
--				end if;
--			end if;
--		end if;

--	end process;
--end behavior;