library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.regarray_type.all;

entity Mux32 is
    Port (Registers : in regarray;
			 Ctrl 	  : in  STD_LOGIC_VECTOR (4 downto 0);
          Rout 	  : out  STD_LOGIC_VECTOR (31 downto 0));
end Mux32;

architecture Behavioral of Mux32 is

begin

ROut <= Registers (to_integer(unsigned(Ctrl))) ;

end Behavioral;

