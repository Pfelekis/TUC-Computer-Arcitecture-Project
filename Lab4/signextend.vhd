library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity signextend is
    Port ( Din : in  STD_LOGIC_VECTOR (7 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end signextend;

architecture Behavioral of signextend is

signal temp : STD_LOGIC_VECTOR (23 downto 0);

begin

temp <= (others => Din(7));
Dout <= temp & Din;

end Behavioral;

