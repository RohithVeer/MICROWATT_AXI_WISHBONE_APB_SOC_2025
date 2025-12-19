#!/usr/bin/env bash
set -e

source ~/.eda_env.sh  # optional: adds OpenROAD/Yosys/Magic to PATH

./scripts/synth.sh
openroad -exit scripts/pnr.tcl
./scripts/signoff_magic.sh

echo "Flow complete: check build/pnr/*.gds"

