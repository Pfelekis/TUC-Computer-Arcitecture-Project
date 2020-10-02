----------------------------------------------------------------------------------
-- Lab2D
-- Omada : Georgakopoulou Artemis
--			  Fragiadoulakis Manolis
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUSTAGE is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
			  zero_B : in  STD_LOGIC_VECTOR (31 downto 0);
			  MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
			  base_addr		: in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Bin_Sel : in STD_LOGIC_VECTOR (2 downto 0);
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  Zero : out  STD_LOGIC);
end ALUSTAGE;

architecture Structural of ALUSTAGE is

Component ALU is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           O : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Ovf : out  STD_LOGIC);
end Component;

Component mux2 is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
			  Ctrl : in STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (31 downto 0));
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



SIGNAL muxout : STD_LOGIC_VECTOR (31 downto 0);
begin

	mux : mux8 Port Map(	In1 	=> RF_B,				--000
								In2 	=> Immed,			--001
								In3 	=> zero_B,			--010
								In4	=> MEM_out,			--011	
								In5 	=> base_addr,		--100
								In6 	=> (others=>'0'),	--101
								In7 	=> (others=>'0'),	--110
								In8 	=> (others=>'0'),	--111
								Ctrl 	=> ALU_Bin_Sel,
								O 		=> muxout);
										
   ALU_label : ALU Port Map( A  		=> RF_A,
									  B  		=> muxout,
									  Op 		=> ALU_func,
									  O  		=> ALU_out,
									  Zero 	=> Zero);
	

end Structural;

