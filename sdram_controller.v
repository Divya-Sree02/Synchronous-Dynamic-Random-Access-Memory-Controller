 module sdram_controller(
    input  wire clk,
    input  wire reset,
    input  wire read_req,
    input  wire write_req,
    output reg  [2:0] sdram_cmd,
    output reg  data_valid
);

parameter IDLE      = 3'd0;
parameter ACTIVE    = 3'd1;
parameter TRCD_WAIT = 3'd2;
parameter READ      = 3'd3;
parameter WRITE     = 3'd4;
parameter TCAS_WAIT = 3'd5;
parameter PRECHARGE = 3'd6;
parameter TRP_WAIT  = 3'd7;

parameter CMD_NOP       = 3'b000;
parameter CMD_ACTIVE    = 3'b001;
parameter CMD_READ      = 3'b010;
parameter CMD_WRITE     = 3'b011;
parameter CMD_PRECHARGE = 3'b100;

parameter TRCD = 3;
parameter TCAS = 2;
parameter TRP  = 2;

reg [2:0] state;
reg [3:0] counter;

reg read_latched;
reg write_latched;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
        counter <= 0;
        sdram_cmd <= CMD_NOP;
        data_valid <= 0;
        read_latched <= 0;
        write_latched <= 0;
    end
    else begin

        if(read_req)  read_latched  <= 1;
        if(write_req) write_latched <= 1;

        data_valid <= 0;

        case(state)

        IDLE: begin
            sdram_cmd <= CMD_NOP;
            if(read_latched || write_latched) begin
                state <= ACTIVE;
                sdram_cmd <= CMD_ACTIVE;
                counter <= 0;
            end
        end

        ACTIVE: begin
            state <= TRCD_WAIT;
            sdram_cmd <= CMD_NOP;
        end

        TRCD_WAIT: begin
            counter <= counter + 1;
            if(counter == TRCD) begin
                counter <= 0;
                if(read_latched)
                    state <= READ;
                else
                    state <= WRITE;
            end
        end

        READ: begin
            sdram_cmd <= CMD_READ;
            state <= TCAS_WAIT;
        end

        TCAS_WAIT: begin
            counter <= counter + 1;
            if(counter == TCAS) begin
                counter <= 0;
                data_valid <= 1;
                read_latched <= 0;
                state <= PRECHARGE;
            end
        end

        WRITE: begin
            sdram_cmd <= CMD_WRITE;
            write_latched <= 0;
            state <= PRECHARGE;
        end

        PRECHARGE: begin
            sdram_cmd <= CMD_PRECHARGE;
            state <= TRP_WAIT;
        end

        TRP_WAIT: begin
            counter <= counter + 1;
            if(counter == TRP) begin
                counter <= 0;
                state <= IDLE;
            end
        end

        endcase
    end
end

endmodule
