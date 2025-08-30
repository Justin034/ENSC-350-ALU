library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EN_FA4 is
Port( X: in std_logic_vector(3 downto 0);
		Y: in std_logic_vector(3 downto 0);
		Z: out std_logic_vector(3 downto 0);
		--Cout: out std_logic;
		carry: out std_logic_vector(3 downto 0));
end entity EN_FA4;

architecture LA0 of EN_FA4 is
	signal G,P: std_logic_vector(3 downto 0);
	signal carries: std_logic_vector(3 downto 0);
begin
	
	GenProp: for i in 0 to 3 generate
		G(i) <= X(i) AND Y(i);
		P(i) <= X(i) XOR Y(i);
	end generate GenProp;
	

	carries(0) <= G(0);
	carries(1) <= G(1) OR (G(0) AND P(1));
	carries(2) <= G(2) OR (G(1) AND P(2)) OR (G(0) AND P(1) AND P(2));
	carries(3) <= G(3) OR (G(2) AND P(3)) OR (G(1) AND P(2) AND P(3)) OR (G(0) AND P(1) AND P(2) AND P(3));
	
	Z(0) <= P(0) XOR '0';
	genSum: for i in 1 to 3 generate
		Z(i) <= P(i) XOR carries(i-1);
	end generate genSum;
	
	carry <= carries;
	
end architecture LA0;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

architecture LA1 of EN_FA4 is
	signal G,P: std_logic_vector(3 downto 0);
	signal carries: std_logic_vector(3 downto 0);
	signal G3: std_logic;
begin
	
	GenProp: for i in 0 to 3 generate
		G(i) <= X(i) AND Y(i);
		P(i) <= X(i) XOR Y(i);
	end generate GenProp;
	G3 <= G(3) OR (G(2) AND P(3)) OR (G(1) AND P(2) AND P(3)) OR (G(0) AND P(1) AND P(2) AND P(3));
	

	carries(0) <= G(0) OR P(0);
	carries(1) <= G(1) OR (G(0) AND P(1)) OR (P(0) AND P(1));
	carries(2) <= G(2) OR (G(1) AND P(2)) OR (G(0) AND P(1) AND P(2)) OR (P(0) AND P(1) AND P(2));
	carries(3) <= G3 OR (P(0) AND P(1) AND P(2) AND P(3));
	
	Z(0) <= P(0) XOR '1';
	genSum: for i in 1 to 3 generate
		Z(i) <= P(i) XOR carries(i-1);
	end generate genSum;

	carry <= carries;
	
end architecture LA1;
	
	
	
	
	