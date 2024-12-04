ghdl -a --std=08 dsd_prj_pkg.vhdl
ghdl -a --std=08 mandelbrot.vhdl
ghdl -a --std=08 mandelbrot_tb.vhdl
ghdl -e --std=08 mandelbrot_tb
ghdl -r --std=08 mandelbrot_tb