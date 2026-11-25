// Parameterized FIFO Buffer Top Module
// Authors: J Anvidh, Shreyas Aradhya, Jayanth Reddy

module fifo_top #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  logic                   clk,
    input  logic                   rst_n,
    
    // Write Interface
    input  logic                   wr_en,
    input  logic [DATA_WIDTH-1:0]  wr_data,
    input  logic [3:0]             byte_en,
    output logic                   full,
    output logic                   almost_full,
    output logic                   wr_err,
    
    // Read Interface
    input  logic                   rd_en,
    output logic [DATA_WIDTH-1:0]  rd_data,
    output logic                   empty,
    output logic                   almost_empty,
    output logic                   rd_err,
    
    // Status
    output logic [ADDR_WIDTH:0]    fifo_count
);

    logic [DATA_WIDTH-1:0] mem [DEPTH-1:0];
    logic [ADDR_WIDTH:0]   wr_ptr;
    logic [ADDR_WIDTH:0]   rd_ptr;

    assign fifo_count   = wr_ptr - rd_ptr;
    assign empty        = (wr_ptr == rd_ptr);
    assign full         = (fifo_count == DEPTH);
    assign almost_empty = (fifo_count <= 2);
    assign almost_full  = (fifo_count >= (DEPTH - 2));

    // Write Logic with Byte-Enable Masking
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= '0;
            wr_err <= 1'b0;
        end else if (wr_en) begin
            if (!full) begin
                if (byte_en[0]) mem[wr_ptr[ADDR_WIDTH-1:0]][7:0]   <= wr_data[7:0];
                if (byte_en[1]) mem[wr_ptr[ADDR_WIDTH-1:0]][15:8]  <= wr_data[15:8];
                if (byte_en[2]) mem[wr_ptr[ADDR_WIDTH-1:0]][23:16] <= wr_data[23:16];
                if (byte_en[3]) mem[wr_ptr[ADDR_WIDTH-1:0]][31:24] <= wr_data[31:24];
                wr_ptr <= wr_ptr + 1'b1;
                wr_err <= 1'b0;
            end else begin
                wr_err <= 1'b1; // Overflow Error
            end
        end else begin
            wr_err <= 1'b0;
        end
    end

    // Read Logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr  <= '0;
            rd_data <= '0;
            rd_err  <= 1'b0;
        end else if (rd_en) begin
            if (!empty) begin
                rd_data <= mem[rd_ptr[ADDR_WIDTH-1:0]];
                rd_ptr  <= rd_ptr + 1'b1;
                rd_err  <= 1'b0;
            end else begin
                rd_err  <= 1'b1; // Underflow Error
            end
        end else begin
            rd_err <= 1'b0;
        end
    end

endmodule
