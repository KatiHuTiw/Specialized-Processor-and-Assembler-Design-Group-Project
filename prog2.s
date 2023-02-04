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
MOVI R1 0 //R1 = 0 because in next command, its least significant bit will be set to xor of something
XOR_REG R2 R1 //R1's least significant bit = D5 ^ D6 ^ D7 ^ D8 ^ D9 ^ D10 ^ D11
MOV R2 R0 //R2 is D11 D10 D9 D8 D7 D6 D5 P8
MOV R0 R1 //R0 = 0 0 0 0 0 0 0 Q8
STORE_TOP_BYTE_I 2 //mem[top - 2] = 0 0 0 0 0 0 0 Q8
MOV R1 R2 //R0 = D11 D10 D9 D8 D7 D6 D5 P8
SHIFT_RIGHT_I R1 3 //R1 = R1 >> 4
MOVI R0 0 //R0 is set to 0 because its last bit will be set to xor of something in next few lines of code
XOR_REG R1 R0 //R0's least significant bit = D8 ^ D9 ^ D10 ^ D11
MOV R1 R0 //R1 = 0 0 0 0 0 0 0 (D8 ^ D9 ^ D10 ^ D11)
LOAD_BYTE R3 0 //R0 = mem[R3] = D4 D3 D2 P4 D1 P2 P1 P0
SHIFT_RIGHT_I R0 3 //R0 = R0 >> 4
SHIFT_RIGHT_I R0 0 //R0 = R0 >> 1
XOR_REG R0 R0 //R0 = 0 0 0 0 0 0 0 (D2 ^ D3 ^ D4)
SHIFT_LEFT_I R0 0 //R0 = 0 0 0 0 0 0 (D2 ^ D3 ^ D4) 0
ADD R0 R1 //R0 = 0 0 0 0 0 0 (D2 ^ D3 ^ D4) (D8 ^ D9 ^ D10 ^ D11)
XOR_REG R0 R0 //0 0 0 0 0 0 0 (D2 ^ D3 ^ D4 ^ D8 ^ D9 ^ D10 ^ D11) = 0 0 0 0 0 0 0 Q4
STORE_TOP_BYTE_I 3 //mem[top - 3] = 0 0 0 0 0 0 0 Q4
LOAD_BYTE R3 1 //R0 = mem[R3 + 1] = D11 D10 D9 D8 D7 D6 D5 P8
MOVI R1 3 //R1 = 0 0 0 0 0 0 1 1
SHIFT_LEFT_I R1 2 //R1 = 0 0 0 1 1 0 0 0
ADDI R1 2 //R1 = 0 0 0 1 1 0 1 1
SHIFT_LEFT_I R1 2 //R1 = 1 1 0 1 1 0 0 0
AND R1 R0 //R0 remains the same, R1 changes to D11 D10 0 0 D7 D6 0 0
XOR_REG R1 R1 //R1 = 0 0 0 0 0 0 0 (D6 ^ D7 ^ D10 ^ D11)
LOAD_BYTE R3 0 //R0 = mem[R3] = D4 D3 D2 P4 D1 P2 P1 P0
MOVI R2 3 //R2 = 0 0 0 0 0 0 1 1
SHIFT_LEFT_I R2 2 //R2 = 0 0 0 1 1 0 0 0
ADDI R2 0 //R2 = 0 0 0 1 1 0 0 1
SHIFT_LEFT_I R2 2 //R2 = 1 1 0 0 1 0 0 0
AND R2 R0 //R0 remains the same, R2 changes to D4 D3 0 0 D1 0 0 0
XOR_REG R2 R2 //R2 = 0 0 0 0 0 0 0 (D1 ^ D3 ^ D4)
SHIFT_LEFT_I R1 0 //R1 = 0 0 0 0 0 0 (D6 ^ D7 ^ D10 ^ D11) 0
ADD R1 R1 //R1 = 0 0 0 0 0 0 (D6 ^ D7 ^ D10 ^ D11) (D1 ^ D3 ^ D4)
XOR_REG R1 R0 //R0 = 0 0 0 0 0 0 0 (D1 ^ D3 ^ D4 ^ D6 ^ D7 ^ D10 ^ D11) = 0 0 0 0 0 0 0 Q2
MOVI R1 3 //R1 = 3
STORE_TOP_BYTE R1 1 //mem[top - 4] = R0 = 0 0 0 0 0 0 0 Q2
MOVI R1 2 //R1 = 0 0 0 0 0 0 1 0
SHIFT_LEFT_I R1 1 //R1 = 0 0 0 0 1 0 0 0
ADD R1 1 //R1 = 0 0 0 0 1 0 1 0
SHIFT_LEFT_I R1 0 //R1 = 0 0 0 1 0 1 0 0  
ADDI R1 0 //R1 = 0 0 0 1 0 1 0 1
SHIFT_LEFT_I R1 2//R1 = 1 0 1 0 1 0 0 0
LOAD_BYTE R3 0 //R0 = D4 D3 D2 P4 D1 P2 P1 P0
AND R1 R0 //R1 = D4 0 D2 0 D1 0 0 0
XOR_REG R1 R1 //R1 = 0 0 0 0 0 0 0 (D1 ^ D2 ^ D4)
LOAD_BYTE R3 1 //R0 = D11 D10 D9 D8 D7 D6 D5 P8
MOVI R2 2 //R2 = 0 0 0 0 0 0 1 0
SHIFT_LEFT_I R2 1 //R2 = 0 0 0 0 1 0 0 0
ADDI R2 1 //R2 = 0 0 0 0 1 0 1 0
SHIFT_LEFT_I R2 1 //R2 = 0 0 1 0 1 0 0 0
ADDI R2 1 //R2 = 0 0 1 0 1 0 1 0 
SHIFT_LEFT_I R2 1 //R2 = 1 0 1 0 1 0 0 0
ADDI R2 1 //R2 = 1 0 1 0 1 0 1 0
AND R2 R0 //R2 = D11 0 D9 0 D7 0 D5 0
SHIFT_LEFT_I R1 0 //R1 = 0 0 0 0 0 0 (D1 ^ D2 ^ D4) 0
XOR_REG R2 R2 //R2 = 0 0 0 0 0 0 0 (D5 ^ D7 ^ D9 ^ D11)
ADD R1 R2 //R1 = 0 0 0 0 0 0 (D1 ^ D2 ^ D4) (D5 ^ D7 ^ D9 ^ D11)
XOR_REG R1 R0 //R0 = 0 0 0 0 0 0 0 (D1 ^ D2 ^ D4 ^ D5 ^ D7 ^ D9 ^ D11) = 0 0 0 0 0 0 0 Q1
MOVI R1 3 //R1 = 3
STORE_TOP_BYTE R1 2 //mem[top - 5] = R0 = 0 0 0 0 0 0 0 Q1
LOAD_BYTE R3 0 //R0 = D4 D3 D2 P4 D1 P2 P1 P0
MOVI R1 3 //R1 = 0 0 0 0 0 0 1 1
SHIFT_LEFT_I R1 1 //R1 = 0 0 0 0 1 1 0 0
ADDI R1 2 //R1 = 0 0 0 0 1 1 1 1
SHIFT_LEFT_I R1 1 //R1 = 0 0 1 1 1 1 0 0
ADDI R1 2 //R1 = 0 0 1 1 1 1 1 1
SHIFT_LEFT_I R1 1 //R1 = 1 1 1 1 1 1 0 0
ADDI R1 1 //R1 = 1 1 1 1 1 1 1 0
AND R0 R1 //R0 = D4 D3 D2 P4 D1 P2 P1 0
XOR_REG R0 R2 //R2 = 0 0 0 0 0 0 0 (P1 ^ P2 ^ P4 ^ D1 ^ D2 ^ D3 ^ D4)
SHIFT_LEFT_I R2 0 //R2 = 0 0 0 0 0 0 (P1 ^ P2 ^ P4 ^ D1 ^ D2 ^ D3 ^ D4) 0
LOAD_BYTE R3 1 //R0 = D11 D10 D9 D8 D7 D6 D5 P8
XOR_REG R0 R1 //R1 = 0 0 0 0 0 0 0 (D11 ^ D10 ^ D9 ^ D8 ^ D7 ^ D6 ^ D5 ^ P8)
ADD R1 R2 //R1 = 0 0 0 0 0 0 (P1 ^ P2 ^ P4 ^ D1 ^ D2 ^ D3 ^ D4) (D11 ^ D10 ^ D9 ^ D8 ^ D7 ^ D6 ^ D5 ^ P8)
XOR_REG R1 R0 //R0 = 0 0 0 0 0 0 0 Q0
MOVI R1 3 //R1 = 3
STORE_TOP_BYTE R1 3 //mem[top - 6] = R0 = 0 0 0 0 0 0 0 Q0
//Now, the next xtep is to compare P0 and Q0
LOAD_BYTE R3 0 //R0 = mem[R3] = D4 D3 D2 P4 D1 P2 P1 P0
MOVI R1 1 //R1 = 0 0 0 0 0 0 0 0
AND R1 R0 //R1 = 0 0 0 0 0 0 0 P0
MOVI R2 3
LOAD_TOP_BYTE R2 3 //R0 = mem[top - 6] = 0 0 0 0 0 0 0 Q0
Error: BEQ (some place (not decided yet) where S0 and S1 and S2 and S4 and S8 will be computed and checked)
// Start of Code to execute if P0 and Q0 are not the same, so the case in which there is a 1-bit error
LOAD_BYTE R3 1 //R0 = D11 D10 D9 D8 D7 D6 D5 P8
MOV R1 1 //R1 = 0 0 0 0 0 0 0 1
AND R1 R0 //R1 = 0 0 0 0 0 0 0 P8
MOVI R2 2 //R2 = 2
LOAD_TOP_BYTE R2 0 //R0 = mem[top - 2] = 0 0 0 0 0 0 0 Q8
AND R1 R0 //R1 = 0 0 0 0 0 0 0 S8
LOAD_BYTE R3 0 //R0 = D4 D3 D2 P4 D1 P2 P1 P0 
MOVI R2 1 //R2 = 0 0 0 0 0 0 0 1
SHIFT_LEFT_I R2 3 //R2 = 0 0 0 1 0 0 0 0 
AND R2 R0 //R2 = 0 0 0 P4 0 0 0 0 
SHIFT_RIGHT R2 1 //R2 = 0 0 0 0 0 P4 0 0
SHIFT_LEFT_2 R1 2 //0 0 0 0 S8 0 0 0
MOVI R0 3 //R0 = 3
LOAD_TOP_BYTE R0 0 //R0 = mem[top - 3] = 0 0 0 0 0 0 0 Q4
SHIFT_LEFT_I R0 1 //R0 = 0 0 0 0 0 Q4 0 0
AND R2 R0 //R2 = 0 0 0 0 0 S4 0 0 
ADD R1 R2 //R1 = 0 0 0 0 S8 S4 0 0
LOAD_BYTE R3 0 //R0 = D4 D3 D2 P4 D1 P2 P1 P0
MOVI R2 3 //R2 = 0 0 0 0 0 0 1 1
SHIFT_LEFT_I R2 0 //R2 = 0 0 0 0 0 1 1 0
AND R2 R0 //R2 = 0 0 0 0 0 P2 P1 0
MOVI R0 3 //R0 = 3
LOAD_TOP_BYTE R0 1 //R0 = mem[top - 4] = 0 0 0 0 0 0 0 Q2
SHIFT_LEFT_I R0 1 //R0 = 0 0 0 0 0 Q2 0 0
AND R2 R0 //R2 = 0 0 0 0 0 S2 P1 0
MOVI R0 3 //R0 = 3
LOAD_TOP_BYTE R0 2 //R0 = mem[top - 5] = 0 0 0 0 0 0 0 Q1
SHIFT_RIGHT_I R2 0 //R2 = 0 0 0 0 0 0 S2 P1
AND R2 R0 //R2 = 0 0 0 0 0 0 S2 S1
ADD R1 R2 //R1 = 0 0 0 0 S8 S4 S2 S1
MOVI R0 1 //R0 = 1
Error: BEQ (Branch ahead of flipping procedure)
ADDI R0 0 //R0 = 2
Error: BEQ (Branch ahead of flipping procedure)
ADDI R0 1 //R0 = 4
Error: BEQ (Branch ahead of flipping procedure)
ADDI R0 3 //R0 = 8
Error: BEQ (Branch ahead of flipping procedure)
NOP //Flipping procedure starts here
MOV R2 R1 //R2 = 0 0 0 0 S8 S4 S2 S1
MOVI R0 3 //R0 = 3
ADDI R0 0 //R0 = 4
SLT R1 R0 //If S8 S4 S2 S1 < 4, then R1 = 1
MOVI R0 1
Error: BEQ (to a place where D1 flipping begins) 
MOVI R0 2 //R0 = 2
SHIFT_LEFT_I R0 1 //R0 = 8
MOV R1 R2 //R1 = 0 0 0 0 S8 S4 S2 S1
SLT R1 R0 //If S8 S4 S2 S1 < 8, then R1 = 1
MOVI R0 1
Error: BEQ (to a place where either D2 or D3 or D4 flipping begins)
MOVI R1 R2 //R1 = S8 S4 S2 S1
MOVI R0 3 //R0 = 3
ADDI R0 3 //R0 = 7
ADDI R0 1 //R0 = 9
Error: BEQ (To a place where D5 flipping begins)
MOVI R1 R2 //R1 = S8 S4 S2 S1
MOVI R0 3 //R0 = 3
ADDI R0 3 //R0 = 7
ADDI R0 2 //R0 = 10
Error: BEQ (To a place where D6 flipping begins)
MOVI R1 R2 //R1 = S8 S4 S2 S1
MOVI R0 3 //R0 = 3
ADDI R0 3 //R0 = 7
ADDI R0 3 //R0 = 11
Error: BEQ (To a place where D7 flipping begins)
MOVI R1 R2 //R1 = S8 S4 S2 S1
MOVI R0 3 //R0 = 3
ADDI R0 3 //R0 = 7
ADDI R0 3 //R0 = 11
ADDI R0 0 //R0 = 12
Error: BEQ (To a place where D8 flipping begins)
MOVI R1 R2 //R1 = S8 S4 S2 S1
MOVI R0 3 //R0 = 3
ADDI R0 3 //R0 = 7
ADDI R0 3 //R0 = 11
ADDI R0 1 //R0 = 13
Error: BEQ (To a place where D9 flipping begins)
MOVI R1 R2 //R1 = S8 S4 S2 S1
MOVI R0 3 //R0 = 3
ADDI R0 3 //R0 = 7
ADDI R0 3 //R0 = 11
ADDI R0 2 //R0 = 14
Error: BEQ (To a place where D10 flipping begins)
MOVI R1 R2 //R1 = S8 S4 S2 S1
MOVI R0 3 //R0 = 3
ADDI R0 3 //R0 = 7
ADDI R0 3 //R0 = 11
ADDI R0 3 //R0 = 15
Error: BEQ (To a place where D11 flipping begins)

