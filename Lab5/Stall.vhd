library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Stall is
    Port ( Clk : in STD_LOGIC;
			  Reset	: in  STD_LOGIC;
			  rs : in  STD_LOGIC_VECTOR (4 downto 0);
           rt : in  STD_LOGIC_VECTOR (4 downto 0);
           Op_pipe1 : in  STD_LOGIC_VECTOR (5 downto 0);
           rd_pipe1 : in  STD_LOGIC_VECTOR (4 downto 0);
           PC_LdEn : out  STD_LOGIC;
			  IMEM_RegEn : out  STD_LOGIC);
end Stall;

architecture Behavioral of Stall is
type state is (B,C);
signal current_state,next_state: state;

begin
	
	process (clk)
	begin
		if (Reset ='1') then
			current_state <= C;
		elsif (rising_edge(clk)) then
		  current_state <= next_state;
		end if;
	end process;
	
	process(current_state,Op_pipe1,rs,rt)
	begin
		case current_state is
--		when A =>
--			PC_LdEn <= '0';
--			IMEM_RegEn <= '0';
--			next_state <= B;
		when B =>
			PC_LdEn <= '0';
			IMEM_RegEn <= '0';
			next_state <= C;
		when C =>
			if ( Op_pipe1 = "001111" AND (rs = rd_pipe1 OR rt =rd_pipe1)) then
				PC_LdEn <= '0';
				IMEM_RegEn <= '1';
				next_state <= B;
			else
				PC_LdEn <= '1';
				IMEM_RegEn <= '1';
				next_state <= C;
			end if;
			
		end case;
	end process;
end Behavioral;

