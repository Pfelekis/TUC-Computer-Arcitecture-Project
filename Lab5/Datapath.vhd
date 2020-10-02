library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Datapath is
    Port ( Clk		: in  STD_LOGIC;
           Reset	: in  STD_LOGIC);
end Datapath;

architecture Structural of Datapath is

Component IFSTAGE is
    Port ( PC_LdEn	: in  STD_LOGIC;
           Reset 		: in  STD_LOGIC;
           Clk 		: in  STD_LOGIC;
           Instr 		: out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component DECSTAGE is
    Port (	Clk 		: in  STD_LOGIC;
				Instr 	: in  STD_LOGIC_VECTOR (31 downto 0);
				RF_B_Sel : in  STD_LOGIC;
				RF_WrEn 	: in  STD_LOGIC;
				WrRd		: in  STD_LOGIC_VECTOR (4 downto 0);	--(rd)
				WrData 	: in  STD_LOGIC_VECTOR (31 downto 0);
				RegAEn 	: in  STD_LOGIC;
				RF_A 		: out  STD_LOGIC_VECTOR (31 downto 0);
				RegBEn 	: in  STD_LOGIC;
				RF_B 		: out  STD_LOGIC_VECTOR (31 downto 0);
				Immed 	: out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component ALUSTAGE is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
			  B_A	: in  STD_LOGIC_VECTOR (31 downto 0);
			  C_A	: in  STD_LOGIC_VECTOR (31 downto 0);
			  D_A	: in  STD_LOGIC_VECTOR (31 downto 0);
			  muxActrl : in STD_LOGIC_VECTOR (1 downto 0);
			  B_B	: in  STD_LOGIC_VECTOR (31 downto 0);
			  C_B	: in  STD_LOGIC_VECTOR (31 downto 0);
			  D_B	: in  STD_LOGIC_VECTOR (31 downto 0);
			  muxBctrl : in STD_LOGIC_VECTOR (1 downto 0);
           ALU_Bin_Sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  Zero : out  STD_LOGIC);
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

Component Reg is
    Port ( CLK : in  STD_LOGIC;
           Din	: in  STD_LOGIC_VECTOR (31 downto 0);
           WE 	: in  STD_LOGIC;
           Dout: out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component Control is
	Port (Instr 			: in  STD_LOGIC_VECTOR (31 downto 0);
			InstrOut 		: out  STD_LOGIC_VECTOR (31 downto 0);
			ALU_Bin_Sel		: out  STD_LOGIC;	
			MEM_WrEn			: out  STD_LOGIC;	
			RF_WrData_Sel	: out  STD_LOGIC;	
			RF_WrEn			: out  STD_LOGIC;
			RF_B_Sel			: out  STD_LOGIC);
end Component;

Component pipeline is
	Port (clk : in STD_LOGIC;
			InstrIn : in  STD_LOGIC_VECTOR (31 downto 0);
			InstrEn : in  STD_LOGIC;
			InstrOut : out  STD_LOGIC_VECTOR (31 downto 0);
			ALU_SelIn : in  STD_LOGIC ;
         ALU_SelEn : in  STD_LOGIC;
         ALU_SelOut : out  STD_LOGIC;
			RF_WrEn_In : in  STD_LOGIC ;
         RF_WrEn_En : in  STD_LOGIC;
         RF_WrEn_Out : out  STD_LOGIC;
			MEM_WrEn_In : in  STD_LOGIC ;
         MEM_WrEn_En : in  STD_LOGIC;
         MEM_WrEn_Out : out  STD_LOGIC;
			RF_Sel_In : in  STD_LOGIC ;
         RF_Sel_En : in  STD_LOGIC;
         RF_Sel_Out : out  STD_LOGIC);
end Component;

Component Forward is
	port( PC_LdEn	: in STD_LOGIC;
			rs 		: in STD_LOGIC_VECTOR (4 downto 0);
			rt			: in STD_LOGIC_VECTOR (4 downto 0);
			rd_pipe2	: in STD_LOGIC_VECTOR (4 downto 0);
			En_pipe2	: in STD_LOGIC;
			rd_pipe3	: in STD_LOGIC_VECTOR (4 downto 0);
			En_pipe3	: in STD_LOGIC;
			A_sel		: out STD_LOGIC_VECTOR (1 downto 0);
			B_sel		: out STD_LOGIC_VECTOR (1 downto 0));
end Component;

Component Stall is
    Port ( Clk : in STD_LOGIC;
			  Reset	: in  STD_LOGIC;
			  rs : in  STD_LOGIC_VECTOR (4 downto 0);
           rt : in  STD_LOGIC_VECTOR (4 downto 0);
           Op_pipe1 : in  STD_LOGIC_VECTOR (5 downto 0);
           rd_pipe1 : in  STD_LOGIC_VECTOR (4 downto 0);
           PC_LdEn : out  STD_LOGIC;
			  IMEM_RegEn : out  STD_LOGIC);
end Component;

SIGNAL Instruction: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL InstrOut0	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL InstrIn1	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL InstrOut1	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL InstrOut2	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL InstrOut3	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Immed_Sig	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL A_Sig		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL B_Sig		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL B_SigOut	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL A_Sel		: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL B_Sel		: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL ALUout_Sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL temp_ALUout		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL temp_ALUout2		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL MEMout_Sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL WrData_Sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ZeroOut 	: STD_LOGIC;
SIGNAL ALU_Sel_In1		: STD_LOGIC;
SIGNAL ALU_Sel_Out1		: STD_LOGIC;
SIGNAL MEM_WrEn_In1		: STD_LOGIC;
SIGNAL MEM_WrEn_Out1		: STD_LOGIC;
SIGNAL RF_WrSel_In1		: STD_LOGIC;
SIGNAL RF_WrSel_Out1		: STD_LOGIC;
SIGNAL RF_WrEn_In1		: STD_LOGIC;
SIGNAL RF_WrEn_Out1		: STD_LOGIC;
SIGNAL RF_BSel_sig		: STD_LOGIC;
SIGNAL ALU_Sel_Out2		: STD_LOGIC;
SIGNAL MEM_WrEn_Out2		: STD_LOGIC;
SIGNAL RF_WrSel_Out2		: STD_LOGIC;
SIGNAL RF_WrEn_Out2		: STD_LOGIC;
SIGNAL ALU_Sel_Out3		: STD_LOGIC;
SIGNAL MEM_WrEn_Out3		: STD_LOGIC;
SIGNAL RF_WrSel_Out3		: STD_LOGIC;
SIGNAL RF_WrEn_Out3		: STD_LOGIC;
SIGNAL PC_LdEn_sig		: STD_LOGIC;
SIGNAL IMEM_RegEn_sig	: STD_LOGIC;

begin

IFSTAGE_label : IFSTAGE port map (PC_LdEn 	=>	PC_LdEn_sig,
											 Reset 		=>	Reset,	
											 Clk 			=>	Clk,
											 Instr 		=>	Instruction);
											 
IMEM_Reg : Reg Port Map(	CLK 	=> Clk,
									Din 	=> Instruction,
									WE 	=> IMEM_RegEn_sig,
									Dout	=> InstrOut0);
									
Control_label : Control Port map (	Instr 			=> InstrOut0,	
												InstrOut 		=>	InstrIn1,
												ALU_Bin_Sel		=>	ALU_Sel_In1,
												MEM_WrEn			=>	MEM_WrEn_In1,
												RF_WrData_Sel	=> RF_WrSel_In1,
												RF_WrEn			=>	RF_WrEn_In1,
												RF_B_Sel			=>	RF_BSel_sig);
												
Stall_label : Stall Port Map( Clk 			=> Clk,
										Reset			=> Reset,
										rs 			=> Instruction(25 downto 21),
										rt 			=> Instruction(15 downto 11),
										Op_pipe1 	=> InstrIn1(31 downto 26),
										rd_pipe1 	=> InstrIn1(20 downto 16),
										PC_LdEn 		=> PC_LdEn_sig,
										IMEM_RegEn 	=> IMEM_RegEn_sig);


DECSTAGE_label : DECSTAGE port map (Clk		=> Clk,
												Instr		=> InstrOut0,
												RF_B_Sel	=> RF_BSel_sig,
												RF_WrEn	=> RF_WrEn_Out3,
												WrRd		=> InstrOut3(20 downto 16),	--(rd)
												WrData	=> WrData_Sig,
												RegAEn	=> '1',
												RF_A		=> A_Sig,
												RegBEn	=> '1',
												RF_B		=> B_Sig,
												Immed		=> Immed_Sig); 
												
Pipeline1 : pipeline Port map(clk 				=> Clk,
										InstrIn			=> InstrIn1,
										InstrEn 			=> '1',
										InstrOut			=> InstrOut1,
										ALU_SelIn		=>	ALU_Sel_In1,
										ALU_SelEn 		=> '1',
										ALU_SelOut 		=> ALU_Sel_Out1,
										RF_WrEn_In 		=>	RF_WrEn_In1,
										RF_WrEn_En 		=> '1',
										RF_WrEn_Out 	=> RF_WrEn_Out1,
										MEM_WrEn_In		=>	MEM_WrEn_In1,
										MEM_WrEn_En 	=> '1',
										MEM_WrEn_Out 	=>	MEM_WrEn_Out1,
										RF_Sel_In		=> RF_WrSel_In1,
										RF_Sel_En 		=> '1',
										RF_Sel_Out		=> RF_WrSel_Out1);

forwarding : Forward port map(PC_LdEn	=>	PC_LdEn_sig,
										rs 		=> InstrOut1(25 downto 21),
										rt			=> InstrOut1(15 downto 11),
										rd_pipe2	=> InstrOut2(20 downto 16),
										En_pipe2	=> RF_WrEn_Out2,
										rd_pipe3	=> InstrOut3(20 downto 16),
										En_pipe3	=> RF_WrEn_Out3,
										A_sel		=> A_Sel,
										B_sel		=> B_Sel);

ALUSTAGE_label : ALUSTAGE port map (RF_A 			=> A_Sig,
												RF_B 			=> B_Sig,
												Immed 		=> Immed_Sig,
												B_A			=> temp_ALUout,
												C_A			=> temp_ALUout2,
												D_A			=> (others => '0'),
												muxActrl 	=> A_Sel,
												B_B			=> temp_ALUout,
												C_B			=> temp_ALUout2,
												D_B			=> (others => '0'),
												muxBctrl 	=> B_Sel,
												ALU_Bin_Sel => ALU_Sel_Out1,
												ALU_func 	=> InstrOut1(3 downto 0),
												ALU_out 		=> ALUout_Sig, 
												Zero			=> ZeroOut);
												
RegALUout : Reg Port Map(	CLK 	=> Clk,
									Din 	=> ALUout_Sig,
									WE 	=> '1',
									Dout	=> temp_ALUout);
									
RegBout 	: Reg Port Map(	CLK 	=> Clk,
									Din 	=> B_Sig,
									WE 	=> '1',
									Dout	=> B_SigOut);
									
Pipeline2 : pipeline Port map(clk 				=> Clk,
										InstrIn			=> InstrOut1,
										InstrEn 			=> '1',
										InstrOut			=> InstrOut2,
										ALU_SelIn		=>	ALU_Sel_Out1,
										ALU_SelEn 		=> '1',
										ALU_SelOut 		=> ALU_Sel_Out2,
										RF_WrEn_In 		=>	RF_WrEn_Out1,
										RF_WrEn_En 		=> '1',
										RF_WrEn_Out 	=> RF_WrEn_Out2,
										MEM_WrEn_In		=>	MEM_WrEn_Out1,
										MEM_WrEn_En 	=> '1',
										MEM_WrEn_Out 	=>	MEM_WrEn_Out2,
										RF_Sel_In		=> RF_WrSel_Out1,
										RF_Sel_En 		=> '1',
										RF_Sel_Out		=> RF_WrSel_Out2);
												
										
MEMSTAGE_label : MEMSTAGE port map (clk 				=> Clk,
												Mem_WrEn 		=> MEM_WrEn_Out2,
												ALU_MEM_Addr 	=> temp_ALUout,
												MEM_DataIn 		=> B_SigOut,
												MEM_DataOut 	=> MEMout_Sig);
												
RegALUout2 : Reg Port Map(	CLK 	=> Clk,
									Din 	=> temp_ALUout,
									WE 	=> '1',
									Dout	=> temp_ALUout2);
									
Pipeline3 : pipeline Port map(clk 				=> Clk,
										InstrIn			=> InstrOut2,
										InstrEn 			=> '1',
										InstrOut			=> InstrOut3,
										ALU_SelIn		=>	ALU_Sel_Out2,
										ALU_SelEn 		=> '1',
										ALU_SelOut 		=> ALU_Sel_Out3,
										RF_WrEn_In 		=>	RF_WrEn_Out2,
										RF_WrEn_En 		=> '1',
										RF_WrEn_Out 	=> RF_WrEn_Out3,
										MEM_WrEn_In		=>	MEM_WrEn_Out2,
										MEM_WrEn_En 	=> '1',
										MEM_WrEn_Out 	=>	MEM_WrEn_Out3,
										RF_Sel_In		=> RF_WrSel_Out2,
										RF_Sel_En 		=> '1',
										RF_Sel_Out		=> RF_WrSel_Out3);

WRSTAGE : mux2 Port Map(A    => MEMout_Sig, 	--0
								B    => temp_ALUout2, --1
								Ctrl => RF_WrSel_Out3, 
								O    => WrData_Sig);
	

end Structural;

