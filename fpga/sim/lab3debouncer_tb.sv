`timescale 1ns/1ns

// Tests short unstable inputs, stable inputs, held inputs, and release.

module lab3debouncer_tb();

    logic       clk;
    logic       reset_n;
    logic [4:0] seg;
    logic [4:0] seg_out;

    integer errors;

    // Use a small counter 
    lab3debouncer #(
        .width     (4),
        .max_count (3)
    ) dut (
        .clk     (clk),
        .reset_n (reset_n),
        .seg     (seg),
        .seg_out (seg_out)
    );

    // 10 ns clock period
    always begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end

    initial begin
        $dumpfile("lab3debouncer_tb.vcd");
        $dumpvars(0, lab3debouncer_tb);

        errors = 0;
        reset_n = 0;
        seg = 5'b11111;

        repeat (2) @(posedge clk);
        #1;
        if (seg_out != 5'b11111) begin
            $display("ERROR: debouncer reset value is wrong");
            errors = errors + 1;
        end

        @(negedge clk);
        reset_n = 1;

        // A short pulse is not a bounce
        seg = 5'h05;
        repeat (2) @(posedge clk);
        @(negedge clk);
        seg = 5'b11111;
        repeat (8) @(posedge clk);
        #1;
        if (seg_out != 5'b11111) begin
            $display("ERROR: short pulse was incorrectly accepted");
            errors = errors + 1;
        end

        // A stable 6
        @(negedge clk);
        seg = 5'h06;
        repeat (10) @(posedge clk);
        #1;
        if (seg_out != 5'h06) begin
            $display("ERROR: stable 6 was not accepted");
            errors = errors + 1;
        end

        // Holding 6
        repeat (5) @(posedge clk);
        #1;
        if (seg_out != 5'h06) begin
            $display("ERROR: held value 6 changed unexpectedly");
            errors = errors + 1;
        end

        // Bounce to 5 then back to 6
        @(negedge clk);
        seg = 5'h05;
        repeat (2) @(posedge clk);
        @(negedge clk);
        seg = 5'h06;
        repeat (8) @(posedge clk);
        #1;
        if (seg_out != 5'h06) begin
            $display("ERROR: a brief bounce changed the accepted 6");
            errors = errors + 1;
        end

        // A stable release
        @(negedge clk);
        seg = 5'b11111;
        repeat (10) @(posedge clk);
        #1;
        if (seg_out != 5'b11111) begin
            $display("ERROR: stable release was not accepted");
            errors = errors + 1;
        end

        // Test reset
        @(negedge clk);
        reset_n = 0;
        @(posedge clk);
        #1;
        if (seg_out != 5'b11111) begin
            $display("ERROR: mid-simulation reset failed");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("lab3debouncer_tb: all tests passed");
        else
            $display("lab3debouncer_tb: %0d tests failed", errors);

        $finish;
    end

endmodule
