// New instructions:
// B_LOOKUP
// branch look up table
// SHIFT_RIGHT_I
// Shift to the right by an immediate

// Local Variables     location in top memory     initial value
// read_bytes                    0                      0
// nocross_patter_cnt            1                      0
// found_byte_cnt                2                      0
// cross_patter_cnt              3                      0
// found_in_this_byte            4                      0

// Underlying logic:
// R0 = mem[read_bytes]
// R1 = mem[32] copy, the pattern *pushed to the right*
// R2 = mem[read_bytes] or half mem[read_bytes-1] half mem[read_bytes]
// R3 = temp reg

// .Lnomatch1: block matches bit 7-3
// .Lnomatch2: block matches bit 6-2
// .Lnomatch3: block matches bit 5-1
// .Lnomatch4: block matches bit 4-0
// The latter 4 can be converted to B with offset +4 (skipping 4 lines).
// (The previous 4 can probably convert as well with some smart change in instruction order.)
// .Lnomatch5: block matches between byte (first bit 3-0 and second bit 7)
// .Lnomatch6: block matches between byte (first bit 2-0 and second bit 7-6)
// .Lnomatch7: block matches between byte (first bit 1-0 and second bit 7-5)
// .Lnomatch8: block matches between byte (first bit 0 and second bit 7-4)
// .Lnomatchlast1: block matches bit 7-3 for mem[31]
// .Lnomatchlast2: block matches bit 6-2 for mem[31]
// .Lnomatchlast3: block matches bit 5-1 for mem[31]
// .Lnomatchlast4: block matches bit 4-0 for mem[31]
// (The 4 above can probably convert as well with some smart change in instruction order as well.)

// Initialize locals
MOVI R0 0
STORE_TOP_BYTE R0 0 // read_half_bytes = 0
MOVI R0 0
STORE_TOP_BYTE R0 1 // nocross_patter_cnt = 0
MOVI R0 0
STORE_TOP_BYTE R0 2 // found_byte_cnt = 0
MOVI R0 0
STORE_TOP_BYTE R0 3 // cross_patter_cnt = 0

MOVI R3 2
SHIFT_LEFT_I R3 4 // R3 = 0b100000 = 32
// [SHIFT_LEFT Opcode] 11 11 for a total shift amount of 4
LOAD_BYTE R3 0 // Now R0 = mem[32]
SHIFT_RIGHT_I R0 3 // R0 = R0 >> 3
SHIFT_LEFT_I R0 3 // R0 = R0 << 3
// Now the lower 3 bits in R0 are zeroed out
STORE_BYTE R3 0 // Put the clean version back in, might not need this line
SWAP R0 R1 // Now R1 = mem[32], the pattern to search
SHIFT_RIGHT_I R1 3 // R1 = R1 >> 3


MOVI R0 0
MOVI R3 3
STORE_TOP_BYTE R3 1 // Set found_in_this_byte to 0 for the current byte
MOVI R3 0
LOAD_TOP_BYTE R3 0
SWAP R3 R0 // Now R3 has read_bytes

.LstartOfLoop:
LOAD_BYTE R3 0 // R0 now has mem[read_bytes]
MOV R2 R0 // R2 = R0 = mem[read_bytes]
SHIFT_RIGHT_I R0 3 // R0 = R0 >> 3
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP .Lnomatch1
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
.Lnomatch1:
// Starts here if R0 != R1 and patter is not the same
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 1
SHIFT_RIGHT_I R0 3
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP .Lnomatch2
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
.Lnomatch2:
// Starts here if R0 != R1 and patter is not the same
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 2
SHIFT_RIGHT_I R0 3
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP .Lnomatch3
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
.Lnomatch3:
// Starts here if R0 != R1 and patter is not the same
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 3
SHIFT_RIGHT_I R0 3
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP .Lnomatch4
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
.Lnomatch4:
// Starts here if R0 != R1 and patter is not the same

// Now checking transition part

// Increment read_bytes for the previous byte
MOVI R3 0
LOAD_TOP_BYTE R3 0
ADDI R0 1 // Increment read_bytes
STORE_TOP_BYTE R3 0 // Store the incremented read_bytes
LOAD_UPPER_H_BYTE R0 0 // Now R0 has mem[read_bytes+1]
SHIFT_RIGHT_I R0 4 // Push the 4 upper bits in mem[read_bytes+1] to the right
SHIFT_LEFT_I R2 4 // R2 = mem[read_bytes][3:0], pushed to the left
ADD R0 R2 // Let R0 = {mem[read_bytes-1][3:0], mem[read_bytes][7:4]}
MOV R2 R0 // Let R2 now back up {mem[read_bytes-1][3:0], mem[read_bytes][7:4]}
SHIFT_RIGHT_I R0 3 // R0 = R0 >> 3
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP .Lnomatch5
MOVI R3 1
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
.Lnomatch5:
// Starts here if R0 != R1 and patter is not the same
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 1
SHIFT_RIGHT_I R0 3
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP .Lnomatch6
MOVI R3 1
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
.Lnomatch6:
// Starts here if R0 != R1 and patter is not the same
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 2
SHIFT_RIGHT_I R0 3
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP .Lnomatch7
MOVI R3 1
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
.Lnomatch7:
// Starts here if R0 != R1 and patter is not the same
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 3
SHIFT_RIGHT_I R0 3
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP .Lnomatch8
MOVI R3 1
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
.Lnomatch8:
// Starts here if R0 != R1 and patter is not the same

