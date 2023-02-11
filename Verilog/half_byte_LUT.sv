module half_byte_LUT(
  input[1:0] load_state,   
  input[7:0] in,	 
  output logic[7:0] rslt
);
	parameter FULL = 2'b00, LOWER = 2'b01, UPPER = 2'b10;
	always_comb begin
		case(load_state)
			FULL: rslt = in;
			LOWER: rslt = {4'b0, in[3:0]};
			UPPER: rslt = {in[3:0], 4'b0};
			default: rslt = in;
		endcase
	end


endmodule