----------------------------------------------------------------------------------
-- Lab3
-- Omada : Georgakopoulou Artemis
--			  Fragiadoulakis Manolis
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CONTROL is
Port (	Instr 			: in  STD_LOGIC_VECTOR (31 downto 0);
         Zero 				: in  STD_LOGIC;
			Reset				: in  STD_LOGIC;
			Clock				: in  STD_LOGIC;
			
			branch_sel		: out  STD_LOGIC;
			PC_sel			: out  STD_LOGIC;
			PC_LdEn			: out  STD_LOGIC;
			PC_Reset			: out  STD_LOGIC;
			RF_WrEn			: out  STD_LOGIC;
			RF_WrData_Sel  : out  STD_LOGIC_VECTOR (2 downto 0);
			RF_RegEn 		: out  STD_LOGIC;
			Reg_A_En			: out  STD_LOGIC;
			Reg_B_En			: out  STD_LOGIC;
			RF_B_sel			: out  STD_LOGIC;
			Byte_Sel			: out  STD_LOGIC_VECTOR (1 downto 0);
			ALU_RegEn		: out  STD_LOGIC;
			ALU_A_sel		: out  STD_LOGIC_VECTOR (2 downto 0);
			ALU_Bin_sel		: out  STD_LOGIC_VECTOR (2 downto 0);
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
end CONTROL;

architecture Behavioral of CONTROL is

type state is (reset_state,instr_state,nop,A1,A2,A3,B1,B2,C1,C2,branch1,branch2,branch3,beq,bne,str1,str2,str3,ld1,ld2,ld3,ld4,cm1,cm2,cm3,cm4,mmx1,mmx2,mmx3,mmx4,mmx5,mmx6,berm1,berm2,berm3,berm4,berm5,bnem1,bnem2,bnem3,bnem4,bnem5,bpm1,bpm2,bpm3,bpm4,bpm5,bpm6,void,void2,bum1,bum2,bum3,bum4,bum5,bum6,endop);
signal current_state, next_state: state;

begin
	process(current_state,Instr,Zero)
	begin
	case current_state is
		when reset_state =>	--reseting all control signals
			branch_sel		<= '0';
			PC_sel			<= '0';
			PC_LdEn			<= '0';
			Reg_A_En			<= '0';
			Reg_B_En			<= '0';
			PC_Reset			<= '1';
			RF_WrEn			<= '0';
			RF_WrData_sel	<= "000"; --pairnei h' aLU h' MEM an ginei 1 pairnei Immed
			RF_RegEn			<= '0';
			Byte_Sel			<= "00";
			ALU_RegEn 		<= '0';
			RF_B_sel			<= '0';
			ALU_A_sel		<= "000";
			ALU_Bin_sel		<= "000";
			ALU_func			<= "0000";
			En1				<= '0';
			En2				<= '0';
			En3				<= '0';
			En4				<= '0';
			En1_B				<= '0';
			En2_B				<= '0';
			En3_B				<= '0';
			En4_B				<= '0';
			MEM_RegEn		<= '0';
			MEM_addr_sel	<= "000";
			MEM_WrEn			<= '0';
			Mux_Control1	<= '0';	--store
			Mux_Control1_2 <= '0';
			Mux_Control2 	<= '0';	--load
			next_state 		<= instr_state;
		when instr_state =>--handles new insructions
			Reg_A_En			<= '1';
			Reg_B_En			<= '1';
			PC_Reset		<=	'0';
			RF_RegEn		<= '1';
			--ALU_RegEn	<= '1';
			if(Instr="00000000000000000000000000000000") then --Nop
				next_state	<= nop;
			elsif(Instr(31 downto 26)="100000") then --ALU
				next_state	<=	A1;
			elsif(Instr(31 downto 26)="111000") then --li
				next_state	<=	B1;
			elsif(Instr(31 downto 26)="111001") then --lui
				next_state	<= B1;
			elsif(Instr(31 downto 26)="110000") then	--addi
				next_state	<= C1;
			elsif(Instr(31 downto 26)="110010") then --andi
				next_state	<= C1;
			elsif(Instr(31 downto 26)="110011") then --ori
				next_state	<= C1;
			elsif(Instr(31 downto 26)="111111") then --b
				next_state	<=	branch1;
			elsif(Instr(31 downto 26)="000000") then --beq
				next_state	<= branch3;
			elsif(Instr(31 downto 26)="000001") then --bneq
				next_state	<= branch3;
			elsif(Instr(31 downto 26)="000111") then --sb
				next_state	<= str1;
			elsif(Instr(31 downto 26)="011111") then --sw
				next_state	<= str1;
			elsif(Instr(31 downto 26)="000011") then --lb
				next_state	<=	ld1;
			elsif(Instr(31 downto 26)="001111") then --lw
				next_state	<= ld1;
			elsif(Instr(31 downto 26)="100001") then --cmov
				next_state	<= cm1;
			elsif(Instr(31 downto 26)="100011") then --add_MMX_byte
				next_state	<= mmx1;
			elsif(Instr(31 downto 26)="100111") then --branch_equal_reg_mem
				next_state	<= berm1;
			elsif(Instr(31 downto 26)="101111") then --branch_not_equal_mem
				next_state	<= bnem1;
			elsif(Instr(31 downto 26)="111100") then --byte_pack_mem
				next_state	<= bpm1;
			elsif(Instr(31 downto 26)="111110") then --byte_unpack_mem
				next_state	<= bum1;
			end if;
		when nop		=>
			RF_WrEn	<= '0';
			MEM_WrEn <= '0';
			PC_LdEn	<= '1';
			PC_Sel	<= '0';
			next_state	<= endop;
		when A1		=>
			RF_B_Sel <= '0';
			next_state	<= A2;
		when A2		=>
			ALU_Bin_Sel	<= "000"; --RF_A
			if Instr(5 downto 0)="110000" then	--add
				ALU_func<= "0000";			
			elsif Instr(5 downto 0)="110001" then --sub
				ALU_func<= "0001";		
			elsif Instr(5 downto 0)="110010" then --and
				ALU_func<= "0010";
			elsif Instr(5 downto 0)="110100" then --not
				ALU_func<= "0100";
			elsif Instr(5 downto 0)="110011" then --or
				ALU_func<= "0011";
			elsif Instr(5 downto 0)="111000" then --shr
				ALU_func<= "1001";
			elsif Instr(5 downto 0)="111001" then --shl
				ALU_func<= "1010";
			elsif Instr(5 downto 0)="111100" then --ror
				ALU_func<= "1100";
			elsif Instr(5 downto 0)="111101" then --rol
				ALU_func<= "1101";
			end if;
			next_state	<= A3;
		when A3		=>
			RF_WrData_sel <= "000";	--ALU
			RF_WrEn	<= '1';
			PC_LdEn	<= '1';
			PC_Sel	<= '0';
			next_state	<= endop;
		when B1		=>
			next_state	<= B2;
		when B2		=>
			RF_WrData_sel <= "010";	--immed
			RF_WrEn	<= '1';
			PC_LdEn	<= '1';
			PC_Sel	<= '0';
			next_state	<= endop;
		when C1		=>
			next_state	<= C2;
		when C2		=>
			ALU_Bin_sel <= "001"; --immed
			if(Instr(31 downto 26)="110000") then	--addi
				ALU_func<= "0000";	
			elsif(Instr(31 downto 26)="110010") then --andi
				ALU_func<= "0010";
			elsif(Instr(31 downto 26)="110011") then --ori
				ALU_func<= "0011";
			end if;
			next_state	<= A3;
		when branch1=>
			branch_sel 	<= '0';
			next_state	<= branch2;
		when branch2=>
			PC_LdEn	<= '1';
			PC_Sel	<= '1';
			next_state	<= endop;
		when branch3=>
			RF_B_sel <='1';
			if(Instr(31 downto 26)="000000") then --beq
				next_state	<= beq;
			elsif(Instr(31 downto 26)="000001") then --bneq
				next_state	<= bne;
			end if;
		when beq		=>
			ALU_A_sel 	<= "000"; --RF_A
			ALU_Bin_sel <= "000"; --RF_B
			ALU_func		<= "0001";
			if(Zero = '1') then 
				next_state	<= branch1;
			else
				next_state	<= nop;
			end if;
		when bne		=>
			ALU_A_sel 	<= "000"; --RF_A
			ALU_Bin_sel <= "000"; --RF_B
			ALU_func		<= "0001";
			if(Zero = '0') then 
				next_state	<= branch1;
			else
				next_state	<= nop;
			end if;
		when str1	=>
			RF_B_Sel	<= '1';
			next_state	<= str2;
		when str2	=>
			ALU_Bin_sel <= "001"; --immed
			ALU_func		<= "0000";
			next_state	<= str3;
		when str3	=>
			if (Instr(31 downto 26)="011111") then --sw
				Mux_Control1	<= '0';
				Mux_Control1_2 <= '0';
			else												--sb
				Mux_Control1	<= '1';
				Mux_Control1_2 <= '0';
			end if;
			MEM_WrEn	<= '1';
			next_state	<= nop;
		when ld1		=>
		next_state	<= ld2;
		when ld2		=>
			ALU_Bin_sel <= "001"; --immed
			ALU_func		<= "0000";
			next_state	<= ld3;
		when ld3		=>
			if (Instr(31 downto 26)="001111") then --lw
				Mux_Control1	<= '0';
				Mux_Control1_2 <= '0';
			else												--lb
				Mux_Control1	<= '1';
				Mux_Control1_2 <= '0';
			end if;
			next_state	<= ld4;
		when ld4		=>
			RF_WrEn	<='1';
			RF_WrData_sel <= "001";	--MEM
			next_state	<= nop;
		when cm1		=>
			RF_B_sel		<= '0';
			next_state	<= cm2;
		when cm2		=>
			ALU_A_Sel	<= "001";
			ALU_Bin_Sel <= "000";
			ALU_func		<= "0001";
			next_state	<= cm3;
		when cm3		=>
			if(Zero = '0') then
				next_state <= cm4;
			else
				next_state <= nop;
			end if;
		when cm4		=>
			RF_WrEn	<='1';
			RF_WrData_sel <= "011";
			next_state	<= nop;
		when mmx1	=>
			RF_B_sel		<= '0';
			next_state	<= mmx2;
		when mmx2	=>
			Byte_sel 	<= "00";
			ALU_A_sel	<= "010";
			ALU_Bin_sel	<= "010";
			ALU_func		<= "0000";
			En1			<= '1';
			next_state	<= mmx3;
		when mmx3	=>
			En1			<= '0';
			Byte_sel 	<= "01";
			En2			<= '1';
			next_state	<= mmx4;
		when mmx4	=>
			En2			<= '0';
			Byte_sel 	<= "10";
			En3			<= '1';
			next_state	<= mmx5;
		when mmx5	=>
			En3			<= '0';
			Byte_sel 	<= "11";
			En4			<= '1';
			next_state	<= mmx6;
		when mmx6	=>
			En4			<= '0';
			RF_B_Sel		<= '1';
			RF_WrData_sel <= "100";
			RF_WrEn		<= '1';
			next_state	<= nop;
		when berm1	=>
			RF_B_Sel	<= '1';
			MEM_addr_sel <= "001";
			next_state	<= berm2;
		when berm2	=>
			ALU_A_sel	<= "011";
			ALU_Bin_sel	<= "000";
			ALU_func		<= "0001";
			next_state	<= berm3;
		when berm3	=>
			if(Zero = '1') then 
				next_state	<= berm4;
			else
				next_state	<= nop;
			end if;
		when berm4=>
			branch_sel 	<= '1';
			next_state	<= berm5;
		when berm5=>
			PC_LdEn	<= '1';
			PC_Sel	<= '1';
			next_state	<= endop;
		when bnem1	=>
			RF_B_sel	<= '1';
			next_state	<= bnem2;
		when bnem2	=>
			MEM_addr_sel	<= "010";
			MEM_RegEn	<= '1';
			next_state	<= bnem3;
		when bnem3	=>
			MEM_RegEn	<= '1';
			next_state	<= bnem4;
		when bnem4	=>
			MEM_RegEn	<= '0';
			MEM_addr_sel	<= "011";
			next_state	<= bnem5;
		when bnem5	=>
			ALU_A_sel	<= "100";
			ALU_Bin_sel	<= "011";
			ALU_func		<= "0001";
			if(Zero = '0') then
				branch_sel	<= '0';
				next_state	<= branch1;
			else
				next_state	<= nop;
			end if;
		when bpm1	=>
			ALU_RegEn	<= '1';
			ALU_A_sel	<= "000";
			ALU_Bin_sel	<= "001";
			ALU_func		<= "0000";
			next_state	<= void;
		when void =>
			
			next_state	<= bpm2;
		when bpm2	=>
			ALU_A_sel	<= "101";
			ALU_Bin_sel	<= "100";
			MEM_addr_sel<= "100";
			En1_B	<= '1';
			next_state	<= void2;
		when void2 =>
			next_state	<= bpm3;
		when bpm3	=>
			En1_B	<= '0';
			En2_B	<= '1';
			next_state	<= bpm4;
		when bpm4	=>
			En2_B	<= '0';
			En3_B	<= '1';
			next_state	<= bpm5;
		when bpm5	=>
			En3_B	<= '0';
			En4_B	<= '1';
			next_state	<= bpm6;
		when bpm6	=>
			En4_B	<= '0';
			RF_WrData_sel <= "101";
			RF_WrEn		<=	'1';
			ALU_RegEn	<= '0';
			next_state	<= nop;
		when bum1	=>
			RF_B_sel	<=	'1';
			next_state	<= bum2;
		when bum2	=>
			ALU_A_sel	<= "000";
			ALU_Bin_sel	<= "001";
			ALU_func		<= "0000";
			ALU_RegEn	<=	'1';
			next_state	<= bum3;
		when bum3	=>
			Byte_Sel	<= "11";
			Mux_Control1_2 <= '1';
			MEM_addr_sel <= "100";
			MEM_WrEn	<= '1';
			ALU_A_sel	<= "101";
			ALU_Bin_sel	<= "100";
			next_state	<= bum4;
		when bum4	=>
			Byte_Sel	<= "10";
			next_state	<= bum5;
		when bum5	=>
			Byte_Sel	<= "01";
			next_state	<= bum6;
		when bum6	=>
			Byte_Sel	<= "00";
			ALU_RegEn	<=	'0';
			next_state	<= nop;
		when endop	=>
			Mux_Control1_2 <= '0';
			RF_WrEn	<= '0';
			PC_LdEn	<= '0';
			next_state	<= instr_state;
		end case;
	end process;

	process(Clock,Reset)
	begin
		if Reset = '1' then
			current_state <= reset_state;
		elsif (Clock'EVENT and Clock = '1') then
			current_state <= next_state;
		end if;
	end process;


end Behavioral;

