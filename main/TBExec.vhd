
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;


entity TBExec is
end entity TBExec;

architecture behavior of TBExec is

    -- Instantiate the TestUnit
	 component TestUnit is
		  Generic ( N : natural := 64 );
			Port ( A, B : in std_logic_vector( N-1 downto 0 );
			FuncClass, LogicFN, ShiftFN : in std_logic_vector( 1 downto 0 );
			AddnSub, ExtWord : in std_logic := '0';
			Y : out std_logic_vector( N-1 downto 0 );
			Zero, AltB, AltBu : out std_logic );
    end component TestUnit;

    -- Signals to connect to the Adder instance
    signal A_tb, B_tb : std_logic_vector(63 downto 0); -- 64-bit input vectors
	 signal FuncClass_tb, LogicFN_tb, ShiftFN_tb : std_logic_vector(1 downto 0);
	 signal AddnSub_tb, ExtWord_tb : std_logic;
	 signal Y_tb, Y_exp : std_logic_vector(63 downto 0) := (others => '0');
	 signal Zero_tb, Zero_exp, AltB_tb, AltB_exp, AltBu_tb, AltBu_exp: std_logic;
	 
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
	 
	 -- Function to return the maximum of three time values
	function min_time(a, b, c : time) return time is
	begin
		 if a <= b and a <= c then
			  return a;
		 elsif b <= c and b <= a then
			  return b;
		 else
			  return c;
		 end if;
	end function;

