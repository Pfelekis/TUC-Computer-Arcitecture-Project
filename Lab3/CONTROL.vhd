library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CONTROL is
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
			RF_RegEn 		: out  STD_LOGIC;
			RF_B_sel			: out  STD_LOGIC;
			ALU_RegEn		: out  STD_LOGIC;
			ALU_Bin_sel		: out  STD_LOGIC;
			ALU_func			: out  STD_LOGIC_VECTOR (3 downto 0);
			MEM_WrEn			: out  STD_LOGIC;
			Mux_Control1	: out  STD_LOGIC;
			Mux_Control2 	: out  STD_LOGIC);
end CONTROL;

architecture Behavioral of CONTROL is

type state is (reset_state,instr_state,nop,A1,A2,A3,B1,B2,C1,C2,branch1,branch2,branch3,beq,bne,str1,str2,str3,ld1,ld2,ld3,ld4,endop);
signal current_state, next_state: state;

begin
	process(current_state,Instr,Zero)
	begin
	case current_state is
		when reset_state =>	--reseting all control signals
			PC_sel			<= '0';
			PC_LdEn			<= '0';
			PC_Reset			<= '1';
			RF_WrEn			<= '0';
			RF_WrData_sel1	<= '0';
			RF_WrData_sel2	<= '0'; --pairnei h' aLU h' MEM an ginei 1 pairnei Immed
			RF_RegEn			<= '0';
			ALU_RegEn 		<= '0';
			RF_B_sel			<= '0';
			ALU_Bin_sel		<= '0';
			ALU_func			<= "0000";
			MEM_WrEn			<= '0';
			Mux_Control1	<= '0';	--store
			Mux_Control2 	<= '0';	--load
			next_state 		<= instr_state;
		when instr_state =>--handles new insructions
			PC_Reset		<=	'0';
			RF_RegEn		<= '1';
			ALU_RegEn	<= '1';
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
			end if;
		when nop		=>
			RF_WrEn	<='0';
			MEM_WrEn <= '0';
			PC_LdEn	<= '1';
			PC_Sel	<= '0';
			next_state	<= endop;
		when A1		=>
			RF_B_Sel <= '0';
			next_state	<= A2;
		when A2		=>
			ALU_Bin_Sel	<= '0';
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
			RF_WrData_sel1 <= '0';
			RF_WrData_sel2 <= '0';
			RF_WrEn	<= '1';
			PC_LdEn	<= '1';
			PC_Sel	<= '0';
			next_state	<= endop;
		when B1		=>
			next_state	<= B2;
		when B2		=>
			RF_WrData_sel1 <= '0';
			RF_WrData_sel2 <= '1';	--immed
			RF_WrEn	<= '1';
			PC_LdEn	<= '1';
			PC_Sel	<= '0';
			next_state	<= endop;
		when C1		=>
			next_state	<= C2;
		when C2		=>
			ALU_Bin_Sel	<= '1';
			if(Instr(31 downto 26)="110000") then	--addi
				ALU_func<= "0000";	
			elsif(Instr(31 downto 26)="110010") then --andi
				ALU_func<= "0010";
			elsif(Instr(31 downto 26)="110011") then --ori
				ALU_func<= "0011";
			end if;
			next_state	<= A3;
		when branch1=>
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
			ALU_Bin_sel <= '0';
			ALU_func		<= "0001";
			if(Zero = '1') then 
				next_state	<= branch1;
			else
				next_state	<= nop;
			end if;
		when bne		=>
			ALU_Bin_sel <= '0';
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
			ALU_Bin_Sel <= '1';
			ALU_func		<= "0000";
			next_state	<= str3;
		when str3	=>
			if (Instr(31 downto 26)="011111") then --sw
				Mux_Control1	<= '0';
			else												--sb
				Mux_Control1	<= '1';
			end if;
			MEM_WrEn	<= '1';
			next_state	<= nop;
		when ld1		=>
		next_state	<= ld2;
		when ld2		=>
			ALU_Bin_Sel <= '1';
			ALU_func		<= "0000";
			next_state	<= ld3;
		when ld3		=>
			if (Instr(31 downto 26)="001111") then --lw
				Mux_Control1	<= '0';
			else												--lb
				Mux_Control1	<= '1';
			end if;
			next_state	<= ld4;
		when ld4		=>
			RF_WrEn	<='1';
			RF_WrData_sel1 <= '1';
			RF_WrData_sel2 <= '0';
			next_state	<= nop;
		when endop	=>
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

