import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock

def find_reset_signal(dut):
    candidates = ["RESET_N", "reset_n", "rst_n", "RESET", "reset", "rst", "POR_N", "por_n"]
    for name in candidates:
        if hasattr(dut, name):
            return getattr(dut, name), name
    for attr in dir(dut):
        low = attr.lower()
        if low.startswith("reset") or low.startswith("rst") or "por" in low or low.endswith("_n"):
            try:
                return getattr(dut, attr), attr
            except Exception:
                continue
    return None, None

async def _maybe_start_clock(dut):
    clk_handle = None
    if hasattr(dut, "CLK_IN"):
        clk_handle = getattr(dut, "CLK_IN")
    elif hasattr(dut, "clk"):
        clk_handle = getattr(dut, "clk")
    if clk_handle is not None:
        cocotb.start_soon(Clock(clk_handle, 10, units="ns").start())
        dut._log.info("Started clock on %s with 10 ns period", clk_handle._name if hasattr(clk_handle, "_name") else "clock")
    else:
        dut._log.info("No clock signal found (tried CLK_IN / clk). Continuing without starting a clock.")

@cocotb.test()
async def test_sram(dut):
    """Smoke test: reset and let WB master make writes; ensure simulation runs."""
    dut._log.info("Applying reset (robust finder)")
    await _maybe_start_clock(dut)
    reset_handle, reset_name = find_reset_signal(dut)
    if reset_handle is None:
        raise RuntimeError("No reset signal found on DUT (tried RESET_N/reset_n/rst_n/RESET/reset/rst/POR_N).")
    dut._log.info("Using reset signal '%s'", reset_name)
    active_low = reset_name.lower().endswith("_n") or "por" in reset_name.lower()
    if active_low:
        reset_handle.value = 0
        dut._log.debug("Asserted active-low reset (%s=0)", reset_name)
    else:
        reset_handle.value = 1
        dut._log.debug("Asserted active-high reset (%s=1)", reset_name)
    await Timer(100, "ns")
    if active_low:
        reset_handle.value = 1
        dut._log.debug("Deasserted active-low reset (%s=1)", reset_name)
    else:
        reset_handle.value = 0
        dut._log.debug("Deasserted active-high reset (%s=0)", reset_name)
    clk = getattr(dut, "CLK_IN", None) or getattr(dut, "clk", None)
    if clk is not None:
        await RisingEdge(clk)
    else:
        await Timer(10, "ns")
    await Timer(500, "ns")
    dut._log.info("Smoke test finished")
