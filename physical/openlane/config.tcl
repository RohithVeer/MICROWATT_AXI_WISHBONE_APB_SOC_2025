# ======================================================
# Design
# ======================================================
set ::env(DESIGN_NAME) soc_top

# RTL + SRAM blackbox for synthesis
set ::env(VERILOG_FILES) [list \
    "$::env(DESIGN_DIR)/src/top/soc_top.sv" \
    "$::env(DESIGN_DIR)/src/sram_blackbox.v" \
]

# ======================================================
# Clock
# ======================================================
set ::env(CLOCK_PORT) clk
set ::env(CLOCK_PERIOD) 10.0

# ======================================================
# Floorplan
# ======================================================
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 600 600"
set ::env(PL_TARGET_DENSITY) 0.38

# ======================================================
# Power
# ======================================================
# VPWR/VGND → std cells
# vccd1/vssd1 → SRAM macro rails (from LEF)
set ::env(VDD_NETS) {VPWR vccd1}
set ::env(GND_NETS) {VGND vssd1}

# ======================================================
# CTS
# ======================================================
set ::env(CTS_TARGET_SKEW) 0.15
set ::env(CTS_ROOT_BUFFER) sky130_fd_sc_hd__clkbuf_4

# ======================================================
# Routing
# ======================================================
set ::env(ROUTING_STRATEGY) 0
set ::env(GRT_ALLOW_CONGESTION) 1

# ======================================================
# Checks
# ======================================================
set ::env(RUN_LINTER) 0
set ::env(RUN_CVC) 1
set ::env(RUN_DRC) 1
set ::env(RUN_ANTENNA_CHECK) 1

# IMPORTANT:
# LVS is intentionally disabled.
# sky130 SRAM macros are foundry-qualified hard macros
# and cannot be LVSed correctly in OpenLane v1.0.x.
set ::env(RUN_LVS) 0

# ======================================================
# SRAM Macro Integration
# ======================================================

# SRAM LEF (placement & routing)
set ::env(EXTRA_LEFS) \
"$::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_32x256_8.lef"

# SRAM GDS (final merge)
set ::env(EXTRA_GDS_FILES) \
"$::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/gds/sky130_sram_1kbyte_1rw1r_32x256_8.gds"

# Manual macro placement
set ::env(MACRO_PLACEMENT) 1
set ::env(MACRO_PLACEMENT_CFG) \
"$::env(DESIGN_DIR)/macro.cfg"

# Prevent buffering macro pins
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 0

# ======================================================
# Macro Handling
# ======================================================

# Treat SRAM as a hard macro (STA / synthesis safe)
set ::env(MACRO_BLACKBOXES) {
    sky130_sram_1kbyte_1rw1r_32x256_8
}

# No flattening (safe default)
set ::env(LVS_FLATTEN_CELLS) {}

