module immediate_ctrl #(parameter width = 4)(
    input[1:0] ctrl, // Decide if use LUT (ctrl = 00), sign extend (ctrl = 01), or unsigned (ctrl = 10)
    input numBits, // Decide if immediate is 2 (numBits = 0) or 4 bits (numBits = 1)
    input[1:0] immediateInput0, // operand1
	 input[1:0] immediateInput1, // operand2
    output[7:0] immediateValue // Final imm value
);

parameter LUT = 'b00, sign_extend = 'b01, unsigned_case = 'b10;

	always_comb begin
		immediateValue = '0;
		case(ctrl)
			LUT: begin
			
			end
			
			sign_extend: begin
			
			end
			
			unsigned_case: begin
				if(numBits)
					immediateValue = {4'b0, immediateInput0, immediateInput1};
				else
					immediateValue = {6'b0, immediateInput1};
			end
		endcase
	
	end


endmodule