NOP //Place where D11 flipping begins
NOP //Place where D11 flipping ends
Error: B (To a place that skips over everything except D11)
NOP //Place where D10 flipping begins
NOP //Place where D10 flipping ends
Error: B (To a place that skips over everything except D10)
NOP //Place where D9 flipping begins
NOP //Place where D9 flipping ends
Error: B (To a place that skips over everything except D9)
NOP //Place where D8 flipping begins
NOP //Place where D8 flipping ends
Error: B (To a place that skips over everything except D8)
NOP //Place where D7 flipping begins
NOP //Place where D7 flipping ends
Error: B (To a place that skips over everything except D7)
NOP //Place where D6 flipping begins
NOP //Place where D6 flipping ends
Error: B (To a place that skips over everything except D6)
NOP //Place where D5 flipping begins
//Continue From Here:

NOP //Place where D5 flipping ends
Error: B (To a place that skips over everything except D5)
NOP //Place where D2 or D3 or D4 flipping begins
// First, I need to figure out whether it is D2 or D3 or D4
MOVI R1 R2 //R1 = 0 0 0 0 S8 S4 S2 S1
MOVI R0 3 //R0 = 3
ADDI R0 2 //R0 = 5
Error: BEQ (to a place where D2 flipping starts)
ADDI R0 0 //R0 = 6
Error: BEQ (to a place where D3 flipping starts)
ADDI R0 0 //R0 = 7
Error: BEQ (to a place where D4 flipping starts)
NOP
NOP
NOP //Place where D4 flipping starts
LOAD_BYTE R3 0 //R0 = D4 D3 D2 P4 D1 P2 P1 P0
MOV R1 2 //R1 = 0 0 0 0 0 0 1 0
SHIFT_LEFT_I R1 3 //R1 = 0 0 1 0 0 0 0 0
SHIFT_LEFT_I R1 1 //R1 = 1 0 0 0 0 0 0 0 
AND R1 R0 //R1 = D4 0 0 0 0 0 0 0
ADD R1 0 //R1 = D4 0 0 0 0 0 0 1
XOR_REG R1 R1 //R1 = 0 0 0 0 0 0 0 (D4 ^ 1) = 0 0 0 0 0 0 0 ~D4
SHIFT_LEFT_I R1 3 //R1 = 0 0 0 ~D4 0 0 0 0
SHIFT_LEFT_I R1 2 //R1 = ~D4 0 0 0 0 0 0 0
SHIFT_LEFT_I R0 0 //R0 = D3 D2 P4 D1 P2 P1 P0 0
SHIFT_RIGHT_I R0 0 //R0 = 0 D3 D2 P4 D1 P2 P1 P0 
ADD R0 R1 //R0 =  ~D4 D3 D2 P4 D1 P2 P1 P0
STORE_BYTE R3 0 //mem[R3] = R0 = ~D4 D3 D2 P4 D1 P2 P1 P0
NOP //Place where D4 flipping ends
Error: B (to a place which skips over flipping everything other than D4)

