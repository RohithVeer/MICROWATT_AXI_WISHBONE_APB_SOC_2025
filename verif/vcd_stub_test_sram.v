`timescale 1ns/1ps

// minimal vcd stub used for simulation harness (keeps tool happy)
module vcd_stub_test_sram ();

`ifdef COCOTB_SIM
  initial begin
    $display("[VCD] creating test_logs/test_sram.vcd (stub)");
    $dumpfile("test_logs/test_sram.vcd");
    $dumpvars(0, soc_top);
  end
`endif

endmodule

