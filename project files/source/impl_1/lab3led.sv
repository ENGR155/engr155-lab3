// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 18, 2026
// Decoder module that takes a number and converts it into two LEDs

module lab3led(
    input  logic       clk,
    input  logic       reset_n,
    input  logic [4:0] num,
    output logic [6:0] segleft,
    output logic [6:0] segright
);

    // Left and right numbers
    logic [3:0] left_num;
    logic [3:0] right_num;

    // Remembers the previous value
    logic [4:0] previous_num;

    always_ff @(posedge clk) begin
        if (reset_n == 0) begin
            left_num     <= 4'd0;
            right_num    <= 4'd0;
            previous_num <= 5'b11111;
        end
        else begin
            // Update if input changes
            if (num != previous_num) begin
                previous_num <= num;

                // No null value is displayed
                if (num != 5'b11111) begin
                    left_num  <= right_num;
                    right_num <= num[3:0];
                end
            end
        end
    end

    // Left LED
    lab2_sevenseg left (
        .s   (left_num),
        .seg (segleft)
    );

    // Right LED
    lab2_sevenseg right (
        .s   (right_num),
        .seg (segright)
    );

endmodule