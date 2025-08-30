library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EN_Ladner is
    generic ( N : natural := 64 );
    port (
        G, P: in std_logic_vector(N-1 downto 0);
        placeG, placeP: buffer std_logic_vector(N-1 downto 0)
    );
end entity EN_Ladner;

architecture Implement of EN_Ladner is
    signal arrG, arrP: std_logic_vector(N/2-1 downto 0);
begin

    -- Recursive case for N > 4
    recurse: if N > 4 generate
        
        -- Upper half instantiation of Ladner
        upper: entity work.EN_Ladner 
            generic map (N => (N+1)/2)
            port map (
                G => G(N-1 downto N/2), 
                P => P(N-1 downto N/2), 
                placeG => arrG, 
                placeP => arrP
            );

        -- Lower half instantiation of Ladner
        lower: entity work.EN_Ladner 
            generic map (N => N/2)
            port map (
                G => G(N/2-1 downto 0), 
                P => P(N/2-1 downto 0), 
                placeG => placeG(N/2-1 downto 0), 
                placeP => placeP(N/2-1 downto 0)
            );

        -- Generate logic for merging results
        gen_merge: for i in 0 to N/2-1 generate
            placeG(N/2 + i) <= (arrP(i) AND placeG(N/2-1)) OR arrG(i);
            placeP(N/2 + i) <= arrP(i) AND placeP(N/2-1);
        end generate gen_merge;

    end generate recurse;

    -- Base case for N = 4
    moment: if N = 4 generate
        bubble: entity work.EN_Block4 -- Look ahead 4 bit
            port map (
                gen => G, 
                prop => P, 
                outG => placeG, 
                outP => placeP
            );
    end generate moment;

end architecture Implement;