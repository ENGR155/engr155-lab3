// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 9, 2026
// Used to be a counter to scan a keypad

module lab2_scanner #(parameter width = 24, parameter logic [width-1:0] max_count = 11_999_999)(// Params
     input  logic reset_n, clk, enable, // Clock input
     output logic [3:0] rows
 );

    logic [width-1:0] count2;
    logic [1:0] state;

  // Sets up a counter for the multiplexer
  counter #(
      .width     (width),
      .max_count (max_count)
  ) count (
      .reset_n  (reset_n),
      .clk    (clk),
      .enable (enable),
      .count2  (count2)
    );

  // Assigning final logic and switching
  always_comb begin
    if (count2 < max_count/4) 
        state = 2'b00;
    else if (count2 < max_count/2)
        state = 2'b01;
    else if (count2 < 3*max_count/4)
        state = 2'b10;
    else 
        state = 2'b11;
  end

  // Assign row data
  assign rows = (state == 2'b00) ? 4'b1000 :
                (state == 2'b01) ? 4'b0100 :
                (state == 2'b10) ? 4'b0010 :
                                   4'b0001;

endmodule