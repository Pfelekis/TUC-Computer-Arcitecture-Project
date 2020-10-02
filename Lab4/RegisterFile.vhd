----------------------------------------------------------------------------------
-- Lab1B
-- Omada : Georgakopoulou Artemis
--			  Fragiadoulakis Manolis
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.regarray_type.all;

entity RegisterFile is
    Port ( Adr1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Adr2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0);
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WrEn : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
end RegisterFile;

architecture Structural of RegisterFile is
Component Decoder is
    Port (Awr : in  STD_LOGIC_VECTOR (4 downto 0);
			 Registers : out STD_LOGIC_VECTOR (31 downto 0));
end Component;
Component Mux32 is
    Port (Registers : in regarray;
			 Ctrl 	  : in  STD_LOGIC_VECTOR (4 downto 0);
          Rout 	  : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;
Component Reg is
    Port ( CLK : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;
Component CompareModule is
    Port ( Adr : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           CM : out  STD_LOGIC);
end Component;
Component mux2 is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
			  Ctrl : in STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

SIGNAL temp1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL temp2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL temp3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL we  	 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL arraymuxsig : regarray;
SIGNAL control1 : STD_LOGIC;
SIGNAL control2 : STD_LOGIC;
SIGNAL temp4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL temp5 : STD_LOGIC_VECTOR(31 DOWNTO 0);
begin
	dec : Decoder Port Map (Awr => Awr,
									Registers => temp1 );
	
	Register0 : Reg Port Map ( CLK  => CLK,
										Din  => "00000000000000000000000000000000",
										WE   => '1',
										Dout => arraymuxsig(0));
	
	generate_registers:
	for i in 1 to 31 generate
		we(i) <= WrEn AND temp1(i);
		Register31x32 : Reg Port Map (CLK=>CLK,
												Din=>Din,
												WE=>we(i),
												Dout=>arraymuxsig(i));
	end generate;
	
	mu32x1: Mux32 Port Map(	Registers=>arraymuxsig,
									Ctrl=>Adr1,
									Rout=>temp2);
	mu32x2: Mux32 Port Map(	Registers=>arraymuxsig,
									Ctrl=>Adr2,
									Rout=>temp3);
	
	CM1: CompareModule Port Map (	Adr=>Adr1,
											Awr=>Awr,
											CM=>control1);
	CM2: CompareModule Port Map (	Adr=>Adr2,
											Awr=>Awr,
											CM=>control2);

	mu2x1: mux2 Port Map ( A => temp2, -- 0
								  B => Din,   -- 1
								  Ctrl=>control1, 
								  O=>temp4);
	Dout1	<=	temp4 when WrEn='1' else
				temp2;
	mu2x2: mux2 Port Map ( A => temp3,
								  B => Din,
								  Ctrl => control2, 
								  O => temp5);									  
	Dout2	<=	temp5 when WrEn='1' else
				temp3;
end Structural;

