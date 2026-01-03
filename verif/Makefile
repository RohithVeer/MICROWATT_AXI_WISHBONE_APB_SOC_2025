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
# Cocotb Makefile include
# ----------------------------
COCOTB_MAKEFILES := $(shell python3 -m cocotb.config --makefiles)
include $(COCOTB_MAKEFILES)/Makefile.sim


# ----------------------------
# Helpers
# ----------------------------
.PHONY: list
list:
	@echo "Available test python files (verif/tb):"
	@ls -1 $(VERIF_DIR)/tb/test_*.py 2>/dev/null || true
# ----------------------------
# Post-RTL (Gate-level) sim
# ----------------------------
.PHONY: post_rtl clean_post_rtl

post_rtl:
	$(MAKE) -f Makefile.post_rtl sim

clean_post_rtl:
	$(MAKE) -f Makefile.post_rtl clean

