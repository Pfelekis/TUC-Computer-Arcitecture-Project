library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package regarray_type is
    type regarray is array(0 to 31) of std_logic_vector (31 downto 0);
end package regarray_type;
