// set up looping variables for the program and get addresses for reading data and writing (storing From top to bottom: addr to go, from address, to address, max iterations)
BIT_MASK                    0000 //loads 1111 0000 in R0
ROT_L                       R0 3 // R0 = 0000 1111
SHIFT_LEFT_I                R0 0 // R0 = 0 0 0 1 1 1 1 0 (loads 30 in R0)
MOVI                        R1 0
STORE_TOP_BYTE              R1 0 // Store 30 to top of the memory
MOVI                        R0 0 
STORE_TOP_BYTE              R1 1 // Store 0 to top of memory - 1
MOVI                        R0 1 
SHIFT_LEFT_I                R0 3 // R0 = 00010000 (load 16 into R0)
STORE_TOP_BYTE              R1 2 // Store 16 to top of memory - 2

MAIN_LOOP:
// all register are zero before doing anything
MOVI                        R0 0
MOVI                        R1 0
MOVI                        R2 0
MOVI                        R3 0

// Check if current read address is equal to 16
LOAD_TOP_BYTE               R0 1 // Get the from address
SWAP                        R0 R1 // store it in R1
LOAD_TOP_BYTE               R0 2 // Get the MAX address
BEQ                         +1 // If r0 == R1 skip the next instruction
B_LOOKUP                    START_LOOP
B_LOOKUP                    EXIT // if the next address is 16 exit the loop.

// Get data
START_LOOP:
LOAD_BYTE                   R1 0 // load the 8 lsw bits into r0 
SWAP                        R0 R3 // Get LSW the first block in R3
LOAD_BYTE                   R1 1 // load the 8 msw into r0
SWAP                        R0 R2 // Get MSW the first block in R2
ADDI                        R1 2 // Add 2 to the address for the next iteration
SWAP                        R0 R1 // get ready to store the next address
STORE_TOP_BYTE              R1 1 // Store next address to top of memory - 1
// R0 = From address + 2, R1 = 00000000, R2 = 0 0 0 0 0 b11 b10 b9, R3 = b8 b7 b6 b5 b4 b3 b2 b1

//Calculate p8
BIT_MASK                    0000 // loads 1111 0000 in R0
AND                         R0 R3 // R0 = b8 b7 b6 b5 0 0 0 0
OR                          R0 R2 // R0 = b8 b7 b6 b5 0 b11 b10 b9
XOR_ADD_REG                 R1 R0 // R1[0] = p8

//Prepare for next calculation
SHIFT_LEFT_I                R1 0 // Shift left by 1
// R0 = b8 b7 b6 b5 0 b11 b10 b9, R1 = 0 0 0 0 0 0 p8 0, R2 = 0 0 0 0 0 b11 b10 b9, R3 = b8 b7 b6 b5 b4 b3 b2 b1

//Calculate p4 
BIT_MASK                    0001 //loads 10001110 in R0
AND                         R0 R3// R0 = b8 0 0 0 b4 b3 b2 0
XOR_ADD_REG                 R0 R2  // R0[0] = ^(b11:b9)
XOR_ADD_REG                 R1 R0  // R1[0] = p4

//Prepare for next calculation
SHIFT_LEFT_I                R1 0 // Shift left by 1
// R0 = b8 0 0 0 b4 b3 b2 ^(b11:b9), R1 = 0 0 0 0 0 p8 p4 0, R2 = 0 0 0 0 0 b11 b10 b9, R3 = b8 b7 b6 b5 b4 b3 b2 b1

//Calculate p2
BIT_MASK                    0010 //loads 01101101 in R0
AND                         R0 R3 // R0 = 0 b7 b6 0 b4 b3 0 b1 
XOR_ADD_REG                 R1 R0// R1[0] = ^(b7,b6,b4,b3,b1)
SHIFT_LEFT_I                R1 0 // R1 = 0 0 0 0 p8 p4 ^(b7,b6,b4,b3,b1) 0
BIT_MASK                    0100 // loads 00000110 in R0
AND                         R0 R2 // R0 = 0 0 0 0 0 b11 b10 0
XOR_ADD_REG                 R1 R0 // R1 = 0 0 0 0 p8 p4 ^(b7,b6,b4,b3,b1) ^(b11,b10)
MOVI                        R0 3 // R0 = 0 0 0 0 0 0 1 1
AND                         R0 R2 // R0 = ^(b7,b6,b4,b3,b1) ^(b11,b10)
RIGHT_SHIFT_I               R1 1 // R1 = 0 0 0 0 0 0 p8 p4 
SHIFT_LEFT_I                R1 0 // R1 = 0 0 0 0 0 p8 p4 0
XOR_ADD_REG                 R1 R0 // R1 = 0 0 0 0 0 p8 p4 p2
SHIFT_LEFT_I                R1 0 // R1 = 0 0 0 0 p8 p4 p2 0

