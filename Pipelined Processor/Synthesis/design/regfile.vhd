-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: regfile.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is a register file
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/16/2016		Created						TH, NS, LV, SC
--	2/27/2016 		Updated to work for 		SC
--					synthesis
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY regfile IS
	PORT (
		ref_clk : IN std_logic;
		we : IN std_logic ; -- write enable
		raddr_1 : IN std_logic_vector (4 DOWNTO 0); -- read address 1
		raddr_2 : IN std_logic_vector (4 DOWNTO 0); -- read address 2
		waddr : IN std_logic_vector (4 DOWNTO 0); -- write address
		rdata_1 : OUT std_logic_vector (31 DOWNTO 0); -- read data 1
		rdata_2 : OUT std_logic_vector (31 DOWNTO 0); -- read data 2
		wdata : IN std_logic_vector (31 DOWNTO 0); -- write data 1
		reset : IN std_logic
	);
END regfile ;

architecture behavior of regfile is
begin
	regfile_write: process(ref_clk,raddr_1,raddr_2)
	subtype word is std_logic_vector(31 downto 0);
	type memory is array(0 to 2**5-1) of word;
	variable mem_var:memory;

	begin

		-- write at rising edge
		if(ref_clk'event AND ref_clk='1') then
			if(reset='1') then
				mem_var := (others=>(others=>'0'));
			elsif (we='1') then
				mem_var(to_integer(unsigned(waddr))) := wdata;
			end if;
		end if;

		rdata_1 <= mem_var(to_integer(unsigned(raddr_1)));
		rdata_2 <= mem_var(to_integer(unsigned(raddr_2)));

	end process;

end behavior;