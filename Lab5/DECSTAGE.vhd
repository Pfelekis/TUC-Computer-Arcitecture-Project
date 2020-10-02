library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DECSTAGE is
	Port (Clk 		: in  STD_LOGIC;
			Instr 	: in  STD_LOGIC_VECTOR (31 downto 0);
			RF_B_Sel : in  STD_LOGIC;
			RF_WrEn 	: in  STD_LOGIC;
			WrRd		: in  STD_LOGIC_VECTOR (4 downto 0);	--(rd)
			WrData 	: in  STD_LOGIC_VECTOR (31 downto 0);
			RegAEn 	: in  STD_LOGIC;
			RF_A 		: out  STD_LOGIC_VECTOR (31 downto 0);
			RegBEn 	: in  STD_LOGIC;
			RF_B 		: out  STD_LOGIC_VECTOR (31 downto 0);
			Immed 	: out  STD_LOGIC_VECTOR (31 downto 0));
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

Component mux5 is
    Port ( A : in  STD_LOGIC_VECTOR (4 downto 0);
           B : in  STD_LOGIC_VECTOR (4 downto 0);
			  Ctrl : in STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (4 downto 0));
end Component;

Component ImmedTo32 is
    Port ( Din 	: in  STD_LOGIC_VECTOR (15 downto 0);
           OpCode : in  STD_LOGIC_VECTOR (5 downto 0);
           Immed 	: out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component Reg is
    Port ( CLK : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WE 	: in  STD_LOGIC;
           Dout: out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

SIGNAL mux0out 	: STD_LOGIC_VECTOR (4 downto 0);
SIGNAL tempImmed 	: STD_LOGIC_VECTOR (31 downto 0);
SIGNAL A_Sig 		: STD_LOGIC_VECTOR (31 downto 0);
SIGNAL B_Sig 		: STD_LOGIC_VECTOR (31 downto 0);

begin
	
	mux5_label : mux5 Port Map(A    => Instr(15 downto 11), --0 (rt)
										B    => Instr(20 downto 16), --1 (rd)
										Ctrl => RF_B_Sel, 
										O    => mux0out);
									
	
	Immed_out : ImmedTo32 Port Map(	Din		=> Instr(15 downto 0),
												OpCode	=> Instr(31 downto 26),
												Immed		=> tempImmed);
	
	Immediate : Reg Port Map(CLK	=> Clk,
									Din	=> tempImmed,
									WE		=> '1',
									Dout	=> Immed);
								
	RF : RegisterFile Port Map(Adr1		=> Instr(25 downto 21),	-- (rs)
										Adr2		=> mux0out,
										Awr 		=> WrRd,
										Dout1 	=> A_Sig,
										Dout2 	=> B_Sig,
										Din		=>	WrData,
										WrEn		=> RF_WrEn,
										CLK		=> Clk);
										
	A_Reg : Reg Port Map(CLK	=> Clk,
								Din	=> A_Sig,
								WE		=> RegAEn,
								Dout	=> RF_A);
								
	B_Reg : Reg Port Map(CLK	=> Clk,
								Din	=> B_Sig,
								WE		=> RegBEn,
								Dout	=> RF_B);
end Structural;

