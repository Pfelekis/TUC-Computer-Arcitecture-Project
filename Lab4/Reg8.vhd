library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg8 is
    Port ( CLK : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (7 downto 0);
           WE : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (7 downto 0));
end Reg8;

architecture Behavioral of Reg8 is

begin
	process (CLK)
	begin
			if WE = '1' AND (CLK'event AND CLK = '1')then
				Dout <= Din ;
			end if;
	end process;

end Behavioral;