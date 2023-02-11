module PC_Controller #(parameter D=12)(
	input        immOrLUT,   // Decide to use immediate or LUT value
	input       [ 3:0] pc_ctrl_input,	   // 4 bits = 16 different LUT value
	output logic[D-1:0] target
);
logic [7:0] offset;

assign target = offset;

  always_comb begin
	if(immOrLUT) begin
		case(pc_ctrl_input)
			// add signed bits to target
				'b0000: offset = 'b11111011;   // go back 5 spaces
				'b0001: offset = 'b00010100;   // go ahead 20 spaces
				'b0010: offset = 'b11111111;   // go back 1 space   1111_1111_1111
				default: offset = 'b0;  // hold PC  
		endcase
	end
	else begin
		offset = pc_ctrl_input;
	end
	
  end

endmodule
