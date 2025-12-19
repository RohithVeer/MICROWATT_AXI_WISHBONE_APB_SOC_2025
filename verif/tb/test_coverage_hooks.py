import cocotb
from common import ensure_reset_and_clock

@cocotb.test()
async def test_coverage_hooks(dut):
    """
    Coverage hooks smoke test.

    This test verifies that enabling coverage does not
    break simulation. It does NOT enforce functional coverage.
    """

    # If clock/reset works, coverage hooks did not break the sim
    await ensure_reset_and_clock(dut)

    dut._log.info("Coverage hooks smoke test passed")
    assert True

