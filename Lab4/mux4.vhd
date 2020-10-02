library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity mux4 is
    Port ( In1 : in  STD_LOGIC_VECTOR (7 downto 0);
           In2 : in  STD_LOGIC_VECTOR (7 downto 0);
           In3 : in  STD_LOGIC_VECTOR (7 downto 0);
           In4 : in  STD_LOGIC_VECTOR (7 downto 0);
           Ctrl : in  STD_LOGIC_VECTOR (1 downto 0);
           O : out  STD_LOGIC_VECTOR (7 downto 0));
end mux4;

architecture Behavioral of mux4 is

begin
	O	<=	In1 when Ctrl="00" else
			In2 when Ctrl="01" else
			In3 when Ctrl="10" else
			In4 when Ctrl="11" else
			(others => '0');

end Behavioral;

