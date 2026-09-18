// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 9, 2026
// Multiplexer module that multiplexes two seven-segment displays

module counter #(parameter width = 24, parameter logic [width-1:0] max_count = 199_999)(
    input  logic reset_n, clk, enable,
    output logic [width-1:0] count2
);

logic [width-1:0] count = 0;

    // Counter
   always_ff @(posedge clk) begin
     if(reset_n == 0) begin
      count <= 0;
     end
     else if(enable) begin
      if(count == max_count) begin // Max count
        count <= 0;
      end
      else count <= count + 1;
     end
   end
    
   // Assign LED output
   assign count2 = count;

endmodule