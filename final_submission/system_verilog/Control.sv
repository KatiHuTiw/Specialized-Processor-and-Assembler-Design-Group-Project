// control decoder
module Control (
  input [4:0] opcode,    // subset of machine code (any width you need)
  input alu_branch,
  output logic [1:0] half_byte,
  output logic jump_en, numBits, doSWAP, RegWrite, MemWrite, ALU_in2_ctr, regfile_dat_ctr,
  regfile_wr_ctr, RXOR, BEQBranch, immOrLUT, stall, done
);	   // for up to 8 ALU operations
parameter ADD = 'b01000, ADDI = 'b11000, SUB = 'b01001, MOV = 'b00100, MOVI = 'b11001,
SHIFT_LEFT = 'b01100, SHIFT_LEFT_I = 'b11100, SHIFT_RIGHT = 'b01101, SHIFT_RIGHT_I = 'b11101, AND = 'b01010,
OR = 'b01011, ROT_L = 'b11110, LOAD_BYTE = 'b10000, STORE_BYTE = 'b10001, LOAD_TOP_BYTE = 'b10110,
STORE_TOP_BYTE = 'b10111, STORE_TOP_BYTE_I = 'b00110, BEQ = 'b00011, SLT = 'b00101, B = 'b00010,
B_LOOKUP = 'b00001, BIT_MASK = 'b00111, XOR_ADD_REG = 'b01110, XOR_REG = 'b01111, SWAP = 'b11111, 
LOAD_LOWER_H_BYTE = 'b11010, LOAD_UPPER_H_BYTE = 'b11011, NOP = 'b00000, DONE = 'b10010, 
AND_MASK_LOOKUP = 'b10011, XOR = 'b10100;

parameter FULL = 2'b00, LOWER = 2'b01, UPPER = 2'b10;
	assign jump_en = (alu_branch)? 1'b1:1'b0;
	always_comb begin
		// Default cases
		immOrLUT = '0;
		numBits = '0;
		doSWAP = '0;
		RegWrite = '0;
		MemWrite = '0;
		ALU_in2_ctr = '0;
		regfile_dat_ctr = '0;
		regfile_wr_ctr = '0;
		RXOR = '0;
		half_byte = FULL;
		BEQBranch = '0;
		done = '0;
		stall = '0;
		case(opcode)
			ADD, SUB, MOV, SHIFT_LEFT, SHIFT_RIGHT, AND, OR, SLT, XOR:begin // Added new instruction: XOR
				RegWrite = '1;
			end
			
			ADDI, MOVI, SHIFT_LEFT_I, SHIFT_RIGHT_I, ROT_L, AND_MASK_LOOKUP:begin // Added new instruction: AND_MASK_LOOKUP
				ALU_in2_ctr = '1; // load immediate
				RegWrite = '1;
			end
			
			BIT_MASK:begin
				RegWrite = '1;
				ALU_in2_ctr = '1; // load immediate
				regfile_wr_ctr = '1; // write result to register R0
				numBits = '1;// 4 bits
			end
			
			SWAP:begin
				doSWAP = '1;
			end
			
			LOAD_BYTE, LOAD_TOP_BYTE: begin
				regfile_dat_ctr = '1;
				RegWrite = '1;
				regfile_wr_ctr = '1; // write result to register R0
				ALU_in2_ctr = '1; // load immediate
			end
			
			STORE_BYTE, STORE_TOP_BYTE: begin
				MemWrite = '1;
				ALU_in2_ctr = '1;// load immediate
			end
			
			STORE_TOP_BYTE_I: begin
				MemWrite = '1;
				ALU_in2_ctr = '1;// load immediate
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
				half_byte = LOWER;
			end
			
			LOAD_UPPER_H_BYTE: begin
				regfile_dat_ctr = '1;
				RegWrite = '1;
				regfile_wr_ctr = '1; // write result to register R0
				ALU_in2_ctr = '1; // load immediate
				half_byte = UPPER;
			end
			
			BEQ: begin
				BEQBranch = '1;
				immOrLUT = '0;
			end
			
			B: begin
				immOrLUT = '0;
			end
			
			B_LOOKUP: begin
				immOrLUT = '1;
			end
			
			NOP: begin
			
			end
			
			DONE: begin
				done = '1;
				stall = '1;
			end
			
			default:begin
			
			end
		endcase
	end

endmodule
