--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:51:40 03/16/2015
-- Design Name:   
-- Module Name:   /home/mafragias/lab1/test_MEMSTAGE.vhd
-- Project Name:  lab1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MEMSTAGE
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
 
ENTITY test_MEMSTAGE IS
END test_MEMSTAGE;
 
ARCHITECTURE behavior OF test_MEMSTAGE IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MEMSTAGE
    PORT(
         clk : IN  std_logic;
         Mem_WrEn : IN  std_logic;
         ALU_MEM_Addr : IN  std_logic_vector(31 downto 0);
         MEM_DataIn : IN  std_logic_vector(31 downto 0);
         MEM_DataOut : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Mem_WrEn : std_logic := '0';
   signal ALU_MEM_Addr : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_DataIn : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal MEM_DataOut : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEMSTAGE PORT MAP (
          clk => clk,
          Mem_WrEn => Mem_WrEn,
          ALU_MEM_Addr => ALU_MEM_Addr,
          MEM_DataIn => MEM_DataIn,
          MEM_DataOut => MEM_DataOut
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
		Mem_WrEn 		<='0';
		ALU_MEM_Addr 	<="00000000000000000000000000000100";
		MEM_DataIn 		<="00000000000000000000000000011100";
      wait for 150 ns;	
		Mem_WrEn 		<='1';
		ALU_MEM_Addr 	<="00000000000000000000000000000100";
		MEM_DataIn 		<="00000000000000000000000000011100";
      wait for 150 ns;
		Mem_WrEn 		<='0';
		ALU_MEM_Addr 	<="00000000000000000000000000000100";
		MEM_DataIn 		<="00000000000010000000000000000000";
      wait for 150 ns;
		Mem_WrEn 		<='1';
		ALU_MEM_Addr 	<="00000000000000000000000000000100";
		MEM_DataIn 		<="00000000000010000000000000000000";
      wait for 150 ns;
		Mem_WrEn 		<='0';
		ALU_MEM_Addr 	<="00000000000000000000000000000100";
		MEM_DataIn 		<="00000000000010000000000000000000";
      wait for 150 ns;
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
