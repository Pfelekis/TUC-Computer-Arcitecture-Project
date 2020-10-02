library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity addImmed is
	Port(A : in  STD_LOGIC_VECTOR (31 downto 0);
		  B : in  STD_LOGIC_VECTOR (31 downto 0);
		  O : out  STD_LOGIC_VECTOR (31 downto 0));
end addImmed;

architecture Behavioral of addImmed is

Component fulladder is
	 Port ( X : in  STD_LOGIC;
           Y : in  STD_LOGIC;
           Cin : in  STD_LOGIC;
           S : out  STD_LOGIC;
           Carryout : out  STD_LOGIC);
end Component;

SIGNAL carry : STD_LOGIC_VECTOR(32 DOWNTO 0);

begin
	carry(0) <= '0';
Gen:
	for i in 0 to 31 generate
		addImmed: fulladder Port Map(	X			=> A(i),
												Y 			=> B(i),
												Cin 		=> carry(i),
												S 			=> O(i),
												Carryout	=> carry(i+1)); 
	end generate;
	
end Behavioral;

