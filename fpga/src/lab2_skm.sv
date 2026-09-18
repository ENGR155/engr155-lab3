// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 5, 2026
// Top-level module that connects two seven-segment displays
// and multiplexes them to save on resources.

module lab2_skm (
    input  logic [3:0] cols, // Column inputs from the keypad
    input  logic [3:0] s,
    input  logic [3:0] s_2,
    output logic [6:0] seg,
    output logic [1:0] anode, // Pinout for common anode for the transistors
    output logic [3:0] rows, // Row outputs to the keypad
    output logic [3:0] led // LED outputs from the FPGA
);

    // Starting logic
    logic int_osc;
    logic [23:0] counter;
    logic multi; // For multiplexing the two seven-segment displays
    logic [3:0] s_1;


    // Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01))
         hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

    // Convert switches into the 7-segment display
    lab2_sevenseg sevenseg_decoder (
        .s   (s_1),
        .seg (seg)
    );

    // Widths and max counts for the counter and multiplexer
    parameter width1 = 24;
    parameter logic [width1-1:0] max_count1 = 199_999;
    parameter width2 = 24;
    parameter logic [width2-1:0] max_count2 = 11_999_999;
    

    // Sets up a counter for the multiplexer
    counter #(
        .width     (width1),
        .max_count (max_count1)
    ) count (
        .reset_n  (1'b1),
        .clk    (int_osc),
        .enable (1'b1),
        .count2  (counter)
    );

    // Sets up a scanning module to output rows
    lab2_scanner #(
        .width     (width2),
        .max_count (max_count2)
    ) scan (
        .clk     (int_osc),
        .rows    (rows)
    );
    
    // Assigning final logic and switching
    assign multi = (counter > max_count1/2);

    assign s_1 = multi ? s_2 : s;

    assign anode[0] = multi;
    assign anode[1] = ~multi;   

    // Assigning final logic by reading from columns
    assign led = ~cols;

endmodule