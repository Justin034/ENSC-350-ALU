configuration Config_functional of TBExec is
    for behavior
        for UUT: TestUnit use entity work.ExecUnit(behaviour);  
		end for;
	 end for;
end configuration Config_functional;

configuration Config_timing of TBExec is
    for behavior
        for UUT: TestUnit use entity work.ExecUnit(structure);  
		end for;
	 end for;
end configuration Config_timing;

configuration Config_functional_ArriaII of TBExec is
    for behavior
        for UUT: TestUnit use entity work.ExecUnit(ArriaII_structure);  
		end for;
	 end for;
end configuration Config_functional_ArriaII;

configuration Config_timing_ArriaII of TBExec is
    for behavior
        for UUT: TestUnit use entity work.ExecUnit(ArriaII_structure);  
		end for;
	 end for;
end configuration Config_timing_ArriaII;