NOP //Place where D3 flipping starts
LOAD_BYTE R3 0 //R0 = D4 D3 D2 P4 D1 P2 P1 P0
MOV R1 2 //R1 = 0 0 0 0 0 0 1 0
SHIFT_LEFT_I R1 3 //R1 = 0 0 1 0 0 0 0 0
SHIFT_LEFT_I R1 0 //R1 = 0 1 0 0 0 0 0 0 
AND R1 R0 //R1 = 0 D3 0 0 0 0 0 0
ADD R1 0 //R1 = 0 D3 0 0 0 0 0 1
XOR_REG R1 R1 //R1 = 0 0 0 0 0 0 0 (D3 ^ 1) = 0 0 0 0 0 0 0 ~D3
SHIFT_LEFT_I R1 3 //R1 = 0 0 0 ~D3 0 0 0 0
SHIFT_LEFT_I R1 1 //R1 = 0 ~D3 0 0 0 0 0 0
SHIFT_LEFT_I R0 1 //R0 = D2 P4 D1 P2 P1 P0 0 0
SHIFT_RIGHT_I R0 2 //R0 = 0 0 D2 P4 D1 P2 P1 P0 
ADD R1 R0 //R1 =  0 ~D3 D2 P4 D1 P2 P1 P0
LOAD_BYTE R3 0 //R0 = D4 D3 D2 P4 D1 P2 P1 P0
SHIFT_RIGHT_I R0 3 //R0 = 0 0 0 0 D4 D3 D2 P4
SHIFT_RIGHT_I R0 2 //R0 = 0 0 0 0 0 0 0 D4
SHIFT_LEFT_I R0 3 //R0 = 0 0 0 D4 0 0 0 0  
SHIFT_LEFT_I R0 2 //R0 = D4 0 0 0 0 0 0 0 
ADD R0 R1 //R0 = D4 ~D3 D2 P4 D1 P2 P1 P0
STORE_BYTE R3 0 //mem[R3] = R0 = D4 ~D3 D2 P4 D1 P2 P1 P0
NOP //Place where D3 flipping ends
Error: B (to a place which skips over flipping everything other than D3)
NOP //Place where D2 flipping starts
LOAD_BYTE R3 0 //R0 = D4 D3 D2 P4 D1 P2 P1 P0
MOV R1 2 //R1 = 0 0 0 0 0 0 1 0
SHIFT_LEFT_I R1 3 //R1 = 0 0 1 0 0 0 0 0
AND R1 R0 //R1 = 0 0 D2 0 0 0 0 0
ADD R1 0 //R1 = 0 0 D2 0 0 0 0 1
XOR_REG R1 R1 //R1 = 0 0 0 0 0 0 0 (D2 ^ 1) = 0 0 0 0 0 0 0 ~D2
SHIFT_LEFT_I R1 3 //R1 = 0 0 0 ~D2 0 0 0 0
SHIFT-LEFT_I R1 0 //R1 = 0 0 ~D2 0 0 0 0 0
SHIFT_LEFT_I R0 2 //R0 = P4 D1 P2 P1 P0 0 0 0
SHIFT_RIGH_I R0 2 //R0 = 0 0 0 P4 D1 P2 P1 P0 
ADD R1 R0 //R1 =  0 0 ~D2 P4 D1 P2 P1 P0
LOAD_BYTE R3 0 //R0 = D4 D3 D2 P4 D1 P2 P1 P0
SHIFT_RIGHT_I R0 3 //R0 = 0 0 0 0 D4 D3 D2 P4
SHIFT_RIGHT_I R0 1 //R0 = 0 0 0 0 0 0 D4 D3
SHIFT_LEFT_I R0 3 //R0 = 0 0 D4 D3 0 0 0 0 
SHIFT_LEFT_I R0 1 //R0 = D4 D3 0 0 0 0 0 0
ADD R0 R1 //R0 = D4 D3 ~D2 P4 D1 P2 P1 P0
STORE_BYTE R3 0 //mem[R3] = R0 = D4 D3 ~D2 P4 D1 P2 P1 P0
NOP //Place where D2 flipping ends
Error: B (to a place which skips over flipping everything other than D2)
NOP //Place where D2 or D3 or D4 flipping ends
NOP //Place where D1 flipping begins
LOAD_BYTE R3 0 //R0 = D4 D3 D2 P4 D1 P2 P1 P0
MOV R1 2 //R1 = 0 0 0 0 0 0 1 0
SHIFT_LEFT_I R1 1 //R1 = 0 0 0 0 1 0 0 0
AND R1 R0 //R1 = 0 0 0 0 D1 0 0 0
ADD R1 0 //R1 = 0 0 0 0 D1 0 0 1
XOR_REG R1 R1 //R1 = 0 0 0 0 0 0 0 (D1 ^ 1) = 0 0 0 0 0 0 0 ~D1
SHIFT_LEFT_I R1 2 //R1 = 0 0 0 0 ~D1 0 0 0
SHIFT_RIGHT_I R0 3 //R0 = 0 0 0 0 D4 D3 D2 P4
SHIFT_LEFT_I R0 3 //R0 = D4 D3 D2 P4 0 0 0 0 
ADD R1 R0 //R1 = D4 D3 D2 P4 ~D1 0 0 0 
LOAD_BYTE R3 0 //R0 = D4 D3 D2 P4 D1 P2 P1 P0
SHIFT_LEFT_I R0 3 //R0 = D1 P2 P1 P0 0 0 0 0 
SHIFT_LEFT_I R0 0 //R0 = P2 P1 P0 0 0 0 0 0 
SHIFT_RIGHT_I R0 3 //R0 = 0 0 0 0 P2 P1 P0 0
SHIFT_RIGHT_I R0 0 //R0 = 0 0 0 0 0 P2 P1 P0
ADD R0 R1 //R0 = D4 D3 D2 P4 ~D1 P2 P1 P0
STORE_BYTE R3 0 //mem[R3] = R0 = D4 D3 D2 P4 ~D1 P2 P1 P0
NOP //Place where D1 flipping ends
Error: B (Unconditional Branch to end of flipping procedure)
NOP //Flipping procedure ends here 
NOP //The previous 4 BEQs branch here (nothing needs to be flipped if there are parity errors instead of data errors)
// End of code to execute if P0 and Q0 are not the same, so the case in which there is a 1-bit error
Error: B (unconditional branch to skip over code execution that occurs when P0 and Q0 are equal and to the place where R2 is set to 0 1 0 0 0 0 0 0)
// The above BEQ leads here - Code to execute if P0 and Q0 are the same
LOAD_BYTE R3 0 //R0 = mem[R3]
MOVI R1 2 //R1 = 0 0 0 0 0 0 1 0
AND R1 R0 //R1 = 0 0 0 0 0 0 P1 0
MOVI R2 2 //R2 = 2
LOAD_TOP_BYTE R2 3 //R0 = mem[top - 5] = 0 0 0 0 0 0 0 Q1
ADD R1 R2 //R1 = 0 0 0 0 0 0 P1 Q1
XOR_REG R1 R2 //R2 = 0 0 0 0 0 0 0 (P1 ^ Q1) = 0 0 0 0 0 0 0 0 S1
LOAD_BYTE R3 0 //R0 = mem[R3]
MOVI R1 2 //R1 = 0 0 0 0 0 0 1 0
SHIFT_LEFT_I R1 0 //R1 = 0 0 0 0 0 1 0 0
AND R1 R0 //R1 = 0 0 0 0 0 P2 0 0 
MOVI R0 1 //R0 = 1
LOAD_TOP_BYTE R0 3 //R0 = mem[top - 4] = 0 0 0 0 0 0 0 Q2
ADD R1 R0 //R1 = 0 0 0 0 0 P2 0 Q2
XOR_REG R1 R1 //R1 = 0 0 0 0 0 0 0 (P2 ^ Q2) = 0 0 0 0 0 0 0 S2
OR R2 R1 //R2 = 0 0 0 0 0 0 0 (S1 ^ S2)
LOAD_BYTE R3 0 //R0 = mem[R3]
MOVI R1 2 //R1 = 0 0 0 0 0 0 1 0
SHIFT_LEFT_I R1 2 //R1 = 0 0 0 1 0 0 0 0
AND R1 R0 //R1 = 0 0 0 P4 0 0 0 0 
MOVI R0 1 //R0 = 1
LOAD_TOP_BYTE R0 2 //R0 = mem[top - 3] = 0 0 0 0 0 0 0 Q4
ADD R1 R0 //R1 = 0 0 0 P4 0 0 0 Q4
XOR_REG R1 R1 //R1 = 0 0 0 0 0 0 0 (P4 ^ Q4) = 0 0 0 0 0 0 0 S4
OR R2 R1 //R2 = 0 0 0 0 0 0 0 (S1 ^ S2 ^ S4)
LOAD_BYTE R3 1 //R0 = mem[R3 + 1]
MOVI R1 1 //R1 = 0 0 0 0 0 0 0 1
AND R1 R0 //R1 = 0 0 0 0 0 0 0 P8 
MOVI R0 1 //R0 = 1
LOAD_TOP_BYTE R0 1 //R0 = mem[top - 2] = 0 0 0 0 0 0 0 Q8
SHIFT_LEFT_I R0 0 //R0 = 0 0 0 0 0 0 Q8 0 
ADD R1 R0 //R1 = 0 0 0 0 0 0 Q8 P8
XOR_REG R1 R1 //R1 = 0 0 0 0 0 0 0 (P8 ^ Q8) = 0 0 0 0 0 0 0 S8
OR R2 R1 //R2 = 0 0 0 0 0 0 0 (S1 ^ S2 ^ S4 ^ S8)
MOV R0 R2 //R0 = 0 0 0 0 0 0 0 (S1 ^ S2 ^ S4 ^ S8)
MOVI R1 0
Error: BEQ (Some place ahead which SKIPS the part where F1 is set to 1 and F0 to 0)
//Start of part where F1 is set to 1 and F0 to 0 for 2 errors
MOVI R2 2 //R2 = 0 0 0 0 0 0 1 0
SHIFT_LEFT_I R2 3 //R2 = 0 0 1 0 0 0 0 0 
SHIFT_LEFT_I R2 1 //R2 = 1 0 0 0 0 0 0 0 = F1 F0 0 0 0 0 0 0 (when there are 2 errors)
//End of part where F1 is set to 1 and F0 to 0 for 2 errors
Error: B (This branch skips the part where F1 is set to 0 and F0 is set to 0)
//Start of part where F1 and F0 are set to 0 for 0 errors
MOVI R2 0 //R2 = 0 0 0 0 0 0 0 0 = F1 F0 0 0 0 0 0 0 (when there are 2 errors)
//End of part where F1 and F0 are set to 0 for 0 errors
Error: B (This branch skips over the part where F1 is set to 0 and F1 is set to 1 for 1 error
NOP //Start of part where R2 is set to 0 1 0 0 0 0 0 0 for 1 error
MOVI R2 2 //R2 = 0 0 0 0 0 0 1 0
SHIFT_LEFT_I R2 3 //R2 = 0 0 1 0 0 0 0 0 
SHIFT_LEFT_I R2 0 //R2 = 0 1 0 0 0 0 0 0
NOP //End of part where R2 is set to 0 1 0 0 0 0 0 0 for 1 error
NOP //This is where the BEQ instruction immmediately before AND the B instructions immediately before returns
//IMP: Beyond this stage (still inside the giant super loop), the output bits (mem[0:29]) will be set and R2 holds F1 F0 0 0 0 0 0 0 for all 3 scenarios
//IMP: Beyond this, all 3 scenarios will process the following instructions
//IMP: Beyond this, both R3 AND R2 cannot be used (as opposed to just R3 before)
LOAD_BYTE R3 0 //R0 = mem[R3] = D4 D3 D2 P4 D1 P2 P1 P0
MOVI R1 3 //R1 = 0 0 0 0 0 0 1 1
SHIFT_LEFT_I R1 0 //R1 = 0 0 0 0 0 1 1 0
ADDI R1 0 //R1 = 0 0 0 0 0 1 1 1
SHIFT_LEFT_I R1 1 //R1 = 0 0 0 1 1 1 0 0 
ADDI R1 0 //R1 = 0 0 0 1 1 1 0 1
SHIFT_LEFT_I R1 2 //R1 = 1 1 1 0 1 0 0 0
AND R1 R0 //R1 = D4 D3 D2 0 D1 0 0 0 
MOVI R0 2 //R0 = 0 0 0 0 0 0 1 0
SHIFT_LEFT_I R0 1 //R0 = 0 0 0 0 1 0 0 0
AND R0 R1 //R0 = 0 0 0 0 D1 0 0 0 
SHIFT_RIGHT_I R0 2 //R0 = 0 0 0 0 0 0 0 D1
SHIFT_RIGHT_I R1 3 //R1 = 0 0 0 0 D4 D3 D2 0
ADD R1 R0 //R1 = 0 0 0 0 D4 D3 D2 D1
LOAD_BYTE R3 1 //R0 = D11 D10 D9 D8 D7 D6 D5 P8
SHIFT_RIGHT_I R0 0 //R0 = 0 D11 D10 D9 D8 D7 D6 D5
SHIFT_LEFT_I R0 3 //R0 = D8 D7 D6 D5 0 0 0 0 
ADD R0 R1 //R0 = D8 D7 D6 D5 D4 D3 D2 D1
MOVI R1 3 //R1 = 0 0 0 0 0 0 1 1
ADDI R1 3 //R1 = 0 0 0 0 0 1 1 1
SHIFT_LEFT_I R1 3 //R1 = 0 1 1 1 0 0 0 0 
ADDI R1 0 //R1 = 0 1 1 1 0 0 0 1
SHIFT_LEFT_I R1 0 //R1 = 1 1 1 0 0 0 1 0, This is -30 in 8-bit signed
ADD R1 R3 //R1 = R1 + R3 = R3 - 30
STORE_BYTE R1 0 //mem[R3 - 30] = R0 = D8 D7 D6 D5 D4 D3 D2 D1
LOAD_BYTE R3 1 //R0 = mem[R3 + 1] = D11 D10 D9 D8 D7 D6 D5 P8
MOVI R1 3 //R1 = 0 0 0 0 0 0 1 1
SHIFT_LEFT_I R1 0 //R1 = 0 0 0 0 0 1 1 0
ADDI R1 0 //R1 = 0 0 0 0 0 1 1 1 
SHIFT_LEFT_I R1 3 //R1 = 0 1 1 1 0 0 0 0
SHIFT_LEFT_I R1 0 //R1 = 1 1 1 0 0 0 0 0 
AND R0 R1 //R0 = D11 D10 D9 0 0 0 0 0 
SHIFT_RIGHT_I R0 3 //R0 = 0 0 0 0 D11 D10 D9 0 
SHIFT_RIGHT_I R0 0 //R0 = 0 0 0 0 0 D11 D10 D9
ADD R0 R2 //R0 = F1 F0 0 0 0 D11 D10 D9
MOVI R1 3 //R1 = 0 0 0 0 0 0 1 1
ADDI R1 3 //R1 = 0 0 0 0 0 1 1 1
SHIFT_LEFT_I R1 3 //R1 = 0 1 1 1 0 0 0 0 
ADDI R1 0 //R1 = 0 1 1 1 0 0 0 1
SHIFT_LEFT_I R1 0 //R1 = 1 1 1 0 0 0 1 0, This is -30 in 8-bit signed
ADD R1 R3 //R1 = R1 + R3 = R3 - 30
STORE_BYTE R1 1 //mem[R3 - 29] = R0 = F1 F0 0 0 0 D11 D10 D9
//At this stage mem[R3 - 29] and mem[R3 - 30] has been filled with the desired byte values (for all 3 stages)
NOP //Code executed inside loop ends above this NOP
MOVI R1 0 //R1 = 0
LOAD_TOP_BYTE R1 0 //R0 = mem[top] = 60
MOV R1 R3 //R1 = R3
Error: BEQ (Exact number will be decided soon, can go as far as 1000 which is -16, if required more than 1 branch will be used)
