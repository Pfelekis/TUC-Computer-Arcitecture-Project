library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           O : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Ovf : out  STD_LOGIC);
end ALU;

architecture Structural of ALU is
Component arithmetic is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
			  O : out  STD_LOGIC_VECTOR (31 downto 0);
           Cout : out  STD_LOGIC;
           Ovf : out  STD_LOGIC);
end Component;
Component logical is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           O : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;
Component shift_rotate is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           O : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

SIGNAL arithm_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL carry_out : STD_LOGIC; 
SIGNAL arithm_ovf : STD_LOGIC;
SIGNAL logical_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL shift_rotate_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL temp_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL temp_zero : STD_LOGIC;

begin

process(A,B,Op, arithm_out, logical_out, shift_rotate_out, carry_out , arithm_ovf, temp_out)
begin

	if (Op = "0000" OR Op = "0001") then -- prosthesi - afairesh
		temp_out <= arithm_out;
		Cout <= carry_out;
		Ovf  <=  arithm_ovf;
	elsif( Op = "0010" OR Op = "0011" OR Op = "0100") then -- AND, OR, NOT
		temp_out <= logical_out;
		Cout <= '0';
		Ovf  <= '0';
	elsif( Op = "1000" OR Op = "1001" OR Op = "1010" OR Op = "1100" OR Op = "1101") then -- shift_rotate
		temp_out <= shift_rotate_out;
		Cout <= '0';
		Ovf  <= '0';
	else
		temp_out<=B;	-- do nothing 
	end if;
	
	if (temp_out = "00000000000000000000000000000000") then
		temp_zero <= '1';
	else
		temp_zero <= '0';
	end if;

end process;
	
	O <= temp_out;
	Zero <= temp_zero;
	

	arithmetic_label : 
	arithmetic PORT MAP(A 	 => A,
							  B 	 => B,
							  Op 	 => Op,
							  O	 => arithm_out,
							  Cout => carry_out,
							  Ovf  => arithm_ovf);
   logical_label : 
	logical PORT MAP(A 	 => A,
						  B 	 => B,
						  Op 	 => Op,
						  O	 => logical_out);	
	shift_rotate_label : 
	shift_rotate PORT MAP(A  => A,
								 Op => Op,
								 O	 => shift_rotate_out);
end Structural;

