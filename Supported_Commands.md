# Supported Commands

There are 5 bits of opcode in total, so there can be at max 32 different types of instructions. Now using 27/32.

## Arithmatic

### ADD
    Do addition with the values in two registers and store in the first register:

    ADD R0 R1 // R0 = R0 + R1

    [ADD Opcode] 00 01

### ADDI
    Do addition with the value in a registers and store in the first register:

    ADDI R0 4 // R0 = R0 + 4

    [ADDI Opcode] 00 11 // The binary immediate is automatically incremented by 1.

    ADDI R0 1 // R0 = R0 + 1

    [ADDI Opcode] 00 00 // The binary immediate is automatically incremented by 1.

### SUB (Might not need)
    Do subtraction with the values in two registers and store in the first register:

    SUB R0 R1 // R0 = R0 - R1

    [SUB Opcode] 00 01

### MOV
    Assign values stored in a register to another register.

    MOV R3 R2 //R3 = R2

    [MOV Opcode] 11 10

### MOVI
    Assign immediate unsigned values to the register.

    MOV R3 2

    [MOVI Opcode] 11 10

### SHIFT_LEFT
    Shift register to the left by a register value.

    SHIFT_LEFT R0 R2  

    [SHIFT_LEFT Opcode] 00 10

### SHIFT_LEFT_I
    Shift register to the left by an immediate value.

    SHIFT_LEFT_I R0 2 //The value in immediate is incremented by 1 automatically, cause why would we need to shift left by 0, R0 << 3

    [SHIFT_LEFT_I Opcode] 00 01

### SHIFT_RIGHT (Might not need)
    Shift register to the right by a register value.

    SHIFT_RIGHT R3 R0

    [SHIFT_RIGHT Opcode] 11 00

### SHIFT_RIGHT_I (Might not need)
    Shift register to the right by a register value.

    SHIFT_RIGHT R3 2 //Incremented by 1 automatically, R3 = R3 >> 3

    [SHIFT_RIGHT Opcode] 11 00

## Logic (Results are stored in the first register on default)

### AND
    Bitwise AND between two registers.

    AND R2 R1 //R2 = R2 & R1

    [AND Opcode] 10 01

### OR
    Bitwise OR between two registers.

    OR R2 R1 //R2 = R2 | R1

    [OR Opcode] 10 01

### ROT_L
    Left retotate of that register.

    ROT_L R3 4 // Rot to the left by 4 bits, also serve as the swap command.

    [ROT_L Opcode] 11 11 // Automatically incrememt 1 to the immediate rotate amount

### ROT_R = ROT_L by s total of 8 - ROT_L amount

## Load/Save

### LOAD_BYTE
    Loads content from memory corresponds to the register's value + immediate Offset into register R0.

    LOAD_BYTE R3 2 // R0 = mem[R3 + 2]

    [LOAD_BYTE Opcode] 11 10

### STORE_BYTE
    Store content in R0 to memory corresponds to the register's value + immediate Offset.

    STORE_BYTE R3 2 // mem[R3 + 2] = R0

    [STORE_BYTE Opcode] 11 10

### LOAD_TOP_BYTE
    Load content to R0 from the top of the memomry. The address is memory's last address - (register value + immediate Offset). Value in bytes

    LOAD_TOP_BYTE R2 3 // R0 = mem[-R2 - 3]

    [LOAD_TOP_BYTE Opcode] 10 11

### STORE_TOP_BYTE
    Store content in R0 to the top of the memomry. The address is memory's last address - (register value + immediate Offset). This value is in bytes.

    STORE_TOP_BYTE R2 3 // mem[-R2 - 3] = R0

    [STORE_TOP_BYTE Opcode] 10 11

## Branching

### BEQ
    Branch to PC+1+Offset(Signed), Offset is specified in the immediate value, if R0 and R1 have the same value.

    BEQ +5

    [BEQ Opcode] 0101

### SLT
    Set less than. If the first register has value less than the second one, set the first register to 1, otherwise 0.

    SLT R3 R2

    [SLT Opcode] 11 10

### B
    Unconditional branch to PC+1+Offset(Signed)

    B -4

    [B Opcode] 1100

## Additional (Specialize for the programs)

### XOR_REG
    Reduction XOR of all bits in the first register, result gets stored in least significant bit of second register.

    XOR_REG R1 R0 // R0 = ^R1

    [XOR_REG Opcode] 01 00

### XOR_R0R1_BIT
    Reduction XOR of the selected bits in the lower 4 bits in the first register and the second register. The result is stored in R3's least significant bit

    XOR_R0R1_BIT 3 2 // R3[0] = R0[3]^R1[2]

    [XOR_R0R1_BIT Opcode] 11 10

### XOR_R0R0_LOWER_BIT
    Reduction XOR of the selected bits in the lower 4 bits in R0. The result is stored in R3's least significant bit

    XOR_R0R1_BIT 3 2 // R3[0] = R0[3]^R0[2]

    [XOR_R0R0_LOWER_BIT Opcode] 11 10

### XOR_R0R0_UPPER_BIT
    Reduction XOR of the selected bits in the upper 4 bits in R0. The result is stored in R3's least significant bit

    XOR_R0R0_UPPER_BIT 5 7 // R3[0] = R0[5]^R0[7]

    [XOR_R0R0_UPPER_BIT Opcode] 01 11

### XOR_R0R0_UPPER_LOWER_BIT
    Reduction XOR of the selected bit in the upper 4 bits in R0 and the selected bit in the lower 4 bits in R0. The result is stored in R3's least significant bit

    XOR_R0R0_UPPER_BIT 6 2 // R3[0] = R0[6]^R0[2]

    [XOR_R0R0_UPPER_LOWER_BIT Opcode] 10 10

### SWITCH = ROT_L by 4

### SWAP
    Swap the values in two registers

    SWAP R0 R1 // temp = R0; R0 = R1; R1 = temp;

    [SWAP Opcode] 00 01

### LOAD_LOWER_H_BYTE
    Loads content from memory corresponds to the register's value + immediate Offset into register R0. Only loads the lower half byte into the register's lower half byte.

    LOAD_LOWER_H_BYTE R3 2 // R0's lower half byte = mem[R3 + 2]'s lower half byte

    [LOAD_LOWER_H_BYTE Opcode] 11 10

### LOAD_UPPER_H_BYTE
    Loads content from memory corresponds to the register's value + immediate Offset into register R0. Only loads the upper half byte of that memory address into the register's lower half byte.

    LOAD_LOWER_H_BYTE R3 2 // R0's upper half byte = mem[R3 + 2]'s upper half byte

    [LOAD_LOWER_H_BYTE Opcode] 11 10

### NOP
    No operation for the clock cycle
