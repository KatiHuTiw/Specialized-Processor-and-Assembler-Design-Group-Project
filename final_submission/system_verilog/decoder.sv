module decoderModule(
    input[8:0] binaryCode,
    output[4:0] opcode,
    output[1:0] operand1,
    output[1:0] operand2
);

	assign opcode = binaryCode[8:4];
	assign operand1 = binaryCode[3:2];
	assign operand2 = binaryCode[1:0];

endmodule

