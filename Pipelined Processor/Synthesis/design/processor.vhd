-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: processor.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is a pipelined processor
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/27/2016		Created						TH, NS, LV, SC
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY processor IS
	PORT (
		ref_clk : IN std_logic ;
		reset : IN std_logic;

		-- This output signal is only necessary for synthesis
		out_b : OUT std_logic_vector(31 DOWNTO 0)
	);
END processor;

architecture behavior of processor is

---------------------------------------
-------------- components -------------
---------------------------------------

-- shiftlui
component shiftlui
	port(
		in32: IN std_logic_vector (31 downto 0);
		out32: OUT std_logic_vector (31 downto 0)
	);
end component;

-- shiftextend
component shiftextend
	port(
		loadcontrol:	IN std_logic_vector(2 downto 0);
		in32:		IN std_logic_vector (31 downto 0);
		out32:		OUT std_logic_vector(31 downto 0)
	);
end component;

-- concatenation
component concatenation
	PORT (
		A_in : IN std_logic_vector (27 DOWNTO 0);
		B_in : IN std_logic_vector (31 DOWNTO 0);
		O_out : OUT std_logic_vector (31 DOWNTO 0)
	);
end component;

-- shiftleft_26bit
component shiftleft_26bit
	PORT (
		A_in : IN std_logic_vector (25 DOWNTO 0);
		O_out: OUT std_logic_vector (27 DOWNTO 0)
	);
end component;

-- orgate
component orgate
	Port (
		IN1 : in STD_LOGIC; 
    	IN2 : in STD_LOGIC; 
		OUT1 : out STD_LOGIC
	); 
end component;

-- mux
component mux
	port( 
		in0: in std_logic_vector(31 downto 0);
		in1: in std_logic_vector(31 downto 0);
		sel: in std_logic;
		outb: out std_logic_vector(31 downto 0)
	);
end component;

-- mux4
component mux4
	port(   
		in0: in std_logic_vector(31 downto 0);
		in1: in std_logic_vector(31 downto 0);
		in2: in std_logic_vector(31 downto 0);
		in3: in std_logic_vector(31 downto 0);		
		sel: in std_logic_vector(1 downto 0);
		mux4out: out std_logic_vector(31 downto 0)
	);
end component;

-- mux_5bit
component mux_5bit
	port( 
		in0: in std_logic_vector(4 downto 0);
		in1: in std_logic_vector(4 downto 0);
		sel: in std_logic;
		outb: out std_logic_vector(4 downto 0)
	);
end component;

-- buffer_e
component buffer_e
	port (
		ref_clk : IN std_logic;
		WE : IN std_logic;
		DataI: IN std_logic_vector(31 DOWNTO 0);
		DataO: OUT std_logic_vector(31 DOWNTO 0)
	);
end component;

