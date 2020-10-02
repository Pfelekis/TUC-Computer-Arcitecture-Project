library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity pipeline is
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
end pipeline;

architecture Behavioral of pipeline is

Component Reg is
    Port ( CLK : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component RegEn is
    Port ( CLK : in  STD_LOGIC;
           Din : in  STD_LOGIC ;
           WE : in  STD_LOGIC;
           Dout : out  STD_LOGIC);
end Component;

begin

	Instr : Reg Port Map(CLK	=> Clk,
								Din	=> InstrIn,
								WE		=> InstrEn,
								Dout	=> InstrOut);
								
	ALU_Bin_Sel : RegEn Port Map(	CLK	=> Clk,
											Din	=> ALU_SelIn,
											WE		=> ALU_SelEn,
											Dout	=> ALU_SelOut);
										
	RF_WrEn : RegEn Port Map(  CLK	=> Clk,
										Din	=> RF_WrEn_In,
										WE		=> RF_WrEn_En,
										Dout	=> RF_WrEn_Out);
									
	MEM_WrEn : RegEn Port Map(  CLK	=> Clk,
										 Din	=> MEM_WrEn_In,
										 WE	=> MEM_WrEn_En,
										 Dout	=> MEM_WrEn_Out);
									
	RF_WrData_Sel : RegEn Port Map(  CLK	=> Clk,
												Din	=> RF_Sel_In,
												WE		=> RF_Sel_En,
												Dout	=> RF_Sel_Out);
								
end Behavioral;

