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
## Tapeout Artifacts and Signoff

This repository includes a curated, tapeout-ready set of physical design artifacts generated using the OpenLane open-source ASIC flow on the SkyWater SKY130 PDK.

### Included Artifacts
- **Final GDS**: `physical/gds/soc_top.gds`
- **Merged LEF** (standard cells + macros): `physical/lef/merged.nom.lef`
- **Final routed DEF**: `physical/def/soc_top.def`
- **Post-synthesis netlist**: `physical/netlist/soc_top.synth.v`
- **Static Timing Analysis (STA)**:
  - Max / Min timing
  - Skew analysis
  - Timing checks
  - Power report
- **DRC signoff report**
- **Die and core area reports**
- **OpenLane configuration files**

All intermediate OpenLane run directories, logs, and PDK files are intentionally excluded to keep the repository clean, reviewable, and reproducible.

The presence of GDS, LEF, DEF, STA, and DRC artifacts confirms full RTL → GDS closure and tapeout-level readiness.
## Physical Design Summary (Sky130)

| Metric | Value | Source |
|------|------|------|
| Technology | SkyWater SKY130A | OpenLane |
| Flow | OpenLane / OpenROAD | — |
| Die Area | See `3-initial_fp_die_area.rpt` | Floorplan report |
| Core Area | See `3-initial_fp_core_area.rpt` | Floorplan report |
| Timing Closure | Met | STA summary |
| DRC | Clean | `drc.rpt` |
| LVS | Clean | OpenLane signoff |
| Netlist | Post-synthesis | `soc_top.synth.v` |

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
