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
			
			branch_sel		: out  STD_LOGIC;
			PC_sel			: out  STD_LOGIC;
			PC_LdEn			: out  STD_LOGIC;
			PC_Reset			: out  STD_LOGIC;
			RF_WrEn			: out  STD_LOGIC;
			RF_WrData_Sel 	: out  STD_LOGIC_VECTOR (2 downto 0);
			RF_B_sel			: out  STD_LOGIC;
			RF_RegEn			: out  STD_LOGIC;
			Reg_A_En			: out  STD_LOGIC;
			Reg_B_En			: out  STD_LOGIC;
			Byte_Sel			: out  STD_LOGIC_VECTOR (1 downto 0);
			ALU_A_Sel		: out  STD_LOGIC_VECTOR (2 downto 0);
			ALU_Bin_sel		: out  STD_LOGIC_VECTOR (2 downto 0);
			ALU_RegEn		: out  STD_LOGIC;
			ALU_func			: out  STD_LOGIC_VECTOR (3 downto 0);
			En1				: out STD_LOGIC;
			En2				: out  STD_LOGIC;
			En3				: out  STD_LOGIC;
			En4				: out  STD_LOGIC;
			En1_B				: out  STD_LOGIC;
			En2_B				: out  STD_LOGIC;
			En3_B				: out  STD_LOGIC;
			En4_B				: out  STD_LOGIC;
			MEM_RegEn		: out  STD_LOGIC;
			MEM_addr_sel	: out  STD_LOGIC_VECTOR (2 downto 0);
			MEM_WrEn			: out  STD_LOGIC;
			Mux_Control1	: out  STD_LOGIC;
			Mux_Control1_2	: out  STD_LOGIC;
			Mux_Control2 	: out  STD_LOGIC);
end Component;

Component Datapath is
    Port ( Clk 				: in  STD_LOGIC;
			  branch_sel		: in  STD_LOGIC;
			  PC_sel				: in  STD_LOGIC;
           PC_LdEn			: in  STD_LOGIC;
           Reset				: in  STD_LOGIC;
           RF_WrEn			: in  STD_LOGIC;
           RF_WrData_Sel 	: in  STD_LOGIC_VECTOR (2 downto 0);	
			  RF_RegEn			: in  STD_LOGIC;
           RF_B_sel			: in  STD_LOGIC;
			  Reg_A_En			: in  STD_LOGIC;
			  Reg_B_En			: in  STD_LOGIC;
			  Byte_Sel			: in  STD_LOGIC_VECTOR (1 downto 0);
			  ALU_A_Sel			: in  STD_LOGIC_VECTOR (2 downto 0);
           ALU_Bin_sel		: in	STD_LOGIC_VECTOR (2 downto 0);
			  ALU_RegEn			: in  STD_LOGIC;
           ALU_func			: in  STD_LOGIC_VECTOR (3 downto 0);
			  En1					: in  STD_LOGIC;
			  En2					: in  STD_LOGIC;
			  En3					: in  STD_LOGIC;
			  En4					: in  STD_LOGIC;
			  En1_B				: in  STD_LOGIC;
			  En2_B				: in  STD_LOGIC;
			  En3_B				: in  STD_LOGIC;
			  En4_B				: in  STD_LOGIC;
			  MEM_RegEn			: in  STD_LOGIC;
			  MEM_addr_sel		: in  STD_LOGIC_VECTOR (2 downto 0);
           MEM_WrEn			: in  STD_LOGIC;
           Mux_Control1		: in  STD_LOGIC;
			  Mux_Control1_2	: in  STD_LOGIC;
           Mux_Control2 	: in  STD_LOGIC;
			  Instr 				: out  STD_LOGIC_VECTOR (31 downto 0);
           Zero 				: out  STD_LOGIC
			 );
end Component;

