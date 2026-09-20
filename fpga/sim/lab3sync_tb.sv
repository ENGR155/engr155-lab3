`timescale 1ns/1ns

// Tests the two-register synchronizer

module lab3sync_tb();

    logic       clk;
    logic       reset_n;
    logic [3:0] cols_async;
    logic [3:0] rows_async;
    logic [3:0] cols_sync;
    logic [3:0] rows_sync;

    integer errors;

    lab3sync dut (
        .clk        (clk),
        .reset_n    (reset_n),
        .cols_async (cols_async),
        .rows_async (rows_async),
        .cols_sync  (cols_sync),
        .rows_sync  (rows_sync)
    );

    // 10 ns clock period
    always begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end

    initial begin
        $dumpfile("lab3sync_tb.vcd");
        $dumpvars(0, lab3sync_tb);

        errors = 0;
        reset_n = 0;
        cols_async = 4'b1111; // No key pressed with pull-up resistors
        rows_async = 4'b1000;

        // Check reset values.
        repeat (2) @(posedge clk);
        #1;
        if (cols_sync != 4'b0000 || rows_sync != 4'b1000) begin
            $display("ERROR: synchronizer reset values are wrong");
            errors = errors + 1;
        end

        // Simulate column 0 being pulled low
        @(negedge clk);
        reset_n = 1;
        cols_async = 4'b1110;
        rows_async = 4'b0100;

        // Only first reg changes
        @(posedge clk);
        #1;
        if (cols_sync != 4'b0000 || rows_sync != 4'b1000) begin
            $display("ERROR: output changed before the second register");
            errors = errors + 1;
        end

        // Synchronized press
        @(posedge clk);
        #1;
        if (cols_sync != 4'b0001 || rows_sync != 4'b0100) begin
            $display("ERROR: column 0 or row 0100 was not synchronized");
            errors = errors + 1;
        end

        // Change the inputs between clock edges
        #2;
        cols_async = 4'b1011; 
        rows_async = 4'b0010;

        @(posedge clk);
        #1;
        if (cols_sync != 4'b0001 || rows_sync != 4'b0100) begin
            $display("ERROR: synchronized outputs changed after only one clock");
            errors = errors + 1;
        end

        @(posedge clk);
        #1;
        if (cols_sync != 4'b0100 || rows_sync != 4'b0010) begin
            $display("ERROR: column 2 or row 0010 was not synchronized");
            errors = errors + 1;
        end

        // Check reset again
        @(negedge clk);
        reset_n = 0;
        @(posedge clk);
        #1;
        if (cols_sync != 4'b0000 || rows_sync != 4'b1000) begin
            $display("ERROR: mid-simulation reset failed");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("lab3sync_tb: all tests passed");
        else
            $display("lab3sync_tb: %0d tests failed", errors);

        $finish;
    end

endmodule
