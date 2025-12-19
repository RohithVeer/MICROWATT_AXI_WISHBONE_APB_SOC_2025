#!/usr/bin/env bash
set -e

export PDKROOT="$HOME/pdks/sky130A"
TOP="soc_top"
CDIR="build/pnr"

# DRC
magic -d null -noconsole <<EOF
gds read $CDIR/$TOP.gds
load $TOP
drc euclidean on
drc check
drc count
EOF

# LVS
netgen -batch lvs "$CDIR/$TOP.def $TOP" \
    "build/synth/$TOP.synth.v $TOP" \
    "$PDKROOT/libs.tech/netgen/sky130A_setup.tcl" \
    build/signoff/lvs_report.log

