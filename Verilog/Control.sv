// control decoder
module Control (
  input [4:0] opcode,    // subset of machine code (any width you need)
  input alu_branch,
  output [1:0] immOrLUT, imm_ctr, half_byte,
  output jump_en, numBits, doSWAP, RegWrite, MemWrite, ALU_in2_ctr, regfile_dat_ctr,
  regfile_wr_ctr, RXOR
);	   // for up to 8 ALU operations
parameter ADD = 'b01000, ADDI = 'b11000, SUB = 'b01001, MOV = 'b00100, MOVI = 'b11001,
SHIFT_LEFT = 'b01100, SHIFT_LEFT_I = 'b11100, SHIFT_RIGHT = 'b01101, SHIFT_RIGHT_I = 'b11101, AND = 'b01010,
OR = 'b01011, ROT_L = 'b11110, LOAD_BYTE = 'b10000, STORE_BYTE = 'b10001, LOAD_TOP_BYTE = 'b10110,
STORE_TOP_BYTE = 'b10111, STORE_TOP_BYTE_I = 'b00110, BEQ = 'b00011, SLT = 'b00101, B = 'b00010,
B_LOOKUP = 'b00001, BIT_MASK = 'b00111, XOR_ADD_REG = 'b01110, XOR_REG = 'b01111, SWAP = 'b11111, 
LOAD_LOWER_H_BYTE = 'b11010, LOAD_UPPER_H_BYTE = 'b11011, NOP = 'b00000;

parameter FULL = 2'b00, LOWER = 2'b01, UPPER = 2'b10;

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
		half_byte = FULL;
		
		case(opcode)
			ADD, SUB, MOV, SHIFT_LEFT, SHIFT_RIGHT, AND, OR:begin
				RegWrite = '1;
			end
			
			ADDI, MOVI, SHIFT_LEFT_I, SHIFT_RIGHT_I, ROT_L:begin
				ALU_in2_ctr = '1; // load immediate
				RegWrite = '1;
				imm_ctr = 2'b10;// immediate is unsigned
			end
			
			BIT_MASK:begin
				RegWrite = '1;
				ALU_in2_ctr = '1; // load immediate
				regfile_wr_ctr = '1; // write result to register R0
				numBits = '1;// 4 bits
				imm_ctr = 2'b10;// immediate is unsigned
			end
			
			SWAP:begin
				doSWAP = '1;
			end
			
			LOAD_BYTE, LOAD_TOP_BYTE: begin
				regfile_dat_ctr = '1;
				RegWrite = '1;
				regfile_wr_ctr = '1; // write result to register R0
				ALU_in2_ctr = '1; // load immediate
				imm_ctr = 2'b10;// immediate is unsigned
			end
			
			STORE_BYTE, STORE_TOP_BYTE: begin
				MemWrite = '1;
				ALU_in2_ctr = '1;// load immediate
				imm_ctr = 2'b10;// immediate is unsigned
			end
			
			STORE_TOP_BYTE_I: begin
				MemWrite = '1;
				ALU_in2_ctr = '1;// load immediate
				imm_ctr = 2'b10;// immediate is unsigned
				numBits = '1;// 4 bits
			end
			
			XOR_REG, XOR_ADD_REG: begin
				RegWrite = '1;
				RXOR = '1;
			end
			
			LOAD_LOWER_H_BYTE: begin
				regfile_dat_ctr = '1;
				RegWrite = '1;
				regfile_wr_ctr = '1; // write result to register R0
				ALU_in2_ctr = '1; // load immediate
				imm_ctr = 2'b10;// immediate is unsigned
				half_byte = LOWER;
			end
			LOAD_UPPER_H_BYTE: begin
				regfile_dat_ctr = '1;
				RegWrite = '1;
				regfile_wr_ctr = '1; // write result to register R0
				ALU_in2_ctr = '1; // load immediate
				imm_ctr = 2'b10;// immediate is unsigned
				half_byte = UPPER;
			end
			
			
			NOP: begin
			
			end
			
			default:begin
			
			end
		endcase
	end

endmodule
