library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC is
	port (Din 			: in std_logic_vector(31 downto 0); -- system inputs
			PC_LdEn 		: in std_logic; -- enable
			Clk, Reset 	: in std_logic; -- clock and reset 
			Dout 			: out std_logic_vector(31 downto 0)); -- system outputs
end PC;

architecture Behavioral of PC is

begin

process(Clk,Reset)
begin -- process
	-- activities triggered by asynchronous reset (active high)
	if Reset = '1' then     
		Dout <= "00000000000000000000000000000000";
		-- activities triggered by rising edge of clock
	elsif Clk'event and Clk = '1' then
		if PC_LdEn='1' then 
			Dout <= Din;
		else 
			null;
		end if;
	end if;
end process;

end Behavioral;

