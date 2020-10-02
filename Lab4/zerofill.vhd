----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:56:59 04/01/2015 
-- Design Name: 
-- Module Name:    zerofill - Behavioral 
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

entity zerofill is
    Port ( DataIn : in  STD_LOGIC_VECTOR (7 downto 0);
           DataOut : out  STD_LOGIC_VECTOR (31 downto 0));
end zerofill;

architecture Behavioral of zerofill is

signal temp : STD_LOGIC_VECTOR (23 downto 0);

begin

temp	<=	(others=>'0');
DataOut	<= temp & DataIn;

end Behavioral;

