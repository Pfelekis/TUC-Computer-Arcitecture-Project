----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:33:32 05/14/2016 
-- Design Name: 
-- Module Name:    top_cashe - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_cashe is
    Port ( instr : in  STD_LOGIC_VECTOR (31 downto 0);
			  Din_mem: in STD_LOGIC_VECTOR (31 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           out_cashe : out  STD_LOGIC_VECTOR (31 downto 0));
end top_cashe;

architecture Behavioral of top_cashe is


component AND_MOD is
	Port (  valid : in  STD_LOGIC;
           comp : in  STD_LOGIC;
           outand : out  STD_LOGIC
);
end component;


component compare is
	Port (  tag_cache : in  STD_LOGIC_VECTOR (3 downto 0);
           tag_instr : in  STD_LOGIC_VECTOR (3 downto 0);
           out_comp : out  STD_LOGIC
);
end component;

component CACHE_MEM is
	port (
			clk : in std_logic;
			we : in std_logic;
			addr : in std_logic_vector(4 downto 0);
			din : in std_logic_vector(132 downto 0);
			dout : out std_logic_vector(132 downto 0)
);
end component;

component DMEM is
	port (
			clk : in std_logic;
			we : in std_logic;
			addr : in std_logic_vector(10 downto 0);
			din : in std_logic_vector(31 downto 0);
			dout : out std_logic_vector(31 downto 0)
);
end component;

component mux_cache is
	Port (  A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           C : in  STD_LOGIC_VECTOR (31 downto 0);
           D : in  STD_LOGIC_VECTOR (31 downto 0);
           mux_out : out  STD_LOGIC_VECTOR (31 downto 0);
           select_mux : in  STD_LOGIC_VECTOR (1 downto 0)
);
end component;

component regi is
    Port ( inregi : in  STD_LOGIC_VECTOR (31 downto 0);
           wren : in  STD_LOGIC;
           outregi : out  STD_LOGIC_VECTOR (31 downto 0);
			  clk : in  STD_LOGIC;
			  Reset : in  STD_LOGIC);
end component;

component FSM is
	Port(
			in_and: in STD_LOGIC;
			instr: in  STD_LOGIC_VECTOR (31 downto 0);
			clk: in STD_LOGIC;
			rst: in STD_LOGIC;
			WE_1: out STD_LOGIC;
			WE_2: out STD_LOGIC;
			WE_3: out STD_LOGIC;
			WE_4: out STD_LOGIC;
			WE_5: out STD_LOGIC;
			we: out STD_LOGIC;
			valid:out STD_LOGIC;
			out_fsm: out STD_LOGIC_VECTOR (10 downto 0));
end component;

component Reg_tag is
    Port ( in_tag : in  STD_LOGIC_VECTOR (3 downto 0);
           out_tag : out  STD_LOGIC_VECTOR (3 downto 0);
           we : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC);
end component;

signal cashe_out:std_logic_vector(132 downto 0);
signal comp_sig,and_sig, w1,w2,w3,w4,w5,we_sig:STD_LOGIC;
signal reg_sig:std_logic_vector(127 downto 0);
signal mem_sig:STD_LOGIC_VECTOR (31 downto 0);
signal addr_mem_sig:STD_LOGIC_VECTOR (10 downto 0);
signal in_cache:std_logic_vector(132 downto 0);
signal out_tag_s:std_logic_vector(3 downto 0);
signal val_sig:STD_LOGIC;
begin

cashe: CACHE_MEM port map(
	clk=>clk,
	we=>we_sig,
	addr=>instr(6 downto 2),
	din=>in_cache,
	dout=>cashe_out
);


and_module: AND_MOD port map(
	valid=>in_cache(132),
	comp=>comp_sig,
	outand=>and_sig
);

comp_mod: compare port map(
	tag_cache=>in_cache(131 downto 128),
	tag_instr=>instr(10 downto 7),
	out_comp=>comp_sig
);


R1: regi port map(
	inregi=>mem_sig,
	wren=>w1,
	outregi=>reg_sig(31 downto 0),
	clk =>clk,
	Reset=>rst
);

R2: regi port map(
	inregi=>mem_sig,
	wren=>w2,
	outregi=>reg_sig(63 downto 32),
	clk =>clk,
	Reset=>rst
);

R3: regi port map(
	inregi=>mem_sig,
	wren=>w3,
	outregi=>reg_sig(95 downto 64),
	clk =>clk,
	Reset=>rst
);

R4: regi port map(
	inregi=>mem_sig,
	wren=>w4,
	outregi=>reg_sig(127 downto 96),
	clk =>clk,
	Reset=>rst
);

RvalidTag: Reg_tag port map(
	in_tag=>addr_mem_sig(10 downto 7),
	we=>w5,
	out_tag=>out_tag_s,
	clk =>clk,
	rst=>rst
);
fsm_mod: FSM port map(
	in_and=>and_sig,
	instr=>instr,
	clk=>clk,
	rst=>rst,
	WE_1=>w1,
	WE_2=>w2,
	WE_3=>w3,
	WE_4=>w4,
	WE_5=>w5,
	we=>we_sig,
	valid=>val_sig,
	out_fsm=>addr_mem_sig
);

muxC: mux_cache port map(
	A=>cashe_out(31 downto 0),
	B=>cashe_out(63 downto 32),
	C=>cashe_out(95 downto 64),
	D=>cashe_out(127 downto 96),
	mux_out=>out_cashe,
	select_mux=>instr(1 downto 0)
);


memory: DMEM port map(
	clk=>clk,
	we=>'0',
	addr=>addr_mem_sig,
	din=>Din_mem,
	dout=>mem_sig
);
in_cache<=val_sig&out_tag_s&reg_sig(127 downto 96)&reg_sig(95 downto 64)&reg_sig(63 downto 32)&reg_sig(31 downto 0);

end Behavioral;