-- rom
component rom
	port(
		addr: IN STD_LOGIC_VECTOR(31 downto 0); 
		dataOut: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end component;

-- adder 
component adder
	port(
		a : in std_logic_vector(31 downto 0);
		b : in std_logic_vector(31 downto 0);	
		sum	: out std_logic_vector(31 downto 0)
	);
end component;

-- reg1 ************************ NOT IMPLEMENTED NEED TO LOOK AT THIS AGAIN
component reg1
	PORT (
		ref_clk : IN std_logic;
		RD : IN std_logic_vector(31 DOWNTO 0);
		PCPlus4F: IN std_logic_vector(31 DOWNTO 0);
		en:	  	  IN std_logic; --enable from stallD
		clr:	  IN std_logic; -- clear enable from PCSrc
		InstrD : OUT std_logic_vector(31 DOWNTO 0);
		PCPlus4D : OUT std_logic_vector(31 DOWNTO 0)	
	);
end component;

-- reg2 ************************ NOT IMPLEMENTED NEED TO LOOK AT THIS AGAIN
component reg2
	PORT(
		ref_clk:		IN std_logic;
		RegWriteD:		IN std_logic;
		MemtoRegD:		IN std_logic;
		MemWriteD:		IN std_logic;
		ALUControlD:	IN std_logic_vector(5 downto 0);
		ALUSrcD: 		IN std_logic;
		RegDstD:		IN std_logic;
		LoadControlD:	IN std_logic_vector(2 DOWNTO 0);
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
		LoadControlE: 	OUT std_logic_vector(2 DOWNTO 0);
		RD1toMux1:		OUT std_logic_vector(31 downto 0);
		RD2toMux2:		OUT std_logic_vector(31 downto 0);
		RsE:			OUT std_logic_vector(25 downto 21);
		RtE:			OUT std_logic_vector(20 downto 16);
		RdE:			OUT std_logic_vector(15 downto 11);
		SignImmE:		OUT std_logic_vector(31 downto 0);
		JALDataE:		OUT std_logic_vector(1 downto 0)
	);
end component;

-- reg3 ************************ NOT IMPLEMENTED NEED TO LOOK AT THIS AGAIN
component reg3
	PORT (
		ref_clk : 		IN std_logic;
		RegWriteE : 	IN std_logic;
		MemtoRegE : 	IN std_logic;
		MemWriteE: 	IN std_logic;
		LoadControlE: IN std_logic_vector(2 DOWNTO 0);
		alu_in:			IN std_logic_vector(31 DOWNTO 0);
		WriteDataE:		IN std_logic_vector(31 DOWNTO 0);
		WriteRegE:		IN std_logic_vector(4 DOWNTO 0);
		SignImmE:		IN std_logic_vector(31 DOWNTO 0);
		JALDataE:		IN std_logic_vector(1 DOWNTO 0);	

		RegWriteM : 	OUT std_logic;
		MemtoRegM : 	OUT std_logic;
		MemWriteM : 	OUT std_logic;
		LoadControlM: 	OUT std_logic_vector(2 DOWNTO 0);
		alu_out:		OUT std_logic_vector(31 DOWNTO 0);
		WriteDataM:		OUT std_logic_vector(31 DOWNTO 0);
		WriteRegM:		OUT std_logic_vector(4 DOWNTO 0);
		SignImmM:		OUT std_logic_vector(31 DOWNTO 0);
		JALDataM: 		OUT std_logic_vector(1 DOWNTO 0)				
	);
end component;

-- reg4 ************************ NOT IMPLEMENTED NEED TO LOOK AT THIS AGAIN
component reg4
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
end component;

-- control ************************ NOT IMPLEMENTED NEED TO LOOK AT THIS AGAIN
component control
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
end component;

-- regfile
component regfile
	PORT (
		ref_clk : IN std_logic;
		we : IN std_logic ; -- write enable
		raddr_1 : IN std_logic_vector (4 DOWNTO 0); -- read address 1
		raddr_2 : IN std_logic_vector (4 DOWNTO 0); -- read address 2
		waddr : IN std_logic_vector (4 DOWNTO 0); -- write address
		rdata_1 : OUT std_logic_vector (31 DOWNTO 0); -- read data 1
		rdata_2 : OUT std_logic_vector (31 DOWNTO 0); -- read data 2
		wdata : IN std_logic_vector (31 DOWNTO 0); -- write data 1
		reset: IN std_logic
	);
end component;

-- sign_extension_16bit
component sign_extension_16bit
	PORT(
		immediate : IN std_logic_vector(15 DOWNTO 0);
		sign_extension_out : OUT std_logic_vector(31 DOWNTO 0)
	);
end component;

-- shiftleft_32bit
component shiftleft_32bit
	PORT (
		A_in : IN std_logic_vector (31 DOWNTO 0);
		O_out: OUT std_logic_vector (31 DOWNTO 0)
	);
end component;

-- andgate
component andgate
	Port (
		IN1 : in STD_LOGIC; -- and gate input
    	IN2 : in STD_LOGIC; -- and gate input
		OUT1 : out STD_LOGIC
	); 
end component;

-- SC 2016-03-04: Commneted out, using branch check that support all the branch instructions
---- equal_comparison 
--component equal_comparison
--	port (
--		in0 : IN std_logic_vector(31 DOWNTO 0);
--		in1 : IN std_logic_vector(31 DOWNTO 0);
--		outb : OUT std_logic
--	);
--end component;

-- branch_check
component branch_check
	port (
		A_in : IN std_logic_vector(31 DOWNTO 0);
		B_in : IN std_logic_vector(31 DOWNTO 0);
		ALUControl : IN std_logic_vector(5 DOWNTO 0);
		outb : OUT std_logic
	);
end component;

-- alu
component alu
	PORT (
		Func_in : IN std_logic_vector (5 DOWNTO 0);
		A_in : IN std_logic_vector (31 DOWNTO 0);
		B_in : IN std_logic_vector (31 DOWNTO 0);
		O_out : OUT std_logic_vector (31 DOWNTO 0)

		-- ******************************************** COMMENTED OUT FOR NOW DON"T NOW IF IT NEEDS THIS
		--Branch_out : OUT std_logic
	);
end component;

-- ram
component ram
	port (
		ref_clk : IN std_logic;
		we : IN std_logic;
		addr : IN std_logic_vector(31 DOWNTO 0); 
		dataI : IN std_logic_vector(31 DOWNTO 0); 
		dataO : OUT std_logic_vector(31 DOWNTO 0)
	);
end component;

-- hazard_unit ************************ NOT IMPLEMENTED NEED TO LOOK AT THIS AGAIN
component hazard_unit
	PORT(
		BranchD : IN std_logic;
		RsD: IN std_logic_vector (4 DOWNTO 0);
		RtD: IN std_logic_vector (4 DOWNTO 0);
		RsE: IN std_logic_vector (4 DOWNTO 0);
		RtE: IN std_logic_vector (4 DOWNTO 0);
		WriteRegE: IN std_logic_vector (4 DOWNTO 0);
		WriteRegM: IN std_logic_vector (4 DOWNTO 0);
		WriteRegW: IN std_logic_vector (4 DOWNTO 0);
		MemtoRegE: IN std_logic;
		RegWriteE: IN std_logic;
		RegWriteM: IN std_logic;
		RegWriteW: IN std_logic;
		JumpD: IN std_logic; -- added for jump
		StallF: OUT std_logic;
		StallD: OUT std_logic;
		ForwardAD: OUT std_logic;
		ForwardBD: OUT std_logic;
		FlushE: OUT std_logic;
		ForwardAE: OUT std_logic_vector (1 DOWNTO 0);
		ForwardBE: OUT std_logic_vector (1 DOWNTO 0)
	);
end component;

-----------------------------------------------
-------------- signals ------------------------
-----------------------------------------------

signal PCSrcD : std_logic;
signal PCPlus4F : std_logic_vector(31 DOWNTO 0);
signal PCPlus4D : std_logic_vector(31 DOWNTO 0);
signal PCBranchD : std_logic_vector(31 DOWNTO 0);
signal PC_in : std_logic_vector(31 DOWNTO 0);

signal PCF : std_logic_vector(31 DOWNTO 0);
signal IR_out : std_logic_vector(31 DOWNTO 0);

-- value '4'
--signal adder_value_4 : std_logic_vector (31 DOWNTO 0) := "00000000000000000000000000000100";

signal InstrD : std_logic_vector(31 DOWNTO 0);

signal RD1_out: std_logic_vector(31 DOWNTO 0);
signal RD2_out: std_logic_vector(31 DOWNTO 0);

signal ResultW: std_logic_vector(31 DOWNTO 0);

signal SignImmD: std_logic_vector(31 DOWNTO 0);

signal shift_out: std_logic_vector(31 DOWNTO 0);

signal EqualD: std_logic;

signal ForwardAD_mux_out : std_logic_vector(31 DOWNTO 0);
signal ForwardBD_mux_out: std_logic_vector(31 DOWNTO 0);

signal RD1toMux1: std_logic_vector(31 DOWNTO 0);
signal RD2toMux2: std_logic_vector(31 DOWNTO 0);

signal ALU_out: std_logic_vector(31 DOWNTO 0);

signal ram_data_out: std_logic_vector(31 DOWNTO 0);

signal RegWriteD: std_logic;
signal MemtoRegD: std_logic;
signal MemWriteD: std_logic;
signal ALUControlD: std_logic_vector(5 DOWNTO 0);
signal ALUSrcD: std_logic;
signal RegDstD: std_logic;
signal BranchD: std_logic;
signal JumpD: std_logic;

signal RegWriteE: std_logic;
signal MemtoRegE: std_logic;
signal MemWriteE: std_logic;
signal ALUControlE: std_logic_vector(5 DOWNTO 0);
signal ALUSrcE: std_logic;
signal RegDstE: std_logic;

signal RsE: std_logic_vector(25 DOWNTO 21);
signal RtE: std_logic_vector(20 DOWNTO 16);
signal RdE: std_logic_vector(15 DOWNTO 11);
signal SignImmE: std_logic_vector(31 DOWNTO 0);
signal WriteRegE: std_logic_vector(4 DOWNTO 0);
signal WriteDataE: std_logic_vector(31 DOWNTO 0);
signal MemtoWriteE: std_logic;
signal SrcAE: std_logic_vector(31 DOWNTO 0);
signal SrcBE: std_logic_vector(31 DOWNTO 0);

signal RegWriteM: std_logic;
signal MemtoRegM: std_logic;
signal MemWriteM: std_logic;
signal WriteDataM: std_logic_vector(31 DOWNTO 0);
signal WriteRegM: std_logic_vector(4 DOWNTO 0);

signal RegWriteW: std_logic;
signal MemtoRegW: std_logic;
signal ReadDataW: std_logic_vector(31 DOWNTO 0);
signal ALUOutW: std_logic_vector(31 DOWNTO 0);
signal WriteRegW: std_logic_vector(4 DOWNTO 0);

signal ALUOutM: std_logic_vector(31 DOWNTO 0);

signal ForwardAD: std_logic;
signal ForwardBD: std_logic;
signal ForwardAE: std_logic_vector(1 DOWNTO 0);
signal ForwardBE: std_logic_vector(1 DOWNTO 0);
signal StallF : std_logic;
signal StallD : std_logic;
signal FlushE: std_logic;

signal LoadControlD: std_logic_vector(2 DOWNTO 0);
signal LoadControlE: std_logic_vector(2 DOWNTO 0);
signal LoadControlM: std_logic_vector(2 DOWNTO 0);
signal LoadControlW: std_logic_vector(2 DOWNTO 0);

signal andgate_out: std_logic;

signal shiftleft_26bit_out: std_logic_vector(27 DOWNTO 0);

signal PCJumpD: std_logic_vector(31 DOWNTO 0);

signal JumpDmux_out: std_logic_vector(31 DOWNTO 0);

signal emptyWire: std_logic_vector(31 DOWNTO 0);

signal MemtoRegWmuxx_out: std_logic_vector(31 DOWNTO 0);

signal shiftlui_out: std_logic_vector(31 DOWNTO 0);

signal JALDataW_out: std_logic_vector(31 DOWNTO 0);

signal SignImmM: std_logic_vector(31 DOWNTO 0);
signal SignImmW: std_logic_vector(31 DOWNTO 0);

signal JALDataD: std_logic_vector(1 DOWNTO 0);
signal JALDataE: std_logic_vector(1 DOWNTO 0);
signal JALDataM: std_logic_vector(1 DOWNTO 0);
signal JALDataW: std_logic_vector(1 DOWNTO 0);


------------------- begin --------------------- 
begin

	PCmuxx:	mux PORT MAP(in0=>PCPlus4F, in1=>PCBranchD, sel=>PCSrcD, outb=>PC_in);

	PC_regx: buffer_e PORT MAP(ref_clk=>ref_clk, WE=>StallF, DataI=>PC_in, DataO=>PCF);

	IRx: rom PORT MAP(addr=>PCF, dataOut=>IR_out);

	PCadderx: adder PORT MAP(a=>PCF, b=>"00000000000000000000000000000100", sum=>PCPlus4F);

	reg1x: reg1 PORT MAP(ref_clk=>ref_clk, RD=>IR_out, PCPlus4F=>PCPlus4F, 
					en=>stallD, clr=>PCSrcD, InstrD=>InstrD, PCPlus4D=>PCPlus4D);

	controlx: control PORT MAP(instruction=>InstrD, Op=>InstrD(31 DOWNTO 26), Funct=>InstrD(5 DOWNTO 0),
					RegWriteD=>RegWriteD, MemtoRegD=>MemtoRegD, MemWriteD=>MemWriteD,
					ALUControlD=>ALUControlD, ALUSrcD=>ALUSrcD, RegDstD=>RegDstD,
					BranchD=>BranchD, JumpD=>JumpD, JALDataD=>JALDataD,
					LoadControlD=>LoadControlD);

	regfilex: regfile PORT MAP(ref_clk=>ref_clk, we=>RegWriteW, raddr_1=>InstrD(25 DOWNTO 21),
					raddr_2=>InstrD(20 DOWNTO 16), waddr=>WriteRegW, rdata_1=>RD1_out,
					rdata_2=>RD2_out, wdata=>JALDataW_out, reset=>reset);

	sign_extension_16bitx: sign_extension_16bit PORT MAP(immediate=>InstrD(15 DOWNTO 0),
					sign_extension_out=>SignImmD);

	shiftleft_32bitx: shiftleft_32bit PORT MAP(A_in=>SignImmD, O_out=>shift_out);

	andgatex: andgate PORT MAP(IN1=>BranchD, IN2=>EqualD, OUT1=>andgate_out);

	orgatex: orgate PORT MAP(IN1=>JumpD, IN2=> andgate_out, OUT1=>PCSrcD);

	-- SC 2016-03-04: Commented out, using branch_check instead
	--equal_comparisonx: equal_comparison PORT MAP(in0=>ForwardAD_mux_out, 
	--				in1=>ForwardBD_mux_out, outb=>EqualD);

	branch_checkx: branch_check PORT MAP(A_in=>ForwardAD_mux_out, B_in=>ForwardBD_mux_out,
					ALUControl=>ALUControlD, outb=>EqualD);

	ForwardAD_muxx: mux PORT MAP(in0=>RD1_out, in1=>ALUOutM, sel=>ForwardAD, 
					outb=>ForwardAD_mux_out);

	ForwardBD_muxx: mux PORT MAP(in0=>RD2_out, in1=>ALUOutM, sel=>ForwardBD, 
					outb=>ForwardBD_mux_out);

	adderx: adder PORT MAP(a=>shift_out, b=>PCPlus4D, sum=>PCBranchD);

	shiftleft_26bitx: shiftleft_26bit PORT MAP(A_in=>InstrD(25 DOWNTO 0), 
					O_out=>shiftleft_26bit_out);

	concatenationx: concatenation PORT MAP(A_in=>shiftleft_26bit_out, 
					B_in=>PCPlus4D, O_out=>PCJumpD);

	JumpDmuxx: mux PORT MAP(in0=>PCBranchD, in1=>PCJumpD, sel=>JumpD, outb=>JumpDmux_out);

	reg2x: reg2 PORT MAP(ref_clk=>ref_clk, RegWriteD=>RegWriteD, MemtoRegD=>MemtoRegD,
					MemWriteD=>MemWriteD, ALUControlD=>ALUControlD,
					ALUSrcD=>ALUSrcD, RegDstD=>RegDstD, LoadControlD=>LoadControlD, RD1=>RD1_out,
					RD2=>RD2_out, RsD=>InstrD(25 DOWNTO 21), RtD=>InstrD(20 DOWNTO 16),
					RdD=>InstrD(15 DOWNTO 11), SignImmD=>SignImmD,
					clr=>FlushE, JALDataD=>JALDataD,
					RegWriteE=>RegWriteE, MemtoRegE=>MemtoRegE,
					MemWriteE=>MemWriteE, ALUControlE=>ALUControlE,
					ALUSrcE=>ALUSrcE, RegDstE=>RegDstE, LoadControlE=>LoadControlE, RD1toMux1=>RD1toMux1,
					RD2toMux2=>RD2toMux2, RsE=>RsE, RtE=>RtE, RdE=>RdE,
					SignImmE=>SignImmE, JALDataE=>JALDataE);

	RegDstEmuxx: mux_5bit PORT MAP(in0=>RtE, in1=>RdE, sel=>RegDstE, outb=>WriteRegE);
	
	ForwardAEmuxx: mux4 PORT MAP(in0=>RD1toMux1, in1=>ResultW, in2=>ALUOutM, 
					in3=>emptyWire, sel=>ForwardAE, mux4out=>SrcAE);	

	ForwardBEmuxx: mux4 PORT MAP(in0=>RD2toMux2, in1=>ResultW, in2=>ALUOutM, 
					in3=>emptyWire, sel=>ForwardBE, mux4out=>WriteDataE);

	ALUSrcEmuxx: mux PORT MAP(in0=>WriteDataE, in1=>SignImmE, sel=>ALUSrcE, 
					outb=>SrcBE);

	ALUx: alu PORT MAP(Func_in=>ALUControlE, A_in=>SrcAE, B_in=>SrcBE, 
					O_out=>ALU_out);

	reg3x: reg3 PORT MAP(ref_clk=>ref_clk, RegWriteE=>RegWriteE, MemtoRegE=>MemtoRegE,
					MemWriteE=>MemWriteE, LoadControlE=>LoadControlE, alu_in=>ALU_out, WriteDataE=>WriteDataE,
					WriteRegE=>WriteRegE, SignImmE=>SignImmE, JALDataE=>JALDataE,
					RegWriteM=>RegWriteM, MemtoRegM=>MemtoRegM, 
					MemWriteM=>MemWriteM, LoadControlM=>LoadControlM, alu_out=>ALUOutM, WriteDataM=>WriteDataM,
					WriteRegM=>WriteRegM, SignImmM=>SignImmM, JALDataM=>JALDataM);

	ramx: ram PORT MAP(ref_clk=>ref_clk, we=>MemWriteM, addr=>ALUOutM, 
					dataI=>WriteDataM, dataO=>ram_data_out);

	reg4x: reg4 PORT MAP(ref_clk=>ref_clk, RegWriteM=>RegWriteM, MemtoRegM=>MemtoRegM, LoadControlM=>LoadControlM,
					rd_in=>ram_data_out, alu_in=>ALUOutM,
					WriteRegM=>WriteRegM, SignImmM=>SignImmM, JALDataM=>JALDataM,
					RegWriteW=>RegWriteW, MemtoRegW=>MemtoRegW, LoadControlW=>LoadControlW,	
					rd_out=>ReadDataW, alu_out=>ALUOutW, WriteRegW=>WriteRegW,
					SignImmW=>SignImmW, JALDataW=>JALDataW);

	shiftluix: shiftlui PORT MAP(in32=>SignImmW, out32=>shiftlui_out);

	MemtoRegWmuxx: mux PORT MAP(in0=>ALUOutW, in1=>ReadDataW, sel=>MemtoRegW, 
					outb=>MemtoRegWmuxx_out);

	HazardUnitx: hazard_unit PORT MAP(BranchD=>BranchD, RsD=>InstrD(25 DOWNTO 21), 
					RtD=>InstrD(20 DOWNTO 16), RsE=>RsE, RtE=>RtE, 
					WriteRegE=>WriteRegE, WriteRegM=>WriteRegM, 
					WriteRegW=>WriteRegW, MemtoRegE=>MemtoRegE, 
					RegWriteE=>RegWriteE, RegWriteM=>RegWriteM, RegWriteW=>RegWriteW, 
					JumpD=>JumpD, StallF=>StallF, StallD=>StallD, ForwardAD=>ForwardAD, 
					ForwardBD=>ForwardBD, FlushE=>FlushE, ForwardAE=>ForwardAE, 
					ForwardBE=>ForwardBE);

	-- ******************* fix, in2 for JAL
	JalDataWmuxx: mux4 PORT MAP(in0=>ResultW, in1=>shiftlui_out, in2=>emptyWire, 
					in3=>emptyWire, sel=>JALDataW, mux4out=>JALDataW_out);

	shiftextendx: shiftextend PORT MAP(loadcontrol=>LoadControlW, in32=>MemtoRegWmuxx_out,
					out32=>ResultW);

	out_b <= ALU_out;

end behavior;