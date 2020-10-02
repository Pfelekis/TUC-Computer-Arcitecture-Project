----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:53:31 05/14/2016 
-- Design Name: 
-- Module Name:    compare - Behavioral 
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

entity compare is
    Port ( tag_cache : in  STD_LOGIC_VECTOR (3 downto 0);
           tag_instr : in  STD_LOGIC_VECTOR (3 downto 0);
           out_comp : out  STD_LOGIC);
end compare;

architecture Behavioral of compare is

begin
	process(tag_cache,tag_instr)
		begin
			out_comp<='0';
			if tag_cache=tag_instr then
				out_comp<='1';
			else
				out_comp<='0';
			end if;
		end process;

end Behavioral;

