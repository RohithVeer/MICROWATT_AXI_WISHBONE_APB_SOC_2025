#!/usr/bin/env bash
set -e
echo "=== PATH summary ==="
which yosys || echo "yosys: NOT FOUND"
which openroad || echo "openroad: NOT FOUND"
which magic || echo "magic: NOT FOUND"
which netgen || echo "netgen: NOT FOUND"
which klayout || echo "klayout: NOT FOUND"
echo
echo "=== Versions (where available) ==="

# yosys: try common flags silently and print a single concise line
if [ -x "$(command -v yosys)" ]; then
  for opt in "-V" "--version" "-v"; do
    out="$(yosys $opt 2>&1 | sed -n '1,3p' | grep -v -i 'invalid option' | sed -n '1p' || true)"
    if [ -n "$out" ]; then
      echo "yosys: $(echo "$out" | tr -d '\r' | sed -n '1p')"
      break
    fi
  done
fi

# openroad (if installed) - show first few lines of version output
if [ -x "$(command -v openroad)" ]; then
  openroad -version 2>&1 | sed -n '1,4p' || true
fi

# magic: probe common flags but suppress long usage output
if [ -x "$(command -v magic)" ]; then
  for opt in "--version" "-V" "-v" "-version"; do
    out="$(magic $opt 2>&1 | sed -n '1,3p' | sed -n '1p' || true)"
    if [ -n "$out" ]; then
      echo "magic: $(echo "$out" | tr -d '\r' | sed -n '1p')"
      break
    fi
  done
fi

# netgen: print version/info succinctly
if [ -x "$(command -v netgen)" ]; then
  netgen -version 2>&1 | sed -n '1,6p' || true
fi

# ---- klayout presence-only check (do NOT execute klayout to avoid GUI popups) ----
if command -v klayout >/dev/null 2>&1 ; then
  echo "klayout: found ($(command -v klayout)) (runtime execution intentionally skipped)"
elif flatpak info de.klayout.KLayout >/dev/null 2>&1 ; then
  echo "klayout: found via Flatpak (runtime execution intentionally skipped)"
else
  echo "klayout: NOT FOUND"
fi
# ---- end klayout block ----

echo
echo "=== PDKROOT check (common candidate paths) ==="
for p in "$HOME/pdks/sky130A" "$HOME/pdks/skywater-pdk" "/usr/share/pdk/sky130"; do
  if [ -d "$p" ]; then
    echo "Found PDK at: $p"
  fi
done

echo
echo "If any required tool shows NOT FOUND, install it or update PATH (see README or ask me)."

