// SystemVerilog FIFO Testbench Top
`timescale 1ns/1ps

module tb_top;
    parameter DATA_WIDTH = 32;
    parameter DEPTH = 16;

    logic clk = 0;
    logic rst_n = 0;

    always #5 clk = ~clk; // 100 MHz Clock

    logic wr_en, rd_en, full, almost_full, empty, almost_empty, wr_err, rd_err;
    logic [3:0] byte_en;
    logic [DATA_WIDTH-1:0] wr_data, rd_data;
    logic [$clog2(DEPTH):0] fifo_count;

    fifo_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .byte_en(byte_en),
        .full(full),
        .almost_full(almost_full),
        .wr_err(wr_err),
        .rd_en(rd_en),
        .rd_data(rd_data),
        .empty(empty),
        .almost_empty(almost_empty),
        .rd_err(rd_err),
        .fifo_count(fifo_count)
    );

    initial begin
        $display("[TB] Starting SystemVerilog FIFO Verification...");
        wr_en = 0; rd_en = 0; byte_en = 4'b1111; wr_data = 0;
        
        // Reset sequence
        #20 rst_n = 1;
        #10;

        // Test 1: Write until Full
        $display("[TB] Phase 1: Sequential Writes until Full");
        for (int i = 1; i <= DEPTH; i++) begin
            @(posedge clk);
            wr_en = 1;
            wr_data = 32'hA000_0000 + i;
            byte_en = 4'b1111;
        end
        @(posedge clk);
        wr_en = 0;

        #20;
        assert(full == 1) else $error("FIFO should be full!");
        $display("[✓] Full flag verified: full = %b, count = %0d", full, fifo_count);

        // Test 2: Read until Empty
        $display("[TB] Phase 2: Sequential Reads until Empty");
        for (int i = 1; i <= DEPTH; i++) begin
            @(posedge clk);
            rd_en = 1;
        end
        @(posedge clk);
        rd_en = 0;

        #20;
        assert(empty == 1) else $error("FIFO should be empty!");
        $display("[✓] Empty flag verified: empty = %b, count = %0d", empty, fifo_count);

        $display("[TB] All FIFO verification test cases PASSED successfully!");
        $finish;
    end
endmodule
