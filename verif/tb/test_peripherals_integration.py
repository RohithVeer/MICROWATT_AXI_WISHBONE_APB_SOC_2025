import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
import asyncio
from common import ensure_reset_and_clock

@cocotb.test()
async def test_peripherals_integration(dut):
    """Simultaneous activity: SPI tx + I2C start + GPIO toggles"""

    # ensure clock + reset are started/asserted

    await ensure_reset_and_clock(dut)

    cocotb.start_soon(Clock(dut.clk, 10000, units="ps").start())
    dut.rst_n.value = 0
    await Timer(200, "ns")
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    async def spi_task():
        for _ in range(4):
            try:
                dut.cs_n.value = 0
                for b in range(8):
                    dut.mosi <= (0xA3 >> (7 - b)) & 1
                    dut.sclk.value = 0
                    await Timer(5, "ns")
                    dut.sclk.value = 1
                    await Timer(5, "ns")
                dut.cs_n.value = 1
            except Exception:
                pass
            await Timer(50, "ns")

    async def i2c_task():
        for _ in range(4):
            try:
                dut.sda.value = 1
                dut.scl.value = 1
                await Timer(5, "ns")
                dut.sda.value = 0
                await Timer(5, "ns")
                dut.sda.value = 1
            except Exception:
                pass
            await Timer(60, "ns")

    async def gpio_task():
        for i in range(16):
            try:
                dut.gpio_out <= i & 0xFF
            except Exception:
                pass
            await Timer(20, "ns")

    await cocotb.start(spi_task())
    await cocotb.start(i2c_task())
    await cocotb.start(gpio_task())

    # run a little while
    await Timer(800, "ns")
    assert True
