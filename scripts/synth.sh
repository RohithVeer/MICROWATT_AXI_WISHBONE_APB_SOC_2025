set -e

export PDKROOT="$HOME/pdks/sky130A"
export STD_CELL_LEF="$PDKROOT/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef"
export LIB_SYN="$PDKROOT/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"

TOP="soc_top"
RTL_DIR="./rtl"
OUT_DIR="./build/synth"
mkdir -p "$OUT_DIR"

yosys -c <<EOF
read_verilog $RTL_DIR/**/*.v
synth -top $TOP
dfflibmap -liberty $LIB_SYN
abc -liberty $LIB_SYN
write_json $OUT_DIR/$TOP.json
write_verilog $OUT_DIR/$TOP.synth.v


