// lookup table
// deep 
// 9 bits wide; as deep as you wish
module instr_ROM #(parameter D=12)(
  input       [D-1:0] prog_ctr,    // prog_ctr	  address pointer
  output logic[ 8:0] mach_code);

  logic[8:0] core[2**D];
  initial							    // load the program
    // Please put the global path for the machine code (C:/....) quartus needs the machine code with the other verilog files and 
    // the simulator checks the simulation/modelsim(quest) folder for the machine code. Specifying global path works on both instances.
    //$readmemb("machine_code.txt",core);

  always_comb  mach_code = core[prog_ctr];

endmodule
