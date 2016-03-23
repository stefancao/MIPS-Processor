-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: control.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is a control unit of the processor (multi-cycle)
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	2/20/2016		Created						TH, NS, LV, SC			
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY control IS
	PORT (
		
		ref_clk : IN std_logic;
		reset : IN std_logic;


		instruction : IN std_logic_vector (31 DOWNTO 0);

		-----------------------------------------------
		--------------- Control Enables ---------------
		-----------------------------------------------

		-- new enables
		-- '0' if instruction, '1' if data
		IorD : OUT std_logic;

		-- '0' choose PC, '1' choose RD1 
		ALUSrcA : OUT std_logic;

		-- "00" if RD2, "01" if 4, "10" if imm extend, "11", shifted by 2 of sign extend
		ALUSrcB : OUT std_logic_vector(1 DOWNTO 0);

		-- "00" if ALU Result (PC), "01" if ALUOut (from buffer), "10" if JUMP
		PCSrc : OUT std_logic_vector(1 DOWNTO 0);

		-- '1' if write to IR buffer, '0' otherwise 
		IRWrite : OUT std_logic;

		-- '1' if write to PC, '0' otherwise
		PCWrite : OUT std_logic;


		-- write enable for regfile
		-- '0' if read, '1' if write
		RegWrite: OUT std_logic;

		-- write ebable for data memory
		-- '0' if not writing to mem, '1' if writing to mem
		MemWrite: OUT std_logic;

		-- selecting output data from memory OR ALU result
		-- '1' if ALU result, '0' if mem result
		MemToReg: OUT std_logic;

		-- selecting if 'rs' or 'rt' is selected to write destination (regfile)
		-- '1' if rd, '0' if rt
		RegDst: OUT std_logic;

		-- '1' if branching, '0' if not branching
		Branch: OUT std_logic;

		-- "000" if LB; "001" if LH; "010" if LBU; "011" if LHU; 
		-- "100" if normal, (don't do any manipulation to input) 
		LoadControl: OUT std_logic_vector(2 DOWNTO 0);

		-- func for ALU
		ALUControl: OUT std_logic_vector(5 DOWNTO 0);

		-- to regfile
		-- operand A
		rs: OUT std_logic_vector(4 DOWNTO 0);

		-- operand B
		rt: OUT std_logic_vector(4 DOWNTO 0);

		-- write address
		rd: OUT std_logic_vector(4 DOWNTO 0);

		-- immediant, (rd+shamt+func)
		imm: OUT std_logic_vector(15 DOWNTO 0);

		-- jump shift left
		jumpshiftleft: OUT std_logic_vector(25 DOWNTO 0)
	);
END control;

architecture behavior of control is

	type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11);

	signal state : state_type;

