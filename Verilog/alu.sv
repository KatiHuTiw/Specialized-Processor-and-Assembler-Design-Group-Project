// combinational -- no clock
// sample -- change as desired
module alu(
  input[4:0] alu_cmd,    // ALU instructions, at least 5 bits
  input[7:0] inA, inB,	 // 8-bit wide data path for the 2 values
  output logic[7:0] rslt,
  output logic doBranch     // conduct branch for that BEQ instrucion
);

parameter ADD = 'b01000, ADDI = 'b11000, SUB = 'b01001, MOV = 'b00100, MOVI = 'b11001,
SHIFT_LEFT = 'b01100, SHIFT_LEFT_I = 'b11100, SHIFT_RIGHT = 'b01101, SHIFT_RIGHT_I = 'b11101, AND = 'b01010,
OR = 'b01011, ROT_L = 'b11110, LOAD_BYTE = 'b10000, STORE_BYTE = 'b10001, LOAD_TOP_BYTE = 'b10110,
STORE_TOP_BYTE = 'b10111, STORE_TOP_BYTE_I = 'b00110, BEQ = 'b00011, SLT = 'b00101, B = 'b00010,
B_LOOKUP = 'b00001, BIT_MASK = 'b00111, XOR_ADD_REG = 'b01110, XOR_REG = 'b01111, SWAP = 'b11111, 
LOAD_LOWER_H_BYTE = 'b11010, LOAD_UPPER_H_BYTE = 'b11011, NOP = 'b00000;

always_comb begin 
	doBranch = '0;
	rslt = '0;
	
	case (alu_cmd)
	ADD, LOAD_BYTE, STORE_BYTE, LOAD_UPPER_H_BYTE, LOAD_LOWER_H_BYTE: begin
		rslt = inA + inB;
	end
	
	ADDI: begin
		rslt = inA + inB + 'b1;
	end
	
	SUB: begin
		rslt = inA - inB;
	end
	
	SHIFT_LEFT: begin
		rslt = inA << inB;
	end
	
	SHIFT_LEFT_I: begin
		rslt = inA << (inB + 1);
	end
	
	SHIFT_RIGHT: begin
		rslt = inA >> inB;
	end
	
	SHIFT_RIGHT_I: begin
		rslt = inA >> (inB + 1);
	end
	MOV, MOVI: begin
		rslt = inB;
	end
	AND: begin
		rslt = inA & inB;
	end
	
	OR: begin
		rslt = inA | inB;
	end
	
	ROT_L: begin
		// (n << d)|(n >> (8 - d)) to rotate left in 8 bits
		//rslt = (inA << (inB + 1)) | (inA >> (8 - inB + 1)); Does not work I dont know why (Maybe updated value of inA used in scond part)
		case(inB)
			'b0000: rslt = {inA[6:0],inA[7]};
			'b0001: rslt = {inA[5:0],inA[7:6]};
			'b0010: rslt = {inA[4:0],inA[7:5]};
			'b0011: rslt = {inA[3:0],inA[7:4]};
			default: rslt = 'b0;
		endcase
	end
	
	XOR_REG: begin
		rslt = ^inA;
	end
	
	XOR_ADD_REG: begin
		rslt = ^inA | inB;
	end
	
	BIT_MASK: begin
		case(inB)
			'b0000: rslt = 'b11110000;
			'b0001: rslt = 'b10001110;
			'b0010: rslt = 'b01101101;
			'b0011: rslt = 'b01011011;
			'b0100: rslt = 'b00000110;
			'b0101: rslt = 'b00000101;
			default: rslt ='b00000000;
		endcase
	end
	
	LOAD_TOP_BYTE, STORE_TOP_BYTE: begin
		rslt = 8'b11111111 - (inA + inB);
	end
	
	STORE_TOP_BYTE_I: begin
		rslt = 8'b11111111 - inB;
	end
	
	NOP, SWAP: begin
		rslt = '0;
	end
	BEQ: begin
		if(inA == inB)
			doBranch = '1;
		else 
			doBranch = '0;
	end
	
	B, B_LOOKUP: begin
		doBranch = '1;
	end
	
	SLT: begin
		if(inA < inB)
			rslt = 'b1;
		else
			rslt = 'b0;
	end
	
	default: begin
		rslt = '0;
	end
	endcase
end

   
endmodule

