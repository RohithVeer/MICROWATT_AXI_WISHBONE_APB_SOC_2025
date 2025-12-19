# MICROWATT AXI–Wishbone–APB SoC

## Overview
A verified SoC interconnect integrating:
- AXI-Lite master
- Wishbone interconnect
- APB peripherals
- SRAM subsystem

Developed as part of **MICROWATT Hackathon 2025**.

## Status
 RTL complete  
 Cocotb verification complete (17/17 tests passing)  
 OpenLane RTL-to-GDS in progress  

## Verification
```bash
cd verif
make SIM=icarus TOPLEVEL=soc_top COCOTB_TEST_MODULES=test_soc_smoke_extended

