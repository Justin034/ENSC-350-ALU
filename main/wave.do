onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Vector #}
add wave -noupdate /tbexec/stimulus_process/MeasurementIndex
add wave -noupdate -divider Operands
add wave -noupdate -radix hexadecimal /tbexec/A_tb
add wave -noupdate -radix hexadecimal /tbexec/B_tb
add wave -noupdate -divider {Control Signals}
add wave -noupdate /tbexec/FuncClass_tb
add wave -noupdate /tbexec/LogicFN_tb
add wave -noupdate /tbexec/ShiftFN_tb
add wave -noupdate /tbexec/AddnSub_tb
add wave -noupdate /tbexec/ExtWord_tb
add wave -noupdate -divider Outputs
add wave -noupdate -radix hexadecimal /tbexec/Y_tb
add wave -noupdate -radix hexadecimal /tbexec/Y_exp
add wave -noupdate -divider {Status Signals}
add wave -noupdate /tbexec/Zero_tb
add wave -noupdate /tbexec/Zero_exp
add wave -noupdate -radix hexadecimal /tbexec/AltB_tb
add wave -noupdate /tbexec/AltB_exp
add wave -noupdate /tbexec/AltBu_tb
add wave -noupdate /tbexec/AltBu_exp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {78600 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 103
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {229 ns}
