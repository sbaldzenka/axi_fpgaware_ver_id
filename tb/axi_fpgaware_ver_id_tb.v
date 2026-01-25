//project : axi_fpgaware_ver_id
//author  : siarhei baldzenka
//date    : 21.01.2026
//e-mail  : venera.electronica@gmail.com

`timescale 1ns/100ps

module axi_fpgaware_ver_id_tb();

    localparam CLK_100_MHZ_PERIOD = 10;

    localparam ID                 = 32'h01234567;
    localparam EXTERNAL_ID        = 32'h89ABCDEF;
    localparam ADDR_WIDTH         = 32;
    localparam DATA_WIDTH         = 32;
    localparam WSTRB_WIDTH        = DATA_WIDTH/8;

    reg                    clk;
    reg                    resetn;

    reg                    s_axi_awvalid;
    reg  [ ADDR_WIDTH-1:0] s_axi_awaddr;
    wire                   s_axi_awready;
    reg                    s_axi_wvalid;
    reg  [ DATA_WIDTH-1:0] s_axi_wdata;
    reg  [WSTRB_WIDTH-1:0] s_axi_wstrb;
    wire                   s_axi_wready;
    wire                   s_axi_bvalid;
    wire [            1:0] s_axi_bresp;
    reg                    s_axi_bready;
    reg                    s_axi_arvalid;
    reg  [ ADDR_WIDTH-1:0] s_axi_araddr;
    wire                   s_axi_arready;
    wire                   s_axi_rvalid;
    wire [ DATA_WIDTH-1:0] s_axi_rdata;
    wire [            1:0] s_axi_rresp;
    reg                    s_axi_rready;

    reg                    set_external_value;

    initial begin
             clk    <= 1'b1;
             resetn <= 1'b1;
        #500 resetn <= 1'b0;
        #50  resetn <= 1'b1;
    end

    always #(CLK_100_MHZ_PERIOD/2) clk = ~clk;

    initial begin
             set_external_value <= 1'b0;
             s_axi_arvalid      <= 1'b0;
             s_axi_araddr       <= '0;
             s_axi_rready       <= 1'b0;

        #700 s_axi_arvalid      <= 1'b1;
             s_axi_araddr[31:0] <= 32'h70000000;
        @(posedge s_axi_arready) #CLK_100_MHZ_PERIOD;
             s_axi_arvalid      <= 1'b0;
        @(posedge s_axi_rvalid) #CLK_100_MHZ_PERIOD;
             s_axi_rready       <= 1'b1;
        #CLK_100_MHZ_PERIOD;
             s_axi_rready       <= 1'b0;

        #300 s_axi_arvalid      <= 1'b1;
             s_axi_rready       <= 1'b1;
             s_axi_araddr[31:0] <= 32'h70000000;
        @(posedge s_axi_arready) #CLK_100_MHZ_PERIOD;
             s_axi_arvalid      <= 1'b0;
        @(posedge s_axi_rvalid) #CLK_100_MHZ_PERIOD;
             s_axi_rready       <= 1'b0;

             set_external_value <= 1'b1;
        #300 s_axi_arvalid      <= 1'b1;
             s_axi_rready       <= 1'b1;
             s_axi_araddr[31:0] <= 32'h70000000;
        @(posedge s_axi_arready) #CLK_100_MHZ_PERIOD;
             s_axi_arvalid      <= 1'b0;
        @(posedge s_axi_rvalid) #CLK_100_MHZ_PERIOD;
             s_axi_rready       <= 1'b0;

        #300 s_axi_arvalid      <= 1'b1;
             s_axi_rready       <= 1'b1;
             s_axi_araddr[31:0] <= 32'h70000000;
        @(posedge s_axi_arready) #CLK_100_MHZ_PERIOD;
             s_axi_arvalid      <= 1'b0;
        @(posedge s_axi_rvalid) #CLK_100_MHZ_PERIOD;
             s_axi_rready       <= 1'b0;
    end

    defparam DUT_inst.ID          = ID;
    defparam DUT_inst.ADDR_WIDTH  = ADDR_WIDTH;
    defparam DUT_inst.DATA_WIDTH  = DATA_WIDTH;
    defparam DUT_inst.WSTRB_WIDTH = WSTRB_WIDTH;

    axi_fpgaware_ver_id DUT_inst
    (
        .s_axi_aclk           ( clk                ),
        .s_axi_aresetn        ( resetn             ),
        .s_axi_awvalid        ( s_axi_awvalid      ),
        .s_axi_awaddr         ( s_axi_awaddr       ),
        .s_axi_awready        ( s_axi_awready      ),
        .s_axi_wvalid         ( s_axi_wvalid       ),
        .s_axi_wdata          ( s_axi_wdata        ),
        .s_axi_wstrb          ( s_axi_wstrb        ),
        .s_axi_wready         ( s_axi_wready       ),
        .s_axi_bvalid         ( s_axi_bvalid       ),
        .s_axi_bresp          ( s_axi_bresp        ),
        .s_axi_bready         ( s_axi_bready       ),
        .s_axi_arvalid        ( s_axi_arvalid      ),
        .s_axi_araddr         ( s_axi_araddr       ),
        .s_axi_arready        ( s_axi_arready      ),
        .s_axi_rvalid         ( s_axi_rvalid       ),
        .s_axi_rdata          ( s_axi_rdata        ),
        .s_axi_rresp          ( s_axi_rresp        ),
        .s_axi_rready         ( s_axi_rready       ),
        .i_set_external_value ( set_external_value ),
        .i_external_value     ( EXTERNAL_ID        )
    );

endmodule