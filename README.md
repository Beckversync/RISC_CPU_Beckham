# Address Mux in SystemVerilog

## Overview
A SystemVerilog implementation of a simple FPGA memory module is presented, featuring a single bidirectional data port. The design is accompanied by a testbench for thorough functional verification.

## Project Structure
```
.
├── ADD_MUX.sv        # Address Mux module
├── tb_ADD_MUX.sv     # Testbench for Address Mux
└── README.md         # Project documentation
```

## Address Mux Module (`ADD_MUX.sv`)
**Features:**
- Selects between instruction address and operand address.
- Default address width is 5 bits, customizable via parameter.

**Parameters:**
- `WIDTH_ADDRESS_BIT` (default: 5): Width of the address signals.

**Ports:**
- `instr_address` (`[WIDTH_ADDRESS_BIT-1:0]`): Instruction address input.
- `operand_address` (`[WIDTH_ADDRESS_BIT-1:0]`): Operand address input.
- `select` (`1-bit`): Control signal (0 selects `instr_address`, 1 selects `operand_address`).
- `address_out` (`[WIDTH_ADDRESS_BIT-1:0]`): Selected address output.

**Implementation:**
The mux uses a simple ternary operator:
```systemverilog
assign address_out = (select) ? operand_address : instr_address;
```

## Testbench (`tb_ADD_MUX.sv`)
The testbench verifies the Address Mux functionality with different input scenarios.

**Test Vectors:**
1. `select = 0`: Should choose `instr_address`.
2. `select = 1`: Should choose `operand_address`.
3. Change input values and repeat.

**Simulation Output Example:**
```
Time = 0 | select = 0 | instr_address = 10101 | operand_address = 01010 | address_out = 10101
Time = 10 | select = 1 | instr_address = 10101 | operand_address = 01010 | address_out = 01010
Time = 20 | select = 0 | instr_address = 11100 | operand_address = 00011 | address_out = 11100
Time = 30 | select = 1 | instr_address = 11100 | operand_address = 00011 | address_out = 00011
```

## How to Run
1. Ensure you have Vivado or a SystemVerilog-compatible simulator installed.
2. Open the project in your environment.
3. Compile and simulate `tb_ADD_MUX.sv`.
4. Observe the output and verify the behavior.

