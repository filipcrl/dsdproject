ghdl -a --std=08 dsd_prj_pkg.vhdl
ghdl -a --std=08 pong_fsm.vhdl
ghdl -a --std=08 debug_tb.vhdl
ghdl -e --std=08 test_bench
ghdl -r --std=08 test_bench