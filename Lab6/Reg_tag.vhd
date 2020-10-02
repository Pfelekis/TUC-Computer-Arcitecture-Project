----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:54:59 05/16/2016 
-- Design Name: 
-- Module Name:    Reg_tag - Behavioral 
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

entity Reg_tag is
    Port ( in_tag : in  STD_LOGIC_VECTOR (3 downto 0);
           out_tag : out  STD_LOGIC_VECTOR (3 downto 0);
           we : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC);
end Reg_tag;

architecture Behavioral of Reg_tag is

begin
process(rst,clk,we,in_tag)
		begin
			
		if (clk' event and clk='1') then
		
			if rst = '1' then
				out_tag<=(others => '0');
			elsif we='1' then
				out_tag<=in_tag;
			end if;
		end if;			
			
	end process;	

end Behavioral;

