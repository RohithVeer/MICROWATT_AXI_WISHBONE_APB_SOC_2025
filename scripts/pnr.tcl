set ::env(PDK_ROOT) "$env(PDKROOT)"
set ::env(STD_CELL_LEF) "$env(PDKROOT)/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef"
set ::env(TECH_LEF)     "$env(PDKROOT)/libs.tech/sky130A/lef/sky130A.tech.lef"

set design soc_top
set netlist build/synth/${design}.synth.v

read_lef $::env(TECH_LEF)
read_lef $::env(STD_CELL_LEF)
read_verilog $netlist
link_design $design

initialize_floorplan -utilization 50

place_design
cts
route_design

write_def build/pnr/${design}.def
write_gds build/pnr/${design}.gds
exit

