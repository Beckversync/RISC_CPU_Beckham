# Memory Module for FPGA

This repository contains the SystemVerilog implementation of a simple memory module for FPGA with a single bidirectional data port. It includes both the memory module and its corresponding testbench.

## Features
- 5-bit address space (32 memory locations)
- 8-bit data width
- Single bidirectional data port (cannot read and write simultaneously)
- Read/Write operation controlled by a `read_write` signal
- Operates on the rising edge of the clock
- Asynchronous reset
- Instruction address counter with an optional increment flag

## File Structure
- `Memory.v` : SystemVerilog implementation of the memory module
- `tb_Memory.v` : Testbench for simulating and verifying the memory module

## How to Simulate
1. Open Vivado and create a new project.
2. Add `Memory.v` and `tb_Memory.v` to the project.
3. Open the simulation settings and set `tb_Memory` as the top module.
4. Run the behavioral simulation.

## Expected Output
When you simulate the testbench, the waveform should resemble the following:

| Time (ns) | clk | rst | enable | read_write | address | tb_data | data | instr_address |
|-----------|-----|-----|--------|------------|---------|---------|------|---------------|
| 0         | 0   | 1   | 0      | 0          | 00      | 00      | ZZ   | 00            |
| 20        | 1   | 0   | 1      | 0          | 05      | 55      | ZZ   | 00            |
| 25        | 0   | 0   | 1      | 0          | 05      | 55      | 55   | 01            |
| 50        | 1   | 0   | 1      | 1          | 05      | --      | 55   | 01            |
| 70        | 1   | 0   | 1      | 1          | 00      | --      | FE   | 01            |

**Legend:**
- `ZZ` indicates high-impedance state (when data bus is not driven)
- `--` means the data bus is not being written to
- `instr_address` increments only when `load_instruction_flag` is high



