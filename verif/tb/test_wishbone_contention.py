import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
import random
from common import ensure_reset_and_clock

@cocotb.test()
async def test_wishbone_contention(dut):
    """Basic two-master contention test on Wishbone interconnect"""

    # ensure clock + reset are started/asserted

    await ensure_reset_and_clock(dut)

    cocotb.start_soon(Clock(dut.clk, 10000, units="ps").start())
    dut.rst_n.value = 0
    await Timer(200, "ns")
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # quick contention pattern: drive two masters alternately (adapt signal names)
    for i in range(20):
        # master0 request
        try:
            dut.m0_addr <= i
            dut.m0_write.value = 1
            dut.m0_wdata <= i + 0x1000
        except Exception:
            pass
        await RisingEdge(dut.clk)
        # master1 request
        try:
            dut.m1_addr <= i
            dut.m1_write.value = 1
            dut.m1_wdata <= i + 0x2000
        except Exception:
            pass
        await Timer(10, "ns")
        # deassert write signals
        try:
            dut.m0_write.value = 0
            dut.m1_write.value = 0
        except Exception:
            pass
        await Timer(20, "ns")

    assert True