signal instr_sig : STD_LOGIC_VECTOR (31 downto 0);
signal func_sig : STD_LOGIC_VECTOR (3 downto 0);
signal zero_sig : STD_LOGIC;
signal branch_sel_sig : STD_LOGIC;
signal PC_Sel_sig : STD_LOGIC;
signal PC_LdEn_sig : STD_LOGIC;
signal PC_Reset_sig : STD_LOGIC;
signal RF_WrEn_sig : STD_LOGIC;
signal RF_WrData_Sel_sig : STD_LOGIC_VECTOR (2 downto 0);
signal RF_B_sel_sig : STD_LOGIC;
signal RF_RegEn_sig : STD_LOGIC;
signal Reg_A_En_sig : STD_LOGIC;
signal Reg_B_En_sig : STD_LOGIC;
signal Byte_Sel_sig : STD_LOGIC_VECTOR (1 downto 0);
signal ALU_RegEn_sig: STD_LOGIC;
signal ALU_A_Sel_sig : STD_LOGIC_VECTOR (2 downto 0);
signal ALU_Bin_sel_sig : STD_LOGIC_VECTOR (2 downto 0);
signal mux1_sig : STD_LOGIC;
signal mux1_sig_2 : STD_LOGIC;
signal mux2_sig : STD_LOGIC;
signal MEM_RegEn_sig :STD_LOGIC;
signal MEM_addr_sel_sig : STD_LOGIC_VECTOR (2 downto 0);
signal MEM_WrEn_sig : STD_LOGIC;
signal En1_sig : STD_LOGIC;
signal En2_sig : STD_LOGIC;
signal En3_sig : STD_LOGIC;
signal En4_sig : STD_LOGIC;
signal En1_B_sig : STD_LOGIC;
signal En2_B_sig : STD_LOGIC;
signal En3_B_sig : STD_LOGIC;
signal En4_B_sig : STD_LOGIC;

begin

control_label: CONTROL
Port Map(	Instr 			=> instr_sig,
				Zero 				=> zero_sig,
				Reset				=>	Reset,
				Clock				=> Clk,
				branch_sel		=> branch_sel_sig,
				PC_sel			=> PC_Sel_sig,
				PC_LdEn			=> PC_LdEn_sig,
				PC_Reset			=> PC_Reset_sig,
				RF_WrEn			=> RF_WrEn_sig,
				RF_WrData_sel	=> RF_WrData_sel_sig,
				RF_RegEn			=> RF_RegEn_sig,
				RF_B_sel			=> RF_B_sel_sig,
				Reg_A_En			=> Reg_A_En_sig,
				Reg_B_En			=> Reg_B_En_sig,
				Byte_Sel			=> Byte_Sel_sig, 
				ALU_A_sel		=> ALU_A_Sel_sig,
				ALU_Bin_sel		=> ALU_Bin_sel_sig,
				ALU_RegEn		=> ALU_RegEn_sig,
				ALU_func			=> func_sig,
				En1				=> En1_sig,
			   En2				=>	En2_sig,
			   En3				=>	En3_sig,
			   En4				=>	En4_sig,
				En1_B				=> En1_B_sig,
			   En2_B				=>	En2_B_sig,
			   En3_B				=>	En3_B_sig,
			   En4_B				=>	En4_B_sig,
				MEM_RegEn		=> MEM_RegEn_sig,
				MEM_addr_sel	=> MEM_addr_sel_sig,
				MEM_WrEn			=> MEM_WrEn_sig,
				Mux_Control1	=> mux1_sig,
				Mux_Control1_2	=> mux1_sig_2,
				Mux_Control2 	=> mux2_sig);

datapath_label	: Datapath
Port Map(  Clk 				=> Clk,
			  branch_sel		=> branch_sel_sig,
			  PC_sel				=> PC_Sel_sig,
			  PC_LdEn			=> PC_LdEn_sig,
			  Reset				=> PC_Reset_sig,
			  RF_WrEn			=> RF_WrEn_sig,
			  RF_WrData_sel	=> RF_WrData_sel_sig,
			  RF_RegEn			=> RF_RegEn_sig,
			  RF_B_sel			=> RF_B_sel_sig,
			  Reg_A_En			=> Reg_A_En_sig,
			  Reg_B_En			=> Reg_B_En_sig,
			  Byte_Sel			=> Byte_Sel_sig,
			  ALU_A_sel			=> ALU_A_Sel_sig,
			  ALU_Bin_sel		=> ALU_Bin_sel_sig,
			  ALU_RegEn			=> ALU_RegEn_sig,
			  ALU_func			=> func_sig,
			  En1					=> En1_sig,
			  En2					=>	En2_sig,
			  En3					=>	En3_sig,
			  En4					=>	En4_sig,
			  En1_B				=> En1_B_sig,
			  En2_B				=>	En2_B_sig,
			  En3_B				=>	En3_B_sig,
			  En4_B				=>	En4_B_sig,
			  MEM_RegEn			=> MEM_RegEn_sig,
			  MEM_addr_sel		=> MEM_addr_sel_sig,
			  MEM_WrEn			=> MEM_WrEn_sig,
			  Mux_Control1		=> mux1_sig,
			  Mux_Control1_2	=> mux1_sig_2,
			  Mux_Control2 	=> mux1_sig,
			  Instr 				=> instr_sig,
			  Zero 				=> zero_sig);

end Behavioral;

