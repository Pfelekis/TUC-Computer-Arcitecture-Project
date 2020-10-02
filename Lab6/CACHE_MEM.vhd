----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:23:25 05/14/2016 
-- Design Name: 
-- Module Name:    CACHE_MEM - Behavioral 
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
library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

use ieee.std_logic_textio.all;
entity CACHE_MEM is
	port (
			clk : in std_logic;
			we : in std_logic;
			addr : in std_logic_vector(4 downto 0);
			din : in std_logic_vector(132 downto 0);
			dout : out std_logic_vector(132 downto 0));
end CACHE_MEM;

architecture syn of CACHE_MEM is

type ram_type is array (31 downto 0) of std_logic_vector (132 downto 0);


impure function InitRamFromFile (RamFileName : in string) return ram_type is
FILE ramfile : text is in RamFileName;
variable RamFileLine : line;
variable ram : ram_type;

begin
	for i in 0 to 31 loop
		readline(ramfile, RamFileLine);
		read (RamFileLine, ram(i));
	end loop;
	return ram;
end function;

signal RAM : ram_type := InitRamFromFile("cache.data");

begin
 process (clk)
	begin
	if clk' event and clk = '1' then
		if we = '1' then
			RAM(conv_integer(addr)) <= din;
		end if;
		dout<= RAM(conv_integer(addr)) ;
	end if;
 end process;
end syn;