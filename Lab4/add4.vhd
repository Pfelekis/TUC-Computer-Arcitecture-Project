library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add4 is
	Port(A : in  STD_LOGIC_VECTOR (31 downto 0);
		  O : out  STD_LOGIC_VECTOR (31 downto 0));
end add4;

architecture Behavioral of add4 is

Component fulladder is
	 Port ( X : in  STD_LOGIC;
           Y : in  STD_LOGIC;
           Cin : in  STD_LOGIC;
           S : out  STD_LOGIC;
           Carryout : out  STD_LOGIC);
end Component;

SIGNAL B : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL carry : STD_LOGIC_VECTOR(32 DOWNTO 0);
begin
	carry(0) <= '0';
	B <= "00000000000000000000000000000100";
Gen:
	for i in 0 to 31 generate
		add4: fulladder Port Map(	X			=> A(i),
											Y 			=> B(i),
											Cin 		=> carry(i),
											S 			=> O(i),
											Carryout	=> carry(i+1)); 
	end generate;

end Behavioral;

