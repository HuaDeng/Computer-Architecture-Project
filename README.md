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
__Machine Code__: `0aaa dddd ssss tttt`
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

More details in source

### Load/Store Instructions
__Machine Code__: `10aa tttt oooo oooo`

__Opcode rt, offset8__

* `SW`: MEM[$DS + signext(offset)] <- rt
* `LW`: rt <- MEM[$DS + signext(offset)]

__Opcode rt, imm8__

* `LHB`: rt[15:8] <- imm8
* `LLB`: rt[7:0] <- imm8

### Control Instructions
#### Branch
__B cond3, offset8__

Conditionally jump to address obtained by adding the 8-bit immediate to the PC.
This is a delayed branch, so the instruction immediately following the branch is always execcuted.

#### Call
__CALL target12__

1. Push the PC to the stack
  1. Store PC to (SP)
  2. SP--
2. Set the 12 least significant bits of the PC to target

#### Return
__RET__

Pop the top of the stack into the PC

1. $SP++
2. Store (SP) into PC
