# ============================
# Cocotb Simulation Makefile
# ============================

SIM ?= icarus
TOPLEVEL_LANG ?= verilog
TOPLEVEL ?= soc_top
COCOTB_TEST_MODULES ?= test_apb

VERIF_DIR := $(CURDIR)
ROOT_DIR  := $(VERIF_DIR)/..

export PYTHONPATH := $(VERIF_DIR)/tb:$(PYTHONPATH)
# ----------------------------
# RTL sources (by TOPLEVEL)
# ----------------------------

ifeq ($(TOPLEVEL),soc_top)
  VERILOG_SOURCES := \
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
# Cocotb Makefile include
# ----------------------------
include $(shell cocotb-config --makefiles)/Makefile.sim

# ----------------------------
# Helpers
# ----------------------------
.PHONY: list
list:
	@echo "Available test python files (verif/tb):"
	@ls -1 $(VERIF_DIR)/tb/test_*.py 2>/dev/null || true

