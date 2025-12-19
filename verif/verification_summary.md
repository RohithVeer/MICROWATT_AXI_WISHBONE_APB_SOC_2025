# Verification Summary


**Repository:** MICROWATT_AXI_WISHBONE_APB_SOC
**Date:** 2025-11-24
**Host:** local dev environment (Cocotb + Icarus)


## Tests (high level)


| Test module (python) | Testbench target | Last run status | Log location |
|---|---:|---|---|
| tb.test_gpio | soc_top | PASS | verif/test_logs/run_tb_test_gpio.log |
| tb.test_i2c | soc_top | PASS | verif/test_logs/run_tb_test_i2c.log |
| tb.test_pwm | soc_top | PASS | verif/test_logs/run_tb_test_pwm.log |
| tb.test_spi | soc_top | PASS | verif/test_logs/run_tb_test_spi.log |
| tb.test_axi2wb_scoreboard | soc_top | PASS | verif/test_logs/run_tb_test_axi2wb_scoreboard.log |
| tb.test_wishbone_contention | soc_top | PASS | verif/test_logs/run_tb_test_wishbone_contention.log |
| tb.test_apb_wait_states | soc_top | (see notes) | verif/test_logs/run_tb_test_apb_wait_states.log |
| tb.test_soc_smoke_extended | soc_top | PASS | verif/test_logs/run_tb_test_soc_smoke_extended.log |
| tb.test_peripherals_integration | soc_top | PASS | verif/test_logs/run_tb_test_peripherals_integration.log |
| tb.test_poweron_reset | soc_top | PASS | verif/test_logs/run_tb_test_poweron_reset.log |
| tb.test_random_transaction_stress | soc_top | PASS | verif/test_logs/run_tb_test_random_transaction_stress.log |
| tb.test_coverage_hooks | soc_top | PASS | verif/test_logs/run_tb_test_coverage_hooks.log |


### Notes & next actions
- The `+timescale` problem (cocotb writing a `+timescale...` line into `sim_build/cmds.f`) was causing `make` to treat that token as a dependency. We switched to passing `VERILOG_SOURCES` explicitly in `run_next_tests.sh` to avoid the issue.
- `tb.test_apb_wait_states` had a read mismatch in an earlier run (see `verif/test_logs/run_tb_test_apb_wait_states.log`). If this test still fails, check:
- `rtl/wishbone/wb_to_apb.sv` behavior around read-data path and APB wait-state logic.
- Verify sram memory initialization/behaviour (verif/sim/* beh_sram files) used by that test.


### VCDs
- VCDs are written to `verif/test_logs` (see each test log for the exact VCD filename). Use `./scripts/open_latest_vcd.sh` or `gtkwave` to open.
