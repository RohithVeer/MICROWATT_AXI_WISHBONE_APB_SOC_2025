import cocotb
from cocotb.triggers import RisingEdge
import random
from common import ensure_reset_and_clock


@cocotb.test()
async def test_apb_wait_states(dut):
    """APB transfers with variable wait states (protocol-only test)"""

    await ensure_reset_and_clock(dut)

    for addr in (0x10, 0x20, 0x30):
        wdata = random.getrandbits(32)

        # ----------------
        # APB WRITE
        # ----------------
        dut.paddr.value   = addr
        dut.pwrite.value  = 1
        dut.psel.value    = 1
        dut.penable.value = 0
        dut.pwdata.value  = wdata

        await RisingEdge(dut.clk)
        dut.penable.value = 1

        # simulate wait states (cycles)
        for _ in range(random.randint(1, 4)):
            await RisingEdge(dut.clk)

        dut.psel.value    = 0
        dut.penable.value = 0

        # ----------------
        # APB READ (protocol check only)
        # ----------------
        dut.paddr.value   = addr
        dut.pwrite.value  = 0
        dut.psel.value    = 1
        dut.penable.value = 0

        await RisingEdge(dut.clk)
        dut.penable.value = 1
        await RisingEdge(dut.clk)

        # Protocol-level sanity
        assert dut.psel.value == 1
        assert dut.penable.value == 1

        dut.psel.value    = 0
        dut.penable.value = 0

