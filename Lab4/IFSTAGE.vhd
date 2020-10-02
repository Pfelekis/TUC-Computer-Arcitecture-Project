----------------------------------------------------------------------------------
-- Lab2B
-- Omada : Georgakopoulou Artemis
--			  Fragiadoulakis Manolis
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IFSTAGE is
    Port ( PC_Immed 	: in  STD_LOGIC_VECTOR (31 downto 0);
           PC_Sel 	: in  STD_LOGIC;
           PC_LdEn 	: in  STD_LOGIC;
           Reset 		: in  STD_LOGIC;
           Clk 		: in  STD_LOGIC;
           Instr 		: out  STD_LOGIC_VECTOR (31 downto 0));
end IFSTAGE;

architecture Structural of IFSTAGE is

Component IF_MEM is
	port (
		clk 	: in std_logic;
		addr 	: in std_logic_vector(9 downto 0);
		dout 	: out std_logic_vector(31 downto 0));
end Component;

Component PC is
	port (Din 			: in std_logic_vector(31 downto 0); -- system inputs
			PC_LdEn 		: in std_logic; -- enable
			Clk, Reset 	: in std_logic; -- clock and reset 
			Dout 			: out std_logic_vector(31 downto 0)); -- system outputs
end Component;

Component mux2 is
    Port ( A 		: in  STD_LOGIC_VECTOR (31 downto 0);
           B 		: in  STD_LOGIC_VECTOR (31 downto 0);
			  Ctrl	: in STD_LOGIC;
           O 		: out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component add4 is
	Port(A : in  STD_LOGIC_VECTOR (31 downto 0);
		  O : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component addImmed is
	Port(A : in  STD_LOGIC_VECTOR (31 downto 0);
		  B : in  STD_LOGIC_VECTOR (31 downto 0);
		  O : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

SIGNAL pcadd4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL pcin : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL pcout : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL addImOut : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin

add4_label: add4 Port Map( A => pcout,
									O => pcadd4);
							
addImmed_label: addImmed Port Map( A => pcadd4,
											  B => PC_Immed,
											  O => addImOut);
									  
mux : mux2 Port Map( A    => pcadd4,	--0
							B    => addImOut,	--1
							Ctrl => PC_Sel, 
							O    => pcin);
							
PC_label : PC Port Map( Din		=> pcin,
								PC_LdEn	=> PC_LdEn, 
								Clk		=> Clk, 
								Reset		=> Reset,
								Dout		=> pcout);
						
IMEM : IF_MEM Port Map( clk	=> Clk,
								addr	=> pcout(11 downto 2),
								dout	=> Instr);

end Structural;

