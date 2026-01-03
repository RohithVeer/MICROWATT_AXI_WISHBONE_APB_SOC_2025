import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge
from common import ensure_reset_and_clock

def _maybe_start_clock(dut):
    if hasattr(dut, "CLK_IN"):
        cocotb.start_soon(Clock(dut.CLK_IN, 10000, units="ps").start())
    elif hasattr(dut, "clk"):
        cocotb.start_soon(Clock(dut.clk, 10000, units="ps").start())

@cocotb.test()
async def test_apb_peripherals(dut):
    """Smoke test for APB peripherals: reset and observe clock toggles."""

    # ensure clock + reset are started/asserted

    await ensure_reset_and_clock(dut)

    _maybe_start_clock(dut)

    dut._log.info("Applying reset for APB smoke test")
    if hasattr(dut, "RESET_N"):
        dut.RESET_N.value = 0
        await Timer(100, "ns")
        dut.RESET_N.value = 1
    else:
        dut._log.warning("No RESET_N found on DUT; continuing without reset")

    await RisingEdge(dut.CLK_IN if hasattr(dut, "CLK_IN") else dut.clk)
    await Timer(400, "ns")
    dut._log.info("APB peripherals smoke test finished")
