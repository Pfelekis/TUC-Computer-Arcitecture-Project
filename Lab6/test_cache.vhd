--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:23:37 05/16/2016
-- Design Name:   
-- Project Name:  lab6
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top_cashe
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_cache IS
END test_cache;
 
ARCHITECTURE behavior OF test_cache IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_cashe
    PORT(
         instr : IN  std_logic_vector(31 downto 0);
         Din_mem : IN  std_logic_vector(31 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         out_cashe : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal instr : std_logic_vector(31 downto 0) := (others => '0');
   signal Din_mem : std_logic_vector(31 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal out_cashe : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_cashe PORT MAP (
          instr => instr,
          Din_mem => Din_mem,
          clk => clk,
          rst => rst,
          out_cashe => out_cashe
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

  -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst<='1';
		wait for 100ns;
		rst<='0';
		wait for 100ns;
		instr<="11100000000000010000000000000010";
		wait for 100ns;
		instr<="11100000000000010000000000000110";
		wait for 100ns;
		instr<="11100000000000010000000000000110";
		
	
      -- insert stimulus here 

      wait;
   end process;

END;
