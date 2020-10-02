library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux5 is
    Port ( A : in  STD_LOGIC_VECTOR (4 downto 0);
           B : in  STD_LOGIC_VECTOR (4 downto 0);
			  Ctrl : in STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (4 downto 0));
end mux5;

architecture Behavioral of mux5 is

begin
	O <= 	A when Ctrl='0' else
			B;
end Behavioral;