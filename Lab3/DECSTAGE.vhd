library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_Sel1 : in  STD_LOGIC;
			  RF_WrData_Sel2 : in  STD_LOGIC;
			  RF_RegEn : in  STD_LOGIC;
           RF_B_Sel : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0));
end DECSTAGE;

architecture Structural of DECSTAGE is

Component RegisterFile is
    Port ( Adr1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Adr2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0);
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WrEn : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
end Component;

Component mux2 is
    Port ( A 		: in  STD_LOGIC_VECTOR (31 downto 0);
           B 		: in  STD_LOGIC_VECTOR (31 downto 0);
			  Ctrl	: in STD_LOGIC;
           O 		: out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component mux5 is
    Port ( A : in  STD_LOGIC_VECTOR (4 downto 0);
           B : in  STD_LOGIC_VECTOR (4 downto 0);
			  Ctrl : in STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (4 downto 0));
end Component;

Component ImmedTo32 is
    Port ( Din : in  STD_LOGIC_VECTOR (15 downto 0);
           OpCode : in  STD_LOGIC_VECTOR (5 downto 0);
           Immed : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;
Component Reg is
    Port ( CLK : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

SIGNAL mux1out : STD_LOGIC_VECTOR (4 downto 0);
SIGNAL mux2out : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL mux3out : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL temp_immed : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL temp_instrout : STD_LOGIC_VECTOR (31 downto 0);
begin
	
	RegInstr : Reg Port Map( CLK 	=> Clk,
									  Din => Instr,
									  WE 	=> RF_RegEn,
									  Dout=> temp_instrout);
	mux2_1 : mux5 Port Map( A    => temp_instrout(15 downto 11), --0
									B    => temp_instrout(20 downto 16), --1
									Ctrl => RF_B_Sel, 
									O    => mux1out);
									
	
	Immed_out : ImmedTo32 Port Map(	Din		=> temp_instrout(15 downto 0),
												OpCode	=> temp_instrout(31 downto 26),
												Immed		=> temp_immed);
	Immed <= temp_immed;
	
	mux2_2 : mux2 Port Map( A    => ALU_out, --0
									B    => MEM_out, --1
									Ctrl => RF_WrData_Sel1, 
									O    => mux2out);
									
	mux2_3 : mux2 Port Map( A    => mux2out, --0
									B    => temp_immed, 	--1
									Ctrl => RF_WrData_Sel2, 
									O    => mux3out);
	
	RF : RegisterFile Port Map( Adr1		=> temp_instrout(25 downto 21),
										 Adr2		=> mux1out,
										 Awr 		=> temp_instrout(20 downto 16),
										 Dout1 	=> RF_A,
										 Dout2 	=> RF_B,
										 Din		=>	mux3out,
										 WrEn		=> RF_WrEn,
										 CLK		=> Clk);
end Structural;

