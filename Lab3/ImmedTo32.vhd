library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ImmedTo32 is
    Port ( Din : in  STD_LOGIC_VECTOR (15 downto 0);
           OpCode : in  STD_LOGIC_VECTOR (5 downto 0);
           Immed : out  STD_LOGIC_VECTOR (31 downto 0));
end ImmedTo32;

architecture Behavioral of ImmedTo32 is

signal tempout : STD_LOGIC_VECTOR (31 downto 0);

begin

process(Din,OpCode)
begin
	if(OpCode="110010" OR OpCode="110011") then
		tempout(31 downto 16) <= (others => '0');
		tempout(15 downto 0) <= Din; --zero fill
	elsif(OpCode="111001") then
		tempout(31 downto 16) <= Din;
		tempout(15 downto 0) <= (others => '0'); --shift left 16 and zero fill
	elsif(OpCode="111000" OR OpCode="110000" OR OpCode="000011"OR OpCode="000111"OR OpCode="001111"OR OpCode="011111") then
		tempout(31 downto 16) <= (others => Din(15));
		tempout(15 downto 0) <= Din; --sign extend
	elsif(OpCode="000000" OR OpCode="000001" OR OpCode="111111") then 
		tempout(31 downto 18) <= (others => Din(15));--sign extend
		tempout(17 downto 2) <= Din; 
		tempout(1 downto 0) <= "00"; -- shift left 2
	end if;
end process;
	Immed <= tempout; -- Immed 32 bits
end Behavioral;

