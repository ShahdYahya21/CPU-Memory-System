## Verilog Code & ISA Explanation

### 1. **Memory Module**
The **Memory** module has a 64-location memory array (16 bits each). It supports:
- **Read**: Outputs data from the specified address.
- **Write**: Stores data at the specified address.

---

### 2. **CPU Module**
The **CPU** module simulates a processor with operations like **load**, **store**, **add**, **subtract**, **multiply**, **divide**, and **branch**. It uses a **Finite State Machine (FSM)** to control instruction execution.

#### Key Components:
- **PC**: Program Counter.
- **IR**: Instruction Register.
- **AC**: Accumulator.
- **Flags**: Z (Zero), OF (Overflow), C (Carry), N (Negative).
- **Mode**: A flag indicating if the operand is from memory or a constant.

#### Operations:
- **Load**: Loads data into AC.
- **Store**: Stores AC to memory.
- **Add/Sub**: Performs arithmetic with memory or constants.
- **Mul/Div**: Multiplies/Divides AC.
- **Branch**: Changes PC.
- **BRZ**: Conditional branch on Zero flag.

#### Mode:
- **Mode 1**: Operates on data from memory (using MAR).
- **Mode 0**: Operates on a constant value embedded in the instruction.

---

### ISA Overview
The **ISA** uses 16-bit instructions with the following arrangement:

- **4-bit opcode** (bits 15-12): Defines the operation (e.g., `0001` for Load, `0010` for Store).
- **1-bit mode** (bit 11): Determines the operand type.
  - **Mode 1**: Operand is from memory.
  - **Mode 0**: Operand is a constant.
- **11-bit operand/address** (bits 10-0): Specifies the data (constant) or address (memory location).


