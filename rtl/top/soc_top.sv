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
    // SRAM outputs
    // -------------------------------------------------------
    wire [31:0] dout0;
    wire [31:0] dout1;

    assign prdata = dout0;

    // -------------------------------------------------------
    // SRAM MACRO (RTL simulation safe tie-offs)
    // -------------------------------------------------------
    sky130_sram_1kbyte_1rw1r_32x256_8 u_sram (
        .clk0   (clk),
        .csb0   (1'b1),        // disabled
        .web0   (1'b1),        // read-only
        .wmask0 (8'hFF),       // full write mask
        .addr0  (8'b0),
        .din0   (32'b0),
        .dout0  (dout0),

        .clk1   (clk),
        .csb1   (1'b1),        // disabled
        .addr1  (8'b0),
        .dout1  (dout1)
    );

endmodule

