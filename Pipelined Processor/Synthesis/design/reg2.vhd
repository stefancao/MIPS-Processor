-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: reg2.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		buffer with clk, 3 inputs, and 2 outputs
--
-- History:
--     Date	    Update Description	            Developer
--  -----------   ----------------------   	  -------------
--   2/25/2016		Created			  TH, NS, LV, SC
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY reg2 IS 
PORT (
		ref_clk: 		IN std_logic;
		RegWriteD:		IN std_logic;
		MemtoRegD:		IN std_logic;
		MemWriteD:		IN std_logic;
		ALUControlD:	IN std_logic_vector(5 downto 0);
		ALUSrcD: 		IN std_logic;
		RegDstD:		IN std_logic;
		LoadControlD: 	IN std_logic_vector(2 downto 0);
		RD1:			IN std_logic_vector(31 downto 0);
		RD2:			IN std_logic_vector(31 downto 0);
		RsD:			IN std_logic_vector(25 downto 21);
		RtD:			IN std_logic_vector(20 downto 16);
		RdD:			IN std_logic_vector(15 downto 11);
		SignImmD:		IN std_logic_vector(31 downto 0);
		clr:			IN std_logic;
		JALDataD:		IN std_logic_vector(1 downto 0);

		RegWriteE:		OUT std_logic;
		MemtoRegE:		OUT std_logic;
		MemWriteE:		OUT std_logic;
		ALUControlE:	OUT std_logic_vector(5 downto 0);
		ALUSrcE: 		OUT std_logic;
		RegDstE:		OUT std_logic;
		LoadControlE: 	OUT std_logic_vector(2 downto 0);
		RD1toMux1:		OUT std_logic_vector(31 downto 0);
		RD2toMux2:		OUT std_logic_vector(31 downto 0);
		RsE:			OUT std_logic_vector(25 downto 21);
		RtE:			OUT std_logic_vector(20 downto 16);
		RdE:			OUT std_logic_vector(15 downto 11);
		SignImmE:		OUT std_logic_vector(31 downto 0);
		JALDataE:		OUT std_logic_vector(1 downto 0)
	);
end reg2;
architecture behavior of reg2 is
begin
	process(ref_clk, RegWriteD, MemtoRegD, MemWriteD, ALUControlD, ALUSrcD, RegDstD, RD1, RD2, RsD, RtD, RdD, SignImmD, clr)
		variable RegWriteD_tmp:		std_logic := '0';
		variable MemtoRegD_tmp:		std_logic := '0';
		variable MemWriteD_tmp:		std_logic := '0';
		variable ALUControlD_tmp:	std_logic_vector(5 downto 0) := "000000";
		variable ALUSrcD_tmp: 		std_logic := '0';
		variable RegDstD_tmp:		std_logic := '0';
		variable RD1_tmp:		std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
		variable RD2_tmp:		std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
		variable RsD_tmp:		std_logic_vector(25 downto 21) := "00000";
		variable RtD_tmp:		std_logic_vector(20 downto 16) := "00000";
		variable RdD_tmp:		std_logic_vector(15 downto 11) := "00000";
		variable SignImmD_tmp:		std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
		variable LoadControlD_tmp: 	std_logic_vector(2 downto 0) := "100";
		variable JALDataD_tmp:		std_logic_vector(1 downto 0) := "XX";
	begin
		if rising_edge(ref_clk) then
			if(clr = '1') then
				RegWriteD_tmp := 'X';
				MemtoRegD_tmp := 'X';
				MemWriteD_tmp := '0';
				ALUControlD_tmp := "XXXXXX";
				ALUSrcD_tmp := 'X';
				RegDstD_tmp := 'X';
				RD1_tmp := "00000000000000000000000000000000";
				RD2_tmp := "00000000000000000000000000000000";
				RsD_tmp := "00000";
				RtD_tmp := "00000";
				RdD_tmp := "00000";
				SignImmD_tmp := "00000000000000000000000000000000";
				JALDataD_tmp := "XX";
			end if;
			if(clr = '0') then
				RegWriteD_tmp:= RegWriteD;
				MemtoRegD_tmp:= MemtoRegD;
				MemWriteD_tmp:= MemWriteD;
				ALUControlD_tmp := ALUControlD;
				ALUSrcD_tmp := ALUSrcD;
				RegDstD_tmp := RegDstD;
				LoadControlD_tmp := std_logic_vector(unsigned(LoadControlD));
				RD1_tmp := std_logic_vector(unsigned(RD1));
				RD2_tmp := std_logic_vector(unsigned(RD2));
				RsD_tmp := std_logic_vector(unsigned(RsD));
				RtD_tmp := std_logic_vector(unsigned(RtD));
				RdD_tmp := std_logic_vector(unsigned(RdD));
				SignImmD_tmp := std_logic_vector(unsigned(SignImmD));
				JALDataD_tmp := std_logic_vector(unsigned(JALDataD));
			end if;
		RegWriteE <= RegWriteD_tmp;
        MemtoRegE <= MemtoRegD_tmp;
        MemWriteE <= MemWriteD_tmp;
        ALUControlE <= ALUControlD_tmp;
        ALUSrcE <= ALUSrcD_tmp;
        RegDstE <= RegDstD_tmp;
        LoadControlE <= LoadControlD_tmp;
		RD1toMux1 <= RD1_tmp;
		RD2toMux2 <= RD2_tmp;
		RsE <= RsD_tmp;
		RtE <= RtD_tmp;
		RdE <= RdD_tmp;
		SignImmE <= SignImmD_tmp;
		JALDataE <= JALDataD_tmp;
		end if;
	end process;
end;	
		
