#project : axi_fpgaware_ver_id
#author  : siarhei baldzenka
#date    : 21.01.2026
#e-mail  : venera.electronica@gmail.com

add wave -noupdate -divider testbench
add wave -noupdate -format Logic -radix HEXADECIMAL -group {testbench} /axi_fpgaware_ver_id_tb/*

add wave -noupdate -divider uart_core
add wave -noupdate -format Logic -radix HEXADECIMAL -group {DUT} /axi_fpgaware_ver_id_tb/DUT_inst/*


TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1611 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps