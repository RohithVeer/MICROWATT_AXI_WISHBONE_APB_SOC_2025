# Microwatt-Based AXI–Wishbone–APB SoC
RTL to GDSII Implementation using OpenLane (Sky130)


## 1. Project Summary

This repository contains a complete end-to-end ASIC implementation of a
Microwatt-based System-on-Chip (SoC), covering the full flow from RTL design
and verification to final GDSII tapeout using open-source EDA tools.

The design integrates multiple on-chip bus protocols, SRAM, and peripherals,
and is functionally verified using Cocotb prior to physical implementation.

Target Process: SkyWater SKY130

### Chip Layout
<img width="1207" height="799" alt="Chip Layout" src="https://github.com/user-attachments/assets/a5f2d097-0d9c-4644-ba1e-d69fa300699f" />
## Key Features and Technical Highlights

- Microwatt POWER ISA CPU integrated as the main processing core.
- AXI-Lite to Wishbone bridge for CPU-to-system interconnect.
- Wishbone interconnect connecting memory and peripheral subsystems.
- Wishbone-to-APB bridge for low-speed peripheral access.
- On-chip 64 KiB SRAM subsystem implemented using Sky130 OpenRAM macros.
- RTL written in Verilog/SystemVerilog, organized by protocol and function.

### Verification
- Functional verification implemented using Cocotb.
- Directed test cases for protocol and feature validation.
- Randomized stress tests for robustness.
- Protocol compliance checks for AXI, Wishbone, and APB.
- Scoreboard-based end-to-end data integrity verification.
- Automated test execution via `run_all_tests.sh`.
- Complete RTL verification suite with **17/17 tests passing**.

### Physical Design
- Physical implementation using OpenLane and OpenROAD.
- Target technology: SkyWater SKY130A.
- Clean Static Timing Analysis (STA) at 100 MHz.
- DRC and LVS clean signoff.
- Final tapeout artifacts (GDS, DEF, LEF, gate-level netlist, reports) included for reproducibility.

- Repository structured following industry-standard ASIC project organization.



## 2. System Description

This SoC integrates the Microwatt POWER ISA CPU with a multi-bus interconnect
and a configurable peripheral subsystem. The design is synthesized using the
SkyWater SKY130 PDK and OpenLane on the ChipFoundry OpenFrame platform.

All RTL is verified using Cocotb with Wishbone, AXI, and APB protocol extensions
and includes an SRAM subsystem built from Sky130 SRAM macros.


## 3. Architecture Overview

Major Functional Blocks:
- Microwatt CPU core (AXI-Lite interface)
- AXI-Lite to Wishbone bridge
- Wishbone interconnect
- Wishbone to APB bridge
- APB peripheral subsystem
- SRAM subsystem

Supported Bus Protocols:
- AXI-Lite
- Wishbone
- APB

### Block Diagram
<img width="750" height="998" alt="Block Diagram" src="https://github.com/user-attachments/assets/8df03eae-206d-4cae-b7d3-ef2e9ff4df56" />

### Functional Overview
<img width="1704" height="1061" alt="Functional Overview" src="https://github.com/user-attachments/assets/c3f3a6cd-6296-4b37-b472-583bb51a4ed8" />


## 4. System Overview

| S. No | Layer         | Protocol           | Function                                      |
|------:|---------------|--------------------|-----------------------------------------------|
| 1     | CPU           | AXI4 / AXI4-Lite   | Microwatt instruction and data access         |
| 2     | System        | Wishbone B4        | Interconnect between memory and peripherals  |
| 3     | Peripheral    | APB3               | Register-mapped low-speed bus                |
| 4     | External      | UART, SPI, I²C, GPIO | Communication interfaces                    |
| 5     | Memory        | SRAM (Sky130 macros) | On-chip instruction and data memory         |
| 6     | Infrastructure| Clock, Reset, JTAG | Synchronization and debug                    |


## 5. Memory Subsystem

| S. No | Component      | Type                               | Description                                   |
|------:|----------------|------------------------------------|-----------------------------------------------|
| 1     | SRAM Macro     | sky130_sram_1kbyte_1rw1r_32x256_8 | 1 KiB macro, 32-bit data, 256 addresses       |
| 2     | Configuration  | 64 KiB total                       | 64 macros × 1 KiB each                        |
| 3     | Access         | 1 RW port + 1 RO port              | Data and instruction access                  |
| 4     | Voltage        | 1.8 V                              | Matched with digital logic                   |
| 5     | Clock          | Single domain @ 100 MHz            | Shared system clock                           |
| 6     | Integration    | OpenRAM macros                     | Synthesized and PnR ready                    |
| 7     | ECC / Parity   | Not enabled                        | Reserved space available                     |

## 6. Physical Specifications

| S. No | Parameter        | Value                          |
|------:|------------------|--------------------------------|
| 1     | Technology Node | SkyWater SKY130A               |
| 2     | Core Voltage    | 1.8 V                          |
| 3     | Frequency       | 100 MHz                        |
| 4     | SRAM Capacity   | 64 KiB                         |
| 5     | Logic Area      | ~12 mm²                        |
| 6     | Total Die Area  | 15 mm² (user region)           |
| 7     | Utilization     | ≤ 80%                          |
| 8     | Power           | < 50 mW (typical)              |
| 9     | Timing Slack    | > 0 ns post-PnR                |
| 10    | Clock Tree      | CTS optimized in OpenROAD      |
| 11    | IO Count        | 44 ESD-protected pads          |

## 7. Repository Structure

