// sample top level design
module top_level #(parameter D=12)(
    input        clk, reset,
    output logic done);

// PC and PC Controller wires
logic [D-1:0] jump_dist;
logic immOrLUT;
logic jump_en;
logic [D-1:0] prog_ctr;

// Instruction ROM and Decoder wires
logic [8:0] currentInstruction;
logic [4:0] opcode;
logic [1:0] operand1, operand2;

// Immediate wires
logic numBits;
logic [7:0] imm_output;

// Register wires
logic doSWAP, RegWrite, regfile_dat_ctr, regfile_wr_ctr;
logic [7:0] regfile_dat, dat1, dat2;
logic [1:0] register_wr_addr;
logic [1:0] XOR_not_selected;
logic [7:0] store_data;

// wires to connect branchreg select mux with reg
logic[1:0] op1, op1_mapped;
logic[1:0] op2, op2_mapped;
// Instantiate Program Counter

// wire for XOR specific register selection
logic RXOR;
// wire for BEQ control signal
logic BEQSig;

// ALU wires
logic alu_branch, ALU_in2_ctr;
logic [7:0] ALU_in2, ALU_rslt;

// Data mem wires
logic [7:0] dat_out;
logic MemWrite;

// Wires for half byte
logic[7:0] processed_data;
logic[1:0] select_bytes;

// Wire for connecting unmapped register write address to the mapper
logic[1:0] write_reg_unmapped;
// Stall pc 
logic pc_stall;


PC #(.D(D)) pc1 (
    .reset(reset),
    .clk(clk),
	 .stall(pc_stall),
    .jump_en (jump_en),
    .target(jump_dist),
    .prog_ctr(prog_ctr)
);

// Instantiate Program Counter lookuptable
PC_Controller #(.D(D)) pc1_ctrl (
    .immOrLUT(immOrLUT),
    .pc_ctrl_input({operand1, operand2}),
    .target (jump_dist)
);


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

immediate_ctrl immediate_ctrl1 (
    .numBits(numBits),
    .immediateInput0(operand1),
	 .immediateInput1(operand2),
    .immediateValue(imm_output)
);

reg_file rf1(
    .dat_in(regfile_dat),	   // loads, most ops
    .clk(clk)         ,
    .wr_en   (RegWrite),
    .rd_addrA(op1_mapped),
    .rd_addrB(op2_mapped),
    .wr_addr (register_wr_addr),      // in place operation
    .datA_out(dat1),
    .datB_out(dat2),
	 .dat0_out(store_data)
);

mux_2x1 reg_dat_mux (
    .in1(ALU_rslt),
    .in2(processed_data),
    .selector(regfile_dat_ctr),
    .out(regfile_dat)
);


mux_2x1 #(.len(2)) op1_branch_mux  (
    .in1(operand1),
    .in2(2'b00),
    .selector(BEQSig),
    .out(op1)
);

mux_2x1 #(.len(2)) op2_branch_mux  (
    .in1(operand2),
    .in2(2'b01),
    .selector(BEQSig),
    .out(op2)
);


// Implement Register Mapper to realize SWAP functionality
Register_Mapper reg_mapper (
    .reg1(op1),
    .reg2(op2),
	 .reg_write(write_reg_unmapped),
    .clk(clk),
    .reset(reset),
    .doSWAP(doSWAP),
    .reg1_mapped(op1_mapped),
    .reg2_mapped(op2_mapped),
	 .reg_write_mapped(register_wr_addr)
);

mux_2x1 #(.len(2)) reg_wr_mux  (
    .in1(operand1),
    .in2(2'b00),
    .selector(regfile_wr_ctr),
    .out(XOR_not_selected)
);

mux_2x1 #(.len(2)) xor_operand_select_mux (
    .in1(XOR_not_selected),
    .in2(operand2),
    .selector(RXOR),
    .out(write_reg_unmapped)
);


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

dat_mem dm1 (
    .dat_in(store_data)  ,  // from reg_file
    .clk(clk),
    .wr_en  (MemWrite), // stores
    .addr   (ALU_rslt),
    .dat_out(dat_out)
);


half_byte_parser hbparser (
    .load_state(select_bytes),   
   .in(dat_out),	 
   .rslt(processed_data)
);

Control ctrl1 (
    .opcode(opcode),
    .alu_branch(alu_branch),
    .immOrLUT(immOrLUT),
    .jump_en(jump_en),
    .numBits(numBits), 
    .doSWAP(doSWAP), 
    .RegWrite(RegWrite), 
    .MemWrite(MemWrite), 
    .ALU_in2_ctr(ALU_in2_ctr), 
    .regfile_dat_ctr(regfile_dat_ctr),
    .regfile_wr_ctr(regfile_wr_ctr),
	 .RXOR(RXOR),
	 .half_byte(select_bytes),
	 .BEQBranch(BEQSig),
	 .stall(pc_stall),
	 .done(done)
);

endmodule
