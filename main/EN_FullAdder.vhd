library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


--A full adder to use in the ripple architecture
entity EN_FullAdder is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Cin : in  STD_LOGIC;
           Sum : out  STD_LOGIC;
           Cout : out  STD_LOGIC);
end EN_FullAdder;

architecture Behavioral of EN_FullAdder is
begin
    Sum <= A xor B xor Cin;
    Cout <= (A and B) or (Cin and (A xor B));
end Behavioral;