// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 18, 2026
// Debouncer module that makes sure outputs are consistent

module lab3debouncer(
    input  logic [4:0] seg,
    input  logic       clk, reset_n,
    output logic [4:0] seg_out
);

    // Synchronizers to prevent metastability from raw input
    logic [4:0] seg_0, seg_1;
    logic [4:0] seg_stable;
    
    logic counter_reset_n, counter_enable; // Internal counter signals

    // Two stage synchronizer
    always_ff @(posedge clk) begin
        if (!reset_n) begin
            seg_0 <= 5'b0;
            seg_1 <= 5'b0;
        end else begin
            seg_0 <= seg;
            seg_1 <= seg_0;
        end
    end

    // If input differs from our last stable value, enable counter, otherwise force reset
    assign counter_enable  = (seg_1 != seg_stable);
    assign counter_reset_n = reset_n && (seg_1 != seg_stable);

    logic [23:0] counterdummy; // Dummy counter

    // Counter setup - max count selected to be 4 ms
    counter #(
        .width(24), 
        .max_count(24'd199_999)
    ) counter (
        .clk(clk),
        .reset_n(counter_reset_n),
        .enable(counter_enable),
        .count2(counterdummy) 
    );

    // Update output when flash - 4 ms
    always_ff @(posedge clk) begin
        if (!reset_n) begin
            seg_stable <= 5'b0;
        end else if (counter_enable && (counter.count == 24'd199_999)) begin
            seg_stable <= seg_1;
        end
    end

    // Output logic
    assign seg_out = seg_stable;

endmodule
