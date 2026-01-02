// --------------------------------------------------
// SRAM Blackbox for RTL Simulation
// --------------------------------------------------
module sky130_sram_1kbyte_1rw1r_32x256_8 (
    input          clk0,
    input          csb0,
    input          web0,
    input  [7:0]   wmask0,
    input  [7:0]   addr0,
    input  [31:0]  din0,
    output [31:0]  dout0,

    input          clk1,
    input          csb1,
    input  [7:0]   addr1,
    output [31:0]  dout1
);

    // Simple behavioral memory
    reg [31:0] mem [0:255];

    assign dout0 = (!csb0 && web0) ? mem[addr0] : 32'h0;
    assign dout1 = (!csb1) ? mem[addr1] : 32'h0;

    always @(posedge clk0) begin
        if (!csb0 && !web0) begin
            if (wmask0[0]) mem[addr0][7:0]   <= din0[7:0];
            if (wmask0[1]) mem[addr0][15:8]  <= din0[15:8];
            if (wmask0[2]) mem[addr0][23:16] <= din0[23:16];
            if (wmask0[3]) mem[addr0][31:24] <= din0[31:24];
        end
    end

endmodule
