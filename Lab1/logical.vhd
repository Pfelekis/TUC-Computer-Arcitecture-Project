library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity logical is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           O : out  STD_LOGIC_VECTOR (31 downto 0));
end logical;

architecture Behavioral of logical is

begin

	O<=(A AND B) when (Op="0010") else	-- logic "AND"
		(A OR B)	 when	(Op="0011") else	-- logic "OR"
		(NOT A)	 when (Op="0100");		-- 
		
end Behavioral;

