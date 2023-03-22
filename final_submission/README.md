# Final Submission

### Name: Aaryan Tiwary, Kati Janav Ganga Raj, and Ruilin Hu
### PID: A16201693, A16243098, and A16228816

## Overview

1) Programs 1, 2 and 3 work for our group when the inputs are randomized, or all-zero/all-one inputs are given. The testbench's automatic scoreboard shows perfect scores at the end of simulation, which all terminate normally.
2) Initially, after the first draft of assembly and their machine code was completed, none of our programs were working with the testbench that was given to us. During the submission of milestone 1, we had written the C code and assembly fully for program 1 and program 3. Though Program 2’s C code was done, we hadn’t been able to finish its assembly code yet. We had also been able to come up with the first draft for the assembly instructions we wanted for our programs. For milestone 2, we finished the assembly code for program 2 and started to implement components in SystemVerilog. This was built upon the starter code files that we obtained from the professor. The additional .sv files we wrote were PC_Controller.sv, half_byte_parser.sv and register_mapper.sv. Most of the implementation was finished by milestone 3's submission and we were able to get down to testing individual program implementations. We started by checking if our basic implementation was working with some elementary tests on smaller components and most of our instructions were working as desired. All our main testing began after Milestone 3's completion. When first testing with the professor's program testbenches on canvas, none of the three programs passed and results were showing as all x. Program 1 was relatively easy to fix but programs 2 and 3 required some more  debugging on the software side. After examining the waveforms produced by the simulation on testbench, we figured out the mistakes in some specific instructions, specifically the branching instructions. After making sure the branches all take place properly, we are able to pass basic tests in the testbench, and we started altering the professor's test bench to run some more demanding tests to comprehensively test our design and debug programs 1,2 and 3. Small problems occurred with instructions that deal with immediate values. However, these problems were quickly fixed and the program and our design were able to pass the test cases with ease.

## Overview

All modules are instantiated inside the top level, within top_level.sv. All module names match their functionality, with some possibly ambiguity in MUX2x1.sv, as there are a few different muxes instantiated in the top_level. The exact functionality of the muxes are indicated by the name of the instances.

## File Structure

final_submission/                      Root folder
├── systemVerilog/                     The folder containing all .sv files
│   ├── testbenches/                   The folder for the testbench files (after rewiring)
│   |   ├── prog1.sv                   Testbench file for Program 1
│   |   ├── prog2.sv                   Testbench file for Program 2
│   |   ├── prog3.sv                   Testbench file for Program 3
│   ├── alu.sv                         The ALU's module
│   ├── Control.sv                     The module of the controller/main combinational logic
│   ├── dat_mem.sv                     The module for the storage unit data memory
│   ├── decoder.sv                     The module that parses the instruction
│   ├── half_byte_parser.sv            The module to extract half a byte from memory reads
│   ├── immediate_Controller.sv        The look up table for the immediates
│   ├── instr_ROM.sv                   The instruction memory's module
│   ├── MUX2x1.sv                      A general module for 2x1 muxes
│   ├── PC_Controller.sv               The module to control PC's branching offsets
│   ├── PC.sv                          The program counter's register and its logic
│   ├── reg_file.sv                    The register file's module
│   ├── register_mapper.sv             The mapper for register addresses, used in SWAP
│   ├── top_level.sv                   The top level, contains isntances of all modules 
├── assembler/                         The folder containing all assemble files
│   ├── program1_assembler.cpp         Assemble file to assemble Program1's bianry
│   ├── program2_assembler.cpp         Assemble file to assemble Program2's bianry
│   ├── program3_assembler.cpp         Assemble file to assemble Program3's bianry
|	(The three assembler are the same other than the name of the input file.)
├── assembly/                          The folder containing all assembly files
│   ├── Program1.S                     Assembly file for Program 1
│   ├── Program2.S                     Assembly file for Program 2
│   ├── Program3.S                     Assembly file for Program 3
├── machine_code/                      The folder containing all assembled machine codes
│   ├── Program1.txt                   Assembled machine code for Program 1
│   ├── Program2.txt                   Assembled machine code for Program 2
│   ├── Program3.txt                   Assembled machine code for Program 3
├── README.md                          The currently open description file

## How to utilize the files?

### To assemble the assembly files: (GNU c++ compiler installation required)
Step 0: On the command line, go to/cd into the "assembler" folder.
Step 1: Compile the assembler file for the designated program using command g++ program1_assembler.cpp for program 1, g++ program2_assembler.cpp for program 2, and g++ program3_assembler.cpp for program 3.
Step 2: Run the executable generated for the assembler file, a.out on a MacBook or a.exe on a window machine. A new .txt file should be generated within the same directory containing the binary for the specified program.
Step 3: Locate the generated file called machine_code.txt within the current folder, which contains the binary executable for the selected program. Use the absolute path to this file in instruction_ROM.sv during synthesis and simulation.

### To synthesize: (Quartus installation required)
Step 0: modify the file path in instruction_ROM.sv (under systemVerilog/ directory) into the absolute path to the previously generated machine_code.txt.
Step 1: create a new project in Quartus.
Step 2: use appropriate project settings as suggested in the Term Project writeup.
Step 3: When prompted, select all the files (excluding the testbench/ direction) in SystemVerilog/ directory.
Step 4: When all the files are loaded into the project, start compilation in Quartus. After the compilation succeeded, open up RTL Viewer to check the Schematic for the design.

### To simulate: (Questa/ModelSim installation required)
Step 1: create a new project in Questa/ModelSim.
Step 2: when prompted to add files, select all the files (excluding the testbench/ direction) in SystemVerilog/ directory and add them to project.
Step 3: Under "Compile" options, click "Compile All" to compile all design files.
Step 4: Under "Compile" options, click "Compile" and find the testbench for each of the programs under the systemVerilog/ directory's testbenches/ directory. Select the desired testbanch to compile.
Step 5: Start simulation with the compiled testbench module, and click "Run all." The testbench will terminate automatically and outputs and scoreboards will be presented on the transcript.