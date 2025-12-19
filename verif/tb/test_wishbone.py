import cocotb
from cocotb.triggers import RisingEdge
from common import ensure_reset_and_clock

@cocotb.test()
async def test_wishbone_basic(dut):
    """Basic Wishbone classic-cycle test"""

    await ensure_reset_and_clock(dut)
    clk = dut.clk

    # --------------------
    # WRITE
    # --------------------
    dut.wb_adr.value   = 0x4
    dut.wb_dat_w.value = 0xDEADBEEF
    dut.wb_we.value    = 1
    dut.wb_sel.value   = 0xF
    dut.wb_cyc.value   = 1
    dut.wb_stb.value   = 1

    for _ in range(50):
        await RisingEdge(clk)
        if dut.wb_ack.value:
            break
    else:
        assert False, "WB WRITE ACK timeout"

    dut.wb_cyc.value = 0
    dut.wb_stb.value = 0
    dut.wb_we.value  = 0

    # --------------------
    # READ
    # --------------------
    await RisingEdge(clk)

    dut.wb_adr.value = 0x4
    dut.wb_we.value  = 0
    dut.wb_sel.value = 0xF
    dut.wb_cyc.value = 1
    dut.wb_stb.value = 1

    for _ in range(50):
        await RisingEdge(clk)
        if dut.wb_ack.value:
            rdata = int(dut.wb_dat_r.value)
            break
    else:
        assert False, "WB READ ACK timeout"

    dut.wb_cyc.value = 0
    dut.wb_stb.value = 0

    assert rdata == 0xDEADBEEF, f"Wishbone read mismatch: {hex(rdata)}"

