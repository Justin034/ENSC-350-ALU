library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Entity EN_SLL64 is
port (A : in std_logic_vector(63 downto 0);
B : in std_logic_vector(5 downto 0);
output : out std_logic_vector(63 downto 0)
);
end Entity EN_SLL64;

Architecture Behaviour of EN_SLL64 is
--signals to hold intermediate results and shift amounts
signal L, M, S : std_logic_vector(1 downto 0);
signal SLL0, SLL1, SLL2 : std_logic_vector(63 downto 0);

begin

	L <= B(5) & B(4);
	M <= B(3) & B(2);
	S <= B(1) & B(0);

	--Shift based on B(5) and B(4)
	with L select 
	SLL0 <= (A(15 downto 0) & (63 downto 16 => '0')) when "11",-- 48 left
	  (A(31 downto 0) & (63 downto 32 => '0')) when "10",-- 32 left
	  (A(47 downto 0) & (63 downto 48 => '0')) when "01", -- 16 left
	  A when others;

	--Shift based on B(3) and B(2)
	with M select 
	SLL1 <= (SLL0(51 downto 0) & (63 downto 52 => '0')) when "11", -- 12 left
	  (SLL0(55 downto 0) & (63 downto 56 => '0')) when "10", -- 8 left
	  (SLL0(59 downto 0) & (63 downto 60 => '0')) when "01", -- 4 left
	  SLL0 when others;

	--Shift based on B(1) and B(0)
	with S select 
	output <= (SLL1(60 downto 0) & (63 downto 61 => '0')) when "11", -- 3 left
	  (SLL1(61 downto 0) & (63 downto 62 => '0')) when "10", -- 2 left
	  (SLL1(62 downto 0) & (63 => '0')) when "01", -- 1 left
	  SLL1 when others;
	  
	end Architecture Behaviour;