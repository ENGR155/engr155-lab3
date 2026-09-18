// Stephen Kanti Mahanty - skantimahanty@hmc.edu
// Made September 9, 2026
// Used to be a seven-segment decoder for the seven-segment display

module lab2_sevenseg(input logic [3:0] s, output logic [6:0] seg);

    // Writing seven segment signal as usual, with s = gfedcba
    always_comb begin
        case(s)
          4'd0:  seg = 7'b1000000;
          4'd1:  seg = 7'b1001111;
          4'd2:  seg = 7'b0100100;
          4'd3:  seg = 7'b0110000;
          4'd4:  seg = 7'b0011001;
          4'd5:  seg = 7'b0010010;
          4'd6:  seg = 7'b0000010;
          4'd7:  seg = 7'b1111000;
          4'd8:  seg = 7'b0000000;
          4'd9:  seg = 7'b0011000;
          4'd10: seg = 7'b0001000;
          4'd11: seg = 7'b0000011;
          4'd12: seg = 7'b1000110;
          4'd13: seg = 7'b0100001;
          4'd14: seg = 7'b0000110;
          4'd15: seg = 7'b0001110;
          default: seg = 7'b1111111;
        endcase
    end
	
endmodule
