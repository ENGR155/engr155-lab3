// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 9, 2026
// Main Decoder FSM for Lab 3 that collects the pressed input

module lab3main (
    input logic clk, reset_n,
    input logic [3:0] row,
    input logic [3:0] col,
    output logic [4:0] segout // Output number
);


// State defines pressed
logic state, nextstate;

// Dummy variable to check if state is still pressed down
logic [1:0] rowdummy, coldummy;

// Assigning output segments
always_comb begin

    /*
    Sees if state = 1 (thing is pressed and dummy variables match row and column) and ignores the rowdummy and coldummy
    Then if state = 0, scans for the next rowdummy and coldummy
    We have 2 states: pressed and unpressed
    */

    // If everything is off, switch to rows
    if (col == 4'd0) nextstate = 2'd0;
    
    // If releasing a finger - changes the number pressed and has to re-evaluate
    else if (row[rowdummy]) begin
        if (col[coldummy] == 0) nextstate = 2'd0
    end

    else nextstate = 1;

    if (state == 0) begin

        // State 1
        if (row == 4'b1000 && col == 4'b0001) begin
            rowdummy = 2'd3;
            coldummy = 2'd0;
            segout = 5'd1;
            nextstate = 1;
        end

        // State 2
        else if (row == 4'b1000 && col == 4'b0010) begin
            rowdummy = 2'd3;
            coldummy = 2'd1;
            segout = 5'd2;
            nextstate = 1;
        end

        // State 3
        else if (row == 4'b1000 && col == 4'b0100) begin
            rowdummy = 2'd3;
            coldummy = 2'd2;
            segout = 5'd3;
            nextstate = 1;
        end

        // State 4
        else if (row == 4'b0100 && col == 4'b0001) begin
            rowdummy = 2'd2;
            coldummy = 2'd0;
            segout = 5'd4;
            nextstate = 1;
        end

        // State 5
        else if (row == 4'b0100 && col == 4'b0010) begin
            rowdummy = 2'd2;
            coldummy = 2'd1;
            segout = 5'd5;
            nextstate = 1;
        end

        // State 6
        else if (row == 4'b0100 && col == 4'b0100) begin
            rowdummy = 2'd2;
            coldummy = 2'd2;
            segout = 5'd6;
            nextstate = 1;
        end

        // State 7
        else if (row == 4'b0010 && col == 4'b0001) begin
            rowdummy = 2'd1;
            coldummy = 2'd0;
            segout = 5'd7;
            nextstate = 1;
        end

        // State 8
        else if (row == 4'b0010 && col == 4'b0010) begin
            rowdummy = 2'd1;
            coldummy = 2'd1;
            segout = 5'd8;
            nextstate = 1;
        end

        // State 9
        else if (row == 4'b0010 && col == 4'b0100) begin
            rowdummy = 2'd1;
            coldummy = 2'd2;
            segout = 5'd9;
            nextstate = 1;
        end

        // State 0
        else if (row == 4'b0001 && col == 4'b0010) begin
            rowdummy = 2'd0;
            coldummy = 2'd1;
            segout = 5'd0;
            nextstate = 1;
        end

        // State A
        else if (row == 4'b1000 && col == 4'b1000) begin
            rowdummy = 2'd3;
            coldummy = 2'd3;
            segout = 5'hA;
            nextstate = 1;
        end

        // State B
        else if (row == 4'b0100 && col == 4'b1000) begin
            rowdummy = 2'd2;
            coldummy = 2'd3;
            segout = 5'hB;
            nextstate = 1;
        end

        // State C
        else if (row == 4'b0010 && col == 4'b1000) begin
            rowdummy = 2'd1;
            coldummy = 2'd3;
            segout = 5'hC;
            nextstate = 1;
        end

        // State D
        else if (row == 4'b0001 && col == 4'b1000) begin
            rowdummy = 2'd0;
            coldummy = 2'd3;
            segout = 5'hD;
            nextstate = 1;
        end

        // State E
        else if (row == 4'b0001 && col == 4'b0100) begin
            rowdummy = 2'd0;
            coldummy = 2'd2;
            segout = 5'hE;
            nextstate = 1;
        end

        // State F
        else if (row == 4'b0001 && col == 4'b0001) begin
            rowdummy = 2'd0;
            coldummy = 2'd0;
            segout = 5'hF;
            nextstate = 1;
        end

        // State null (default)
        else begin
            rowdummy = 2'd0;
            coldummy = 2'd0;
            segout = 5'd11111;
            nextstate = 0;
        end
    end
end


// State transition
always_ff @(posedge clk, posedge reset_n) begin
    if (reset_n == 0) state <= 0;
    else state <= nextstate;
end

endmodule
