module lab3main (
    input  logic       clk,
    input  logic       reset_n,
    input  logic [3:0] row,
    input  logic [3:0] col,
    output logic [4:0] segout
);

    // state = 0: waiting for a button
    // state = 1: holding/ignoring additional buttons
    logic state, nextstate;

    // Stored row and column indices
    logic [1:0] rowdummy, rowdummynext;
    logic [1:0] coldummy, coldummynext;

    // Stored hexadecimal value
    logic [4:0] num, numnext;

    // Next-state and output logic
    always_comb begin

        // Default
        nextstate      = state;
        rowdummynext   = rowdummy;
        coldummynext   = coldummy;
        numnext        = num;
        segout         = 5'b11111;

        if (state == 0) begin
            // Waiting for a single button press

            if (row == 4'b1000 && col == 4'b0001) begin
                rowdummynext = 2'd3;
                coldummynext = 2'd0;
                numnext      = 5'd1;
                nextstate    = 1;
            end
            else if (row == 4'b1000 && col == 4'b0010) begin
                rowdummynext = 2'd3;
                coldummynext = 2'd1;
                numnext      = 5'd2;
                nextstate    = 1;
            end
            else if (row == 4'b1000 && col == 4'b0100) begin
                rowdummynext = 2'd3;
                coldummynext = 2'd2;
                numnext      = 5'd3;
                nextstate    = 1;
            end
            else if (row == 4'b1000 && col == 4'b1000) begin
                rowdummynext = 2'd3;
                coldummynext = 2'd3;
                numnext      = 5'hA;
                nextstate    = 1;
            end

            else if (row == 4'b0100 && col == 4'b0001) begin
                rowdummynext = 2'd2;
                coldummynext = 2'd0;
                numnext      = 5'd4;
                nextstate    = 1;
            end
            else if (row == 4'b0100 && col == 4'b0010) begin
                rowdummynext = 2'd2;
                coldummynext = 2'd1;
                numnext      = 5'd5;
                nextstate    = 1;
            end
            else if (row == 4'b0100 && col == 4'b0100) begin
                rowdummynext = 2'd2;
                coldummynext = 2'd2;
                numnext      = 5'd6;
                nextstate    = 1;
            end
            else if (row == 4'b0100 && col == 4'b1000) begin
                rowdummynext = 2'd2;
                coldummynext = 2'd3;
                numnext      = 5'hB;
                nextstate    = 1;
            end

            else if (row == 4'b0010 && col == 4'b0001) begin
                rowdummynext = 2'd1;
                coldummynext = 2'd0;
                numnext      = 5'd7;
                nextstate    = 1;
            end
            else if (row == 4'b0010 && col == 4'b0010) begin
                rowdummynext = 2'd1;
                coldummynext = 2'd1;
                numnext      = 5'd8;
                nextstate    = 1;
            end
            else if (row == 4'b0010 && col == 4'b0100) begin
                rowdummynext = 2'd1;
                coldummynext = 2'd2;
                numnext      = 5'd9;
                nextstate    = 1;
            end
            else if (row == 4'b0010 && col == 4'b1000) begin
                rowdummynext = 2'd1;
                coldummynext = 2'd3;
                numnext      = 5'hC;
                nextstate    = 1;
            end

            else if (row == 4'b0001 && col == 4'b0001) begin
                rowdummynext = 2'd0;
                coldummynext = 2'd0;
                numnext      = 5'hF;
                nextstate    = 1;
            end
            else if (row == 4'b0001 && col == 4'b0010) begin
                rowdummynext = 2'd0;
                coldummynext = 2'd1;
                numnext      = 5'd0;
                nextstate    = 1;
            end
            else if (row == 4'b0001 && col == 4'b0100) begin
                rowdummynext = 2'd0;
                coldummynext = 2'd2;
                numnext      = 5'hE;
                nextstate    = 1;
            end
            else if (row == 4'b0001 && col == 4'b1000) begin
                rowdummynext = 2'd0;
                coldummynext = 2'd3;
                numnext      = 5'hD;
                nextstate    = 1;
            end
        end

        else begin
            // Button is being held
            segout = num;

            
            // Only test for release when nothing is released
            if (row[rowdummy] == 1'b1) begin
                if (col[coldummy] == 1'b0)
                    nextstate = 0;
            end
        end
    end

    // Registers
    always_ff @(posedge clk) begin
        if (reset_n == 0) begin
            state    <= 0;
            rowdummy <= 2'd0;
            coldummy <= 2'd0;
            num      <= 5'b11111;
        end
        else begin
            state    <= nextstate;
            rowdummy <= rowdummynext;
            coldummy <= coldummynext;
            num      <= numnext;
        end
    end

endmodule