// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 20, 2026
// Synchronizes both the rows and columns

module lab3sync (
    input  logic       clk,
    input  logic       reset_n,
    input  logic [3:0] cols_async,
    input  logic [3:0] rows_async,
    output logic [3:0] cols_sync,
    output logic [3:0] rows_sync
);

    logic [3:0] cols_first;
    logic [3:0] rows_first;

    always_ff @(posedge clk) begin
        if (reset_n == 0) begin
            // Columns are active high oops
            cols_first   <= 4'b1111;
            cols_sync <= 4'b0000;

            rows_first   <= 4'b1000;
            rows_sync <= 4'b1000;
        end
        else begin
            // First synchronizer
            cols_first <= cols_async;

            // Second register inverts active high
            cols_sync <= ~cols_first;

            // Delay rows so it's on track with columns
            rows_first   <= rows_async;
            rows_sync <= rows_first;
        end
    end

endmodule