library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Datapath is
    Port ( Clk 				: in  STD_LOGIC;
			  PC_sel				: in  STD_LOGIC;
           PC_LdEn			: in  STD_LOGIC;
           Reset				: in  STD_LOGIC;
           RF_WrEn			: in  STD_LOGIC;
           RF_WrData_sel1	: in  STD_LOGIC;
			  RF_WrData_Sel2 	: in  STD_LOGIC;
			  RF_RegEn 			: in  STD_LOGIC;
           RF_B_sel			: in  STD_LOGIC;
			  ALU_RegEn			: in  STD_LOGIC;
           ALU_Bin_sel		: in  STD_LOGIC;
           ALU_func			: in  STD_LOGIC_VECTOR (3 downto 0);
           MEM_WrEn			: in  STD_LOGIC;
           Mux_Control1		: in  STD_LOGIC;
           Mux_Control2 	: in  STD_LOGIC;
			  Instr 				: out  STD_LOGIC_VECTOR (31 downto 0);
           Zero 				: out  STD_LOGIC
			 );
end Datapath;

architecture Structural of Datapath is

Component IFSTAGE is
    Port ( PC_Immed 	: in  STD_LOGIC_VECTOR (31 downto 0);
           PC_Sel 	: in  STD_LOGIC;
           PC_LdEn 	: in  STD_LOGIC;
           Reset 		: in  STD_LOGIC;
           Clk 		: in  STD_LOGIC;
           Instr 		: out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component DECSTAGE is
    Port ( Instr 				: in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn 			: in  STD_LOGIC;
           ALU_out 			: in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out 			: in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_Sel1 	: in  STD_LOGIC;
			  RF_WrData_Sel2 	: in  STD_LOGIC;
			  RF_RegEn 			: in  STD_LOGIC;
           RF_B_Sel 			: in  STD_LOGIC;
           Clk 				: in  STD_LOGIC;
           Immed 				: out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A 				: out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B 				: out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component ALUSTAGE is
    Port ( RF_A 			: in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B 			: in  STD_LOGIC_VECTOR (31 downto 0);
           Immed 			: in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Bin_Sel 	: in  STD_LOGIC;
           ALU_func 		: in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out 		: out  STD_LOGIC_VECTOR (31 downto 0);
			  Zero			: out  STD_LOGIC);
end Component;

Component MEMSTAGE is
    Port ( clk 			: in  STD_LOGIC;
           Mem_WrEn 		: in  STD_LOGIC;
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataIn 	: in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataOut 	: out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component mux2 is
    Port ( A 		: in  STD_LOGIC_VECTOR (31 downto 0);
           B 		: in  STD_LOGIC_VECTOR (31 downto 0);
			  Ctrl	: in STD_LOGIC;
           O 		: out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component zerofill is
    Port ( DataIn		: in  STD_LOGIC_VECTOR (31 downto 0);
           DataOut	: out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component Reg is
    Port ( CLK : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

SIGNAL Istruction	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Immed_Sig	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL A_Sig		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL B_Sig		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ALUout_Sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL temp_ALUout: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL MEMout_Sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL MEMDataIn_Sig		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL MEMDataOut_Sig	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Load_Sig	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Store_Sig 	: STD_LOGIC_VECTOR(31 DOWNTO 0);




begin

IFSTAGE_label : IFSTAGE port map (PC_Immed	=> Immed_Sig,	
											 PC_Sel 		=>	PC_Sel,
											 PC_LdEn 	=>	PC_LdEn,
											 Reset 		=>	Reset,	
											 Clk 			=>	Clk,
											 Instr 		=>	Istruction	);
											
DECSTAGE_label : DECSTAGE port map (Instr 			=> Istruction, 
												RF_WrEn 			=> RF_WrEn,
												ALU_out 			=> temp_ALUout,
												MEM_out 			=> MEMout_Sig,
												RF_WrData_Sel1 => RF_WrData_Sel1,
												RF_WrData_Sel2 => RF_WrData_Sel2,
												RF_RegEn			=> RF_RegEn,
												RF_B_Sel 		=> RF_B_Sel,
												Clk 				=> Clk,
												Immed 			=> Immed_Sig,
												RF_A 				=> A_Sig,
												RF_B 				=> B_Sig); 
												
ALUSTAGE_label : ALUSTAGE port map (RF_A 			=> A_Sig,
												RF_B 			=> B_Sig,
												Immed 		=> Immed_Sig,
												ALU_Bin_Sel => ALU_Bin_Sel,
												ALU_func 	=> ALU_func,
												ALU_out 		=> ALUout_Sig, 
												Zero			=> Zero);
RegALUout : Reg Port Map(  CLK 	=> Clk,
								  Din => ALUout_Sig,
								  WE 	=> ALU_RegEn,
								  Dout=> temp_ALUout);
									  
Store_label : zerofill port map(DataIn 	=> B_Sig,
										 DataOut 	=> Store_Sig);
												
muxControl1 : mux2 Port Map(A    => B_Sig,    --0
									 B    => Store_Sig, --1
									 Ctrl => Mux_Control1, 
									 O    => MEMDataIn_Sig );
									
MEMSTAGE_label : MEMSTAGE port map (clk 				=> Clk,
												Mem_WrEn 		=> Mem_WrEn,
												ALU_MEM_Addr 	=> temp_ALUout,
												MEM_DataIn 		=> MEMDataIn_Sig,
												MEM_DataOut 	=> MEMDataOut_Sig);
												
Load_label : zerofill port map (DataIn  => MEMDataOut_Sig,
											DataOut => Load_Sig);

muxControl2 : mux2 Port Map(A    => MEMDataOut_Sig,	--0
									 B    => Load_Sig,			--1
									 Ctrl => Mux_Control2, 
									 O    => MEMout_Sig);

Instr<=Istruction;


end Structural;

