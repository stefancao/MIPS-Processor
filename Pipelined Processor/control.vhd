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
--		This is a control unit of the processor
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/19/2016		Created						TH, NS, LV, SC
--	2/4/2016		Updated to work with 		SC 
--					new instructions for
--					Lab3		
--  3/1/2016		Edited for Lab5				LV		
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY control IS
	PORT (
		-- SC: i don't think we need clock 
		--clk : IN std_logic;
		instruction : IN std_logic_vector (31 DOWNTO 0);
		--funct: IN std_logic_vector(5 DOWNTO 0);

		Op: IN std_logic_vector(31 DOWNTO 26);

		Funct: IN std_logic_vector(5 DOWNTO 0);
		
		-----------------------------------------------
		--------------- Control Enables ---------------
		-----------------------------------------------
		-- write enable for regfile
		-- '0' if read, '1' if write
		RegWriteD: OUT std_logic;
		
		-- selecting output data from memory OR ALU result
		-- '1' if ALU result, '0' if mem result
		MemToRegD: OUT std_logic;
		
		-- write ebable for data memory
		-- '0' if not writing to mem, '1' if writing to mem
		MemWriteD: OUT std_logic;

		-- func for ALU
		ALUControlD: OUT std_logic_vector(5 DOWNTO 0);
		
		-- selecting sign extend OR raddr_2
		-- '0' if raddr_2 result, '1' if sign extend result
		ALUSrcD: OUT std_logic;
		
		-- selecting if 'rs' or 'rt' is selected to write destination (regfile)
		-- '1' if rd, '0' if rt
		RegDstD: OUT std_logic;

		-- '1' if branching, '0' if not branching
		BranchD: OUT std_logic;

		JumpD: OUT std_logic;

		-- '1' if jump instruction, else '0' 
		--Jump: OUT std_logic;

		-- '1' if JR instruction, else '0'
		--JRControl: OUT std_logic;

		-- '1' if JAL instruction and saves current address to register '31' else '0' 
		--JALAddr: OUT std_logic;

		-- "00" (LB/LH, and whatever comes out from memReg)
		-- "01" for LUI instruction,
		-- "10" for JAL, saves data of current instruction (or the next one)		 
		JALDataD: OUT std_logic_vector(1 DOWNTO 0);

		-- '1' if shift, else '0' (SLL, SRL, SRA ONLY)
		--ShiftControl: OUT std_logic;

		-- "000" if LB; "001" if LH; "010" if LBU; "011" if LHU; 
		-- "100" if normal, (don't do any manipulation to input) 
		LoadControlD: OUT std_logic_vector(2 DOWNTO 0)


		-- to regfile
		-- operand A
		--rs: OUT std_logic_vector(4 DOWNTO 0);

		-- operand B
		--rt: OUT std_logic_vector(4 DOWNTO 0);

		-- write address
		--rd: OUT std_logic_vector(4 DOWNTO 0);

		-- immediant, (rd+shamt+func)
		--imm: OUT std_logic_vector(15 DOWNTO 0);

		-- shamt
		--shamt: OUT std_logic_vector(4 DOWNTO 0);

		-- jump shift left
		--jumpshiftleft: OUT std_logic_vector(25 DOWNTO 0)
	);
END control;

architecture behavior of control is

begin
	
	-----------------------------------------------
	--------------- Control Enables ---------------
	-----------------------------------------------
	RegWriteD <= '1' when ( 
					
						-- if not BEQ
						NOT(instruction(31 DOWNTO 26)="000100") AND

						-- if not BNE
						NOT(instruction(31 DOWNTO 26)="000101") AND

						-- if not BLTZ or BGEZ
						NOT(instruction(31 DOWNTO 26)="000001") AND

						-- if not BLEZ
						NOT(instruction(31 DOWNTO 26)="000110") AND

						-- if not BGTZ
						NOT(instruction(31 DOWNTO 26)="000111") AND

						-- if not JUMP
						NOT(instruction(31 DOWNTO 26)="000010") AND

						-- if not JR
						NOT((instruction(31 DOWNTO 26)="000000") AND
								(instruction(5 DOWNTO 0)="001000")) AND

						-- if not SB
						NOT(instruction(31 DOWNTO 26)="101000") AND
						
						-- if not SH
						NOT(instruction(31 DOWNTO 26)="101001")
					) 	else 
				'0';

	ALUSrcD <= '1' when (	

						-- addi
						(instruction(31 DOWNTO 26) = "001000") OR

						-- ADDIU or JALR(can be anything)
						(instruction(31 DOWNTO 26) = "001001") OR

						-- SUBi and SubUi need to do...

						-- ANDI
						(instruction(31 DOWNTO 26) = "001100") OR

						-- ORI
						(instruction(31 DOWNTO 26) = "001101") OR

						-- XORI
						(instruction(31 DOWNTO 26) = "001110") OR

						-- SLTI
						(instruction(31 DOWNTO 26) = "001010") OR

						-- SLTUI
						(instruction(31 DOWNTO 26) = "001011") OR

						-- LUI
						(instruction(31 DOWNTO 26) = "001111") OR

						-- BEQ
						(instruction(31 DOWNTO 26) = "000100") OR
						-- BNE
						(instruction(31 DOWNTO 26) = "000101") OR
						
						-- BLTZ or BGEZ
						(instruction(31 DOWNTO 26) = "000001") OR

						-- BLEZ
						(instruction(31 DOWNTO 26) = "000110") OR

						-- BGTZ
						(instruction(31 DOWNTO 26) = "000111") OR

						-- LB
						(instruction(31 DOWNTO 26) = "100000") OR

						-- LH
						(instruction(31 DOWNTO 26) = "100001") OR

						-- SB
						(instruction(31 DOWNTO 26) = "101000") OR

						-- SH
						(instruction(31 DOWNTO 26) = "101001") OR

						-- LBU
						(instruction(31 DOWNTO 26) = "100100") OR

						-- LHU
						(instruction(31 DOWNTO 26) = "100101") OR

						-- LW
						(instruction(31 DOWNTO 26) = "100011") OR

						-- SW
						(instruction(31 DOWNTO 26) = "101011") 

						)	else 
				'0';

	MemWriteD <= '1' when (

						-- SB
						(instruction(31 DOWNTO 26) = "101000") OR

						-- SH
						(instruction(31 DOWNTO 26) = "101001") OR

						-- SW
						(instruction(31 DOWNTO 26) = "101011")
					)	else 
				'0';

	-- SC 2016-03-04: Changed MemToRegD <= '1'
	MemToRegD <= '1' when (

						-- LB
						(instruction(31 DOWNTO 26) = "100000") OR
						-- BEQ
						(instruction(31 DOWNTO 26) = "000100") OR
						-- LH
						(instruction(31 DOWNTO 26) = "100001") OR

						-- SB
						(instruction(31 DOWNTO 26) = "101000") OR

						-- SH
						(instruction(31 DOWNTO 26) = "101001") OR

						-- LBU
						(instruction(31 DOWNTO 26) = "100100") OR

						-- LHU
						(instruction(31 DOWNTO 26) = "100101") OR

						-- LW
						(instruction(31 DOWNTO 26) = "100011") OR

						-- SW
						(instruction(31 DOWNTO 26) = "101011") 
					)	else 
				'0';

	RegDstD <= '1' 	when (

						-- R-type and instruction with opcode "000000"
						-- 		all take RegDst='1'
						(instruction(31 DOWNTO 26) = "000000") 
					) 	else 
				'0';
		
	BranchD <= '1' 	when (

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
					)	else 
				'0';

	JumpD <= '1' when (

						-- JUMP
						(instruction(31 DOWNTO 26) = "000010")

					)	else 
				'0';

	LoadControlD <= "000" when(

							-- LB
							(instruction(31 DOWNTO 26) = "100000")
						) 	else 
					"001" when (

							-- LH
							(instruction(31 DOWNTO 26) = "100001")
						) 	else 
					"010" when (

							-- LBU
							(instruction(31 DOWNTO 26) = "100100")
						) 	else 
					"011" when (

							-- LHU
							(instruction(31 DOWNTO 26) = "100101")
						)	else 
					"100";

	JALDataD <= "10" when(

						-- JAL
						(instruction(31 DOWNTO 26) = "000011") OR

						-- JALR
						((instruction(31 DOWNTO 26) = "000000") AND
							(instruction(5 DOWNTO 0) = "001001"))
					)	else 
				"01" when (

						-- LUI
						(instruction(31 DOWNTO 26) = "001111")
					)	else 
				"00";

	ALUControlD <= "100000" when (

							-- ADDI
							(instruction(31 DOWNTO 26) = "001000")
						)	else 
				  "100001" when (

				  			-- ADDUI
				  			(instruction(31 DOWNTO 26) = "001001") OR

				  			-- LB
				  			(instruction(31 DOWNTO 26) = "100000") OR

				  			-- LH
				  			(instruction(31 DOWNTO 26) = "100001") OR

				  			-- SB
				  			(instruction(31 DOWNTO 26) = "101000") OR

				  			-- SH
				  			(instruction(31 DOWNTO 26) = "101001") OR

				  			-- LBU 
				  			(instruction(31 DOWNTO 26) = "100100") OR

				  			-- LHU
				  			(instruction(31 DOWNTO 26) = "100101") OR

				  			-- LW
				  			(instruction(31 DOWNTO 26) = "100011") OR

				  			-- SW
				  			(instruction(31 DOWNTO 26) = "101011") 
				  		)	else 
				  "100100" when (

				  			-- ANDI
				  			(instruction(31 DOWNTO 26) = "001100")
				  		)	else 
				  "100101" when (

				  			-- ORI
				  			(instruction(31 DOWNTO 26) = "001101")
				  		)	else
				  "100110" when (

				  			-- XORI
				  			(instruction(31 DOWNTO 26) = "001110")
				  		)	else 
				  "101010" when (

				  			-- SLTI
				  			(instruction(31 DOWNTO 26) = "001010")
				  		)	else
				  "101011" when (

				  			-- SLTIU
				  			(instruction(31 DOWNTO 26) = "001011")
				  		)	else 

				   -- SC 2016-03-04: Commented out, moved branching to branch_check.vhd
				  --"111100" when (
				  --			-- BEQ
				  --			(instruction(31 DOWNTO 26) = "000100")
				  --		)	else
				  --"111101" when (

				  --			-- BNE
				  --			(instruction(31 DOWNTO 26) = "000101")
				  --		)	else 
				  --"111000" when (

				  --			-- BLTZ
				  --			(instruction(31 DOWNTO 26) = "000001") AND
				  --			(instruction(20 DOWNTO 16) = "00000")	
				  --		)	else 
				  --"111001" when (

				  --			-- BGEZ
				  --			(instruction(31 DOWNTO 26) = "000001") AND
				  --			(instruction(20 DOWNTO 16) = "00001")	
				  --		)	else 
				  --"111110" when (

				  --			-- BLEZ
				  --			(instruction(31 DOWNTO 26) = "000110")	
				  --		)	else
				  --"111111" when (

				  --			-- BGTZ
				  --			(instruction(31 DOWNTO 26) = "000111")
				  --		)	else 
				  (instruction(5 DOWNTO 0));

end behavior;

