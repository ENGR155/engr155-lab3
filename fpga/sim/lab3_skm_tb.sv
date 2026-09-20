`timescale 1ns/1ns

// Tests the connections and logic that are new in the top-level module

module lab3_skm_tb();

    logic [3:0] cols;
    logic [6:0] seg;
    logic [1:0] anode;
    logic [3:0] rows;

    logic press4;
    logic press6;

    integer errors;

    // Smaller scanning and display counters make the top simulation faster.
    lab3_skm #(
        .width1         (8),
        .max_count1     (8'd15),
        .display_switch (8'd31)
    ) dut (
        .cols  (cols),
        .seg   (seg),
        .anode (anode),
        .rows  (rows)
    );

    // Simple electrical model of keys 4 and 6.
    // The Lab 2 hardware uses pull-ups, so an unpressed column is 1.
    always_comb begin
        cols = 4'b1111;

        if (press4 == 1'b1 && rows == 4'b0100)
            cols[0] = 1'b0;

        if (press6 == 1'b1 && rows == 4'b0100)
            cols[2] = 1'b0;
    end

    initial begin
        $dumpfile("lab3_skm_tb.vcd");
        $dumpvars(0, lab3_skm_tb);

        errors = 0;
        press4 = 0;
        press6 = 0;

        // lab3_skm connects every reset input to 1. These force statements
        // briefly pulse those resets so the simulation starts predictably.
        force dut.scan.reset_n      = 1'b0;
        force dut.sync.reset_n      = 1'b0;
        force dut.decoder.reset_n   = 1'b0;
        force dut.debouncer.reset_n = 1'b0;
        force dut.led.reset_n       = 1'b0;
        force dut.count.reset_n     = 1'b0;

        repeat (3) @(posedge dut.int_osc);

        release dut.scan.reset_n;
        release dut.sync.reset_n;
        release dut.decoder.reset_n;
        release dut.debouncer.reset_n;
        release dut.led.reset_n;
        release dut.count.reset_n;

        // Seeing this edge confirms that the internal oscillator is running.
        @(posedge dut.int_osc);
        $display("Internal oscillator is running");

        // Check that the scanner reaches all four rows.
        wait (rows == 4'b1000);
        wait (rows == 4'b0100);
        wait (rows == 4'b0010);
        wait (rows == 4'b0001);
        $display("Observed all four scanner rows");

        // Check both sides of the top-level display multiplexer.
        wait (anode == 2'b10);
        #1;
        if (seg != dut.segright) begin
            $display("ERROR: right display was selected with the wrong segments");
            errors = errors + 1;
        end

        wait (anode == 2'b01);
        #1;
        if (seg != dut.segleft) begin
            $display("ERROR: left display was selected with the wrong segments");
            errors = errors + 1;
        end

        // Press 4. The real debounce count is used, so wait about 5 ms.
        press4 = 1;
        #5_000_000;
        if (dut.segleft != 7'b1000000 || dut.segright != 7'b0011001) begin
            $display("ERROR: pressing 4 did not display 04");
            errors = errors + 1;
        end

        // Add 6 while 4 remains down. The original 4 must be kept.
        press6 = 1;
        #1_000_000;
        if (dut.segleft != 7'b1000000 || dut.segright != 7'b0011001) begin
            $display("ERROR: additional key 6 was not ignored");
            errors = errors + 1;
        end

        // Release 4 while 6 remains. After debouncing, display should be 46.
        press4 = 0;
        #5_000_000;
        if (dut.segleft != 7'b0011001 || dut.segright != 7'b0000010) begin
            $display("ERROR: remaining key 6 did not change display to 46");
            errors = errors + 1;
        end

        // Releasing 6 must not erase the displayed history.
        press6 = 0;
        #5_000_000;
        if (dut.segleft != 7'b0011001 || dut.segright != 7'b0000010) begin
            $display("ERROR: releasing 6 changed the displayed history");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("lab3_skm_tb: all tests passed");
        else
            $display("lab3_skm_tb: %0d tests failed", errors);

        $finish;
    end

    // Stop the simulation if a wait statement never completes.
    initial begin
        #20_000_000;
        $display("ERROR: lab3_skm_tb timed out");
        $finish;
    end

endmodule
