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
--		This is a a multi cycle processor
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/20/2016		Created						TH, NS, LV, SC
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY processor IS
	PORT (
		ref_clk : IN std_logic ;
		reset : IN std_logic
	);
END processor;

architecture behavior of processor is

---------------------------------------
-------------- components -------------
---------------------------------------

-- buffer_e
component buffer_e
	port (
		ref_clk : IN std_logic;
		WE : IN std_logic;
		DataI: IN std_logic_vector(31 DOWNTO 0);
		DataO: OUT std_logic_vector(31 DOWNTO 0)
	);
end component;

-- buffer_woe
component buffer_woe
	port (
		ref_clk : IN std_logic;
		DataI: IN std_logic_vector(31 DOWNTO 0);
		DataO: OUT std_logic_vector(31 DOWNTO 0)
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

-- mux_5bit
component mux_5bit
	port( 
		in0: in std_logic_vector(4 downto 0);
		in1: in std_logic_vector(4 downto 0);
		sel: in std_logic;
		outb: out std_logic_vector(4 downto 0)
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

-- memory
component memory
	port (
		ref_clk : IN std_logic;
		WE : IN std_logic;
		IorD : IN std_logic; 
		addr : IN std_logic_vector(31 DOWNTO 0); 
		WD : IN std_logic_vector(31 DOWNTO 0); 
		RD : OUT std_logic_vector(31 DOWNTO 0)
	);
end component;

-- regfile
component regfile
	PORT (
		ref_clk : IN std_logic ;
		rst_s : IN std_logic ; 
		we : IN std_logic ; -- write enable
		raddr_1 : IN std_logic_vector (4 DOWNTO 0); -- read address 1
		raddr_2 : IN std_logic_vector (4 DOWNTO 0); -- read address 2
		waddr : IN std_logic_vector (4 DOWNTO 0); -- write address
		rdata_1 : OUT std_logic_vector (31 DOWNTO 0); -- read data 1
		rdata_2 : OUT std_logic_vector (31 DOWNTO 0); -- read data 2
		wdata : IN std_logic_vector (31 DOWNTO 0) -- write data 1
	);
end component;

-- sign_extension_16bit
component sign_extension_16bit
	PORT(
		immediate : IN std_logic_vector(15 DOWNTO 0);
		sign_extension_out : OUT std_logic_vector(31 DOWNTO 0)
	);
end component;

-- buffer_2_woe
component buffer_2_woe
	PORT (
		ref_clk : IN std_logic;
		DataI_A : IN std_logic_vector(31 DOWNTO 0);
		DataI_B : IN std_logic_vector(31 DOWNTO 0);
		DataO_A : OUT std_logic_vector(31 DOWNTO 0);
		DataO_B: OUT std_logic_vector(31 DOWNTO 0)
	);
end component;

-- shiftleft_32bit
component shiftleft_32bit
	PORT (
		A_in : IN std_logic_vector (31 DOWNTO 0);
		O_out: OUT std_logic_vector (31 DOWNTO 0)
	);
end component;

-- shiftleft_26bit
component shiftleft_26bit
	PORT (
		A_in : IN std_logic_vector (25 DOWNTO 0);
		O_out: OUT std_logic_vector (27 DOWNTO 0)
	);
end component;

-- alu
component alu
	PORT (
		Func_in : IN std_logic_vector (5 DOWNTO 0);
		A_in : IN std_logic_vector (31 DOWNTO 0);
		B_in : IN std_logic_vector (31 DOWNTO 0);
		O_out : OUT std_logic_vector (31 DOWNTO 0);
		Branch_out : OUT std_logic
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

-- andgate
component andgate
	Port (
		IN1 : in STD_LOGIC; -- and gate input
    	IN2 : in STD_LOGIC; -- and gate input
		OUT1 : out STD_LOGIC
	); 
end component;

-- orgate
component orgate
	Port (
		IN1 : in STD_LOGIC; -- and gate input
    	IN2 : in STD_LOGIC; -- and gate input
		OUT1 : out STD_LOGIC
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



-- control
-- ************ missing some functionalities
component control
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
end component;


-----------------------------------------------
-------------- signals ------------------------
-----------------------------------------------
signal PCEnable : std_logic;
signal PCIn : std_logic_vector(31 DOWNTO 0);
signal PCOut : std_logic_vector(31 DOWNTO 0);

signal ALUOut: std_logic_vector(31 DOWNTO 0);

signal Adr: std_logic_vector(31 DOWNTO 0);

signal WriteData: std_logic_vector(31 DOWNTO 0);
signal RD_out: std_logic_vector(31 DOWNTO 0);

signal Instr_out: std_logic_vector(31 DOWNTO 0);
signal Data_out: std_logic_vector(31 DOWNTO 0);

signal waddr: std_logic_vector(4 DOWNTO 0);
signal wdata: std_logic_vector(31 DOWNTO 0);

signal RD1_out: std_logic_vector(31 DOWNTO 0);
signal RD2_out: std_logic_vector(31 DOWNTO 0);

signal ImmExt: std_logic_vector(31 DOWNTO 0);

signal DataO_A: std_logic_vector(31 DOWNTO 0);
signal DataO_B: std_logic_vector(31 DOWNTO 0);

signal SrcA: std_logic_vector(31 DOWNTO 0);
signal SrcB: std_logic_vector(31 DOWNTO 0);

signal ALUSrcB_11: std_logic_vector(31 DOWNTO 0);

signal value4: std_logic_vector (31 DOWNTO 0) := "00000000000000000000000000000100";

signal ALUResult: std_logic_vector(31 DOWNTO 0);

signal Zero: std_logic;

signal concatenation_b: std_logic_vector(31 DOWNTO 0);
signal concatenation_a: std_logic_vector(27 DOWNTO 0);
signal concatenation_out: std_logic_vector(31 DOWNTO 0);

signal andgate_out: std_logic;

signal shiftextend_out: std_logic_vector(31 DOWNTO 0);

signal IorD: std_logic;
signal MemWrite: std_logic;
signal IRWrite: std_logic;
signal RegDst: std_logic;
signal MemToReg: std_logic;
signal RegWrite: std_logic;
signal ALUSrcA: std_logic;
signal ALUSrcB: std_logic_vector(1 DOWNTO 0);
signal LoadControl: std_logic_vector(2 DOWNTO 0);
signal ALUControl: std_logic_vector(5 DOWNTO 0);
signal PCSrc: std_logic_vector(1 DOWNTO 0);
signal Branch: std_logic;
signal PCWrite: std_logic;
signal rs: std_logic_vector(4 DOWNTO 0);
signal rt: std_logic_vector(4 DOWNTO 0);
signal rd: std_logic_vector(4 DOWNTO 0);
signal imm: std_logic_vector(15 DOWNTO 0);
signal jumpshiftleft: std_logic_vector(25 DOWNTO 0);

signal emptyWire: std_logic_vector(31 DOWNTO 0);


------------------- begin --------------------- 
begin

	PCx:	buffer_e PORT MAP(ref_clk=>ref_clk, WE=>PCEnable, DataI=>PCIn, 
						DataO=>PCOut);	
	
	IorDmuxx:	mux PORT MAP(in0=>PCOut, in1=>shiftextend_out, sel=>IorD, outb=>Adr);
	
	Memoryx: 	memory PORT MAP(ref_clk=>ref_clk, WE=>MemWrite, IorD=>IorD, 
						addr=>Adr, WD=>WriteData, RD=>RD_out);

	Ibufferx:	buffer_e PORT MAP(ref_clk=>ref_clk, WE=>IRWrite, DataI=>RD_out,
						DataO=>Instr_out);

	Dbufferx:	buffer_woe PORT MAP(ref_clk=>ref_clk, DataI=>RD_out, DataO=>Data_out);

	RegDstmuxx:	mux_5bit PORT MAP(in0=>rt, in1=>rd, sel=>RegDst, outb=>waddr);

	MemToRegmuxx: mux PORT MAP(in0=>shiftextend_out, in1=>Data_out, sel=>MemToReg, 
						outb=>wdata);

	Regfilex: regfile PORT MAP(ref_clk=>ref_clk, rst_s=>reset, we=>RegWrite,
						raddr_1=>rs, raddr_2=>rt, waddr=>waddr, rdata_1=>RD1_out,
						rdata_2=>RD2_out, wdata=>wdata);

	SignExtendx:	sign_extension_16bit PORT MAP(immediate=>imm, sign_extension_out=>ImmExt);

	Regbufferx:	buffer_2_woe PORT MAP(ref_clk=>ref_clk, DataI_A=>RD1_out,
						DataI_B=>RD2_out, DataO_A=>DataO_A, DataO_B=>DataO_B);

	ALUSrcAmuxx: mux PORT MAP(in0=>PCOut, in1=>DataO_A, sel=>ALUSrcA, outb=>SrcA);

	ShiftLeft_32x: shiftleft_32bit PORT MAP(A_in=>ImmExt, O_out=>ALUSrcB_11);

	ALUSrcBmuxx:	mux4 PORT MAP(in0=>DataO_B, in1=>value4, in2=>ImmExt, 
						in3=>ALUSrcB_11, sel=>ALUSrcB, mux4out=>SrcB);

	ALUx:	alu PORT MAP(Func_in=>ALUControl, A_in=>SrcA, B_in=>SrcB, 
						O_out=>ALUResult, Branch_out=>Zero);

	ALUbufferx: buffer_woe PORT MAP(ref_clk=>ref_clk, DataI=>ALUResult, DataO=>ALUOut);

	ShiftLeft_26x: shiftleft_26bit PORT MAP(A_in=>jumpshiftleft, O_out=>concatenation_a);

	Concatenationx: concatenation PORT MAP(A_in=>concatenation_a, B_in=>concatenation_b, 
						O_out=>concatenation_out);

	PCSrcmxx: mux4 PORT MAP(in0=>ALUResult, in1=>ALUOut, in2=>concatenation_out, 
						in3=>emptyWire, sel=>PCSrc, mux4out=>PCIn);

	Shiftextendx: shiftextend PORT MAP(loadcontrol=>LoadControl, in32=>ALUOut, 
						out32=>shiftextend_out);

	Andgatex: andgate PORT MAP(IN1=>Branch, IN2=>Zero, OUT1=>andgate_out);

	Orgatex: orgate PORT MAP(IN1=>PCWrite, IN2=>andgate_out, OUT1=>PCEnable);

	Controlx: control PORT MAP(ref_clk=>ref_clk, reset=>reset, instruction=>Instr_out, 
						IorD=>IorD, ALUSrcA=>ALUSrcA, ALUSrcB=>ALUSrcB, 
						PCSrc=>PCSrc, IRWrite=>IRWrite, PCWrite=>PCWrite, 
						RegWrite=>RegWrite, MemWrite=>MemWrite, MemToReg=>MemToReg, 
						RegDst=>RegDst, Branch=>Branch, LoadControl=>LoadControl, 
						ALUControl=>ALUControl, rs=>rs, rt=>rt, rd=>rd, 
						imm=>imm, jumpshiftleft=>jumpshiftleft);




end behavior;