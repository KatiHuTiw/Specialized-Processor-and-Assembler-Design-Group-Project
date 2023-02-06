// sample top level design
module top_level #(parameter D=12)(
    input        clk, reset, req, 
    output logic done);

// PC and PC Controller wires
logic [D-1:0] jump_dist;
logic [1:0] immOrLUT;
logic jump_en;
logic [D-1:0] prog_ctr;

// Instantiate Program Counter
PC #(.D(D)) pc1 (
    .reset(reset),
    .clk(clk),
    .jump_en (jump_en),
    .target(jump_dist),
    .prog_ctr(prog_ctr)
);

// Instantiate Program Counter lookuptable
PC_Controller #(.D(D)) pc1_ctrl (
    .immOrLUT(immOrLUT),
    .input({operand1, operand2}),
    .target (jump_dist)
);

// Instruction ROM and Decoder wires
logic [8:0] currentInstruction;
logic [4:0] opcode;
logic [1:0] operand1, operand2;

instr_ROM #(.D(D)) instructions (
    .prog_ctr(prog_ctr),
    .mach_code(currentInstruction)
);

decoderModule dec1 (
    .binaryCode(currentInstruction),
    .opcode(opcode),
    .operand1(operand1),
    .operand2(operand2)
);

// Immediate wires
logic [1:0] imm_ctr;
logic numBits;
logic [7:0] imm_output;

immLUT immediate_ctrl (
    .ctrl(imm_ctr),
    .numBits(numBits)
    .immediateInput({operand1, operand2}),
    .immediateValue(imm_output)
);

// Register wires
logic doSWAP, RegWrite, regfile_dat_ctr, regfile_wr_ctr;
logic [7:0] regfile_dat, dat1, dat2;
logic [1:0] register_wr_addr;

reg_file #(.pw(3)) rf1(
    .dat_in(regfile_dat),	   // loads, most ops
    .clk(clk)         ,
    .wr_en   (RegWrite),
    .rd_addrA(operand1),
    .rd_addrB(operand2),
    .wr_addr (register_wr_addr),      // in place operation
    .doSWAP(doSWAP),          // SWAP instruction signal
    .datA_out(dat1),
    .datB_out(dat2)
);

mux_2x1 reg_dat_mux (
    .in1(ALU_rslt),
    .in2(dat_out),
    .selector(regfile_dat_ctr),
    .out(regfile_dat)
);

mux_2x1 reg_wr_mux (
    .in1(operand1),
    .in2(2'b0),
    .selector(regfile_wr_ctr),
    .out(register_wr_addr)
);

// ALU wires
logic alu_branch, ALU_in2_ctr;
logic [7:0] ALU_in2, ALU_rslt;

alu alu1 (
    .alu_cmd(opcode), // More than half if the instructions have to do with ALU
    .inA(dat1),
    .inB(ALU_in2),
    .rslt(ALU_rslt),
    .doBranch(alu_branch) // ALU controls if jump is enabled
);

mux_2x1 alu_in2_mux (
    .in1(dat2),
    .in2(imm_output),
    .selector(ALU_in2_ctr),
    .out(ALU_in2)
);

// Data mem wires
logic [7:0] dat_out;
logic MemWrite;

dat_mem dm1(
    .dat_in(regfile_dat)  ,  // from reg_file
    .clk(clk),
    .wr_en  (MemWrite), // stores
    .addr   (ALU_rslt),
    .dat_out(dat_out)
);

endmodule