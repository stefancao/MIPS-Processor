-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved
--
-- File: reg4.vhd
-- Team: MIPS_R_US
-- Members:
--              Stefan Cao (ID# 79267250)
--              Ting-Yi Huang (ID# 58106363)
--              Nehme Saikali (ID# 89201494)
--              Linda Vang (ID# 71434490)
--
-- Description:
--              buffer with clk, 6 inputs, and 5 outputs
--
-- History:
--     Date         Update Description              Developer
--  -----------   ----------------------          -------------
--   2/27/2016          Created                   TH, NS, LV, SC
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY reg4 IS
PORT (
		ref_clk : 		IN std_logic;
		RegWriteM : 	IN std_logic;
		MemtoRegM : 	IN std_logic;
		LoadControlM: 	IN std_logic_vector(2 DOWNTO 0);
		rd_in:			IN std_logic_vector(31 DOWNTO 0);
		alu_in:			IN std_logic_vector(31 DOWNTO 0);
		WriteRegM:		IN std_logic_vector(4 DOWNTO 0);
		SignImmM:		IN std_logic_vector(31 DOWNTO 0);
		JALDataM:		IN std_logic_vector(1 DOWNTO 0);

		RegWriteW : 	OUT std_logic;
		MemtoRegW : 	OUT std_logic;
		LoadControlW : 	OUT std_logic_vector(2 DOWNTO 0);
		rd_out:			OUT std_logic_vector(31 DOWNTO 0);				
		alu_out:		OUT std_logic_vector(31 DOWNTO 0);
		WriteRegW:		OUT std_logic_vector(4 DOWNTO 0);
		SignImmW: 		OUT std_logic_vector(31 DOWNTO 0);	
		JALDataW:		OUT std_logic_vector(1 DOWNTO 0)			
        );
end reg4;
architecture behavior of reg4 is
begin
	process(ref_clk, RegWriteM, MemtoRegM, rd_in, alu_in, WriteRegM)
	variable temp_RegWriteM : 	std_logic := '0';
	variable temp_MemtoRegM : 	std_logic := '0';
	variable temp_rd_in:			std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
	variable temp_alu_in:			std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
	variable temp_WriteRegM:		std_logic_vector(4 DOWNTO 0) := "00000";
	variable temp_LoadControlM:		std_logic_vector(2 DOWNTO 0) := "100";
	variable temp_SignImmM:			std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
	variable temp_JALDataM:			std_logic_vector(1 DOWNTO 0) := "00";

	begin

		-- SC 2016-03-04: Changed ref_clk='1'
		if(ref_clk'event AND ref_clk='1') then 
			temp_RegWriteM := RegWriteM;
			temp_MemtoRegM := MemtoRegM;
			temp_rd_in := std_logic_vector(unsigned(rd_in));
			temp_alu_in := std_logic_vector(unsigned(alu_in));
			temp_WriteRegM := std_logic_vector(unsigned(WriteRegM));
			temp_LoadControlM := std_logic_vector(unsigned(LoadControlM));
			temp_SignImmM := std_logic_vector(unsigned(SignImmM));
			temp_JALDataM := std_logic_vector(unsigned(JALDataM));
		end if;
		RegWriteW <= temp_RegWriteM;
		MemtoRegW <= temp_MemtoRegM;
		rd_out <= temp_rd_in;
		alu_out <= temp_alu_in;
		WriteRegW <= temp_WriteRegM;
		LoadControlW <= temp_LoadControlM;
		SignImmW <= temp_SignImmM;
		JALDataW <= JALDataM;
	end process;
end;