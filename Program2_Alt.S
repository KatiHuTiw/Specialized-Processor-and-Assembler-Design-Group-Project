MOVI R0 0
STORE_TOP_BYTE R0 2 // wr_addr = 0
MOVI R0 0
STORE_TOP_BYTE R0 1 // bit_to_correct = 0
MOVI R0 0
STORE_TOP_BYTE R0 3 // double_error = 0
MOVI R0 0 // Zero our R0
MOVI R0 3
SHIFT_LEFT_I R0 1 // left shift 'b11 by 2
ADDI R0 3
SHIFT_LEFT_I R0 0 // left shift 'b1111 by 1 to get 30
MOVI R3 0
STORE_TOP_BYTE R3 0 // Now read_bytes = 30
MOV R1 R0 // Restore R0 to 0, start reading from mem 0
LOAD_BYTE R1 0 // startOfLoopP2Alt: Now R0 = mem[0], R1 should contain read_bytes                                   ---------Start loop by checking P8, P4, P2, and P1:
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
B_LOOKUP notOneError // go to notOneError: If P0 does not match, there is one error to fix----------------------------- Fixing 1 error
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
MOVI R1 0 //notOneError: starts here!!!
LOAD_TOP_BYTE R1 1
BEQ +2 // No need to report double error if bit_to_correct is also 0, because there is no error, just restore the message already
MOVI R0 1
STORE_TOP_BYTE R0 2 // Report double error in the local variable
MOV R0 R3 // Copy LSW to R0 restoreMessage: 
SHIFT_LEFT_I R0 3 // Abandon P4, D2-D4
SHIFT_RIGHT_I R0 3
SHIFT_RIGHT_I R0 2 // Abandon P0, P1, and P2
MOV R1 R0 // Restored B1 and save that in LSB in R1 for now
MOV R0 R3 // Copy LSW to R0 again
SHIFT_RIGHT_I R0 3
SHIFT_RIGHT_I R0 0 // Only save B2-B4
ADD R1 R0 // Restored B1-B4 now
MOV R0 R2 // Copy MSW to R0
SHIFT_RIGHT_I R0 0 // Squeeze out P8
SHIFT_LEFT_I R0 3 // Retain B5-B8
ADD R1 R0  // Now R1 has decoded B1-B8
MOVI R0 0 // to get wr_addr
LOAD_TOP_BYTE R0 2 // Now R0 = wr_addr
SWAP R1 R0
STORE_BYTE R1 0 // Write decoded D1-8 to memory
MOV R0 R2 // Copy MSW to R0
SHIFT_RIGHT_I R0 3
SHIFT_RIGHT_I R0 0 // Only save B9-B11
MOV R0 R3 // Save this value in R3, the input message is no longer needed at this point
MOVI R1 0 // Retrieve bit_to_correct from memory to R0 to check---------------------------- Dealing with 2 errors or no error below:
LOAD_TOP_BYTE R1 1
BEQ +4 // No need to report single error
MOVI R1 1
SHIFT_LEFT_I R1 3
SHIFT_LEFT_I R1 1 // Move the 1 bit left by 6 times to change F0 to 1
ADD R3 R1 // Put F0 in the message to store
MOVI R1 0
LOAD_TOP_BYTE R1 3 // Now R0 contains double_error
BEQ +4 //Skip changing F1 to 1 if there is no double error
MOVI R1 1
SHIFT_LEFT_I R1 3
SHIFT_LEFT_I R1 2 // Move the 1 bit left by 7 times to change F1 to 1
ADD R3 R1 // Put F1 in the message to store
MOVI R1 0 // Store the decoded MSB, which is now in R3
LOAD_TOP_BYTE R1 2 // Now R0 contains wr_addr
SWAP R0 R3
STORE_BYTE R3 1 // Now the current message is all decoded and stored ----------------- Done decoding the current 2-word message!
ADDI R3 2 // Increment wr_addr by 2
MOV R0 R3
MOVI R3 0
STORE_TOP_BYTE R3 2 // Put updated wr_addr to top of memory
MOVI R0 0
STORE_TOP_BYTE R3 1 // Restore bit_to_correct to 0 for next iteration (Just in case)
STORE_TOP_BYTE R3 3 // Restore double_error to 0 for next iteration
LOAD_TOP_BYTE R3 2 // Let R0 = read_bytes
ADDI R0 2 // Increment read_bytes by 2
STORE_TOP_BYTE R3 2 // Store the updated read_bytes
MOV R2 R0
SHIFT_RIGHT_I R0 3
SHIFT_RIGHT_I R0 0 // If R0 = read_bytes == 32, then R0 == 1 now
MOVI R1 1
BEQ +2 // If R0 = read_bytes == 32, terminate the program with DONE instruction
MOV R1 R2 // Put updated read_bytes in R1 to start the next iteration
B_LOOKUP startOfLoopP2Alt
DONE 0