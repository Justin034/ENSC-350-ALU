
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity TBCSA is
end entity TBCSA;

architecture behavior of TBCSA is
    -- Signals to connect to the Adder instance
    signal A_tb, B_tb : std_logic_vector(63 downto 0); -- 64-bit input vectors
    signal S_tb, expectedSum : std_logic_vector(63 downto 0);       -- Output sum
    signal Cin_tb : std_logic;                          -- Carry input
    signal Cout_tb, Ovfl_tb, expectedCout, expectedOvfl: std_logic;               -- Carry output and overflow
	 file file_VECTORS : text;
		
    -- File handling variables
   -- file stimulus_file : text is "adder_stimulus.tvs";

    -- Function to convert std_logic_vector to string for reporting
    function slv_to_string(slv: std_logic_vector) return string is
        variable result: string(1 to slv'length);
    begin
        for i in slv'range loop
            result(i + 1) := character'VALUE(std_ulogic'IMAGE(slv(i)));
        end loop;
        return result;
    end function;

begin
    -- Instantiate the Adder
    UUT: entity work.Adder(CSA)
        generic map (N => 64)
        port map (
            A => A_tb,
            B => B_tb,
            S => S_tb,
            Cin => Cin_tb,
            Cout => Cout_tb,
            Ovfl => Ovfl_tb
        );

    -- Process to read stimulus from the .tvs file
    stimulus_process: process
        variable MeasurementIndex : integer := 1;  -- Variable to track the test vector index
        constant PRESTIMTIME : time := 1 ns;
        constant POSTSTIMTIME : time := 10 ns;
		  variable line_buffer : line;
		  variable bin_A, bin_B, expected_sum : std_logic_vector(63 downto 0);
		  variable bin_Cin: std_logic;
		  variable expected_Cout : std_logic;
		  variable expected_Ovfl : std_logic;
		  variable v_SPACE : character;
    begin
	 
			file_open(file_VECTORS, "Adder00.tvs", read_mode);
			report "Now simulating carry select adder" severity note;
        while not endfile(file_VECTORS) loop
		      A_tb <= (others => 'X');
            B_tb <= (others => 'X');
				Cin_tb <='X';
				wait for PRESTIMTIME;
            readline(file_VECTORS, line_buffer);
            -- Read inputs A and B from the file
            hread(line_buffer, bin_A);    -- Read binary for A
				read(line_buffer, v_SPACE);           -- read in the space character
            hread(line_buffer, bin_B);    -- Read binary for B
				read(line_buffer, v_SPACE); 
            read(line_buffer,bin_Cin);    -- Read carry-in
				read(line_buffer, v_SPACE); 
            hread(line_buffer, expected_sum);  -- Read expected sum
				read(line_buffer, v_SPACE); 
            read(line_buffer, expected_Cout); -- Read expected Cout
				read(line_buffer, v_SPACE); 
            read(line_buffer, expected_Ovfl);  -- Read expected Ovfl

            -- Convert binary strings to std_logic_vectors
            A_tb <= bin_A;
				B_tb <= bin_b;
				Cin_tb <= bin_Cin;
				expectedSum <= expected_sum;
				expectedCout <= expected_Cout;
				expectedOvfl <= expected_Ovfl;

            wait for POSTSTIMTIME;

            -- Report the results
            report "Test Vector #:" & integer'image(MeasurementIndex) severity note;
            report "Expected Sum : " & slv_to_string(expectedSum) severity note;
            report "Actual Sum   : " & slv_to_string(S_tb) severity note;
            report "Expected Cout: " & std_logic'image(expectedCout) severity note;
            report "Actual Cout  : " & std_logic'image(Cout_tb) severity note;
            report "Expected Ovfl: " & std_logic'image(expectedOvfl) severity note;
            report "Actual Ovfl  : " & std_logic'image(Ovfl_tb) severity note;

            -- Check for mismatches
            if S_tb /= expectedSum then
                report "Mismatch in Sum at Test Vector #" & integer'image(MeasurementIndex) severity error;
            end if;

            if Cout_tb /= expectedCout then
                report "Mismatch in Cout at Test Vector #" & integer'image(MeasurementIndex) severity error;
            end if;

            if Ovfl_tb /= expectedOvfl then
                report "Mismatch in Ovfl at Test Vector #" & integer'image(MeasurementIndex) severity error;
            end if;

            -- Increment index
            MeasurementIndex := MeasurementIndex + 1;
        end loop;

        -- End the simulation
		  file_close(file_VECTORS);
		  report "All test vectors processed" severity note;
        wait;
    end process;

end architecture behavior;
