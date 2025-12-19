module soc_top();

    // -------------------------------------------------------
    // Clock & Reset
    // -------------------------------------------------------
    logic clk;
    logic rst_n;
    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        rst_n = 0;
        #50;
        rst_n = 1;
    end

    // -------------------------------------------------------
    // APB interface signals driven by testbenches
    // -------------------------------------------------------
    logic [31:0] paddr;
    logic        pwrite;
    logic        psel;
    logic        penable;
    logic [31:0] pwdata;

    logic [31:0] prdata;
    logic        pready;  // **TB drives pready. DO NOT assign internally**

    // -------------------------------------------------------
    // Simple APB RAM model
    // -------------------------------------------------------
    localparam MEM_WORDS = 1024;
    logic [31:0] mem [0:MEM_WORDS-1];

    // reset memory and prdata
    always_ff @(negedge rst_n) begin
        for (int i=0; i<MEM_WORDS; i++)
            mem[i] <= '0;
        prdata <= '0;
    end

    // word index (use word-aligned address)
    wire [31:0] addr_word = paddr[31:2];

    // handshake signals (declared and latched)
    logic hs;               // current handshake condition
    logic hs_prev;          // previous-cycle handshake
    logic [31:0] latched_addr_word;
    logic        latched_pwrite;

    // compute handshake (combinational)
    assign hs = psel & penable & pready;

    // edge-detect + single-shot action on handshake
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prdata <= 32'd0;
            hs_prev <= 1'b0;
            latched_addr_word <= 32'd0;
            latched_pwrite <= 1'b0;
        end else begin
            // update previous-handshake
            hs_prev <= hs;

            // detect rising/first cycle of the handshake and latch controls
            if (hs && !hs_prev) begin
                latched_addr_word <= addr_word;
                latched_pwrite <= pwrite;

                // write on handshake when pwrite asserted
                if (pwrite) begin
                    if (addr_word < MEM_WORDS)
                        mem[addr_word] <= pwdata;
                end
            end

            // READ DATA: present memory data one cycle after completed handshake
            // use latched_pwrite so read/write ordering is stable
            if (hs_prev && (latched_pwrite == 1'b0)) begin
                if (latched_addr_word < MEM_WORDS)
                    prdata <= mem[latched_addr_word];
                else
                    prdata <= 32'h0;
            end
        end
    end

    // -------------------------------------------------------
    // Dummy peripherals required by other tests
    // -------------------------------------------------------

    // GPIO
    logic [7:0] gpio_out;
    assign gpio_out = 8'hA5;

    // SPI
    logic cs_n, mosi, miso, sclk;
    assign miso = 1'b0;

    // I2C
    logic sda, scl;
    assign sda = 1'b1;
    assign scl = 1'b1;

    // PWM
    logic pwm_out;
    assign pwm_out = clk;

endmodule

