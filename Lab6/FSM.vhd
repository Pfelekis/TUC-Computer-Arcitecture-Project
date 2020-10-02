----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:15:57 05/14/2016 
-- Design Name: 
-- Module Name:    FSM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM is
	Port(
			in_and: in STD_LOGIC;
			instr: in  STD_LOGIC_VECTOR (31 downto 0);
			clk: in STD_LOGIC;
			rst: in STD_LOGIC;
			WE_1: out STD_LOGIC;
			WE_2: out STD_LOGIC;
			WE_3: out STD_LOGIC;
			WE_4: out STD_LOGIC;
			WE_5: out STD_LOGIC;
			we: out STD_LOGIC;
			valid:out STD_LOGIC;
			out_fsm: out STD_LOGIC_VECTOR (10 downto 0));
end FSM;

architecture Behavioral of FSM is
type State is (start, m1,m2,m3,m4);
signal state_con: State;
signal instr_sig: STD_LOGIC_VECTOR (10 downto 0);

begin
	process(state_con,in_and, instr, clk, rst)
		begin
		if(clk' event and clk='1') then
		
			if (rst='1') then 
				WE_1<='0';
				WE_2<='0';
				WE_3<='0';
				WE_4<='0';
				WE_5<='0';
				we<='0';
				out_fsm<="00000000000";
				valid<='0';
				instr_sig<=instr(10 downto 0);
				state_con<=start;
			else
				
				case state_con is
					when start=>
						if in_and='1' then
							WE_1<='0';
							WE_2<='0';
							WE_3<='0';
							WE_4<='0';
							WE_5<='0';
							we<='0';
							valid<='0';
							out_fsm<="00000000000";
							state_con<=start;
						else
							WE_1<='1';
							we<='0';
							valid<='0';
							instr_sig(1 downto 0)<="00";--grafei ston kataxwriti 1 ston epomeno kuklo
							out_fsm<=instr_sig;
							state_con<=m1;
						end if;
						
						
					when m1=>
						WE_2<='1';
						WE_1<='0';
						instr_sig(1 downto 0)<="01";--grafei ston kataxwriti 2 ston epomeno kuklo
						out_fsm<=instr_sig;
						state_con<=m2;
						
					when m2=>
						WE_2<='0';
						WE_3<='1';
						instr_sig(1 downto 0)<="10";--grafei ston kataxwriti 3 ston epomeno kuklo
						out_fsm<=instr_sig;
						state_con<=m3;
					
					when m3=>
						WE_3<='0';
						WE_4<='1';
						WE_5<='1';
						instr_sig(1 downto 0)<="11";--grafei ston kataxwriti 4 ston epomeno kuklo
						out_fsm<=instr_sig;
						state_con<=m4;
											
					when m4=>
						WE_4<='0';
						WE_5<='0';
						we<='1';
						valid<='1';
						state_con<=start;
							
				
				end case;
			end if;
		
		end if;
	end process;


end Behavioral;

