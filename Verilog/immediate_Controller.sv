module immediate_ctrl #(parameter width = 4)(
    input numBits, // Decide if immediate is 2 (numBits = 0) or 4 bits (numBits = 1)
    input[1:0] immediateInput0, // operand1
	 input[1:0] immediateInput1, // operand2
    output[7:0] immediateValue // Final imm value
);

	assign immediateValue = (numBits)? {6'b0, immediateInput1} : {4'b0, immediateInput0, immediateInput1};
	

endmodule