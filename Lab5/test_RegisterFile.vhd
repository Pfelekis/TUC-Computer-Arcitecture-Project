--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:25:08 03/03/2015
-- Design Name:   
-- Project Name:  lab1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RegisterFile
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
 
ENTITY test_RegisterFile IS
END test_RegisterFile;
 
ARCHITECTURE behavior OF test_RegisterFile IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RegisterFile
    PORT(
         Adr1 : IN  std_logic_vector(4 downto 0);
         Adr2 : IN  std_logic_vector(4 downto 0);
         Awr : IN  std_logic_vector(4 downto 0);
         Dout1 : OUT  std_logic_vector(31 downto 0);
         Dout2 : OUT  std_logic_vector(31 downto 0);
         Din : IN  std_logic_vector(31 downto 0);
         WrEn : IN  std_logic;
         CLK : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Adr1 : std_logic_vector(4 downto 0) := (others => '0');
   signal Adr2 : std_logic_vector(4 downto 0) := (others => '0');
   signal Awr : std_logic_vector(4 downto 0) := (others => '0');
   signal Din : std_logic_vector(31 downto 0) := (others => '0');
   signal WrEn : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal Dout1 : std_logic_vector(31 downto 0);
   signal Dout2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RegisterFile PORT MAP (
          Adr1 => Adr1,
          Adr2 => Adr2,
          Awr => Awr,
          Dout1 => Dout1,
          Dout2 => Dout2,
          Din => Din,
          WrEn => WrEn,
          CLK => CLK
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      Adr1 <= "01000";
		Adr2 <= "00010";
		Awr  <= "00101";
		Din  <= "00000011110001010101100000000000";
		WrEn <= '0';
      wait for 120 ns;
		-- grafei ston kataxwrhth (alla den exei entolh na to diabasei)
		Awr  <= "00101";
		Din  <= "00000011110001010101100000000000";
		WrEn <= '1';
      wait for 120 ns;
		Adr1 <= "00101";
		Awr  <= "00100";
		Din  <= "00000011110001010101100000000111";
		WrEn <= '1';
      wait for 120 ns;
		--blepoyme sthn eksodo duo diaforetikes dieuthhnseis
		Adr2 <= "00101";
		Adr1 <= "00100";
		WrEn <= '1';
      wait for 120 ns;
		--blepoume pws douleuei to compare		
		Adr1 <= "00011";
		Awr  <= "00011";
		Din  <= "11111111110001010101100000000111";
		WrEn <= '1';
      wait for 120 ns;
		Adr1 <= "00000";
		Awr  <= "00000";
		Din  <= "11111111110001010101100000000111";
		WrEn <= '1';
      wait for 120 ns;
		
      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
