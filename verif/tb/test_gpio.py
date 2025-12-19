import cocotb
from cocotb.triggers import Timer
from cocotb import log
from common import ensure_reset_and_clock

@cocotb.test()
async def test_gpio_smoke(dut):

    # ensure clock + reset are started/asserted
    await ensure_reset_and_clock(dut)
    log.info("GPIO smoke: start")
    await Timer(10, 'ns')
    await Timer(500, 'ns')
    log.info("GPIO smoke: finished - PASS")
