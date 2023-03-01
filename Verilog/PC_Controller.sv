module PC_Controller #(parameter D=12)(
	input        immOrLUT,   // Decide to use immediate or LUT value
	input       [ 3:0] pc_ctrl_input,	   // 4 bits = 16 different LUT value
	output logic[D-1:0] target
);
logic [D-1:0] offset;

assign target = offset;

  always_comb begin
	if(immOrLUT) begin
		case(pc_ctrl_input)
			// Send signed bits. ALL VALUES IN THE LUT ARE SIGNED!!!!
				4'b0000: offset = 12'b111111111011;   // go back 5 spaces
				4'b0001: offset = 12'b000000010100;   // go ahead 20 spaces
				4'b0010: offset = 12'b111111111111;   // go back 1 space   1111_1111_1111
				4'b1101: offset = 12'b111101111110;        // Go to startOfLoopP2Alt, -130
				4'b1110: offset = 12'b000000001101;   // Go to notOneError for Program 2 Alt, +13
				4'b1111: offset = 12'b111110001000;   // Go to startOfLoopP3 for Program 3, -120
				default: offset = 12'b0;  // hold PC  
		endcase
	end
	else begin
		offset = {{D-4{pc_ctrl_input[3]}},pc_ctrl_input};// sign extend and send
	end
	
  end

endmodule
