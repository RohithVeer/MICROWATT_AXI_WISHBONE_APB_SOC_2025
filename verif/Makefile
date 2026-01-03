# ============================
# Cocotb Simulation Makefile
# ============================

SIM ?= icarus
TOPLEVEL_LANG ?= verilog
TOPLEVEL ?= soc_top
MODULE ?= test_soc_smoke_extended

VERIF_DIR := $(CURDIR)
ROOT_DIR  := $(VERIF_DIR)/..

export PYTHONPATH := $(VERIF_DIR)/tb:$(PYTHONPATH)

# ----------------------------
# RTL sources (by TOPLEVEL)
# ----------------------------
ifeq ($(TOPLEVEL),soc_top)
VERILOG_SOURCES := \
  $(VERIF_DIR)/sram_blackbox.v \
  $(ROOT_DIR)/rtl/axi/axi_lite_to_wishbone.sv \
  $(ROOT_DIR)/rtl/wishbone/wb_to_apb.sv \
  $(ROOT_DIR)/rtl/wishbone/wishbone_interconnect.sv \
  $(ROOT_DIR)/rtl/sram/sram_wrapper.v \
  $(ROOT_DIR)/rtl/top/vcd_force.v \
  $(ROOT_DIR)/rtl/top/soc_top.sv
endif

ifeq ($(TOPLEVEL),wb_to_apb)
VERILOG_SOURCES := \
  $(ROOT_DIR)/rtl/wishbone/wb_to_apb.sv
endif

# ----------------------------
# Default targets that NEVER require cocotb
# ----------------------------
.PHONY: clean list

clean:
	rm -rf sim_build results.xml

list:
	@echo "Available test python files (verif/tb):"
	@ls -1 $(VERIF_DIR)/tb/test_*.py 2>/dev/null || true

# ----------------------------
# Simulation target (CI SAFE)
# ----------------------------
.PHONY: sim

sim:
	@echo "Running RTL cocotb simulation"
	@python3 -m cocotb.config --makefiles >/dev/null
	$(MAKE) -f $(shell python3 -m cocotb.config --makefiles)/Makefile.sim \
		SIM=$(SIM) \
		TOPLEVEL_LANG=$(TOPLEVEL_LANG) \
		TOPLEVEL=$(TOPLEVEL) \
		MODULE=$(MODULE) \
		VERILOG_SOURCES="$(VERILOG_SOURCES)"

