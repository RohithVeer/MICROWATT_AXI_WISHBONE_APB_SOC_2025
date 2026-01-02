module soc_top (
    input  wire        clk,
    input  wire        rst_n,

    input  wire [31:0] paddr,
    input  wire        pwrite,
    input  wire        psel,
    input  wire        penable,
    input  wire [31:0] pwdata,

    output wire [31:0] prdata
);

    // -------------------------------------------------------
    // Write mask (full write)
    // -------------------------------------------------------
    wire [3:0] wmask0 = 4'b1111;

    // -------------------------------------------------------
    // SRAM outputs
    // -------------------------------------------------------
    wire [31:0] dout0;
    wire [31:0] dout1;

    assign prdata = dout0;

    // -------------------------------------------------------
    // SRAM MACRO
    // POWER PINS ARE **NOT CONNECTED IN RTL**
    // -------------------------------------------------------
    sky130_sram_1kbyte_1rw1r_32x256_8 u_sram (
        .clk0   (clk),
        .clk1   (clk),
        .wmask0 (wmask0),
        .dout0  (dout0),
        .dout1  (dout1)
    );

    wire _unused = |dout1;

endmodule

