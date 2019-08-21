onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+program -L blk_mem_gen_v8_4_1 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.program xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {program.udo}

run -all

endsim

quit -force
