----------------------------------------------------------------------------------
-- Lab2C
-- Omada : Georgakopoulou Artemis
--			  Fragiadoulakis Manolis
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
			  con_out : in  STD_LOGIC_VECTOR (31 downto 0);
			  conout_B: in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_Sel : in  STD_LOGIC_VECTOR (2 downto 0);
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

Component mux8 is
    Port ( In1 	: in  STD_LOGIC_VECTOR (31 downto 0);
           In2 	: in  STD_LOGIC_VECTOR (31 downto 0);
			  In3 	: in  STD_LOGIC_VECTOR (31 downto 0);
           In4		: in  STD_LOGIC_VECTOR (31 downto 0);
			  In5 	: in  STD_LOGIC_VECTOR (31 downto 0);
           In6 	: in  STD_LOGIC_VECTOR (31 downto 0);
			  In7 	: in  STD_LOGIC_VECTOR (31 downto 0);
           In8 	: in  STD_LOGIC_VECTOR (31 downto 0);
			  Ctrl 	: in STD_LOGIC_VECTOR (2 downto 0);
           O 		: out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

SIGNAL mux1out : STD_LOGIC_VECTOR (4 downto 0);
SIGNAL mux2out : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL RF_A_sig : STD_LOGIC_VECTOR (31 downto 0);
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
	
	mux_DataIn : mux8 Port Map(In1 	=> ALU_out,   		--000
										In2 	=> MEM_out,			--001
										In3 	=> temp_immed, 	--010
 										In4	=> RF_A_sig,		--011	
										In5 	=> con_out,			--100
										In6 	=> conout_B,		--101
										In7 	=> (others=>'0'),	--110
										In8 	=> (others=>'0'),	--111
										Ctrl 	=> RF_WrData_Sel,
										O 		=> mux2out);

	
	RF : RegisterFile Port Map( Adr1		=> temp_instrout(25 downto 21),
										 Adr2		=> mux1out,
										 Awr 		=> temp_instrout(20 downto 16),
										 Dout1 	=> RF_A_sig,
										 Dout2 	=> RF_B,
										 Din		=>	mux2out,
										 WrEn		=> RF_WrEn,
										 CLK		=> Clk);
	RF_A	<=	RF_A_sig;
end Structural;

