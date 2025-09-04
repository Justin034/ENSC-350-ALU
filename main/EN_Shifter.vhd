library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Entity EN_Shifter is
generic (N : natural := 64);
	port (A : in std_logic_vector(63 downto 0);
			B : in std_logic_vector(5 downto 0);
			SLLog, SRLog, SRAri: out std_logic_vector(63 downto 0)
			);
end Entity EN_Shifter;

Architecture Behaviour of EN_Shifter is
	
	--signals to hold shifted results
	signal SLL_output, SRL_output, SRA_output : std_logic_vector(63 downto 0);
	
begin
	
	--Instantiate all shifters
	SLL64: entity work.EN_SLL64
		port map(A => A, B => B, output => SLL_output);
		
	SRL64: entity work.EN_SRL64
		port map(A => A, B => B, output => SRL_output);
		
	SRA64: entity work.EN_SRA64
		port map(A => A, B => B, output => SRA_output);
	
	SLLog <= SLL_output;
	SRLog <= SRL_output;
	SRAri <= SRA_output;
	
	
end Behaviour;