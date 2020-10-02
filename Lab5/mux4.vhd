library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4 is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           C : in  STD_LOGIC_VECTOR (31 downto 0);
           D : in  STD_LOGIC_VECTOR (31 downto 0);
           Ctrl : in  STD_LOGIC_VECTOR (1 downto 0);
           muxOut : out  STD_LOGIC_VECTOR (31 downto 0));
end mux4;

architecture Behavioral of mux4 is

begin
	muxOut <= 	A when Ctrl= "00" else
					B when Ctrl= "01" else
					C when Ctrl= "10" else
					D;

end Behavioral;

