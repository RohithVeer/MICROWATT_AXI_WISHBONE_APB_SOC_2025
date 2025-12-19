import cocotb
from cocotb.triggers import Timer
from cocotb import log
from common import ensure_reset_and_clock

@cocotb.test()
async def test_spi_smoke(dut):

    # ensure clock + reset are started/asserted
    await ensure_reset_and_clock(dut)
    log.info("SPI smoke: start")
    # small wait to allow soc_top to apply reset/clock infrastructure
    await Timer(10, 'ns')
    # wait some cycles (keeps test minimal & resilient)
    await Timer(500, 'ns')
    log.info("SPI smoke: finished - PASS")
