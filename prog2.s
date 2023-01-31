//I am supposed to read memory from address 30-59, so I am going to keep track of memory address in register R3, starting from 30
MOVI R3 3
SHIFT_LEFT_I R3 2 //R3 << 3, R3 now stores 24
ADDI R3 3//R3 = R3 + 4
ADDI R3 1 //R3 = R3 + 2, now R3 = 30, R3 will be used as index in this program
//Now, to not use any more registers for storing upper limit (59), I am going to store 60 in uppper part of memory  from which I can load when required
MOVI R1 0 //R1 = 0
MOV R0 R3 //R0 = 30
STORE_TOP_BYTE R1 1 //mem[top - 1] = 30 (30 is stored because it will be needed inside for loop again and again to get lower memory address)
SHIFT_LEFT R0 1 //Now, R0 = 60
STORE_TOP_BYTE R1 0 //mem[top] = R0 = 60
NOP
NOP //The place where loop starts, relative jumps will be used to get here, loop uses R3 as index R3 goes from 30 to 58 in jumps of 2
NOP //Code executed inside loop starts below this NOP
LOAD_BYTE R3 0 //R0 = mem[R3]
MOV R1 R0 //R1 = R0
LOAD_BYTE R3 1 //R0 = mem[R3 + 1]
NOP //Code executed inside loop ends above this NOP
MOV R1 0 //R1 = 0
LOAD_TOP_BYTE R1 0 //R0 = mem[top] = 60
MOV R1 R3 //R1 = R3
Error: BEQ (Exact number will be decided soon, can go as far as 1000 which is -16, if required more than 1 branch will be used)
