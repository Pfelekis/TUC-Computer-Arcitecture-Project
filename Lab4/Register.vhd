----------------------------------------------------------------------------------
-- Lab1B
-- Omada : Georgakopoulou Artemis
--			  Fragiadoulakis Manolis
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg is
    Port ( CLK : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end Reg;

architecture Behavioral of Reg is

begin
	process (CLK)
	begin
			if WE = '1' AND (CLK'event AND CLK = '1')then
				Dout <= Din ;
			end if;
	end process;

end Behavioral;

