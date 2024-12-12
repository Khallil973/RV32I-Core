# RV32I 5-Stage Pipelined CPU

## Description
This repository contains the implementation of an RV32I 5-Stage Pipelined Processor using Verilog. The design supports RV32I instructions (I, S, B, J, and R types) and includes hazard resolution mechanisms for data and control hazards. The pipeline consists of the following stages:  
- **Instruction Fetch (IF)**  
- **Instruction Decode (ID)**  
- **Execute (EX)**  
- **Memory Access (MEM)**  
- **Write Back (WB)**  

The processor is designed for efficient execution of instructions and smooth handling of data dependencies.

---

## Hazards

### 1. **Data Hazards**
- **Forwarding**: Data is bypassed from later stages to earlier stages as needed.  
- **Stalls**: Introduced when forwarding cannot resolve dependencies, especially in load-use situations.  

### 2. **Control Hazards**
- **Branch Prediction**: Resolves branches early in the ID stage to reduce penalties.  
- **Pipeline Flushing**: Clears incorrect instructions on branch misprediction.  

### 3. **Structural Hazards**
- **Conflict-Free Design**: Register and memory accesses are scheduled to avoid conflicts.  

---

## Pre-Requisites
- **Venus Simulator**: For simulating RISC-V assembly instructions.  
- **VS Code**: For editing and running Verilog code.  
- **Verilog HDL**: To understand and modify the processor code.  

---

## Diagram

Below is the block diagram of the RV32I Pipelined Processor with full hazard handling:

![RV32I Pipelined Processor Diagram](images/RV32I_Pipelined.png)

---

## Supported Instructions

This processor supports all RV32I instructions categorized into the following types:  

### 1. **I-Type**  
Immediate operations for arithmetic and logic, such as:  
- `addi`, `andi`, `ori`, `xori`, `slli`, `srli`, `srai`  
- **Load Instructions**: `lw` (load word)  

### 2. **S-Type**  
Store operations that write data to memory:  
- `sw` (store word), `sh` (store halfword), `sb` (store byte)  

### 3. **B-Type**  
Branch instructions for conditional jumps:  
- `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`  

### 4. **J-Type**  
Unconditional jump instructions:  
- `jal` (jump and link), `jalr` (jump and link register)  

### 5. **R-Type**  
Register-to-register arithmetic and logic operations:  
- `add`, `sub`, `and`, `or`, `xor`, `sll`, `srl`, `slt`, `sltu`, `sra`  

---

## Program Execution
To execute a program:  
1. Write the assembly code for the desired operation in the **Venus Simulator**.  
2. Use the "Dump" option in Venus Simulator to generate the hex file.  
3. Save the hex data in a file with a header `v2.0 raw` and remove any unnecessary prefixes (e.g., `0x`).  
4. Load the hex file into the ROM module for simulation.  

---

## Sample Program

This program demonstrates the basic use of instructions and pipeline logic:  

```assembly
# Initialize Registers
addi x1, x0, 10       # x1 = 10
addi x2, x0, 5        # x2 = 5

# Arithmetic Operations
add  x3, x1, x2       # x3 = x1 + x2 = 15
sub  x4, x1, x2       # x4 = x1 - x2 = 5

# Logical Operations
and  x5, x1, x2       # x5 = x1 & x2
or   x6, x1, x2       # x6 = x1 | x2

# Shift Operations
sll  x7, x1, x2       # x7 = x1 << x2
srl  x8, x1, x2       # x8 = x1 >> x2 (logical)

# Memory Operations
sw   x3, 0(x2)        # Store x3 (15) at address (x2 = 5)
lw   x9, 0(x2)        # Load value from address (x2 = 5) into x9 (should be 15)

# Branch Operations
beq  x1, x2, Branch1  # Branch to Branch1 if x1 == x2 (false, does not branch)
addi x10, x0, 1       # x10 = 1 (executed)

bne  x1, x2, Branch2  # Branch to Branch2 if x1 != x2 (true, will branch)
addi x10, x0, 2       # Skipped because bne branches

Branch1:
addi x11, x0, 99      # x11 = 99 (marker for Branch1)

Branch2:
jal  x12, Done        # Unconditionally jump to Done
addi x13, x0, 3       # Skipped due to jump

Done:
addi x14, x0, 100     # x14 = 100 (end marker)

---

## Diagram
