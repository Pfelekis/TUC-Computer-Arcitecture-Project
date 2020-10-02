--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:52:39 03/16/2015
-- Design Name:   
-- Module Name:   /home/mafragias/lab1/test_DECSTAGE.vhd
-- Project Name:  lab1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DECSTAGE
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
 
ENTITY test_DECSTAGE IS
END test_DECSTAGE;
 
ARCHITECTURE behavior OF test_DECSTAGE IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DECSTAGE
    PORT(
         Instr : IN  std_logic_vector(31 downto 0);
         RF_WrEn : IN  std_logic;
         ALU_out : IN  std_logic_vector(31 downto 0);
         MEM_out : IN  std_logic_vector(31 downto 0);
         RF_WrData_Sel : IN  std_logic;
         RF_B_Sel : IN  std_logic;
         Clk : IN  std_logic;
         Immed : OUT  std_logic_vector(31 downto 0);
         RF_A : OUT  std_logic_vector(31 downto 0);
         RF_B : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Instr : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_WrEn : std_logic := '0';
   signal ALU_out : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_out : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_WrData_Sel : std_logic := '0';
   signal RF_B_Sel : std_logic := '0';
   signal Clk : std_logic := '0';

 	--Outputs
   signal Immed : std_logic_vector(31 downto 0);
   signal RF_A : std_logic_vector(31 downto 0);
   signal RF_B : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DECSTAGE PORT MAP (
          Instr => Instr,
          RF_WrEn => RF_WrEn,
          ALU_out => ALU_out,
          MEM_out => MEM_out,
          RF_WrData_Sel => RF_WrData_Sel,
          RF_B_Sel => RF_B_Sel,
          Clk => Clk,
          Immed => Immed,
          RF_A => RF_A,
          RF_B => RF_B
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		-- (31downto26)(25downto21)(20downto16)(15downto11)
		Instr<="100000" & "00000" & "00001" & "00000" & "00000" & "000000";
		RF_WrEn<='1';
		ALU_out<="00000000000000000000000000000001";
		MEM_out<="00000000000000000000000000000000";
		RF_WrData_Sel<='0';--ALU
		RF_B_Sel<='0';
		
      wait for 150 ns;
		-- (31downto26)(25downto21)(20downto16)(15downto11)
		Instr<="100000" & "00001" & "10000" & "00000" & "00000" & "000000";
		RF_WrEn<='1';
		ALU_out<="00000000000000000000000000000011";
		MEM_out<="00000000000000000000000000000000";
		RF_WrData_Sel<='0';--ALU
		RF_B_Sel<='0';
		
      wait for 150 ns;
		-- (31downto26)(25downto21)(20downto16)(15downto11)
		Instr<="110010" & "00001" & "00000" & "10000" & "00100" & "000110";
		RF_WrEn<='0';
		ALU_out<="00000000000000000000000000000000";
		MEM_out<="00000000110000000000000000000011";
		RF_WrData_Sel<='1';--MEM
		RF_B_Sel<='0';--(15downto11)
		-- zero fill(Immed)
      wait for 150 ns;
		-- (31downto26)(25downto21)(20downto16)(15downto11)
		Instr<="111001" & "00001" & "10000" & "10000" & "00011" & "000011";
		RF_WrEn<='0';
		ALU_out<="00000000000000000000000000000000";
		MEM_out<="00000000000000000000000000000000";
		RF_WrData_Sel<='0';--ALU
		RF_B_Sel<='1'; --(20downto16)
		-- shift left 16 and zero fill (Immed)
      wait for 150 ns;
		-- (31downto26)(25downto21)(20downto16)(15downto11)
		Instr<="111000" & "00000" & "00011" & "10000" & "11111" & "000000";
		RF_WrEn<='1';
		ALU_out<="00000000000000000000000000000000";
		MEM_out<="00000000000000000000000000000011";
		RF_WrData_Sel<='1';--MEM
		RF_B_Sel<='0';--(15downto11)
		-- sign extend (Immed)
      wait for 150 ns;
		-- (31downto26)(25downto21)(20downto16)(15downto11)
		Instr<="000000" & "00000" & "00011" & "00011" & "00000" & "000000";
		RF_WrEn<='0';
		ALU_out<="00000000000000000000000000000000";
		MEM_out<="11000000000000000000000000000000";
		RF_WrData_Sel<='1';--MEM
		RF_B_Sel<='0';--(15downto11)
		-- sign extend and shift left 2 (Immed)
      wait for 150 ns;	

      wait for Clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
