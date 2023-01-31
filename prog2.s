//I am supposed to read memory from address 30-59, so I am going to keep track of memory address in register R3, starting from 30
MOVI R3 11
SHIFT_LEFT_I R3 2 //R3 << 3, R3 now stores 24
ADDI R3 11 //R3 = R3 + 4
ADDI R3 01 //R3 = R3 + 2, now R3 = 30
