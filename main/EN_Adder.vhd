library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Entity declaration
entity EN_Adder is
    generic ( N : natural := 64 );
    port (
        A, B : in std_logic_vector(N-1 downto 0);
        S : out std_logic_vector(N-1 downto 0);
        Cin : in std_logic;
        Cout, Ovfl : out std_logic
    );
end entity EN_Adder;

architecture ripple of EN_Adder is
	signal A_unsigned, B_unsigned : UNSIGNED(N downto 0);
    signal Result : UNSIGNED(N downto 0); -- One extra bit for carry
begin

    -- Convert inputs to unsigned
    A_unsigned(N-1 downto 0) <= UNSIGNED(A);
    B_unsigned(N-1 downto 0) <= UNSIGNED(B);
	 A_unsigned(N) <= '0';
    B_unsigned(N) <= '0';

    -- Perform addition
    Result <= A_unsigned + B_unsigned + (0 => Cin);

    -- Map the sum output
    S <= STD_LOGIC_VECTOR(Result(N-1 downto 0));

    -- Calculate Carry-Out
    Cout <= Result(N);

    -- Calculate Overflow for signed addition
    Ovfl <= (A(N-1) AND B(N-1) AND NOT Result(N-1)) OR (NOT A(N-1) AND NOT B(N-1) AND Result(N-1));
	
end architecture ripple;

