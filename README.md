# WISC-S15
A simple MIPS processor
### Features
- 16 bit
- One 3-bit FLAG Register
  1. Zero (Z)
  2. Overflow (V)
  3. Sign (N)
- 14 MIPS instructions
- 16 16-bit registers
  - $14 is Data Segment (DS)
  - $15 is Stack Pointer (SP)
- For use with word addressable memory

## Instructions
### Arithmetic Instructions
#### Three address instructions
__Opcode rd, rs, rt__
* `ADD`: rd <- rs + rt
* `SUB`: rd <- rs - rt
* `NAND`: rd <- rs NAND rt
* `XOR`: rd <- rs XOR rt

#### Immediate instructions
__Opcode rd, rs, imm4__
* `INC`: rd <- rs + signext(imm)
* `SRA`: rd <- signext(rs) >> imm
* `SRL`: rd <- rs >> imm
* `SLL`: rd <- rs << imm
* 
More details in source
