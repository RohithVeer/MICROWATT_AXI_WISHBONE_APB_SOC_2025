#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

LOGDIR="$ROOT/verif/logs"
mkdir -p "$LOGDIR"

echo "===================="
echo "RUN START: $(date)"
echo "===================="

tests=(verif/tb/test_*.py)

passed=()
failed=()

for testfile in "${tests[@]}"; do
  module="$(basename "$testfile" .py)"
  logfile="$LOGDIR/${module}.log"

  # -------------------------------------------------
  # SELECT CORRECT TOPLEVEL
  # -------------------------------------------------
  if [[ "$module" == "test_wishbone" ]]; then
    TOP=wb_to_apb
  else
    TOP=soc_top
  fi

  echo "-------------------------------------------------------"
  echo "Running test: $module (TOPLEVEL=$TOP)"
  echo "-------------------------------------------------------"

  rm -rf verif/sim_build

  if make -C verif \
      SIM=icarus \
      TOPLEVEL="$TOP" \
      COCOTB_TEST_MODULES="$module" \
      >"$logfile" 2>&1; then
    echo "PASS: $module"
    passed+=("$module")
  else
    echo "FAIL: $module (see $logfile)"
    failed+=("$module")
  fi
  echo
done

echo "================ SUMMARY ================="
echo "Passed: ${#passed[@]}"
for p in "${passed[@]}"; do echo "  ✔ $p"; done
echo ""
echo "Failed: ${#failed[@]}"
for f in "${failed[@]}"; do echo "  ✘ $f"; done

exit ${#failed[@]}

