library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Entity ExecUnit is
Generic ( N : natural := 64 );
Port ( A, B : in std_logic_vector( N-1 downto 0 );
		FuncClass, LogicFN, ShiftFN : in std_logic_vector( 1 downto 0 );
		AddnSub, ExtWord : in std_logic := '0';
		Y : out std_logic_vector( N-1 downto 0 );
		Zero, AltB, AltBu : out std_logic );
End Entity ExecUnit;

Architecture behaviour of ExecUnit is
--temp signals to be funneled to output
	signal SRLog, SRAri, SLLog,  Y0, Y1, Y2, Y3, Y4, Log, Y0Ext, Y2Ext, Ain: std_logic_vector(63 downto 0);
	signal tempB : std_logic_vector(63 downto 0);
	signal Cin, Cout, Ovfl : std_logic;
	signal Sum : std_logic_vector(63 downto 0);
	signal rightWord: std_logic;
	signal AltB_calc, AltBU_calc: std_logic;
	signal check: std_logic_vector(63 downto 0);
	signal inter: std_logic_vector(5 downto 0);
	

begin 

--complement b if subtracting
tempB <= not(B) when AddnSub = '1' else B;

--calculate arith output
Add: entity work.EN_Adder
		generic map(N => N)
		port map(A => A, B => tempB, S => Sum, Cin => AddnSub, Cout => Cout, Ovfl => Ovfl);
--------------------------------

	--swap word if needed
	rightWord <= ShiftFn(1) and ExtWord;

	Ain(63 downto 32) <= A(31 downto 0) when rightWord = '1' else A(63 downto 32);
	Ain(31 downto 0) <= A(63 downto 32) when rightWord = '1' else A(31 downto 0);
	
	inter <= (B(5) and not(ExtWord)) & B(4 downto 0);
	
--calculate shift outputs
Shift: entity work.EN_Shifter
	  port map (A => Ain, B => inter, SRLog => SRLog, SRAri => SRAri, SLLog => SLLog);
		  
--calculate logic outputs
Logic: entity work.EN_Logic
	  generic map(N => N)
	  port map (A => A, B => B, LogicFN => LogicFN, Y => Log);
	  
	  
	  -- MUX train Adder and SLL
	  Y0 <= Sum when ShiftFn(0) = '0' else SLLog;
	  
	  --sign extended intermediate output
	  Y0Ext(63 downto 32) <= (63 downto 32 => Y0(31));
	  Y0Ext(31 downto 0) <= Y0(31 downto 0);
	  
	  --extend word if needed
	  Y1 <= Y0 when ExtWord = '0' else Y0Ext;
	  
	  
	  -- SRL or SRA
	  Y2 <= SRLog when ShiftFn(0) = '0' else SRAri;
	  
	  --sign extended intermediate output
	  Y2Ext(31 downto 0) <= Y2(63 downto 32);
	  Y2Ext(63 downto 32) <= (63 downto 32 => Y2(63));
	  
	  --extend word if needed
	  Y3 <= Y2 when ExtWord = '0' else Y2Ext;
	  
	  --Input to final MUX
	  Y4 <= Y1 when ShiftFn(1) = '0' else Y3;
		
		--status calculations
	  AltB_calc <=  Ovfl xor Sum(63); 
	  AltB <= AltB_calc;
	  AltBU_calc <= not(Cout);
	  AltBu <= AltBU_calc;
	  
	  check <= (others => '0');
	  Zero <= '1' when Sum = check else '0';
	  
	  --Final output MUX
	  with FuncClass select
		  Y <= (N-1 downto 1 => '0') & AltBU_calc when "11",
				 (N-1 downto 1 => '0') & AltB_calc when "10",
				 Log when "01",
				 Y4 when others;
		  
end Architecture behaviour;