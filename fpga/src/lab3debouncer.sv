// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 18, 2026
// Debouncer module that makes sure outputs are consistent


module lab3debouncer #(
    parameter width = 24,
    parameter logic [width-1:0] max_count = 95_999
)(
    input  logic       clk,
    input  logic       reset_n,
    input  logic [4:0] seg,
    output logic [4:0] seg_out
);

    logic [4:0] seg_0, seg_1;
    logic [4:0] candidate;
    logic [width-1:0] timer_count;
    logic timer_reset_n;

    // Two-stage synchronizer
    always_ff @(posedge clk) begin
        if (!reset_n) begin
            seg_0     <= 5'b11111;
            seg_1     <= 5'b11111;
            candidate <= 5'b11111;
            seg_out   <= 5'b11111;
        end
        else begin
            seg_0 <= seg;
            seg_1 <= seg_0;

            // A change starts a new candidate and restarts timing
            if (seg_1 != candidate)
                candidate <= seg_1;

            // Accept output only after the candidate remains unchanged
            else if (timer_count == max_count)
                seg_out <= candidate;
        end
    end

    assign timer_reset_n =
        reset_n &&
        (seg_1 == candidate) &&
        (candidate != seg_out);

    // Setting up counter
    counter #(
        .width(width),
        .max_count(max_count)
    ) debounce_counter (
        .clk     (clk),
        .reset_n (timer_reset_n),
        .enable  (1'b1),
        .count2  (timer_count)
    );

endmodule