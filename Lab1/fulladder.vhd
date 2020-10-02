library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fulladder is
    Port ( X : in  STD_LOGIC;
           Y : in  STD_LOGIC;
           Cin : in  STD_LOGIC;
           S : out  STD_LOGIC;
           Carryout : out  STD_LOGIC);
end fulladder;

architecture Behavioral of fulladder is

begin
	S <= Cin XOR (X XOR Y);
	Carryout <= (X AND Y)OR (Cin AND(X XOR Y)) ;
end Behavioral;

