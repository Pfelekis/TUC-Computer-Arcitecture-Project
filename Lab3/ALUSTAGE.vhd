library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUSTAGE is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
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



SIGNAL muxout : STD_LOGIC_VECTOR (31 downto 0);
begin

	mux : mux2 Port Map( A    => RF_B, 	--0
								B    => Immed, --1
								Ctrl => ALU_Bin_Sel, 
								O    => muxout);
	
   ALU_label : ALU Port Map( A  		=> RF_A,
									  B  		=> muxout,
									  Op 		=> ALU_func,
									  O  		=> ALU_out,
									  Zero 	=> Zero);
	

end Structural;

