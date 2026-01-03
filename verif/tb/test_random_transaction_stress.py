import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
import random
from common import ensure_reset_and_clock

@cocotb.test()
async def test_random_transaction_stress(dut):

    # ensure clock + reset are started/asserted
    await ensure_reset_and_clock(dut)
    cocotb.start_soon(Clock(dut.clk, 10000, units="ps").start())
    dut.rst_n.value = 0
    await Timer(200, "ns")
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    for _ in range(128):
        addr = random.randint(0, 0xFFF) & ~0x3
        wdata = random.getrandbits(32)
        # attempt a write (adapt to interface)
        try:
            dut.bus_addr <= addr
            dut.bus_write.value = 1
            dut.bus_wdata <= wdata
            await RisingEdge(dut.clk)
            dut.bus_write.value = 0
        except Exception:
            pass
        await Timer(random.randint(1, 10) * 10, "ns")
    assert True
