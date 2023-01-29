// Get data
LOAD_BYTE                   R0 0 // Get LSW the first block 
LOAD_BYTE                   R1 0 // Get MSW the first block
MOVI                        R3 0 // Set R3 to zero.
//R0 = b8  b7  b6  b5 b4  b3  b2  b1 , R1 = 0   0   0   0   0 b11 b10 b09    
// x ^ 0 = x => p8 = ^(b11:b9^00000) ^ ^(b8:b5)

// P8 calculation
XOR_REG                     R1 R3 // R3[0] = ^(b11:b9)
SHIFT_LEFT_I                R3 1 // Move bits for next calculation 
XOR_R0R0_UPPER_BIT          3 2  // ^(b8,b7)
SHIFT_LEFT_I                R3 1 // Move bits for next calculation 
XOR_R0R0_UPPER_BIT          1 0  // ^(b6,b5)
// R3 = 0 0 0 0 0 ^(b11:b9)  ^(b8,b7) ^(b6,b5)
XOR_REG                     R3 R2// R2[0] = p8
// R2 = 0 0 0 0 0 0 0 p8

//P4 calculation
MOVI                        R3 0 // Set R3 to zero.
XOR_REG                     R1 R3 // ^(b11:b9)
SHIFT_LEFT_I                R3 1 // Move bits for next calculation 
// R3 = 0 0 0 0 0 0 ^(b11:b9) 0 
XOR_R0R0_UPPER_LOWER_BIT    3 3 // ^(b8,b4)
SHIFT_LEFT_I                R3 1
XOR_R0R0_LOWER_BIT          2 1 // ^(b3,b2)
// R3 = 0 0 0 0 0  ^(b11:b9) ^(b8,b4) ^(b3,b2)
SHIFT_LEFT_I                R2 1
// R2 = 0 0 0 0 0 0 p8 0
XOR_REG                     R3 R2// R2[0] = p4
// R2 = 0 0 0 0 0 0 p8 p4

//P2 calculation
MOVI                        R3 0 // Set R3 to zero.
XOR_R0R1_BIT                0  1 // R3[0] = b1^b10
SHIFT_LEFT_I                R3 1 // Move bits for next calculation 
XOR_R0R1_BIT                2  2 // R3[0] = b11^b3
SHIFT_LEFT_I                R3 1 // Move bits for next calculation 
// R3 = 0 0 0 0 0 b10^b1 b11^b3 0
XOR_R0R0_UPPER_BIT          1  2 // R3[0] = b7^b6
SHIFT_LEFT_I                R3 1 // Move bits for next calculation 
// R3 = 0 0 0 0 0 b10^b1 b11^b3 b7^b6 
XOR_R0R1_BIT                3  3 // R3[0] = b4^0 = b4
SHIFT_LEFT_I                R3 1 // Move bits for next calculation 
// R3 = 0 0 0 0 b10^b1 b11^b3 b7^b6 b4
SHIFT_LEFT_I                R2 1
// R2 = 0 0 0 0 0 p8 p4 0
XOR_REG                     R3 R2// R2[0] = p2
// R2 = 0 0 0 0 0 p8 p4 p2

// P1 calculation
MOVI                        R3 0 // Set R3 to zero.
XOR_R0R1_BIT                3  2// R3[0] = b4^b11
SHIFT_LEFT_I                R3 1 // Move bits for next calculation 
XOR_R0R1_BIT                1  0 // R3[0] = b9^b2
SHIFT_LEFT_I                R3 1 // Move bits for next calculation 
// R3 = 0 0 0 0 0 b11^b4 b9^b9 0
XOR_R0R0_UPPER_BIT          2  0 // R3[0] = b7^b5
SHIFT_LEFT_I                R3 1 // Move bits for next calculation 
// R3 = 0 0 0 0 0 b11^b4 b9^b2 b7^b5 
XOR_R0R1_BIT                0  3 // R3[0] = b1^0 = b1
SHIFT_LEFT_I                R3 1 // Move bits for next calculation 
// R3 = 0 0 0 0 b11^b4 b9^b2 b7^b6 b1
SHIFT_LEFT_I                R2 1
// R2 = 0 0 0 0 p8 p4 p2 0
XOR_REG                     R3 R2// R2[0] = p1
// R2 = 0 0 0 0 p8 p4 p2 p1


// P0 calculation
MOVI                        R3 0 // Set R3 to 0
XOR_REG                     R2 R3 // R3[0] = ^(p8,p4,p2,p1)
SHIFT_LEFT_I                3 1 // Move bits
// R3 = 0 0 0 0 0 0 ^(p8,p4,p2,p1) 0
XOR_REG                     R0 R3 // R3[0] = ^(b8:b1)
SHIFT_LEFT_I                R3 1 // Move bits
XOR_REG                     R1 R3 // R3[0] = ^(b11:b9)
// R3 = 0 0 0 0 0 ^(p8,p4,p2,p1) ^(b11:b9) ^(b8:b1)
SHIFT_LEFT_I                R2 1 // Move bits
XOR_REG                     R2 R2 // R2[0] = p0
// R2 = 0 0 0 p8 p4 p2 p1 p0

              