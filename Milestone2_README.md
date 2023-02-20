# Milestone 2 SystemVerilog Code

### Name: Aaryan Tiwary, Kati Janav Ganga Raj, and Ruilin Hu
### PID: A16201693, A16243098, and A16228816

### Overview

All modules are instantiated inside the top level, within top_level.sv. All module names match their functionality, with some possibly ambiguity in MUX2x1.sv, as there are a few different muxes instantiated in the top_level. The exact functionality of the muxes are indicated by the name of the instances. There is currently one testbench written to briefly test the functionality of the PC's increments, and that files, milestone2_quicktest_tb.sv, is located in the testbench directory. The machine_code.txt file is currently empty but included to prevent errors in the logic synthesis. Also, the parameter definitions are currently private to the modules, so please check the definitions within each module/file.

### File structure:
Milestone 2 Code/                      Root folder
├── testbench/                         Folder for the testbench files
│   ├── milestone2_quicktest_tb.sv     A quick testbench for PC's increments
├── machine_code.txt                   The machine code to store in instruction ROM, remains empty
├── instr_ROM.sv                       The instruction ROM's module
├── top_level.sv                       The top level, contains isntances of all other modules
├── register_mapper.sv                 The mapper for register addresses, used in SWAP
├── reg_file.sv                        The register file's module
├── immediate_Controller.sv            The look up table for the immediates
├── half_byte_parser.sv                The module to extract half a byte from memory reads
├── alu.sv                             The ALU's module
├── PC_Controller.sv                   The module to control PC's branching offsets
├── PC.sv                              The program counter's register and its logic
├── MUX2x1.sv                          A general module for 2x1 muxes
├── Control.sv                         The module of the controller/main combinational logic
├── decoder.sv                         The module that parses the instruction
└── dat_mem.sv                         The module for data memory