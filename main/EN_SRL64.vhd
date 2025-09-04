library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Entity EN_SRL64 is
    port (A : in std_logic_vector(63 downto 0);
            B : in std_logic_vector(5 downto 0);
            output : out std_logic_vector(63 downto 0)
            );
end Entity EN_SRL64;

Architecture Behaviour of EN_SRL64 is
	 --signals to hold intermediate results and shift amounts
    signal L, M, S : std_logic_vector(1 downto 0);
    signal SRL0, SRL1, SRL2 : std_logic_vector(63 downto 0);

begin

    L <= B(5) & B(4);
    M <= B(3) & B(2);
    S <= B(1) & B(0);
	
	--Shift based on B(5) and B(4)
    with L select 
        SRL0 <= (63 downto 16 => '0') & A(63 downto 48) when "11",    -- 48 right
                  (63 downto 32 => '0') & A(63 downto 32) when "10",    -- 32 right
                  (63 downto 48 => '0') & A(63 downto 16) when "01", -- 16 right
                  A when others;
	 --Shift based on B(3) and B(2)
    with M select 
        SRL1 <= (63 downto 52 => '0') & SRL0(63 downto 12) when "11", -- 12 right
                  (63 downto 56 => '0') & SRL0(63 downto 8) when "10", -- 8 right
                  (63 downto 60 => '0') & SRL0(63 downto 4) when "01", -- 4 right
                  SRL0 when others;
	 --Shift based on B(1) and B(0)
    with S select 
        output <= (63 downto 61 => '0') & SRL1(63 downto 3) when "11", -- 3 right
                  (63 downto 62 => '0') & SRL1(63 downto 2) when "10", -- 2 right
                  (63 => '0') & SRL1(63 downto 1) when "01", -- 1 right
                  SRL1 when others;

end Architecture Behaviour;