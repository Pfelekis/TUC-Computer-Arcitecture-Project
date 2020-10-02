library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2 is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
			  Ctrl : in STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (31 downto 0));
end mux2;

architecture Behavioral of mux2 is

begin
	O <= 	A when Ctrl='0' else
			B ;
end Behavioral;

