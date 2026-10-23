# Mano Basic Computer

A Verilog implementation of the **Mano Basic Computer**, developed to explore processor organization and instruction execution through a simple educational CPU architecture.

## Overview

The design models the main components of Mano's basic computer, including processor registers, memory, the common bus, ALU operations, control sequencing, and instruction execution.

## Implemented Features

- Fetch, decode, and execute sequencing
- Memory-reference instructions such as `AND`, `ADD`, `LDA`, `STA`, `BUN`, `BSA`, and `ISZ`
- Register-reference operations including clear, complement, shift, skip, and halt operations
- Basic input/output handling with `INP` and `OUT`
- Internal memory and CPU registers

## Testbench

The testbench loads a short machine-code program directly into memory and exercises instruction fetching, execution, input, output, and halt behavior.

