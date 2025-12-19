#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
VERIF="$ROOT/verif"
COCOTB_MK="$ROOT/.venv/lib/python3.10/site-packages/cocotb/share/makefiles/Makefile.sim"
LOGDIR="$VERIF/test_logs"
mkdir -p "$LOGDIR"


# The two groups of tests (fast + next); adjust as needed
FAST=(
"tb.test_gpio"
"tb.test_i2c"
"tb.test_pwm"
"tb.test_spi"
)


NEXT=(
"tb.test_axi2wb_scoreboard"
"tb.test_wishbone_contention"
"tb.test_apb_wait_states"
"tb.test_soc_smoke_extended"
"tb.test_peripherals_integration"
"tb.test_poweron_reset"
"tb.test_random_transaction_stress"
"tb.test_coverage_hooks"
)


# prefer sim_build/cmds.f if present
if [ -f "$VERIF/sim_build/cmds.f" ]; then
SRCS="$(tr '\n' ' ' < "$VERIF/sim_build/cmds.f")"
else
SRCS="$(awk -v root="$ROOT" 'NF && $0 !~ /^\+/ { print root "/" $0 }' "$VERIF/filelist.f" | tr '\n' ' ')"
fi


echo "Using $(wc -w <<<"$SRCS") verilog sources\n"


run_tests() {
local -n tests_arr=$1
for t in "${tests_arr[@]}"; do
LOG="$LOGDIR/run_${t//./_}.log"
echo "=== Running $t (log: $LOG) ==="
(
cd "$VERIF"
MODULE="$t" TOPLEVEL=soc_top TOPLEVEL_LANG=verilog \
VERILOG_SOURCES+="$SRCS" \
make -B -f "$COCOTB_MK" results.xml
) 2>&1 | tee "$LOG" || echo "=== $t finished with errors; see $LOG ==="
done
}


# Run fast then next
run_tests FAST
run_tests NEXT


echo "All tests executed. Logs -> $LOGDIR"
