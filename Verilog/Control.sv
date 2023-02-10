// control decoder
module Control (
  input [4:0] opcode,    // subset of machine code (any width you need)
  input alu_branch,
  output [1:0] immOrLUT, imm_ctr,
  output jump_en, numBits, doSWAP, RegWrite, MemWrite, ALU_in2_ctr, regfile_dat_ctr,
  regfile_wr_ctr, RXOR
);	   // for up to 8 ALU operations
parameter ADD = 'b01000, ADDI = 'b11000, SUB = 'b01001, MOV = 'b00100, MOVI = 'b11001,
SHIFT_LEFT = 'b01100, SHIFT_LEFT_I = 'b11100, SHIFT_RIGHT = 'b01101, SHIFT_RIGHT_I = 'b11101, AND = 'b01010,
OR = 'b01011, ROT_L = 'b11110, LOAD_BYTE = 'b10000, STORE_BYTE = 'b10001, LOAD_TOP_BYTE = 'b10110,
STORE_TOP_BYTE = 'b10111, STORE_TOP_BYTE_I = 'b00110, BEQ = 'b00011, SLT = 'b00101, B = 'b00010,
B_LOOKUP = 'b00001, BIT_MASK = 'b00111, XOR_ADD_REG = 'b01110, XOR_REG = 'b01111, SWAP = 'b11111, 
LOAD_LOWER_H_BYTE = 'b11010, LOAD_UPPER_H_BYTE = 'b11011, NOP = 'b00000;

	always_comb begin
		// Default cases
		immOrLUT = '0;
		imm_ctr = '0;
		jump_en = '0;
		numBits = '0;
		doSWAP = '0;
		RegWrite = '0;
		MemWrite = '0;
		ALU_in2_ctr = '0;
		regfile_dat_ctr = '0;
		regfile_wr_ctr = '0;
		RXOR = '0;
		
		case(opcode)
			ADD:begin
				RegWrite = '1;
			end
			
			ADDI:begin
				ALU_in2_ctr = '1;
				RegWrite = '1;
				imm_ctr = 2'b10;// immediate is unsigned
			end
			
			SUB:begin
				RegWrite = '1;
			end
			
			MOV:begin
				RegWrite = '1;
			end
			
			MOVI:begin
				RegWrite = '1;
				ALU_in2_ctr = '1;
				imm_ctr = 2'b10;// immediate is unsigned
			end
			
			SHIFT_LEFT:begin
				RegWrite = '1;
			end
			
			SHIFT_LEFT_I:begin
				RegWrite = '1;
				ALU_in2_ctr = '1;
				imm_ctr = 2'b10;// immediate is unsigned
			end
			
			SHIFT_RIGHT:begin
				RegWrite = '1;
			end
			
			SHIFT_RIGHT_I:begin
				RegWrite = '1;
				ALU_in2_ctr = '1;
				imm_ctr = 2'b10;// immediate is unsigned
			end
			
			AND:begin
				RegWrite = '1;
			end
			
			OR:begin
				RegWrite = '1;
			end
			
			ROT_L:begin
				RegWrite = '1;
				ALU_in2_ctr = '1;
				imm_ctr = 2'b10;// immediate is unsigned
			end
			
			BIT_MASK:begin
				RegWrite = '1;
				ALU_in2_ctr = '1;
				numBits = '1;// 4 bits
				imm_ctr = 2'b10;// immediate is unsigned
			end
			
			SWAP:begin
				doSWAP = '1;
			end
			
			XOR_REG, XOR_ADD_REG: begin
				RegWrite = '1;
				RXOR = '1;
			end
			NOP: begin
			
			end
			
			default:begin
			
			end
		endcase
	end

endmodule
