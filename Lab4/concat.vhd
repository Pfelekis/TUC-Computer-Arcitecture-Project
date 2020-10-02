library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity concat is
    Port ( In1 : in  STD_LOGIC_VECTOR (7 downto 0);
           In2 : in  STD_LOGIC_VECTOR (7 downto 0);
           In3 : in  STD_LOGIC_VECTOR (7 downto 0);
           In4 : in  STD_LOGIC_VECTOR (7 downto 0);
           O : out  STD_LOGIC_VECTOR (31 downto 0));
end concat;

architecture Behavioral of concat is

begin

	O	<=	In1 & In2 & In3 & In4;

end Behavioral;

