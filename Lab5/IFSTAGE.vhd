library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IFSTAGE is
	Port (PC_LdEn 		: in  STD_LOGIC;
			Reset 		: in  STD_LOGIC;
			Clk 			: in  STD_LOGIC;
			Instr 		: out  STD_LOGIC_VECTOR (31 downto 0));
end IFSTAGE;

architecture Structural of IFSTAGE is

Component IF_MEM is
	Port (clk 	: in std_logic;
			addr 	: in std_logic_vector(9 downto 0);
			dout 	: out std_logic_vector(31 downto 0));
end Component;

Component PC is
	Port (Din 			: in std_logic_vector(31 downto 0); -- system inputs
			PC_LdEn 		: in std_logic; -- enable
			Clk, Reset 	: in std_logic; -- clock and reset 
			Dout 			: out std_logic_vector(31 downto 0)); -- system outputs
end Component;

Component addImmed is
	Port(A : in  STD_LOGIC_VECTOR (31 downto 0);
		  B : in  STD_LOGIC_VECTOR (31 downto 0);
		  O : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

SIGNAL pcin : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL pcout : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL addOut : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin

add_label: addImmed Port Map(A => "00000000000000000000000000000100", -- "4"
									  B => pcout,
									  O => addOut);
							
PC_label : PC Port Map( Din		=> addOut,
								PC_LdEn	=> PC_LdEn, 
								Clk		=> Clk, 
								Reset		=> Reset,
								Dout		=> pcout);
						
IMEM : IF_MEM Port Map( clk	=> Clk,
								addr	=> pcout(11 downto 2),
								dout	=> Instr);

end Structural;

