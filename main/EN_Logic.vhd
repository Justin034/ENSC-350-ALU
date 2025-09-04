library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Entity EN_Logic is
	generic (N : natural := 64);
	port (A, B: in std_logic_vector(63 downto 0);
			LogicFN: in std_logic_vector(1 downto 0);
			Y: out std_logic_vector(63 downto 0)
			);
end Entity EN_Logic;

Architecture Behaviour of EN_Logic is 

	signal LUI: std_logic_vector(63 downto 0) := (others => '0');

begin

--what is the condition for LUI

	LUI <= (63 downto 32 => B(31)) & B(31 downto 12) & (11 downto 0=> '0'); 
	
	--MUX output based on LogicFN
	Y <= LUI when LogicFN = "00" else
		  (A xor B) when LogicFN = "01" else 
		  (A or B) when LogicFN = "10" else
		  (A and B);
		  
end architecture Behaviour;