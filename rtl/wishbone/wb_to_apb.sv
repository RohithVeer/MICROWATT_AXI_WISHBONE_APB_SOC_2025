module wb_to_apb (
    input  logic        clk,
    input  logic        rst_n,

    // Wishbone SLAVE interface
    input  logic [31:0] wb_adr,
    input  logic [31:0] wb_dat_w,
    output logic [31:0] wb_dat_r,
    input  logic        wb_we,
    input  logic [3:0]  wb_sel,
    input  logic        wb_cyc,
    input  logic        wb_stb,
    output logic        wb_ack
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wb_ack   <= 1'b0;
            wb_dat_r <= 32'h0;
        end else begin
            wb_ack <= wb_cyc & wb_stb;

            // simple readback logic
            if (wb_cyc && wb_stb && !wb_we) begin
                wb_dat_r <= 32'hDEADBEEF;
            end
        end
    end

endmodule

