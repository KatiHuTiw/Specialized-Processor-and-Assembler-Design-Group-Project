module immediate_ctrl #(parameter width = 4)(
    input[1:0] ctrl, // Decide if use LUT, sign extend, or unsigned
    input numBits, // Decide if immediate is 2 or 4 bits
    input[3:0] immediateInput, // Input from the instruction
    output[7:0] immediateValue // Final imm value
);
endmodule