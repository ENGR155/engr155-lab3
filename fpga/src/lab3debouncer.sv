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

    // Typedef for states
    typedef enum logic {STABLE, WAITING} state_t;

    state_t state, nextstate;

    logic [4:0] candidate, candidate_next;
    logic [4:0] seg_out_next;
    logic [width-1:0] timer_count;
    logic counter_reset_n;

    // Next-state and datapath logic
    always_comb begin
        nextstate      = state;
        candidate_next = candidate;
        seg_out_next   = seg_out;
        counter_reset_n = 1'b0;

        case (state)
            STABLE: begin
                // Start checking when input changes
                if (seg != seg_out) begin
                    candidate_next = seg;
                    nextstate = WAITING;
                end
            end

            WAITING: begin
                if (seg != candidate) begin
                    // The input changed before timer finished
                    candidate_next = seg;

                    // If the input bounced back
                    if (seg == seg_out)
                        nextstate = STABLE;
                end
                else if (timer_count == max_count) begin
                    // The candidate stayed unchanged long enough
                    seg_out_next = candidate;
                    nextstate = STABLE;
                end
                else begin
                    // Counter runs only if candidate is stable
                    counter_reset_n = 1'b1;
                end
            end

            default: begin
                nextstate = STABLE;
                candidate_next = 5'b11111;
                seg_out_next = 5'b11111;
            end
        endcase
    end

    // State and data registers
    always_ff @(posedge clk) begin
        if (!reset_n) begin
            state     <= STABLE;
            candidate <= 5'b11111;
            seg_out   <= 5'b11111;
        end
        else begin
            state     <= nextstate;
            candidate <= candidate_next;
            seg_out   <= seg_out_next;
        end
    end

    // Counter
    counter #(
        .width(width),
        .max_count(max_count)
    ) debounce_counter (
        .clk     (clk),
        .reset_n (reset_n && counter_reset_n),
        .enable  (1'b1),
        .count2  (timer_count)
    );

endmodule
