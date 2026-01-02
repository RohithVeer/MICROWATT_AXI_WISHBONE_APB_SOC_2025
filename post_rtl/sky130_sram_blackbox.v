/*
 * Blackbox model for SKY130 SRAM
 * Used for post-RTL (gate-level) functional simulation
 */

(* blackbox *)
module sky130_sram_1kbyte_1rw1r_32x256_8 (
    // Port 0 (RW)
    input         clk0,
    input         csb0,
    input         web0,
    input  [7:0]  wmask0,
    input  [7:0]  addr0,
    input  [31:0] din0,
    output [31:0] dout0,

    // Port 1 (R)
    input         clk1,
    input         csb1,
    input  [7:0]  addr1,
    output [31:0] dout1
);
endmodule
