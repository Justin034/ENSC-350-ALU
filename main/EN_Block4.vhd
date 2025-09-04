library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EN_Block4 is
    generic (N : natural := 4);  -- Added a generic for N
    port (
        gen, prop: in std_logic_vector(N-1 downto 0);
        outG, outP: out std_logic_vector(N-1 downto 0)
    );
end entity EN_Block4;

architecture behaviour of EN_Block4 is
begin
    -- Calculate outG and outP for index 0
    outG(0) <= gen(0);
    outP(0) <= prop(0);

    -- Calculate outG and outP for index 1
    outG(1) <= (gen(0) and prop(1)) or gen(1);
    outP(1) <= prop(0) and prop(1);

    -- Calculate outG and outP for index 2
    outG(2) <= (gen(0) and prop(1) and prop(2)) or (gen(1) and prop(2)) or gen(2);
    outP(2) <= prop(0) and prop(1) and prop(2);

    -- Calculate outG and outP for index 3
    outG(3) <= (gen(0) and prop(1) and prop(2) and prop(3)) or 
                 (gen(1) and prop(2) and prop(3)) or 
                 (gen(2) and prop(3)) or gen(3);
    outP(3) <= prop(0) and prop(1) and prop(2) and prop(3);
    
end architecture behaviour;