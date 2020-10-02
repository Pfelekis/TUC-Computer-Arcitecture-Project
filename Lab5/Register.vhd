library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegEn is
    Port ( CLK : in  STD_LOGIC;
           Din : in  STD_LOGIC;
           WE : in  STD_LOGIC;
           Dout : out  STD_LOGIC);
end RegEn;

architecture Behavioral of RegEn is

begin
	process (CLK)
	begin
			if WE = '1' AND (CLK'event AND CLK = '1')then
				Dout <= Din ;
			end if;
	end process;

end Behavioral;

