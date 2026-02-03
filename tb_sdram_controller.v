 module tb_sdram_controller;

reg clk = 0;
reg reset;
reg read_req;
reg write_req;

wire [2:0] sdram_cmd;
wire data_valid;

sdram_controller DUT (
    .clk(clk),
    .reset(reset),
    .read_req(read_req),
    .write_req(write_req),
    .sdram_cmd(sdram_cmd),
    .data_valid(data_valid)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("sdram.vcd");
    $dumpvars(0, tb_sdram_controller);

    reset = 1;
    read_req = 0;
    write_req = 0;

    #20 reset = 0;

    // WRITE TRANSACTION
    #10 write_req = 1;
    #10 write_req = 0;

    // Wait enough time for WRITE + tRP
    #120;

    // READ TRANSACTION
    #10 read_req = 1;
    #10 read_req = 0;

    // Wait to observe data_valid (after tCAS)
    #150;

    $finish;
end

endmodule
