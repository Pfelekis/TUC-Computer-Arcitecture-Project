library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Decoder is
    Port (Awr : in  STD_LOGIC_VECTOR (4 downto 0);
			 Registers : out STD_LOGIC_VECTOR (31 downto 0));
end Decoder;

architecture Behavioral of Decoder is

begin
	decode:
	for i in 0 to 31 generate 
		Registers(i)<= '1' when Awr = i else
							'0';
	end generate;
end Behavioral;

