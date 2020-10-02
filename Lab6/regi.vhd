----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:45:13 05/14/2016 
-- Design Name: 
-- Module Name:    regi - Behavioral 
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

entity regi is
    Port ( inregi : in  STD_LOGIC_VECTOR (31 downto 0);
           wren : in  STD_LOGIC;
           outregi : out  STD_LOGIC_VECTOR (31 downto 0);
			  clk : in  STD_LOGIC;
			  Reset : in  STD_LOGIC);
end regi;

architecture Behavioral of regi is

begin
	process(Reset,clk,wren,inregi)
		begin
			
		if (clk' event and clk='1') then
		
			if Reset = '1' then
				outregi<=(others => '0');
			elsif wren='1' then
				outregi<=inregi;
			end if;
		end if;			
			
	end process;		
			
			
	end Behavioral;

