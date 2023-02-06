// control decoder
module Control (
  input [4:0] opcode,    // subset of machine code (any width you need)
  input alu_branch,
  output [1:0] immOrLUT, imm_ctr,
  output jump_en, numBits, doSWAP, RegWrite, MemWrite, ALU_in2_ctr, regfile_dat_ctr
);	   // for up to 8 ALU operations
endmodule