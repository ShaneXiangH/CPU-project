onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib program_opt

do {wave.do}

view wave
view structure
view signals

do {program.udo}

run -all

quit -force
