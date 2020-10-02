library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUSTAGE is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
			  B_A	: in  STD_LOGIC_VECTOR (31 downto 0);
			  C_A	: in  STD_LOGIC_VECTOR (31 downto 0);
			  D_A	: in  STD_LOGIC_VECTOR (31 downto 0);
			  muxActrl : in STD_LOGIC_VECTOR (1 downto 0);
			  B_B	: in  STD_LOGIC_VECTOR (31 downto 0);
			  C_B	: in  STD_LOGIC_VECTOR (31 downto 0);
			  D_B	: in  STD_LOGIC_VECTOR (31 downto 0);
			  muxBctrl : in STD_LOGIC_VECTOR (1 downto 0);
           ALU_Bin_Sel : in  STD_LOGIC;
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

Component mux4 is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           C : in  STD_LOGIC_VECTOR (31 downto 0);
           D : in  STD_LOGIC_VECTOR (31 downto 0);
           Ctrl : in  STD_LOGIC_VECTOR (1 downto 0);
           muxOut : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

SIGNAL muxout : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL muxAout : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL muxBout : STD_LOGIC_VECTOR (31 downto 0);

begin

	mux : mux2 Port Map( A    => RF_B, 	--0
								B    => Immed, --1
								Ctrl => ALU_Bin_Sel, 
								O    => muxout);
								
	A_mux	: mux4 Port Map( A		=> RF_A,
								  B 		=> B_A,
								  C		=> C_A,
								  D		=> D_A,
								  Ctrl 	=> muxActrl,
								  muxOut => muxAout);
								  
	B_mux	: mux4 Port Map( A		=> muxout,
								  B 		=> B_B,
								  C		=> C_B,
								  D		=> D_B,
								  Ctrl 	=> muxBctrl,
								  muxOut => muxBout);
								  
   ALU_label : ALU Port Map( A  		=> muxAout,
									  B  		=> muxBout,
									  Op 		=> ALU_func,
									  O  		=> ALU_out,
									  Zero 	=> Zero);
	

end Structural;

