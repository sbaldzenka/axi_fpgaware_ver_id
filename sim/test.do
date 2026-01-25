#project : axi_fpgaware_ver_id
#author  : siarhei baldzenka
#date    : 21.01.2026
#e-mail  : venera.electronica@gmail.com

vlib work
vmap work work

vlog ../tb/axi_fpgaware_ver_id_tb.v
vlog ../src/axi_fpgaware_ver_id.v

vsim -t 1ps -voptargs=+acc=lprn -lib work axi_fpgaware_ver_id_tb

do wave_test.do 
view wave
run 2 us