- **rtl/**        – Synthesizable RTL sources (Verilog / SystemVerilog)
- **verif/**      – Cocotb-based functional verification
- **post_rtl/**   – Post-synthesis / gate-level simulation artifacts
- **physical/**   – Physical design outputs (GDS, DEF, LEF, STA, reports)
- **scripts/**    – Automation and helper scripts
- **docs/**       – Design and project documentation

## 8. Tasks Performed

### RTL Design:
- Designed top-level SoC integration
- Implemented AXI-Lite, Wishbone, and APB interconnect logic
- Integrated SRAM subsystem using black-box modeling
- Ensured synthesizable and lint-clean RTL

### Functional Verification:
- Developed Cocotb-based verification environment
- Implemented drivers, monitors, and scoreboards
- Created directed and randomized test cases
- Verified protocol compliance and data integrity

### Pre- and Post-Synthesis Simulation:
- Verified RTL functionality before synthesis
- Enabled gate-level simulation using synthesized netlist
- Validated reset behavior and functional equivalence

### Physical Design (OpenLane):
- RTL synthesis using Yosys
- Floorplanning and die sizing
- Power Distribution Network (PDN) generation
- Standard-cell placement
- Clock Tree Synthesis (CTS)
- Global and detailed routing
- Static Timing Analysis (STA)
- Design Rule Check (DRC)
- Layout Versus Schematic (LVS)


## 9. Verification Results

Passed: 17  
Failed: 0  

### RTL Verification Test Matrix

| # | Test Case | Status | Focus Area |
|---|----------|--------|------------|
| 1 | test_apb | PASS | APB protocol |
| 2 | test_apb_wait_states | PASS | Wait states |
| 3 | test_axi2wb | PASS | AXI→WB bridge |
| 4 | test_axi2wb_scoreboard | PASS | Data integrity |
| 5 | test_coverage_hooks | PASS | Coverage |
| 6 | test_gpio | PASS | GPIO |
| 7 | test_i2c | PASS | I2C |
| 8 | test_peripherals_integration | PASS | Integration |
| 9 | test_poweron_reset | PASS | Reset |
|10 | test_pwm | PASS | PWM |
|11 | test_random_transaction_stress | PASS | Stress |
|12 | test_soc_smoke | PASS | Boot |
|13 | test_soc_smoke_extended | PASS | Stability |
|14 | test_spi | PASS | SPI |
|15 | test_sram | PASS | SRAM |
|16 | test_wb_to_apb | PASS | WB→APB |
|17 | test_wishbone_contention | PASS | Arbitration |


## 10. Clone, Build, and Run Verification (Commands)

This section documents the verified procedure to clone the repository and run
RTL verification using Cocotb. The commands below are validated against the
current repository structure and test setup.

### 10.1 Clone Repository

git clone https://github.com/RohithVeer/MICROWATT_AXI_WISHBONE_APB_SOC_2025.git  
cd MICROWATT_AXI_WISHBONE_APB_SOC_2025  

### 10.2 Install Dependencies (Ubuntu)

sudo apt update  
sudo apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    iverilog \
    gtkwave \
    make \
    git  

### 10.3 Python Environment Setup

python3 -m venv .venv  
source .venv/bin/activate  
pip install --upgrade pip  
pip install cocotb cocotbext-bus cocotbext-axi cocotbext-wishbone  

Note:
If a Python virtual environment is not activated, Cocotb will fall back to the
system Python interpreter. This behavior is supported and does not affect test
execution.

### 10.4 Run All RTL Verification Tests (Recommended)

All RTL tests are executed using the provided automation script.

cd verif  
./run_all_tests.sh  

Expected result:

Passed: 17  
Failed: 0  

### 10.5 Run an Individual Test (Optional)

To run a specific Cocotb test module, invoke `make` with `MODULE` set to the
exact Python filename (without the `.py` extension).

Example:

cd verif  
make SIM=icarus TOPLEVEL=soc_top MODULE=test_soc_smoke_extended  

Expected result:

TESTS=1 PASS=1 FAIL=0  

### 10.6 Important Notes

- The Cocotb Makefile resides in the `verif/` directory  
- `MODULE` must correspond to an existing Python test file  
- There is no umbrella `test_soc.py` in this repository  
- For complete verification, `run_all_tests.sh` should be used  

Expected Result:
Passed: 17  
Failed: 0  

## 11. Physical Design Results

Clock Period: 10 ns  
Setup Violations: 0  
Hold Violations: 0  
DRC: Clean  
LVS: Clean  

## 12. Tapeout Artifacts

- GDSII
- DEF
- LEF
- Gate-level netlist
- STA reports
- OpenLane configs

## 13. Toolchain (RTL to GDSII) and Versions

| S. No | Flow Stage            | Tool / Component        | Version / Details |
|------:|----------------------|-------------------------|-------------------|
| 1     | Operating System     | Ubuntu                  | 22.04.5 LTS (jammy) |
| 2     | Kernel               | Linux                   | 6.8.0-90-generic (x86_64) |
| 3     | RTL Simulation       | Icarus Verilog          | 11.0 (stable) |
| 4     | Simulation Runtime   | vvp                     | 11.0 (stable) |
| 5     | Verification         | Python                  | 3.10.12 |
| 6     | Verification         | pip                     | 22.0.2 |
| 7     | Verification         | Cocotb                  | 1.9.2 |
| 8     | Verification         | cocotbext-bus           | Installed |
| 9     | Verification         | cocotbext-axi           | Installed |
| 10    | Verification         | cocotbext-wishbone      | Installed |
| 11    | Synthesis            | Yosys                   | 0.9 (git sha1: 1979e0b) |
| 12    | Place & Route        | OpenLane                | Docker-based flow |
| 13    | Place & Route        | OpenLane Image          | ghcr.io/the-openroad-project/openlane:ff5509f65b17bfa4068d5336495ab1718987ff69 |
| 14    | Place & Route        | OpenLane Image          | efabless/openlane:latest |
| 15    | Static Timing        | OpenROAD                | Invoked via OpenLane Docker |
| 16    | DRC / LVS            | Magic                   | 8.3.105 |
| 17    | DRC / LVS            | Netgen                  | 6.2-dev |
| 18    | Version Control      | Git                     | 2.34.1 |
| 19    | Container Runtime    | Docker                  | 29.0.1 |
| 20    | CI / Automation      | GitHub Actions          | Continuous verification |

**Notes:**
- OpenROAD is executed internally through the OpenLane Docker flow and is not installed as a standalone host binary.
- The above toolchain was used to achieve clean RTL verification (17/17 tests passing) and DRC/LVS-clean GDSII at 100 MHz.

## 14. License

Apache License 2.0

## 15. Acknowledgements

ChipFoundry Microwatt Challenge  
https://chipfoundry.io/challenges/microwatt  

OpenPOWER Foundation  
https://openpowerfoundation.org/

## 16. Author

Rohith Mudigonda