// Calculate p1
BIT_MASK                    0011 //loads 01011011 in R0
AND                         R0 R3 // R0 = 0 b7 0 b5 b4 0 b2 b1 
XOR_ADD_REG                 R1 R0 // R1[0] = ^(b7,b5,b4,b2,b1)
SHIFT_LEFT_I                R1 0 // R1 = 0 0 0 p8 p4 p2 ^(b7,b5,b4,b2,b1) 0
BIT_MASK                    0101 // loads 00000101 in R0
AND                         R0 R2 // R0 = 0 0 0 0 0 b11 0 b9
XOR_ADD_REG                 R1 R0 // R1 = 0 0 0 p8 p4 p2 ^(b7,b5,b4,b2,b1) ^(b11,b9)
MOVI                        R0 3 // R0 = 0 0 0 0 0 0 1 1
AND                         R0 R2 // R0 = 0 0 0 0 0 0 ^(b7,b5,b4,b2,b1) ^(b11,b9)
RIGHT_SHIFT_I               R1 2 // R1 = 0 0 0 0 0 0 p8 p4 p2 
SHIFT_LEFT_I                R1 0 // R1 = 0 0 0 0 p8 p4 p2 0
XOR_ADD_REG                 R1 R0 // R1 = 0 0 0 0 p8 p4 p2 p1

// R0 = 0 0 0 0 0 0 ^(b7,b5,b4,b2,b1) ^(b11,b9), R1 = 0 0 0 0 p8 p4 p2 p1, R2 = 0 0 0 0 0 b11 b10 b9, R3 = b8 b7 b6 b5 b4 b3 b2 b1

MOVI                        R0 0
SHIFT_LEFT_I                R1 0
XOR_ADD_REG                 R1 R1 // R1 = 0 0 0 p8 p4 p2 p1 ^(p8,p4,p2,p1)
SHIFT_LEFT_I                R1 0
XOR_ADD_REG                 R1 R2 // R1 =  0 0 p8 p4 p2 p1 ^(p8,p4,p2,p1) ^(b11:b9)
SHIFT_LEFT_I                R1 0
XOR_ADD_REG                 R1 R3 // R1 =  0 p8 p4 p2 p1 ^(p8,p4,p2,p1) ^(b11:b9) ^(b8:b1)
SHIFT_LEFT_I                R1 0
XOR_ADD_REG                 R0 R1 // R0 = 0 0 0 0 0 0 0 p0
RIGHT_SHIFT_I               R1 2 // R1 = 0 0 0 0 p8 p4 p2 p1 
SHIFT_LEFT_I                R1 0
ADD                         R1 R0 // R1 = 0 0 0 p8 p4 p2 p1 p0

// R0 = 0 0 0 0 0 0 0 p0, R1 = 0 0 0 p8 p4 p2 p1 p0, R2 = 0 0 0 0 0 b11 b10 b9, R3 = b8 b7 b6 b5 b4 b3 b2 b1

// Create the final words
BIT_MASK                    0000 // loads 1111 0000 in R0
AND                         R0 R3 // R0 = b8 b7 b6 b5 0 0 0 0
OR                          R0 R2 // R0 = b8 b7 b6 b5 0 b11 b10 b9
ROT_L                       R0 2  // R0 = b11 b10 b9 b8 b7 b6 b5 0
SWAP                        R0 R2 //                         
MOVI                        R0 2 // R0 = 0 0 0 0 0 0 1 0
SHIFT_LEFT_I                R0, 2 // R0 = 0 0 0 1 0 0 0 0 
AND                         R0 R1 // R0 = 0 0 0 p8 0 0 0 0
ROT_L                       R0 3 // R0 =  0 0 0 0 0 0 0 p8
ADD                         R2 R0 // R2 = b11 b10 b9 b8 b7 b6 b5 p8
// R0 = 0 0 0 0 0 0 0 P8, R1 = 0 0 0 p8 p4 p2 p1 p0, R2 = b11 b10 b9 b8 b7 b6 b5 p8, R3 = b8 b7 b6 b5 b4 b3 b2 b1
// Store msb
MOVI                        R0 0
LOAD_TOP_BYTE               R0 0 // Get the address at last memory location 
SWAP                        R0 R2 // Get ready to store
STORE_BYTE                  R2 1 // Store R0 to the address in R2 + 1

BIT_MASK                    0110 // loads 00001110 into register 0
AND                         R0 R3 // R0 = 0 0 0 0 b4 b3 b2 0
SWAP                        R0 R2 
MOVI                        R0 1 
SHIFT_LEFT_I                R0 3 // R0 = 0 0 0 0 1 0 0 0
AND                         R0 R1 //R0 = 0 0 0 0 p4 0 0 0
RIGHT_SHIFT_I               R0 2 //R0 = 0 0 0 0 0 0 0 p4 
ADD                         R2 R0 // R2 = 0 0 0 0 b4 b3 b2 p4
MOVI                        R0 1 // R0 = 0 0 0 0 0 0 0 1
AND                         R0 R3 // R0 = 0 0 0 0 0 0 0 b1
SHIFT_LEFT_I                R2 0 // R2 = 0 0 0 b4 b3 b2 p4 0
ADD                         R2 R0 // R2 = 0 0 0 b4 b3 b2 p4 b1
BIT_MASK                    0110 // loads 00001110 into register 0
RIGHT_SHIFT_I               R0 0 // R0 = 0 0 0 0 0 1 1 1
AND                         R0 R1 // R0 = 0 0 0 0 0 b4 b3 b2 p4 b1
SHIFT_LEFT_I                R2 2 // R2 = b4 b3 b2 p4 b1 0 0 0
ADD                         R2 R0 // R2 = b4 b3 b2 p4 b1 b4 b3 b2 p4 b1

// Store LSB
MOVI                        R0 0
LOAD_TOP_BYTE               R0 0 // Get the address at last memory location 
SWAP                        R0 R2 // Get ready to store
STORE_BYTE                  R2 0 // Store R0 to the address in R2 + 0

B_LOOKUP                    MAIN_LOOP

EXIT:
