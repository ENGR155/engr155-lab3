`timescale 1ns/1ns


module lab3led_tb();

    logic       clk;
    logic       reset_n;
    logic [4:0] num;
    logic [6:0] segleft;
    logic [6:0] segright;

    integer errors;

    lab3led dut (
        .clk      (clk),
        .reset_n  (reset_n),
        .num      (num),
        .segleft  (segleft),
        .segright (segright)
    );

    // 10 ns clock period
    always begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end

    initial begin
        $dumpfile("lab3led_tb.vcd");
        $dumpvars(0, lab3led_tb);

        errors = 0;
        reset_n = 0;
        num = 5'b11111;

        // Reset should display 00
        repeat (2) @(posedge clk);
        #1;
        if (segleft != 7'b1000000 || segright != 7'b1000000) begin
            $display("ERROR: reset did not display 00");
            errors = errors + 1;
        end

        // First key so 00 becomes 05
        @(negedge clk);
        reset_n = 1;
        num = 5'h05;
        @(posedge clk);
        #1;
        if (segleft != 7'b1000000 || segright != 7'b0010010) begin
            $display("ERROR: first key did not change the display to 05");
            errors = errors + 1;
        end

        // Holding 5 should not put in both displays
        repeat (4) @(posedge clk);
        #1;
        if (segleft != 7'b1000000 || segright != 7'b0010010) begin
            $display("ERROR: held key 5 was recorded more than once");
            errors = errors + 1;
        end

        // Keep display unchanged
        @(negedge clk);
        num = 5'b11111;
        @(posedge clk);
        #1;
        if (segleft != 7'b1000000 || segright != 7'b0010010) begin
            $display("ERROR: releasing 5 changed the display");
            errors = errors + 1;
        end

        // Second key so 05 becomes 5A.
        @(negedge clk);
        num = 5'h0A;
        @(posedge clk);
        #1;
        if (segleft != 7'b0010010 || segright != 7'b0001000) begin
            $display("ERROR: second key did not change the display to 5A");
            errors = errors + 1;
        end

        // Release A, then press A again
        @(negedge clk);
        num = 5'b11111;
        @(posedge clk);

        @(negedge clk);
        num = 5'h0A;
        @(posedge clk);
        #1;
        if (segleft != 7'b0001000 || segright != 7'b0001000) begin
            $display("ERROR: pressing A twice did not display AA");
            errors = errors + 1;
        end

        // Test reset after the display has changed
        @(negedge clk);
        reset_n = 0;
        @(posedge clk);
        #1;
        if (segleft != 7'b1000000 || segright != 7'b1000000) begin
            $display("ERROR: mid-simulation reset did not restore 00");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("lab3led_tb: all tests passed");
        else
            $display("lab3led_tb: %0d tests failed", errors);

        $finish;
    end

endmodule
