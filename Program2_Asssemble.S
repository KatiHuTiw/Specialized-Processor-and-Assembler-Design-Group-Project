// Used instructions:
// B_LOOKUP
// branch look up table
// New instructions:
// XOR (Regular XOR 2 REGs)
// AND_MASK_LOOKUP REG IMM
/*  index           mask value           Usage
    00              00000111              Get bit fix for LSW (Used to reduce Look Up branches)
    01              00110011              P2
    10              01010101              P1
    11              11100000           Masking off P4-P0 (Do bit extraction on B1)
 */

// Local Variables     location in top memory     initial value
// read_bytes                    0                      0
// bit_to_correct                1                      0
// wr_addr                       2                      30
// double_error                  3                      0

// Underlying logic:
// XOR_REG MSW is freebie for P8
// XOR_REG MSW and LSW is freebie for P0

/* Logic
                                     Check P0 value:
                                           |
                                           |
                                           |
                    _______________________|____________________________
                   |                                                    |
        P0 matches = no error or 2                        P0 does not match = 1 error
                   |                                                    |
        ___________|___________                                         |
       |                       |                                     Fix Error
    correct                2 errors
*/

// Initialize locals
MOVI R0 0
STORE_TOP_BYTE R0 0 // read_bytes = 0
MOVI R0 0
STORE_TOP_BYTE R0 1 // bit_to_correct = 0
MOVI R0 0
STORE_TOP_BYTE R0 3 // double_error = 0
MOVI R0 0 // Zero our R0
MOVI R0 3
SHIFT_LEFT_I R0 1 // left shift 'b11 by 2
ADDI R0 3
SHIFT_LEFT_I R0 0 // left shift 'b1111 by 1 to get 30
MOV R3 2
STORE_TOP_BYTE R3 0 // Now wr_addr = 30
MOVI R1 0 // Restore R0 to 0, start reading from mem 0

startOfLoop:
LOAD_BYTE R1 0 // Now R0 = mem[0], R1 should contain read_bytes                                   ---------Start checking P8, P4, P2, and P1:
SWAP R0 R3 // Let R3 store LSW
LOAD_BYTE R1 1 // Now R0 = mem[0], R1 should still contain read_bytes
SWAP R0 R2 // Let R2 store MSW
MOV R0 R2  // Copy MSW to R1, processing freebie P8:
XOR_REG R0 R0
SHIFT_LEFT_I R0 2 // R1 is now either 8 or 0
MOVI R1 0
STORE_TOP_BYTE R1 1 // R0 = bit_to_correct now. Done checking freebie P8. Store updated bit_to_correct to memory
MOV R1 R3  // Copy LSW to R1, processing P4:
SHIFT_LEFT_I R1 3 // Only take last 4 bit
SHIFT_RIGHT_I R1 3
MOV R0 R2 // Copy MSB to R2
SHIFT_LEFT_I R0 3 // Only take last 4 bit
ADD R1 R0 // Now R1 can be used to check P4
XOR_REG R1 R1
SHIFT_LEFT_I R1 1 // R1 is now either 4 or 0
MOVI R0 0
LOAD_TOP_BYTE R0 1 // Retrieve bit_to_correct from memory to check
ADD R0 R1
MOVI R1 0
STORE_TOP_BYTE R1 1 // Done checking freebie P4. Store updated bit_to_correct to memory
MOV R1 R3  // Copy LSW to R1, processing P2:
AND_MASK_LOOKUP R1 1 // Mask with 00110011
SHIFT_LEFT_I R1 1 // Left shift R1 by 2
MOV R0 R2 // Copy MSB to R2
AND_MASK_LOOKUP R0 1 // Mask with 00110011
ADD R1 R0 // Now R1 can be used to check P2
XOR_REG R1 R1
SHIFT_LEFT_I R1 0 // R1 is now either 2 or 0
MOVI R0 0
LOAD_TOP_BYTE R0 1 // Retrieve bit_to_correct from memory to check
ADD R0 R1
MOVI R1 0
STORE_TOP_BYTE R1 1 // Done checking freebie P2. Store updated bit_to_correct to memory
MOV R1 R3  // Copy LSW to R1, processing P1:
AND_MASK_LOOKUP R1 2 // Mask with 01010101
SHIFT_LEFT_I R1 0 // Left shift R1 by 1
MOV R0 R2 // Copy MSB to R2
AND_MASK_LOOKUP R0 2 // Mask with 01010101
ADD R1 R0 // Now R1 can be used to check P1
XOR_REG R1 R1
MOVI R0 0
LOAD_TOP_BYTE R0 1 // Retrieve bit_to_correct from memory to check
ADD R0 R1
MOVI R1 0
STORE_TOP_BYTE R1 1 // Done checking freebie P1s. Store updated bit_to_correct to memory ---------Done checking P8, P4, P2, and P1 above.
MOV R0 R2  // Copy MSW to R0                                                             ---------Checking P0 below:
MOV R1 R3  // Copy LSW to R1
XOR_REG R0 R0  
XOR_REG R1 R1
SHIFT_LEFT_I R0 0
ADD R0 R1
XOR_REG R0 R0
MOVI R1 0
BEQ +1 // Checked P0 above, and P0 matches, and R0 and R1 both have 0                    ---------Done checking P0 above.
B_LOOKUP notOneError // If P0 does not match, there is one error to fix----------------------------- Fixing 1 error
LOAD_TOP_BYTE R1 1 // Retrieve bit_to_correct from memory to R0 to check
MOVI R1 1
SHIFT_LEFT R1 R0
XOR R3 R1 //Fix lower 8 bits if error occurs there
MOVI R0 0
BEQ +1 // Bit 1 is getting pushed off, so error is not in the LSW
B +5 // Bit 1 is not pushed off, so error is in LSW and it's fixed, go straight to store the decoded message
LOAD_TOP_BYTE R0 1 // Retrieve bit_to_correct from memory to fix MSB
AND_MASK_LOOKUP R0 0 // Only get least 3 bits
MOVI R1 1
SHIFT_LEFT R1 R0
XOR R2 R1 //Fix upper 8 bits if error occurs there --------------------------------------------------- Done fixing 1 error
B +5 // B_LOOKUP restoreMessage // Go to storing the decoded message
notOneError: MOVI R1 0 // Retrieve bit_to_correct from memory to R0 to check---------------------------- Dealing with 2 errors or no error below:
LOAD_TOP_BYTE R1 1
BEQ +2 // No need to report double error, because there is no error, just restore the message already
MOVI R0 1
STORE_TOP_BYTE R1 1 // Retrieve bit_to_correct from memory to R0 to check---------------------------- Dealing with 2 errors or no error below:
restoreMessage: 