begin
    -- Instantiate the Adder
	UUT: component TestUnit
		generic map(N => 64)
      port map (
            A => A_tb,
            B => B_tb,
            FuncClass => FuncClass_tb,
				LogicFn => LogicFn_tb,
				ShiftFn => ShiftFn_tb,
				AddnSub => AddnSub_tb,
				ExtWord => ExtWord_tb,
				Y => Y_tb,
				Zero => Zero_tb,
				AltB => AltB_tb,
				AltBu => AltBu_tb
     );

    -- Process to read stimulus from the .tvs file
    stimulus_process: process
        variable MeasurementIndex : integer := 1;  -- Variable to track the test vector index
        constant PRESTIMTIME : time := 20 ns;
        constant POSTSTIMTIME : time := 50 ns;
		  variable line_buffer : line;
		  variable bin_A, bin_B, Y_read : std_logic_vector(63 downto 0);
		  variable FuncClass_read, LogicFn_read, ShiftFn_read: std_logic_vector(1 downto 0); 
		  variable AddnSub_read, ExtWord_read, Zero_read, AltB_read, AltBu_read: std_logic;
		  variable v_SPACE : character;
		  variable StartTime, EndTime, PropDelay : time;
    begin
			file_open(file_VECTORS, "Exec00.tvs", read_mode);
			report "Now simulating" severity note;
        while not endfile(file_VECTORS) loop
		      A_tb <= (others => 'X');
            B_tb <= (others => 'X');
				FuncClass_tb <= (others => 'X');
				LogicFn_tb <= (others => 'X');
				ShiftFn_tb <= (others => 'X');
				AddnSub_tb <= 'X';
				ExtWord_tb <= 'X';
				wait for PRESTIMTIME;
            readline(file_VECTORS, line_buffer);
            -- Read inputs A and B from the file
            hread(line_buffer, bin_A);    -- Read binary for A
				read(line_buffer, v_SPACE);           -- read in the space character
            hread(line_buffer, bin_B);    -- Read binary for B
				read(line_buffer, v_SPACE); 
				read(line_buffer, FuncClass_read);
				read(line_buffer, v_SPACE); 
				read(line_buffer, LogicFn_read);
				read(line_buffer, v_SPACE); 
				read(line_buffer, ShiftFn_read);
				read(line_buffer, v_SPACE); 
				read(line_buffer, AddnSub_read);
				read(line_buffer, v_SPACE); 
				read(line_buffer, ExtWord_read);
            hread(line_buffer, Y_read);  -- Read expected sum
				read(line_buffer, v_SPACE); 
            read(line_buffer, Zero_read); -- Read expected Cout
				read(line_buffer, v_SPACE); 
            read(line_buffer, AltB_read);  -- Read expected Ovfl
				read(line_buffer, v_SPACE); 
            read(line_buffer, AltBu_read);
				
            -- Convert binary strings to std_logic_vectors
            A_tb <= bin_A;
				B_tb <= bin_b;
				FuncClass_tb <= FuncClass_read;
				LogicFN_tb <= LogicFN_read;
				ShiftFN_tb <= ShiftFN_read;
				AddnSub_tb <= AddnSub_read;
				ExtWord_tb <= ExtWord_read;
				Y_exp <= Y_read;
				Zero_exp <= Zero_read;
				AltB_exp <= AltB_read;
				AltBu_exp <= AltBu_read;
				
				StartTime := now;
				
				--give all signals ample time to stabilize
				wait until Y_tb'Stable(25 ns) and Y_tb'quiet(25ns);
				
				--end time is based on the signal that took longest
				--EndTime := min_time(S_tb'Last_Event, Cout_tb'Last_Event, Ovfl_tb'Last_Event);
				
				
				-- Calculate propagation delay
				
				
            wait for POSTSTIMTIME;
				EndTime := Y_tb'Last_Event;
				PropDelay := now - EndTime - StartTime;
				
            -- Report the results
            report "Test Vector # :" & integer'image(MeasurementIndex) severity note;
            report "Expected Y    : " & slv_to_string(Y_exp) severity note;
            report "Actual   Y    : " & slv_to_string(Y_tb) severity note;
				report "Y Propagation Delay: " & time'image(PropDelay) severity note;
				
				if AddnSub_tb = '1' then
					report "Expected Zero : " & std_logic'image(Zero_exp) severity note;
					report "Actual Zero   : " & std_logic'image(Zero_tb) severity note;
					report "Expected AltB : " & std_logic'image(AltB_exp) severity note;
					report "Actual AltB   : " & std_logic'image(AltB_tb) severity note;
					report "Expected AltBu: " & std_logic'image(AltBu_exp) severity note;
					report "Actual AltBu  : " & std_logic'image(AltBu_tb) severity note;
				end if;
				
				if AddnSub_tb = '0' then
					report "Expected Zero : X" severity note;
					report "Actual Zero   : " & std_logic'image(Zero_tb) severity note;
					report "Expected AltB : X" severity note;
					report "Actual AltB   : " & std_logic'image(AltB_tb) severity note;
					report "Expected AltBu: X" severity note;
					report "Actual AltBu  : " & std_logic'image(AltBu_tb) severity note;
				end if;

            -- Check for mismatches
            if Y_tb /= Y_exp then
                report "Mismatch in Y at Test Vector #" & integer'image(MeasurementIndex) severity failure;
            end if;
				
				--If AddnSub is '0', then the status signals are don't cares as they will not be generated from the adder
				if AddnSub_tb = '1' then
					if Zero_tb /= Zero_exp then
						 report "Mismatch in Zero at Test Vector #" & integer'image(MeasurementIndex) severity failure;
					end if;

					if AltB_tb /= AltB_exp then
						 report "Mismatch in AltB at Test Vector #" & integer'image(MeasurementIndex) severity failure;
					end if;
					
					if AltBu_tb /= AltBu_exp then
						 report "Mismatch in AltBu at Test Vector #" & integer'image(MeasurementIndex) severity failure;
					end if;
					
				end if;
				--separate test vectors for readability
				
				report "End of Test Vector # " & integer'image(MeasurementIndex) severity note;
				report "------------------------------------------------------------------------" severity note;
            -- Increment index
            MeasurementIndex := MeasurementIndex + 1;
        end loop;

        -- End the simulation
		  file_close(file_VECTORS);
		  report "All test vectors processed" severity note;
        wait;
    end process;

end architecture behavior;
