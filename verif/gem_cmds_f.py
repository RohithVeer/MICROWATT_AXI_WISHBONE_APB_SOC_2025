#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
verif = ROOT / "verif"
rtl = ROOT / "rtl"

sources = []

# RTL (recursive, deterministic order)
for p in sorted(rtl.rglob("*.v")):
    sources.append(str(p.relative_to(verif)))

for p in sorted(rtl.rglob("*.sv")):
    sources.append(str(p.relative_to(verif)))

# test stubs / helpers
for p in sorted(verif.glob("*.v")):
    sources.append(str(p.name))

out = verif / "sim_build" / "cmds.f"
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text("\n".join(sources) + "\n")

print(f"[gen_cmds_f] wrote {len(sources)} files to {out}")

