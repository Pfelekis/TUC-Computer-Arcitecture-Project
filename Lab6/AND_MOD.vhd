----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:17:02 05/14/2016 
-- Design Name: 
-- Module Name:    AND_MOD - Behavioral 
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

entity AND_MOD is
    Port ( valid : in  STD_LOGIC;
           comp : in  STD_LOGIC;
           outand : out  STD_LOGIC);
end AND_MOD;

architecture Behavioral of AND_MOD is

begin
	process(valid,comp)
		begin
			if valid='1' and comp='1' then
				outand<='1';
			else
				outand<='0';
			end if;
		end process;


end Behavioral;

