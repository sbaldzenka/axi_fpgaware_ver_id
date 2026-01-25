//project     : axi_fpgaware_ver_id
//author      : siarhei baldzenka
//date        : 13.12.2021
//e-mail      : venera.electronica@gmail.com
//description : https://github.com/sbaldzenka/axi_fpgaware_ver_id

`timescale 1ns/100ps

module axi_fpgaware_ver_id
#(
    parameter ID          = 32'h00000000,
    parameter ADDR_WIDTH  = 32,
    parameter DATA_WIDTH  = 32,
    parameter WSTRB_WIDTH = DATA_WIDTH/8
)
(
    // global signals
    input  wire                   s_axi_aclk,
    input  wire                   s_axi_aresetn,
    // axi-lite bus
    input  wire                   s_axi_awvalid,
    input  wire [ ADDR_WIDTH-1:0] s_axi_awaddr,
    output wire                   s_axi_awready,
    input  wire                   s_axi_wvalid,
    input  wire [ DATA_WIDTH-1:0] s_axi_wdata,
    input  wire [WSTRB_WIDTH-1:0] s_axi_wstrb,
    output wire                   s_axi_wready,
    output wire                   s_axi_bvalid,
    output wire [            1:0] s_axi_bresp,
    input  wire                   s_axi_bready,
    input  wire                   s_axi_arvalid,
    input  wire [ ADDR_WIDTH-1:0] s_axi_araddr,
    output reg                    s_axi_arready,
    output wire                   s_axi_rvalid,
    output wire [ DATA_WIDTH-1:0] s_axi_rdata,
    output wire [            1:0] s_axi_rresp,
    input  wire                   s_axi_rready,
    // external value
    input  wire                   i_set_external_value,
    input  wire [ DATA_WIDTH-1:0] i_external_value
);

    parameter [3:0] S_IDLE           = 0,
                    S_GET_RADDR      = 1,
                    S_CHECK_ADDR     = 2,
                    S_WAIT_READY_ID  = 3,
                    S_WAIT_READY_ERR = 4,
                    S_SEND_ID        = 5,
                    S_SEND_ERR       = 6;

    reg [ADDR_WIDTH-1:0] buffer_raddr;
    reg [           3:0] state;

    assign s_axi_awready = 1'b0;
    assign s_axi_wready  = 1'b0;
    assign s_axi_bvalid  = 1'b0;
    assign s_axi_bresp   = 2'b00;

    always@(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE: begin
                    if (s_axi_arvalid) begin
                        state <= S_GET_RADDR;
                    end
                end

                S_GET_RADDR: begin
                    state <= S_CHECK_ADDR;
                end

                S_CHECK_ADDR: begin
                    if (buffer_raddr[7:0] == 8'h00) begin
                        state <= S_WAIT_READY_ID;
                    end else begin
                        state <= S_WAIT_READY_ERR;
                    end
                end

                S_WAIT_READY_ID: begin
                    if (s_axi_rready) begin
                        state <= S_SEND_ID;
                    end
                end

                S_SEND_ID: begin
                    state <= S_IDLE;
                end

                S_WAIT_READY_ERR: begin
                    if (s_axi_rready) begin
                        state <= S_SEND_ERR;
                    end
                end

                S_SEND_ERR: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

    always@(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            buffer_raddr <= 'b0;
        end else if (state == S_GET_RADDR) begin
            buffer_raddr <= s_axi_araddr;
        end
    end

    always@(posedge s_axi_aclk) begin
        if (state == S_GET_RADDR) begin
            s_axi_arready <= 1'b1;
        end else begin
            s_axi_arready <= 1'b0;
        end
    end

    assign s_axi_rvalid = (state == S_WAIT_READY_ID | state == S_WAIT_READY_ERR) ? 1'b1 : 1'b0;
    assign s_axi_rdata  = (state == S_WAIT_READY_ID & i_set_external_value) ? i_external_value : ID;
    assign s_axi_rresp  = (state == S_WAIT_READY_ERR) ? 2'b01 : 2'b00;

endmodule