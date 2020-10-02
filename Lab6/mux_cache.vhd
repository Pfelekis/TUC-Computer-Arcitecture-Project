----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:41:19 05/14/2016 
-- Design Name: 
-- Module Name:    mux_cache - Behavioral 
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

entity mux_cache is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           C : in  STD_LOGIC_VECTOR (31 downto 0);
           D : in  STD_LOGIC_VECTOR (31 downto 0);
           mux_out : out  STD_LOGIC_VECTOR (31 downto 0);
           select_mux : in  STD_LOGIC_VECTOR (1 downto 0));
end mux_cache;

architecture Behavioral of mux_cache is

begin
	process(A,B,C,D,select_mux)
		begin
			if select_mux="00" then
				mux_out<=A;
			elsif select_mux="01" then
				mux_out<=B;
			elsif select_mux="10" then
				mux_out<=C;
			else
				mux_out<=D;
			end if;
	end process;
	
			


end Behavioral;

