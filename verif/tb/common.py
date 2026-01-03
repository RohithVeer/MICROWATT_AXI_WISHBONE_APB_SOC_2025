import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer

async def _maybe_start_clock(dut, period_ns=10):
    """
    Start a clock on the DUT if a reasonable clock signal exists.
    We explicitly check names with hasattr() to avoid using a cocotb Handle
    in a boolean context (which raises TypeError).
    """
    clk_names = ("CLK_IN", "clk", "clock", "CLK", "clock_in")
    clk_name = None
    clk_handle = None
    for name in clk_names:
        if hasattr(dut, name):
            clk_name = name
            clk_handle = getattr(dut, name)
            break

    if clk_handle is not None:
        # period is in ns by default here (match tests' usage)
        cocotb.start_soon(Clock(clk_handle, period_ns, units="ns").start())
        try:
            dut._log.info(f"Started clock on {clk_name} with {period_ns} ns period")
        except Exception:
            # best-effort logging; don't crash if logging fails
            pass
    return clk_handle

async def ensure_reset_and_clock(dut, reset_active_low=True, reset_pulse_ns=100, clock_period_ns=10):
    """
    Helper used by tests to ensure a clock is running and to apply a reset pulse.
    - reset_active_low: True if reset is active low (i.e. assert with 0), else active high.
    - reset_pulse_ns: how long to hold reset asserted.
    - clock_period_ns: clock period to start if a clock is present.
    """
    # start clock if possible
    await _maybe_start_clock(dut, period_ns=clock_period_ns)

    # pick reset signal explicitly (no truthiness checks)
    reset_candidates = ["RESET_N", "reset_n", "rst_n", "RESET", "reset", "rst", "POR_N", "por_n"]
    reset_name = None
    reset_handle = None
    for name in reset_candidates:
        if hasattr(dut, name):
            reset_name = name
            reset_handle = getattr(dut, name)
            break

    if reset_handle is None:
        dut._log.info("No top-level reset found (tried common names); continuing without reset pulse")
        return

    # assert reset
    if reset_active_low:
        reset_handle.value = 0
    else:
        reset_handle.value = 1

    try:
        dut._log.info(f"Applied reset pulse (active_low={reset_active_low}) to {reset_name}")
    except Exception:
        pass

    await Timer(reset_pulse_ns, "ns")

    # deassert reset
    if reset_active_low:
        reset_handle.value = 1
    else:
        reset_handle.value = 0

    try:
        dut._log.info(f"Deasserted reset {reset_name}")
    except Exception:
        pass