// Now the current byte is completely processed
// Increment found_byte_cnt if found_in_this_byte is set to 1 for this byte
MOVI R1 1
LOAD_TOP_BYTE R1 1 // Now R0 = found_byte_cnt
MOV R2 R0 // Let R2 = found_byte_cnt
LOAD_TOP_BYTE R1 3 // Now R0 = found_in_this_byte
BEQ +1 // Skip the next line if found_in_this_byte == 1
B +1
ADDI R2 1 // increment found_byte_cnt only if found_in_this_byte == 1
MOV R0 R2 // Start here if found_in_this_byte != 1
STORE_TOP_BYTE R1 1 // Now R0 = updated found_byte_cnt
MOVI R0 0 // Reset found_in_this_byte to 0
MOVI R3 3
STORE_TOP_BYTE R3 1 // Set found_in_this_byte to 0 for the current byte

// Check if this is the last byte
MOVI R3 0
LOAD_TOP_BYTE R3 0 // Now R0 = read_bytes
MOV R1 2 // R1 = 0b10
SHIFT_LEFT_I R1 4 // R1 = 0b100000 = 32
MOVI R3 1
SUB R1 R3 // Now R1 = 0b11111 = 31
BEQ +1 // If this is the last byte, terminate the loop
B +1
B .LstartOfLoop: // Make sure R0 has read_bytes before branching back
// Loop terminated, wrapping up, check the upper 4 bits of the last byte
LOAD_BYTE R1 0 // R0 now has mem[31]
MOV R2 R0 // R2 now has mem[31] back up
ADDI R1 1 // Let R1 = 32
LOAD_BYTE R1 0 // R0 now has the pattern
MOV R1 R0 // Let R1 hold the pattern
SHIFT_RIGHT_I R1 3 // Push the pattern to the far right
// Start matching the last byte's upper 4 bits
MOV R2 R0 // R2 = R0 = mem[read_bytes]
SHIFT_RIGHT_I R0 3 // R0 = R0 >> 3
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP .Lnomatchlast1
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
.Lnomatchlast1:
// Starts here if R0 != R1 and patter is not the same
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 1
SHIFT_RIGHT_I R0 3
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP .Lnomatchlast2
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
.Lnomatchlast2:
// Starts here if R0 != R1 and patter is not the same
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 2
SHIFT_RIGHT_I R0 3
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP .Lnomatchlast3
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
.Lnomatchlast3:
// Starts here if R0 != R1 and patter is not the same
MOV R0 R2 // R0 now has mem[read_bytes], stored in R2
SHIFT_LEFT_I R0 3
SHIFT_RIGHT_I R0 3
BEQ +1 // Skip the next line if R0 = R1, meaning the pattern matches
B_LOOKUP .Lnomatchlast4
MOVI R3 1
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 0 // Increment nocross_patter_cnt
LOAD_TOP_BYTE R3 2 // R0 = cross_patter_cnt
ADDI R0 1
STORE_TOP_BYTE R3 2 // Increment cross_patter_cnt
MOVI R0 1
STORE_TOP_BYTE R3 3 // Set found_in_this_byte to 1 for the current byte
.Lnomatchlast4:
// Starts here if R0 != R1 and patter is not the same

// Now the last byte is completely processed
// Increment found_byte_cnt if found_in_this_byte is set to 1 for this byte
MOVI R1 1
LOAD_TOP_BYTE R1 1 // Now R0 = found_byte_cnt
MOV R2 R0 // Let R2 = found_byte_cnt
LOAD_TOP_BYTE R1 3 // Now R0 = found_in_this_byte
BEQ +1 // Skip the next line if found_in_this_byte == 1
B +1
ADDI R2 1 // increment found_byte_cnt only if found_in_this_byte == 1
MOV R0 R2 // Start here if found_in_this_byte != 1
// Store the final results
MOVI R3 2 // Start storing found_byte_cnt
SHIFT_LEFT_I R3 4 // R3 = 0b100000 = 32
STORE_BYTE R3 2 // Store final found_byte_cnt value into mem[34]
MOVI R3 1 // Start storing nocross_patter_cnt
LOAD_TOP_BYTE R3 0 // R0 = nocross_patter_cnt
MOVI R3 2
SHIFT_LEFT_I R3 4 // R3 = 0b100000 = 32
STORE_BYTE R3 1 // Store final nocross_patter_cnt value into mem[33]

MOVI R3 3 // Start storing cross_patter_cnt
LOAD_TOP_BYTE R3 0 // R0 = cross_patter_cnt
MOVI R3 2
SHIFT_LEFT_I R3 4 // R3 = 0b100000 = 32
STORE_BYTE R3 3 // Store final cross_patter_cnt value into mem[35]
DONE
// Program terminates here