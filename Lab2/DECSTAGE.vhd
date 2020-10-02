library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_Sel : in  STD_LOGIC;
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

SIGNAL mux1out : STD_LOGIC_VECTOR (4 downto 0);
SIGNAL mux2out : STD_LOGIC_VECTOR (31 downto 0);

begin

	mux2_1 : mux5 Port Map( A    => Instr(15 downto 11), --0
									B    => Instr(20 downto 16), --1
									Ctrl => RF_B_Sel, 
									O    => mux1out);
	Immed_out : ImmedTo32 Port Map(	Din		=> Instr(15 downto 0),
												OpCode	=> Instr(31 downto 26),
												Immed		=> Immed);
	mux2_2 : mux2 Port Map( A    => ALU_out, --0
									B    => MEM_out, --1
									Ctrl => RF_WrData_Sel, 
									O    => mux2out);
	RF : RegisterFile Port Map( Adr1		=> Instr(25 downto 21),
										 Adr2		=> mux1out,
										 Awr 		=> Instr(20 downto 16),
										 Dout1 	=> RF_A,
										 Dout2 	=> RF_B,
										 Din		=>	mux2out,
										 WrEn		=> RF_WrEn,
										 CLK		=> Clk);
end Structural;

