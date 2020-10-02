----------------------------------------------------------------------------------
-- Lab3
-- Omada : Georgakopoulou Artemis
--			  Fragiadoulakis Manolis
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Datapath is
    Port ( Clk 				: in  STD_LOGIC;
			  branch_sel		: in  STD_LOGIC;
			  PC_sel				: in  STD_LOGIC;
           PC_LdEn			: in  STD_LOGIC;
           Reset				: in  STD_LOGIC;
           RF_WrEn			: in  STD_LOGIC;
           RF_WrData_Sel   : in  STD_LOGIC_VECTOR (2 downto 0);
			  RF_RegEn 			: in  STD_LOGIC;
           RF_B_sel			: in  STD_LOGIC;
			  Reg_A_En			: in  STD_LOGIC;
			  Reg_B_En			: in  STD_LOGIC;
			  Byte_Sel			: in  STD_LOGIC_VECTOR (1 downto 0);
			  ALU_RegEn			: in  STD_LOGIC;
			  ALU_A_Sel			: in  STD_LOGIC_VECTOR (2 downto 0);
           ALU_Bin_sel		: in  STD_LOGIC_VECTOR (2 downto 0);
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
			  con_out 			: in  STD_LOGIC_VECTOR (31 downto 0);
			  conout_B			: in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_Sel 	: in  STD_LOGIC_VECTOR (2 downto 0);
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
			  zero_B 		: in  STD_LOGIC_VECTOR (31 downto 0);
			  MEM_out 		: in  STD_LOGIC_VECTOR (31 downto 0);
			  base_addr		: in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Bin_Sel 	: in  STD_LOGIC_VECTOR (2 downto 0);
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
    Port ( DataIn		: in  STD_LOGIC_VECTOR (7 downto 0);
           DataOut	: out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component Reg is
    Port ( CLK : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component Reg8 is
    Port ( CLK : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (7 downto 0);
           WE : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (7 downto 0));
end Component;

Component mux8 is
    Port ( In1 	: in  STD_LOGIC_VECTOR (31 downto 0);
           In2 	: in  STD_LOGIC_VECTOR (31 downto 0);
			  In3 	: in  STD_LOGIC_VECTOR (31 downto 0);
           In4		: in  STD_LOGIC_VECTOR (31 downto 0);
			  In5 	: in  STD_LOGIC_VECTOR (31 downto 0);
           In6 	: in  STD_LOGIC_VECTOR (31 downto 0);
			  In7 	: in  STD_LOGIC_VECTOR (31 downto 0);
           In8 	: in  STD_LOGIC_VECTOR (31 downto 0);
			  Ctrl 	: in STD_LOGIC_VECTOR (2 downto 0);
           O 		: out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component mux4 is
    Port ( In1 : in  STD_LOGIC_VECTOR (7 downto 0);
           In2 : in  STD_LOGIC_VECTOR (7 downto 0);
           In3 : in  STD_LOGIC_VECTOR (7 downto 0);
           In4 : in  STD_LOGIC_VECTOR (7 downto 0);
           Ctrl : in  STD_LOGIC_VECTOR (1 downto 0);
           O : out  STD_LOGIC_VECTOR (7 downto 0));
end Component;

Component concat is
    Port ( In1 : in  STD_LOGIC_VECTOR (7 downto 0);
           In2 : in  STD_LOGIC_VECTOR (7 downto 0);
           In3 : in  STD_LOGIC_VECTOR (7 downto 0);
           In4 : in  STD_LOGIC_VECTOR (7 downto 0);
           O : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component signextend is
    Port ( Din : in  STD_LOGIC_VECTOR (7 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

SIGNAL Istruction	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Immed_Sig	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL A_Sig		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL mux_out		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL mux_out2	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL mux_out3	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL B_Sig		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ALUout_Sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL base_addr_sig		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL temp_MEMout: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL MEMout_Sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL MEMDataIn_Sig		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL MEMDataOut_Sig	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Load_Sig	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Store_Sig 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL mux4_outA	: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL mux4_outB	: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL zero_A	 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL zero_B 		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Out1			: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Out2			: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Out3			: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Out4			: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Out1_B		: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Out2_B		: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Out3_B		: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Out4_B		: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL conout_sig	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL conout_sig_B		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL cloud		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL MEMin		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Reg_A_sig	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Reg_B_sig	: STD_LOGIC_VECTOR(31 DOWNTO 0);


begin
PC_adder_mux : mux2 Port Map(	A 	=> Immed_Sig,		--000
										B 	=> Reg_A_Sig,			--001
										Ctrl 	=> branch_sel,
										O 		=> mux_out3);
IFSTAGE_label : IFSTAGE port map (PC_Immed	=> mux_out3,	
											 PC_Sel 		=>	PC_Sel,
											 PC_LdEn 	=>	PC_LdEn,
											 Reset 		=>	Reset,	
											 Clk 			=>	Clk,
											 Instr 		=>	Istruction	);
											
DECSTAGE_label : DECSTAGE port map (Instr 			=> Istruction, 
												RF_WrEn 			=> RF_WrEn,
												ALU_out 			=> ALUout_Sig,
												MEM_out 			=> MEMout_Sig,
												con_out			=> conout_sig,
												conout_B			=> conout_sig_B,	
												RF_WrData_Sel	=> RF_WrData_Sel,
												RF_RegEn			=> RF_RegEn,
												RF_B_Sel 		=> RF_B_Sel,
												Clk 				=> Clk,
												Immed 			=> Immed_Sig,
												RF_A 				=> A_Sig,
												RF_B 				=> B_Sig);
												
Reg_A	: Reg Port Map ( CLK => Clk,
							  Din => A_Sig,
							  WE 	=> Reg_A_En,
							  Dout=> Reg_A_Sig);
Reg_B	: Reg Port Map ( CLK => Clk,
							  Din => B_Sig,
							  WE 	=> Reg_B_En,
							  Dout=> Reg_B_Sig);

mux_Byte_A	:	mux4	Port Map (	In1 	=> Reg_A_Sig(31 downto 24),
											In2 	=> Reg_A_Sig(23 downto 16),
											In3 	=> Reg_A_Sig(15 downto 8),
											In4 	=> Reg_A_Sig(7 downto 0),
											Ctrl 	=> Byte_Sel,
											O 		=> mux4_outA);
											
zerofill_A	:	zerofill Port Map ( 	DataIn 	=> mux4_outA,
												DataOut 	=> zero_A);
										 
mux_Byte_B	:	mux4	Port Map (	In1 	=> Reg_B_Sig(31 downto 24),
											In2 	=> Reg_B_Sig(23 downto 16),
											In3 	=> Reg_B_Sig(15 downto 8),
											In4 	=> Reg_B_Sig(7 downto 0),
											Ctrl 	=> Byte_Sel,
											O 		=> mux4_outB);
											
zerofill_B	:	zerofill Port Map ( 	DataIn 	=> mux4_outB,
												DataOut 	=> zero_B);
												
sign_extend :	signextend Port Map( Din	=> mux4_outB,
												Dout 	=> cloud);

ALU_A_DataIn : mux8 Port Map(	In1 	=> Reg_A_Sig,		--000
										In2 	=> (others=>'0'),	--001 (zero)
										In3 	=> zero_A,			--010
										In4	=> MEMout_Sig,		--011	
										In5 	=> temp_MEMout,	--100
										In6 	=> "00000000000000000000000000000100",	--101 (base_addr)
										In7 	=> (others=>'0'),	--110
										In8 	=> (others=>'0'),	--111
										Ctrl 	=> ALU_A_Sel,
										O 		=> mux_out);											
ALUSTAGE_label : ALUSTAGE port map (RF_A 			=> mux_out,
												RF_B 			=> Reg_B_Sig,		--000
												Immed 		=> Immed_Sig,		--001
												zero_B		=> zero_B,			--010
												MEM_out		=> MEMout_Sig,		--011
												base_addr	=> base_addr_Sig,	--100
												ALU_Bin_Sel => ALU_Bin_Sel,
												ALU_func 	=> ALU_func,
												ALU_out 		=> ALUout_Sig, 
												Zero			=> Zero);

base_addr_label	: Reg Port Map ( CLK => Clk,
											  Din => ALUout_Sig,
											  WE 	=> ALU_RegEn,
											  Dout=> base_addr_Sig);
						  
Reg8_1		: Reg8 Port Map ( CLK => Clk,
									  Din => ALUout_Sig(7 downto 0),
									  WE 	=> En1,
									  Dout=> Out1);
Reg8_2		: Reg8 Port Map ( CLK => Clk,
									  Din => ALUout_Sig(7 downto 0),
									  WE 	=> En2,
									  Dout=> Out2);
Reg8_3		: Reg8 Port Map ( CLK => Clk,
									  Din => ALUout_Sig(7 downto 0),
									  WE 	=> En3,
									  Dout=> Out3);
Reg8_4		: Reg8 Port Map ( CLK => Clk,
									  Din => ALUout_Sig(7 downto 0),
									  WE 	=> En4,
									  Dout=> Out4);
									  
concat_l		: concat Port Map (	In1	=> Out1,
											In2	=> Out2,
											In3	=> Out3,
											In4	=> Out4,
											O		=> conout_sig);								  
mux_MEM_addr : mux8 Port Map(	In1 	=> ALUout_Sig,		--000
										In2 	=> Immed_Sig,		--001
										In3 	=> Reg_A_Sig,		--010
										In4	=> Reg_B_Sig,		--011	
										In5 	=> base_addr_Sig,	--100
										In6 	=> (others=>'0'),	--101
										In7 	=> (others=>'0'),	--110
										In8 	=> (others=>'0'),	--111
										Ctrl 	=> MEM_addr_sel,
										O 		=> mux_out2);	
Store_label : zerofill port map(	DataIn 	=> Reg_B_Sig(7 downto 0),
											DataOut 	=> Store_Sig);
												
muxControl1 	: mux2 Port Map(A    => Reg_B_Sig,    --0
										 B    => Store_Sig, --1
										 Ctrl => Mux_Control1, 
										 O    => MEMDataIn_Sig );
									 
muxControl1_2 	: mux2 Port Map(A    => MEMDataIn_Sig,    --0
										 B    => cloud, 				--1
										 Ctrl => Mux_Control1_2, 
										 O    =>  MEMin);									 
									
MEMSTAGE_label : MEMSTAGE port map (clk 				=> Clk,
												Mem_WrEn 		=> Mem_WrEn,
												ALU_MEM_Addr 	=> mux_out2,
												MEM_DataIn 		=> MEMin,
												MEM_DataOut 	=> MEMDataOut_Sig);
RegMEMout		: Reg Port Map ( CLK => Clk,
										  Din => MEMDataOut_Sig,
										  WE 	=> MEM_RegEn,
										  Dout=> temp_MEMout);

Load_label : zerofill port map (	DataIn  => MEMDataOut_Sig(7 downto 0),
											DataOut => Load_Sig);

muxControl2 : mux2 Port Map(A    => MEMDataOut_Sig,	--0
									 B    => Load_Sig,			--1
									 Ctrl => Mux_Control2, 
									 O    => MEMout_Sig);
									 
Reg8_1_B		: Reg8 Port Map (	CLK	=> Clk,
										Din	=> MEMDataOut_Sig(7 downto 0),
										WE		=> En1_B,
										Dout	=> Out1_B);
Reg8_2_B		: Reg8 Port Map ( CLK 	=> Clk,
									   Din 	=> MEMDataOut_Sig(7 downto 0),
									   WE 	=> En2_B,
									   Dout	=> Out2_B);
Reg8_3_B		: Reg8 Port Map ( CLK 	=> Clk,
									   Din 	=> MEMDataOut_Sig(7 downto 0),
									   WE 	=> En3_B,
									   Dout	=> Out3_B);
Reg8_4_B		: Reg8 Port Map ( CLK 	=> Clk,
									   Din 	=> MEMDataOut_Sig(7 downto 0),
									   WE 	=> En4_B,
									   Dout	=> Out4_B);
									  
concat_l_B	: concat Port Map (	In1	=> Out4_B,
											In2	=> Out3_B,
											In3	=> Out2_B,
											In4	=> Out1_B,
											O		=> conout_sig_B);
Instr<=Istruction;


end Structural;

