 module tb_sdram_controller;

reg clk = 0;
reg reset;
reg read_req;
reg write_req;
wire [2:0] sdram_cmd;
wire data_valid;

sdram_controller dut (
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

    #10 reset = 0;

    #10 write_req = 1;
    #10 write_req = 0;

    #60;

    #10 read_req = 1;
    #10 read_req = 0;

    #100 $finish;
end

endmodule
