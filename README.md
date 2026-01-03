Microwatt POWER ISA SoC with AXI–Wishbone–APB Interconnect
RTL → GDS Open-Source Silicon Project (SKY130 / OpenLane)


Project Overview
This project implements a Microwatt POWER ISA–based System-on-Chip (SoC) featuring a multi-bus interconnect architecture and a configurable peripheral subsystem. The design is fully verified at RTL and synthesized to silicon using the SkyWater SKY130 PDK and OpenLane.

Key Features
- Microwatt POWER ISA CPU core
- AXI → Wishbone → APB hierarchical bus architecture
- 64 KiB on-chip SRAM (Sky130 macros)
- UART, SPI, I²C, GPIO, PWM, Timer, Debug peripherals
- Deterministic Cocotb verification with CI support
- RTL → GDS flow using OpenLane
- Post-PnR verification (STA, DRC, LVS)

System Architecture
CPU (AXI4/AXI4-Lite)
System Interconnect (Wishbone B4)
Peripheral Bus (APB3)
Memory (Sky130 SRAM)
Infrastructure (Clock, Reset, JTAG)

Verification
Cocotb-based RTL verification
17 automated tests
CI-enabled deterministic simulation

Toolchain
RTL Simulation: Icarus Verilog
Verification: Cocotb
RTL → GDS: OpenLane, OpenROAD, Magic, Netgen
PDK: SkyWater SKY130A

Directory Structure
rtl/
verif/
post_rtl/
scripts/
docs/

How to Run
cd verif
make SIM=icarus

Project Status
RTL complete
Verification complete
CI stable
OpenLane synthesis complete
DRC/LVS clean

License
Microwatt, SkyWater SKY130, OpenLane

Acknowledgements
Microwatt community
SkyWater PDK team
OpenLane contributors
