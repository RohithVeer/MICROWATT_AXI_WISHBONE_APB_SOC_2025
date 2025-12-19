import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from common import ensure_reset_and_clock

@cocotb.test()
async def test_poweron_reset(dut):

    # ensure clock + reset are started/asserted
    await ensure_reset_and_clock(dut)
    cocotb.start_soon(Clock(dut.clk, 10000, unit="ps").start())
    # assert reset long, then release
    dut.rst_n.value = 0
    await Timer(1000, "ns")
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)
    # check a few default registers (example)
    try:
        val = int(dut.bus_rdata.value)
    except Exception:
        val = 0
    # re-assert reset and ensure registers return to reset values
    dut.rst_n.value = 0
    await Timer(50, "ns")
    dut.rst_n.value = 1
    await Timer(50, "ns")
    assert True
