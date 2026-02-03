 module sdram_controller(
    input  wire clk,
    input  wire reset,
    input  wire read_req,
    input  wire write_req,
    output reg  [2:0] sdram_cmd,
    output reg  data_valid
);

parameter IDLE   = 3'd0;
parameter ACTIVE = 3'd1;
parameter WAIT   = 3'd2;
parameter READ   = 3'd3;
parameter WRITE  = 3'd4;
parameter DONE   = 3'd5;

reg [2:0] state;
reg [3:0] counter;

reg read_latched;
reg write_latched;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        sdram_cmd <= 3'b000;
        data_valid <= 0;
        counter <= 0;
        read_latched <= 0;
        write_latched <= 0;
    end
    else begin

        if(read_req)
            read_latched <= 1;

        if(write_req)
            write_latched <= 1;

        data_valid <= 0;

        case(state)

            IDLE: begin
                if(read_latched || write_latched) begin
                    state <= ACTIVE;
                    sdram_cmd <= 3'b001;
                    counter <= 0;
                end
            end

            ACTIVE: begin
                state <= WAIT;
                sdram_cmd <= 3'b000;
            end

            WAIT: begin
                counter <= counter + 1;
                if(counter == 3) begin
                    if(read_latched)
                        state <= READ;
                    else
                        state <= WRITE;
                end
            end

            READ: begin
                sdram_cmd <= 3'b010;
                data_valid <= 1;
                read_latched <= 0;
                state <= DONE;
            end

            WRITE: begin
                sdram_cmd <= 3'b011;
                write_latched <= 0;
                state <= DONE;
            end

            DONE: begin
                sdram_cmd <= 3'b000;
                state <= IDLE;
            end

        endcase
    end
end

endmodule
