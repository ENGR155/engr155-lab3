// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 20, 2026
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


    // Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV("0b01"))
         hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

    // Widths and max counts for the deocder and LED modules - 50 Hz for both
    parameter width1 = 24;
    parameter logic [width1-1:0] max_count1 = 23_999;
    parameter logic [width1-1:0] display_switch = 199_999; // For display
    
    // Sets up every module

    // Sets up a scanning module to output rows
    lab2_scanner #(
        .width     (width1),
        .max_count (max_count1)
    ) scan (
        .reset_n (1'b1),
        .clk     (int_osc),
        .enable  (1'b1),
        .rows    (rows)
    );

    // Columns and rows output from synchronizer
    logic [3:0] cols2; 
    logic [3:0] rows2;

    // Sets up synchronizer
    lab3sync sync (
        .clk        (int_osc),
        .reset_n    (1'b1),
        .cols_async (cols),
        .rows_async (rows),
        .cols_sync  (cols2),
        .rows_sync  (rows2)
    );

    logic [4:0] numdummy; // Dummy variable that passes through the decoder

    // Sets up decoder
    lab3main decoder (
        .clk     (int_osc),
        .reset_n (1'b1),
        .row     (rows2),
        .col     (cols2),
        .segout  (numdummy)
    );

    logic [4:0] numdummy2; // Same dummy variable but from debouncer

    // Sets up debouncer
    lab3debouncer debouncer (
        .seg     (numdummy),
        .clk     (int_osc),
        .reset_n (1'b1),
        .seg_out (numdummy2)
    );

    // Final segleft segright
    logic [6:0] segleft, segright;

    // Sets up LED
    lab3led led (
        .clk      (int_osc),
        .reset_n  (1'b1),
        .num      (numdummy2),
        .segleft  (segleft),
        .segright (segright)
    );
    
    // Sets up a counter for the multiplexer
    counter #(
        .width     (width1),
        .max_count (display_switch)
    ) count (
        .reset_n  (1'b1),
        .clk      (int_osc),
        .enable   (1'b1),
        .count2   (counter)
    );
    
    // Assigning final logic and switching
    assign multi = (counter > display_switch/2);

    assign seg = multi ? segleft : segright;

    assign anode[0] = multi;
    assign anode[1] = ~multi;   

endmodule