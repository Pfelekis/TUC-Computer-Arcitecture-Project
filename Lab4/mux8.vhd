library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux8 is
    Port ( In1 	: in  STD_LOGIC_VECTOR (31 downto 0);
           In2 	: in  STD_LOGIC_VECTOR (31 downto 0);
			  In3 	: in  STD_LOGIC_VECTOR (31 downto 0);
           In4		: in  STD_LOGIC_VECTOR (31 downto 0);
			  In5 	: in  STD_LOGIC_VECTOR (31 downto 0);
           In6 	: in  STD_LOGIC_VECTOR (31 downto 0);
			  In7 	: in  STD_LOGIC_VECTOR (31 downto 0);
           In8 	: in  STD_LOGIC_VECTOR (31 downto 0);
			  Ctrl 	: in STD_LOGIC_VECTOR (2 downto 0);
           O 		: out  STD_LOGIC_VECTOR (31 downto 0));
end mux8;

architecture Behavioral of mux8 is
begin

	O <= 	In1 when Ctrl="000" else
			In2 when Ctrl="001" else
			In3 when Ctrl="010" else
			In4 when Ctrl="011" else
			In5 when Ctrl="100" else
			In6 when Ctrl="101" else
			In7 when Ctrl="110" else
			In8 when Ctrl="111" else
			(others => '0');

end Behavioral;

