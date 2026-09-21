`timescale 1ns/1ns

// Tests all 16 key mappings and the important FSM transitions

module lab3main_tb();

    logic       clk;
    logic       reset_n;
    logic [3:0] row;
    logic [3:0] col;
    logic [4:0] segout;

    integer errors;

    lab3main dut (
        .clk     (clk),
        .reset_n (reset_n),
        .row     (row),
        .col     (col),
        .segout  (segout)
    );

    // 10 ns clock period
    always begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, lab3main_tb);        

        errors = 0;
        reset_n = 0;
        row = 4'b1000;
        col = 4'b0000;

        repeat (2) @(posedge clk);
        #1;
        if (segout != 5'b11111) begin
            $display("ERROR: reset output should be 11111");
            errors = errors + 1;
        end

        @(negedge clk);
        reset_n = 1;

        // Row 1000: 1, 2, 3, A
        row = 4'b1000; col = 4'b0001;
        @(posedge clk); #1;
        if (segout != 5'h01) begin $display("ERROR: key 1"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after 1"); errors = errors + 1; end

        @(negedge clk); row = 4'b1000; col = 4'b0010;
        @(posedge clk); #1;
        if (segout != 5'h02) begin $display("ERROR: key 2"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after 2"); errors = errors + 1; end

        @(negedge clk); row = 4'b1000; col = 4'b0100;
        @(posedge clk); #1;
        if (segout != 5'h03) begin $display("ERROR: key 3"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after 3"); errors = errors + 1; end

        @(negedge clk); row = 4'b1000; col = 4'b1000;
        @(posedge clk); #1;
        if (segout != 5'h0A) begin $display("ERROR: key A"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after A"); errors = errors + 1; end

        // Row 0100: 4, 5, 6, B
        @(negedge clk); row = 4'b0100; col = 4'b0001;
        @(posedge clk); #1;
        if (segout != 5'h04) begin $display("ERROR: key 4"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after 4"); errors = errors + 1; end

        @(negedge clk); row = 4'b0100; col = 4'b0010;
        @(posedge clk); #1;
        if (segout != 5'h05) begin $display("ERROR: key 5"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after 5"); errors = errors + 1; end

        @(negedge clk); row = 4'b0100; col = 4'b0100;
        @(posedge clk); #1;
        if (segout != 5'h06) begin $display("ERROR: key 6"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after 6"); errors = errors + 1; end

        @(negedge clk); row = 4'b0100; col = 4'b1000;
        @(posedge clk); #1;
        if (segout != 5'h0B) begin $display("ERROR: key B"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after B"); errors = errors + 1; end

        // Row 0010: 7, 8, 9, C
        @(negedge clk); row = 4'b0010; col = 4'b0001;
        @(posedge clk); #1;
        if (segout != 5'h07) begin $display("ERROR: key 7"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after 7"); errors = errors + 1; end

        @(negedge clk); row = 4'b0010; col = 4'b0010;
        @(posedge clk); #1;
        if (segout != 5'h08) begin $display("ERROR: key 8"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after 8"); errors = errors + 1; end

        @(negedge clk); row = 4'b0010; col = 4'b0100;
        @(posedge clk); #1;
        if (segout != 5'h09) begin $display("ERROR: key 9"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after 9"); errors = errors + 1; end

        @(negedge clk); row = 4'b0010; col = 4'b1000;
        @(posedge clk); #1;
        if (segout != 5'h0C) begin $display("ERROR: key C"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after C"); errors = errors + 1; end

        // Row 0001: F, 0, E, D
        @(negedge clk); row = 4'b0001; col = 4'b0001;
        @(posedge clk); #1;
        if (segout != 5'h0F) begin $display("ERROR: key F"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after F"); errors = errors + 1; end

        @(negedge clk); row = 4'b0001; col = 4'b0010;
        @(posedge clk); #1;
        if (segout != 5'h00) begin $display("ERROR: key 0"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after 0"); errors = errors + 1; end

        @(negedge clk); row = 4'b0001; col = 4'b0100;
        @(posedge clk); #1;
        if (segout != 5'h0E) begin $display("ERROR: key E"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after E"); errors = errors + 1; end

        @(negedge clk); row = 4'b0001; col = 4'b1000;
        @(posedge clk); #1;
        if (segout != 5'h0D) begin $display("ERROR: key D"); errors = errors + 1; end
        @(negedge clk); col = 4'b0000;
        @(posedge clk); #1;
        if (segout != 5'b11111) begin $display("ERROR: release after D"); errors = errors + 1; end

        // Two keys in the same row
        @(negedge clk);
        row = 4'b0100;
        col = 4'b0101; // 4 and 6 together
        @(posedge clk);
        #1;
        if (segout != 5'b11111) begin
            $display("ERROR: simultaneous 4 and 6 produced a digit");
            errors = errors + 1;
        end

        // Leave only 4
        @(negedge clk);
        col = 4'b0001;
        @(posedge clk);
        #1;
        if (segout != 5'h04) begin
            $display("ERROR: 4 was not accepted after 6 was released");
            errors = errors + 1;
        end

        // Scanning a different row must not look like releasing 4
        @(negedge clk);
        row = 4'b1000;
        col = 4'b0000;
        @(posedge clk);
        #1;
        if (segout != 5'h04) begin
            $display("ERROR: key 4 was lost while another row was scanned");
            errors = errors + 1;
        end

        // Add 6 while 4 remains held
        @(negedge clk);
        row = 4'b0100;
        col = 4'b0101;
        @(posedge clk);
        #1;
        if (segout != 5'h04) begin
            $display("ERROR: additional key 6 replaced held key 4");
            errors = errors + 1;
        end

        // Release 4 while 6 remains
        @(negedge clk);
        col = 4'b0100;
        @(posedge clk);
        #1;
        if (segout != 5'b11111) begin
            $display("ERROR: releasing original key did not return to waiting");
            errors = errors + 1;
        end

        // Next 6
        @(posedge clk);
        #1;
        if (segout != 5'h06) begin
            $display("ERROR: remaining key 6 was not accepted");
            errors = errors + 1;
        end

        // Final release
        @(negedge clk);
        col = 4'b0000;
        @(posedge clk);
        #1;
        if (segout != 5'b11111) begin
            $display("ERROR: final release failed");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("lab3main_tb: all tests passed");
        else
            $display("lab3main_tb: %0d tests failed", errors);

        $finish;
    end

endmodule
