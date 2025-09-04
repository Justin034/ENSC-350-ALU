# End any running simulation
quit -sim

# Set the filename for the transcript file
transcript file ExUTimeTranscript.txt

# Compile the source code in the correct order
vcom -work work -2008 -explicit -stats=none ../SourceCode/ExecUnit.vhd
vcom -work work -2008 -explicit -stats=none ../SourceCode/EN_SLL64.vhd
vcom -work work -2008 -explicit -stats=none ../SourceCode/EN_SRL64.vhd
vcom -work work -2008 -explicit -stats=none ../SourceCode/EN_SRA64.vhd
vcom -work work -2008 -explicit -stats=none ../SourceCode/EN_Shifter.vhd
vcom -work work -2008 -explicit -stats=none ../SourceCode/EN_Adder.vhd
vcom -work work -2008 -explicit -stats=none TBExec.vhd
vcom -work work -2008 -explicit -stats=none ./modelsim/FP_cyclone4.vho
vcom -work work -2008 -explicit -stats=none ../SourceCode/ExecConfig.vhd

# Start the simulation with logging to the transcript
vsim -t 100ps -gui -sdftyp /UUT=modelsim/FP_cyclone4_vhd.sdo work.Config_timing

# Setup the wave window using a separate script
do wave.do

# Turn on the wave view
view wave

# Turn on the transcription
transcript on

# Restart the simulation
restart -force

# Run the simulation
run -all

# Turn off the transcription
transcript off

# Set the transcript filename to an empty string to stop further messages
transcript file ""