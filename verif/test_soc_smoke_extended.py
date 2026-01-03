import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_soc_smoke_extended(dut):
    """Basic SOC smoke test"""

    dut._log.info("Starting SOC smoke test")

    # ----------------------------
    # Start clock
    # ----------------------------
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # ----------------------------
    # Apply active-low reset
    # ----------------------------
    dut.rst_n.value = 0
    await Timer(100, units="ns")
    dut.rst_n.value = 1

    # ----------------------------
    # Let the design run
    # ----------------------------
    for _ in range(50):
        await RisingEdge(dut.clk)

    dut._log.info("SOC smoke test completed")

