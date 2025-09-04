library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Entity declaration
entity Adder is
    generic ( N : natural := 64 );
    port (
        A, B : in std_logic_vector(N-1 downto 0);
        S : out std_logic_vector(N-1 downto 0);
        Cin : in std_logic;
        Cout, Ovfl : out std_logic
    );
end entity Adder;

--Carry select architecture
architecture CSA of Adder is
	signal carries0, carries1, carries: std_logic_vector(N downto 0); --a vector of carries for components assuming 0, assuming 1, and real carries
	signal sum0, sum1: std_logic_vector(N-1 downto 0); --a vector of sums for components assuming 0, assuming 1,
	signal G,P: std_logic_vector(3 downto 0); --for generate and propagate signals
	signal G30: std_logic;							--intermediate G[3..0] to avoid wide gates
begin

	carries(0) <= Cin;
	
	--Process the very first batch of 4 bits as a normal full adder
	
	--get generate propagate signals
	GP: for i in 0 to 3 generate
		G(i) <= A(i) AND B(i);
		P(i) <= A(i) XOR B(i);
	end generate GP;
	
	--calculating initial carries
	G30 <= G(3) OR (G(2) AND P(3)) OR (G(1) AND P(2) AND P(3)) OR (G(0) AND P(1) AND P(2) AND P(3));
	
	carries(1) <= G(0) OR (P(0) AND carries(0));
	carries(2) <= G(1) OR (G(0) AND P(1)) OR (P(0) AND P(1) AND carries(0));
	carries(3) <= G(2) OR (G(1) AND P(2)) OR (G(0) AND P(1) AND P(2)) OR (P(0) AND P(1) AND P(2) AND carries(0));
	carries(4) <= G30 OR ((P(0) AND P(1) AND P(2) AND P(3)) AND carries(0));
	
	--Initial sums
	initial: for i in 0 to 3 generate
		S(i) <= P(i) XOR carries(i);
	end generate initial;
	
	
	--generating all pairs of FAs
	CSA: for i in 1 to N/4-1 generate
		
		--The FA assuming input carry = 0
		CSA0: entity work.EN_FA4(LA0) port map
			(X => A(i*4 +3 downto i*4),
			 Y => B(i*4+3 downto i*4),
			 Z => sum0(i*4+3 downto i*4),
			 carry => carries0(i*4+4 downto i*4+1));
			 
		--The FA assuming input carry = 1
		CSA1: entity work.EN_FA4(LA1) port map
			(X => A(i*4 +3 downto i*4),
			 Y => B(i*4+3 downto i*4),
			 Z => sum1(i*4+3 downto i*4),
			 carry => carries1(i*4+4 downto i*4+1));
		

		--based on the previous carry, choose the output of either CSA0 or CSA1 
		carries(i*4+4 downto i*4+1) <= carries0(i*4+4 downto i*4+1) when carries(i*4) = '0' else carries1(i*4+4 downto i*4+1);
		
		S(i*4+3 downto i*4) <= sum0(i*4+3 downto i*4) when carries(i*4) = '0' else sum1(i*4+3 downto i*4);
	end generate CSA;
	

	--final assignment of ovfl and cout
	Ovfl <= carries(N) XOR carries(N-1);
	Cout <= carries(N);
		
end architecture CSA;
		
architecture ripple of Adder is
	signal carries: std_logic_vector(N downto 0);
begin
	
	--initial carry cin
	carries(0) <= Cin;
	
	--generate full adders for the carries to ripple through
	chain: for i in 0 to N-1 generate
		FA: entity work.EN_FullAdder
			port map(
			A => A(i),
			B => B(i),
			Cin => carries(i),
			Sum => S(i),
			Cout => carries(i+1)
			);
	end generate chain;
	
	--final assignment of ovfl and cout
	Cout <= carries(N);
	Ovfl <= carries(N) XOR carries(N-1);
	
end architecture ripple;		
		
architecture LadnerFischer of Adder is
    signal placeG, placeP, G, P : std_logic_vector(N-1 downto 0);
    signal carries : std_logic_vector(N downto 0);
begin
    -- Generate propagate and generate signals
    G <= A AND B;
    P <= A XOR B;

    -- Instance of an entity 'ActAdder' to calculate block generate and propagate signals
    ActAdder_inst: entity work.EN_Ladner
        generic map (N => N)
        port map (G => G, P => P, placeG => placeG, placeP => placeP);

    -- Calculate carries
    carries(0) <= Cin;
    gen_carry: for i in 0 to N-1 generate
        carries(i+1) <= placeG(i) OR (placeP(i) AND carries(i));
    end generate gen_carry;

    -- Calculate sums
    gen_sum: for i in 0 to N-1 generate
        S(i) <= carries(i) XOR P(i);
    end generate gen_sum;

    -- Calculate Cout and overflow
    Cout <= carries(N);
    Ovfl <= carries(N) XOR carries(N-1);
end architecture LadnerFischer;
		
			 