begin

	-- Operand A
	rs <= instruction(25 DOWNTO 21);

	-- Operand B
	rt <= instruction(20 DOWNTO 16);

	-- write destination
	rd <= instruction(15 DOWNTO 11);

	-- immediant, (rd+shamt+func)
	imm <= instruction(15 DOWNTO 0);

	jumpshiftleft <= instruction(25 DOWNTO 0);
	
	process(ref_clk, reset)
	begin
		if reset = '1' then 
			state <= s0;
		elsif (rising_edge(ref_clk)) then

			case state is 
				when s0=>
					state <= s1;

				when s1=>
					if(
						-- LW
						(instruction(31 DOWNTO 26) = "100011") OR

						-- LB
						(instruction(31 DOWNTO 26) = "100000") OR

						-- LH
						(instruction(31 DOWNTO 26) = "100001") OR

						-- LBU 
						(instruction(31 DOWNTO 26) = "100100") OR
						
						-- LHU
						(instruction(31 DOWNTO 26) = "100101") OR

						-- SW
						(instruction(31 DOWNTO 26) = "101011") OR

						-- SB
						(instruction(31 DOWNTO 26) = "101000") OR

						-- SH
						(instruction(31 DOWNTO 26) = "101001")
						
					) then

						state <= s2;

					elsif( 

						-- R-type
						((instruction(31 DOWNTO 26) = "000000") AND

							-- Not equal to JR
							((instruction(5 DOWNTO 0) /= "001000") OR

							-- Not equal to JALR
							(instruction(5 DOWNTO 0) /= "001001")))

					) then

						state <= s6;

					elsif(

						-- BEQ
						(instruction(31 DOWNTO 26) = "000100") OR

						-- BNE
						(instruction(31 DOWNTO 26) = "000101") OR

						-- BLTZ or BGEZ
						(instruction(31 DOWNTO 26) = "000001") OR

						-- BLEZ
						(instruction(31 DOWNTO 26) = "000110") OR

						-- BGTZ
						(instruction(31 DOWNTO 26) = "000111") 
					) then

						state <= s8;

					elsif(

						-- Addi
						(instruction(31 DOWNTO 26) = "001000") OR

						-- Addiu
						(instruction(31 DOWNTO 26) = "001001") OR

						-- ANDI
						(instruction(31 DOWNTO 26) = "001100") OR

						-- ORI						
						(instruction(31 DOWNTO 26) = "001101") OR

						-- XORI
						(instruction(31 DOWNTO 26) = "001110") OR

						-- SLTI
						(instruction(31 DOWNTO 26) = "001010") OR

						-- SLTIU
						(instruction(31 DOWNTO 26) = "001011") 

					) then 

						state <= s9;

					elsif(

						-- JUMP
						(instruction(31 DOWNTO 26) = "000010") OR

						-- JR or JALR
						((instruction(31 DOWNTO 26) = "000000") AND
							((instruction(5 DOWNTO 0) = "001000") OR
							  (instruction(5 DOWNTO 0) = "001001"))) OR

						-- JAL
						(instruction(31 DOWNTO 26) = "000011") 
					) then 

						state <= s11;
					end if;

				when s2=>

					if(

						-- LW
						(instruction(31 DOWNTO 26) = "100011") OR

						-- LB
						(instruction(31 DOWNTO 26) = "100000") OR

						-- LH
						(instruction(31 DOWNTO 26) = "100001") OR

						-- LBU 
						(instruction(31 DOWNTO 26) = "100100") OR
						
						-- LHU
						(instruction(31 DOWNTO 26) = "100101") 

					) then

						state <= s3;

					elsif(

						-- SW
						(instruction(31 DOWNTO 26) = "101011") OR

						-- SB
						(instruction(31 DOWNTO 26) = "101000") OR

						-- SH
						(instruction(31 DOWNTO 26) = "101001")

					) then

						state <= s5;
					end if;

				when s3=>

					state <= s4;

				when s4=>

					state <= s0;

				when s5=>

					state <= s0;

				when s6=>

					state <= s7;

				when s7=> 

					state <= s0;

				when s8=>
					state <= s0;

				when s9=>
					
					state <= s10;
				
				when s10=>
					
					state <= s0;
					

				when s11=>
					state <= s0;

			end case;

		end if;
	end process;

	process(state)
	begin
		case state is

			-- Fetch
			when s0=>

				-- IorD = '0' --> choose instruction
				IorD <= '0';

				-- ALUSrcA = '0' --> choose PC
				ALUSrcA <= '0';

				-- ALUSrcB = "01" --> choose value 4
				ALUSrcB <= "01";

				-- ALUControl = "100000" --> ADD operation
				ALUControl <= "100000";
				PCSrc <= "00";
				IRWrite <= '1';
				PCWrite <= '1';

				RegWrite <= '0';
				MemWrite <= '0';

				LoadControl <= "100";

				Branch <= '0';

			-- Decode
			when s1=>
				ALUSrcA <=	'0';
				ALUSrcB <=	"11";
				ALUControl <= "100000";
				IRWrite <= '0';
				PCWrite <= '0';

			-- MemAdr (LW and SW)
			when s2=>
				ALUSrcA <=	'1';
				ALUSrcB <=	"10";
				ALUControl <= "100000";

				-- LB
				if(instruction(31 DOWNTO 26) = "100000") then 
					LoadControl <= "000";

				-- LH
				elsif(instruction(31 DOWNTO 26) = "100001") then
					LoadControl <= "001";

				-- LBU
				elsif(instruction(31 DOWNTO 26) = "100100") then 
					LoadControl <= "010";

				-- LHU
				elsif(instruction(31 DOWNTO 26) = "100101") then 
					LoadControl <= "011";

				else 	
					LoadControl <= "100";
				end if;

			-- MemRead (LW)
			when s3=>
				IorD <= '1';

			-- Mem Writeback
			when s4=>
				RegDst <= '0';
				MemToReg <= '0';
				RegWrite <= '1';

			-- MemWrite
			when s5=>
				IorD <= '1';
				MemWrite <= '1';

			-- Execute
			when s6=>
				ALUSrcA <= '1';
				ALUSrcB <= "00";

				ALUControl <= instruction(5 DOWNTO 0);

			-- ALU Writeback
			when s7=>
				RegDst <= '1';
				MemToReg <= '0';
				RegWrite <= '1';

			-- Branch
			when s8=>
				ALUSrcA <= '1';
				ALUSrcB <= "00";

				ALUControl <= instruction(5 DOWNTO 0);
				
				PCSrc <= "01";
				Branch <= '1';

			-- ADDI Execute
			when s9=>
				PCSrc <= "00";
				ALUSrcA <= '1';
				ALUSrcB <= "10";
				ALUControl <= instruction(5 DOWNTO 0);

			-- ADDI Writeback
			when s10=>
				RegDst <= '1';
				MemToReg <= '0';
				RegWrite <= '1';

			-- Jump
			when s11=>
				PCSrc <= "10";
				PCWrite <= '1';

		end case;
	end process;

end behavior;

