library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CompareModule is
    Port ( Adr : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           CM : out  STD_LOGIC);
end CompareModule;

architecture Behavioral of CompareModule is

begin

CM <= '0' when Adr=Awr AND Adr="00000" else
		'1' when Adr=Awr else
		'0';
		
end Behavioral;

