library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity processor is
    Port ( Clk : in  STD_LOGIC;
           Reset : in  STD_LOGIC);
end processor;

architecture Behavioral of processor is
Component CONTROL is
Port (	Instr 			: in  STD_LOGIC_VECTOR (31 downto 0);
         Zero 				: in  STD_LOGIC;
			Reset				: in  STD_LOGIC;
			Clock				: in  STD_LOGIC;
			PC_sel			: out  STD_LOGIC;
			PC_LdEn			: out  STD_LOGIC;
			PC_Reset			: out  STD_LOGIC;
			RF_WrEn			: out  STD_LOGIC;
			RF_WrData_sel1	: out  STD_LOGIC;
			RF_WrData_sel2	: out  STD_LOGIC;
			RF_B_sel			: out  STD_LOGIC;
		
			RF_RegEn			: out  STD_LOGIC;
			ALU_Bin_sel		: out  STD_LOGIC;
			ALU_RegEn			: out  STD_LOGIC;
			ALU_func			: out  STD_LOGIC_VECTOR (3 downto 0);
			MEM_WrEn			: out  STD_LOGIC;
			Mux_Control1	: out  STD_LOGIC;
			Mux_Control2 	: out  STD_LOGIC);
end Component;

Component Datapath is
    Port ( Clk 				: in  STD_LOGIC;
			  PC_sel				: in  STD_LOGIC;
           PC_LdEn			: in  STD_LOGIC;
           Reset				: in  STD_LOGIC;
           RF_WrEn			: in  STD_LOGIC;
           RF_WrData_sel1	: in  STD_LOGIC;
			  RF_WrData_sel2	: in  STD_LOGIC;
			  RF_RegEn			: in  STD_LOGIC;
           RF_B_sel			: in  STD_LOGIC;
           ALU_Bin_sel		: in  STD_LOGIC;
			  ALU_RegEn			: in  STD_LOGIC;
           ALU_func			: in  STD_LOGIC_VECTOR (3 downto 0);
           MEM_WrEn			: in  STD_LOGIC;
           Mux_Control1		: in  STD_LOGIC;
           Mux_Control2 	: in  STD_LOGIC;
			  Instr 				: out  STD_LOGIC_VECTOR (31 downto 0);
           Zero 				: out  STD_LOGIC
			 );
end Component;

signal instr_sig : STD_LOGIC_VECTOR (31 downto 0);
signal func_sig : STD_LOGIC_VECTOR (3 downto 0);
signal zero_sig : STD_LOGIC;
signal PC_Sel_sig : STD_LOGIC;
signal PC_LdEn_sig : STD_LOGIC;
signal PC_Reset_sig : STD_LOGIC;
signal RF_WrEn_sig : STD_LOGIC;
signal RF_WrData_sel1_sig : STD_LOGIC;
signal RF_WrData_sel2_sig : STD_LOGIC;
signal RF_B_sel_sig : STD_LOGIC;
signal RF_RegEn_sig : STD_LOGIC;
signal ALU_RegEn_sig: STD_LOGIC;
signal ALU_Bin_sel_sig : STD_LOGIC;
signal mux1_sig : STD_LOGIC; 
signal mux2_sig : STD_LOGIC;
signal MEM_WrEn_sig : STD_LOGIC;

begin

control_label: CONTROL
Port Map(	Instr 			=> instr_sig,
				Zero 				=> zero_sig,
				Reset				=>	Reset,
				Clock				=> Clk,
				PC_sel			=> PC_Sel_sig,
				PC_LdEn			=> PC_LdEn_sig,
				PC_Reset			=> PC_Reset_sig,
				RF_WrEn			=> RF_WrEn_sig,
				RF_WrData_sel1	=> RF_WrData_sel1_sig,
				RF_WrData_sel2	=> RF_WrData_sel2_sig,
				RF_RegEn			=> RF_RegEn_sig,
				RF_B_sel			=> RF_B_sel_sig,
				ALU_Bin_sel		=> ALU_Bin_sel_sig,
				ALU_RegEn		=> ALU_RegEn_sig,
				ALU_func			=> func_sig,
				MEM_WrEn			=> MEM_WrEn_sig,
				Mux_Control1	=> mux1_sig,
				Mux_Control2 	=> mux2_sig);

datapath_label	: Datapath
Port Map(  Clk 				=> Clk,
			  PC_sel				=> PC_Sel_sig,
			  PC_LdEn			=> PC_LdEn_sig,
			  Reset				=> PC_Reset_sig,
			  RF_WrEn			=> RF_WrEn_sig,
			  RF_WrData_sel1	=> RF_WrData_sel1_sig,
			  RF_WrData_sel2	=> RF_WrData_sel2_sig,
			  RF_RegEn			=> RF_RegEn_sig,
			  RF_B_sel			=> RF_B_sel_sig,
			  ALU_Bin_sel		=> ALU_Bin_sel_sig,
			  ALU_RegEn			=> ALU_RegEn_sig,
			  ALU_func			=> func_sig,
			  MEM_WrEn			=> MEM_WrEn_sig,
			  Mux_Control1		=> mux1_sig,
			  Mux_Control2 	=> mux1_sig,
			  Instr 				=> instr_sig,
			  Zero 				=> zero_sig);

end Behavioral;

