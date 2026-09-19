// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 18, 2026
// Decoder module that takes a number and converts it into two LEDs

module lab3led(
    input logic clk, reset_n,
    input logic [4:0] num, // input number
    output logic [6:0] segleft, segright // left and right segments
);

// Two states - Nothing (or null) is pressed, new number is pressed
logic state, nextstate;

logic [3:0] numdummy; // Dummy variable for switching
logic [6:0] segleft_normal, segleft_next; // Dummy segment variable (next is the next value in left, normal is the current left stuff)
logic [6:0] segright_normal, segright_next; // Dummy segment variable (next is the next value in right, normal is the current right stuff)

// Segment output dummy variable
logic [6:0] segrightdummy;
logic [4:0] num2; // Num variable that checks if it's the same

// Segment display for the new variable
    lab2_sevenseg sevenseg_decoder (
    .s   (num[3:0]),
    .seg (segrightdummy)
    );

// Next state logic
always_comb begin
    if (num == 5'b11111) or (num2 == num) begin
         nextstate = 0;
         segleft_normal = segleft_next; // Same left value
         segright_normal = segright_next; // Same right value
    end
    else begin
        segleft_normal = segright; // Shifts to left
        segright_normal = segrightdummy;
        nextstate = 1; // New number pressed
    
    end
end

// State transition
always_ff @(posedge clk, posedge reset_n) begin
    if (reset_n == 0) begin
        state <= 0;
        segleft_normal <= 7'b1000000; // Initial state of 0
        segright_normal <= 7'b1000000;
    end
    else begin
        num2 <= num;
        state <= nextstate;
        segleft_normal <= segleft_next; // Shifts to the next left
        segright_normal <= segright_next; // New right
    end
end

// Final assign logic
assign segleft = segleft_normal;
assign segright = segright_normal;

endmodule