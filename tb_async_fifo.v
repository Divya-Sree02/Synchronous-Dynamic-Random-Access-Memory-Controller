module tb_async_fifo;

    // -----------------------------------------
    // Clock and reset
    // -----------------------------------------
    reg wr_clk = 0;
    reg rd_clk = 0;
    reg reset  = 1;

    // -----------------------------------------
    // Write interface
    // -----------------------------------------
    reg        wr_en;
    reg [7:0]  wr_data;
    wire       full;

    // -----------------------------------------
    // Read interface
    // -----------------------------------------
    reg        rd_en;
    wire [7:0] rd_data;
    wire       empty;

    // -----------------------------------------
    // DUT instantiation
    // -----------------------------------------
    async_fifo DUT (
        .wr_clk (wr_clk),
        .rd_clk (rd_clk),
        .reset  (reset),
        .wr_en  (wr_en),
        .wr_data(wr_data),
        .full   (full),
        .rd_en  (rd_en),
        .rd_data(rd_data),
        .empty  (empty)
    );

    // -----------------------------------------
    // Clock generation
    // -----------------------------------------
    always #5  wr_clk = ~wr_clk;   // Write clock: 100 MHz
    always #8  rd_clk = ~rd_clk;   // Read clock: ~62.5 MHz

    // -----------------------------------------
    // Test sequence
    // -----------------------------------------
    initial begin
        // Create waveform file
        $dumpfile("fifo.vcd");
        $dumpvars(0, tb_async_fifo);

        // Initialize
        wr_en   = 0;
        rd_en   = 0;
        wr_data = 0;

        // Apply reset
        #20 reset = 0;

        // -------------------------------
        // WRITE DATA INTO FIFO
        // -------------------------------
        repeat (10) begin
            @(posedge wr_clk);
            if (!full) begin
                wr_en   = 1;
                wr_data = wr_data + 8'h01;
            end
        end
        wr_en = 0;

        // Wait a little
        #50;

        // -------------------------------
        // READ DATA FROM FIFO
        // -------------------------------
        repeat (10) begin
            @(posedge rd_clk);
            if (!empty)
                rd_en = 1;
        end
        rd_en = 0;

        // Finish simulation
        #100;
        $finish;
    end

endmodule