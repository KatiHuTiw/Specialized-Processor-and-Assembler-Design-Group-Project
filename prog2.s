//I am supposed to read memory from address 30-59, so I am going to keep track of memory address in register R3, starting from 30
MOVI R3 3
SHIFT_LEFT_I R3 2 //R3 << 3, R3 now stores 24
ADDI R3 3//R3 = R3 + 4
ADDI R3 1 //R3 = R3 + 2, now R3 = 30, R3 will be used as index in this program
//Now, to not use any more registers for storing upper limit (59), I am going to store 60 in uppper part of memory  from which I can load when required
MOV R0 R3 //R0 = 30
STORE_TOP_BYTE_I 1 //mem[top - 1] = 30 (30 is stored because it will be needed inside for loop again and again to get lower memory address)
SHIFT_LEFT R0 1 //Now, R0 = 60
STORE_TOP_BYTE_I 0 //mem[top] = R0 = 60
NOP
NOP //The place where loop starts, relative jumps will be used to get here, loop uses R3 as index R3 goes from 30 to 58 in jumps of 2
NOP //Code executed inside loop starts below this NOP
LOAD_BYTE R3 1 //R0 = mem[R3 + 1], now R0 is D11 D10 D9 D8 D7 D6 D5 P8
MOV R2 R0 //R2 = R0, now R2 is D11 D10 D9 D8 D7 D6 D5 P8
SHIFT_RIGHT_I R2 0 //R2 = R2 >> 1, R2 is 0 D11 D10 D9 D8 D7 D6 D5
SHIFT_LEFT_I R2 0 //R2 is D11 D10 D9 D8 D7 D6 D5 0
MOV R1 0 //R1 = 0 because in next command, its least significant bit will be set to xor of something
XOR_REG R2 R1 //R1's least significant bit = D5 ^ D6 ^ D7 ^ D8 ^ D9 ^ D10 ^ D11
MOV R2 R0 //R2 is D11 D10 D9 D8 D7 D6 D5 P8
MOV R0 R1 //R0 = 0 0 0 0 0 0 0 Q8
STORE_TOP_BYTE_I 2 //mem[top - 2] = 0 0 0 0 0 0 0 Q8
MOV R1 R2 //R0 = D11 D10 D9 D8 D7 D6 D5 P8
SHIFT_RIGHT_I R1 3 //R1 = R1 >> 4
MOV R0 0 //R0 is set to 0 because its last bit will be set to xor of something in next few lines of code
XOR_REG R1 R0 //R0's least significant bit = D8 ^ D9 ^ D10 ^ D11
MOV R1 R0 //R1 = 0 0 0 0 0 0 0 (D8 ^ D9 ^ D10 ^ D11)
LOAD_BYTE R3 0 //R0 = mem[R3] = D4 D3 D2 P4 D1 P2 P1 P0
SHIFT_RIGHT_I R0 3 //R0 = R0 >> 4
SHIFT_RIGHT_I R0 0 //R0 = R0 >> 1
XOR_REG R0 R0 //R0 = 0 0 0 0 0 0 0 (D2 ^ D3 ^ D4)
XOR_REG R1 R0 //R1 remains same, R0 = 0 0 0 0 0 0 0 Q4
STORE_TOP_BYTE_I 3 //mem[top - 3] = 0 0 0 0 0 0 0 Q4
LOAD_BYTE R3 1 //R0 = mem[R3] = D11 D10 D9 D8 D7 D6 D5 P8
MOV R1 3 //R1 = 0 0 0 0 0 0 1 1
SHIFT_LEFT_I R1 2 //R1 = 0 0 0 1 1 0 0 0
ADDI R1 2 //R1 = 0 0 0 1 1 0 1 1
SHIFT_LEFT_I R1 2 //R1 = 1 1 0 1 1 0 0 0
NOP //Code executed inside loop ends above this NOP
MOV R1 0 //R1 = 0
LOAD_TOP_BYTE R1 0 //R0 = mem[top] = 60
MOV R1 R3 //R1 = R3
Error: BEQ (Exact number will be decided soon, can go as far as 1000 which is -16, if required more than 1 branch will be used)
