MOVI R0 0
STORE_TOP_BYTE R0 0 // read_half_bytes = 0
MOVI R0 0
STORE_TOP_BYTE R0 1 // nocross_patter_cnt = 0
MOVI R0 0
STORE_TOP_BYTE R0 2 // found_byte_cnt = 0
MOVI R0 0
STORE_TOP_BYTE R0 3 // cross_patter_cnt = 0
MOVI R3 2 // !!! This line is the startOfLoopP3:
SHIFT_LEFT_I R3 3 // R3 = 0b100000 = 32 // [SHIFT_LEFT Opcode] 11 11 for a total shift amount of 4
LOAD_BYTE R3 0 // Now R0 = mem[32]
NOP 0 //SHIFT_RIGHT_I R0 2 // R0 = R0 >> 3
NOP 0 //SHIFT_LEFT_I R0 2 // R0 = R0 << 3 // Now the lower 3 bits in R0 are zeroed out
STORE_BYTE R3 0 // Put the clean version back in, might not need this line
SWAP R0 R1 // Now R1 = mem[32], the pattern to search
SHIFT_RIGHT_I R1 2 // R1 = R1 >> 3
MOVI R0 0
MOVI R3 3
STORE_TOP_BYTE R3 1 // Set found_in_this_byte to 0 for the current byte
MOVI R3 0
LOAD_TOP_BYTE R3 0
SWAP R3 R0 // Now R3 has read_bytes
LOAD_BYTE R3 0 // R0 now has mem[read_bytes]       
MOV R2 R0 // R2 = R0 = mem[read_bytes]
SHIFT_RIGHT_I R0 2 // R0 = R0 >> 3
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP skipIncrementP3
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 0
SHIFT_RIGHT_I R0 2
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP skipIncrementP3
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 1
SHIFT_RIGHT_I R0 2
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP skipIncrementP3
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 2
SHIFT_RIGHT_I R0 2
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP skipIncrementP3
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
MOVI R3 0
LOAD_TOP_BYTE R3 0
ADDI R0 0 // Increment read_bytes
STORE_TOP_BYTE R3 0 // Store the incremented read_bytes
LOAD_UPPER_H_BYTE R0 0 // Now R0 has mem[read_bytes+1]
SHIFT_RIGHT_I R0 3 // Push the 4 upper bits in mem[read_bytes+1] to the right
SHIFT_LEFT_I R2 3 // R2 = mem[read_bytes][3:0], pushed to the left
ADD R0 R2 // Let R0 = {mem[read_bytes-1][3:0], mem[read_bytes][7:4]}
MOV R2 R0 // Let R2 now back up {mem[read_bytes-1][3:0], mem[read_bytes][7:4]}
SHIFT_RIGHT_I R0 2 // R0 = R0 >> 3
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B +4
MOVI R3 1
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 0
SHIFT_RIGHT_I R0 2
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B +4
MOVI R3 1
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 1
SHIFT_RIGHT_I R0 2
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B +4
MOVI R3 1
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 2
SHIFT_RIGHT_I R0 2
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B +4
MOVI R3 1
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R1 1
LOAD_TOP_BYTE R1 1 // Now R0 = found_byte_cnt
MOV R2 R0 // Let R2 = found_byte_cnt
LOAD_TOP_BYTE R1 3 // Now R0 = found_in_this_byte
BEQ +1 // Skip the next line if found_in_this_byte == 1
B +1
ADDI R2 0 // increment found_byte_cnt only if found_in_this_byte == 1
MOV R0 R2 // Start here if found_in_this_byte != 1
STORE_TOP_BYTE R1 1 // Now R0 = updated found_byte_cnt
MOVI R0 0 // Reset found_in_this_byte to 0
MOVI R3 3
STORE_TOP_BYTE R3 1 // Set found_in_this_byte to 0 for the current byte
MOVI R3 0
LOAD_TOP_BYTE R3 0 // Now R0 = read_bytes
MOVI R1 2 // R1 = 0b10
SHIFT_LEFT_I R1 3 // R1 = 0b100000 = 32
MOVI R3 1
SUB R1 R3 // Now R1 = 0b11111 = 31
BEQ +1 // If this is the last byte, terminate the loop
B_LOOKUP startOfLoopP3 // Make sure R0 has read_bytes before branching back. Otherwise Loop terminated, wrapping up, check the upper 4 bits of the last byte
LOAD_BYTE R1 0 // R0 now has mem[31]
MOV R2 R0 // R2 now has mem[31] back up
ADDI R1 0 // Let R1 = 32
LOAD_BYTE R1 0 // R0 now has the pattern
MOV R1 R0 // Let R1 hold the pattern
NOP // SHIFT_RIGHT_I R1 2 // Push the pattern to the far right and start matching the last byte's upper 4 bits
MOV R2 R0 // R2 = R0 = mem[read_bytes]
SHIFT_RIGHT_I R0 2 // R0 = R0 >> 3
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP skipIncrementP3
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 0
SHIFT_RIGHT_I R0 2
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP skipIncrementP3
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 1
SHIFT_RIGHT_I R0 2
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP skipIncrementP3
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 2
SHIFT_RIGHT_I R0 2
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP skipIncrementP3
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 0
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
MOVI R1 1
LOAD_TOP_BYTE R1 1 // Now R0 = found_byte_cnt
MOV R2 R0 // Let R2 = found_byte_cnt
LOAD_TOP_BYTE R1 3 // Now R0 = found_in_this_byte
BEQ +1 // Skip the next line if found_in_this_byte == 1
B +1
ADDI R2 0 // increment found_byte_cnt only if found_in_this_byte == 1
MOV R0 R2 // Start here if found_in_this_byte != 1 // Store the final results
MOVI R3 2 // Start storing found_byte_cnt
SHIFT_LEFT_I R3 3 // R3 = 0b100000 = 32
STORE_BYTE R3 2 // Store final found_byte_cnt value into mem[34]
MOVI R3 1 // Start storing nocross_patter_cnt
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
MOVI R3 2
SHIFT_LEFT_I R3 3 // R3 = 0b100000 = 32
STORE_BYTE R3 1 // Store final nocross_patter_cnt value into mem[33]
MOVI R3 3 // Start storing cross_patter_cnt
LOAD_TOP_BYTE R3 0 // R0 = cross_patter_cnt
MOVI R3 2
SHIFT_LEFT_I R3 3 // R3 = 0b100000 = 32
STORE_BYTE R3 3 // Store final cross_patter_cnt value into mem[35]
DONE 0