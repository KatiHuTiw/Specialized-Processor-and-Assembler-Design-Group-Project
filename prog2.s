//I am supposed to read memory from address 30-59, so I am going to keep track of memory address in register R3, starting from 30
MOVI R3 3
SHIFT_LEFT_I R3 2 //R3 << 3, R3 now stores 24
ADDI R3 3//R3 = R3 + 4
ADDI R3 1 //R3 = R3 + 2, now R3 = 30
//Now, to not use any more registers for storing upper limit (59), I am going to store 60 in uppper part of memory  from which I can load when required
MOV R0 R3
SHIFT_LEFT R0 1 //Now, R0 = 60
MOVI R1 0 //R1 = 0
STORE_TOP_BYTE R1 0 //mem[top] = R0 = 60
NOP
NOP //The place where loop starts, relative jumps will be used to get here
NOP //Code executed inside loop starts below this NOP
NOP //Code executed inside loop ends above this NOP
MOV R1 0 //R1 = 0
LOAD_TOP_BYTE R1 0 //R0 = mem[top] = 60
MOV R1 R3 //R1 = R3
BEQ (Exact number will be decided soon, can go as far as 1000 which is -16, if required more than 1 branch will be used)
