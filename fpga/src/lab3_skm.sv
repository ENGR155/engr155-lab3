// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 5, 2026
// Top-level module that connects two seven-segment displays
// and multiplexes them to save on resources.

module lab3_skm (
    input  logic [3:0] cols, // Column inputs from the keypad
    output logic [6:0] seg,
    output logic [1:0] anode, // Pinout for common anode for the transistors
    output logic [3:0] rows // Row outputs to the keypad
);

    // Starting logic
    logic int_osc;
    logic [23:0] counter;
    logic multi; // For multiplexing the two seven-segment displays
    logic [3:0] s_1;
    logic [3:0] s // Switches 1
    logic [3:0] s_2 // Switches 2


    // Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01))
         hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

    // Widths and max counts for the deocder and LED modules - 50 Hz for both
    parameter width1 = 24;
    parameter logic [width1-1:0] max_count1 = 199_999;
    
    // Sets up every module

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

    logic [4:0] numdummy; // Dummy variable that passes through the decoder

    // Sets up decoder
    lab3main deoder (
        .clk (counter),
        .reset_n (1'b1),
        .row (rows),
        .col (cols),
        .segout (numdummy)
    );

    logic [4:0] numdummy2; // Same dummy variable but from debouncer

    // Sets up debouncer
    lab3debouncer debouncer (
        .seg (numdummy),
        .clk (int_osc),
        .reset_n (1'b1),
        .seg_out (numdummy2),
    );

    // Final segleft segright
    logic [6:0] segleft, segright;

    // Sets up LED
    lab3led led (
        .clk (counter),
        .reset_n (1'b1),
        .segleft (segleft),
        .segright (segright)
    );
    
    // Assigning final logic and switching
    assign multi = (counter > max_count1/2);

    assign s_1 = multi ? segleft : segright;

    assign anode[0] = multi;
    assign anode[1] = ~multi;   

    // Assigning final logic by reading from columns
    assign led = ~cols;

endmodule