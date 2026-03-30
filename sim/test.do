-- project     : axi_fpgaware_ver_id
-- date        : 21.01.2026
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/axi_fpgaware_ver_id

vlib work
vmap work work

vlog ../tb/axi_fpgaware_ver_id_tb.v
vlog ../src/axi_fpgaware_ver_id.v

vsim -t 1ps -voptargs=+acc=lprn -lib work axi_fpgaware_ver_id_tb

do wave_test.do
view wave
run 2 us