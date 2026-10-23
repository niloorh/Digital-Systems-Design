# FPGA Karatsuba Multiplier

This project implements a **128-bit Karatsuba multiplier** in Verilog for FPGA synthesis and hardware testing. Two 128-bit operands are multiplied and the resulting **256-bit product** is registered on the rising edge of the clock.

## Design Overview

The multiplier follows the Karatsuba multiplication method by splitting each 128-bit operand into two 64-bit halves. The partial products are then combined to generate the final 256-bit result.

A clocked output stage is included so that the multiplication result is stored and made available after the rising edge of the clock, making the design suitable for FPGA implementation and testing.

## FPGA Interface

The multiplier is integrated with a serial **Remote FPGA Test** interface. Input test vectors are transferred through UART to the FPGA, applied to the multiplier, and the resulting product is returned over the serial connection for verification.

The design can be tested using tools such as **RemoteFPGATest** and **RealTerm** after synthesis and implementation in Xilinx Vivado.

## Tools

- Verilog / SystemVerilog
- Xilinx Vivado
- RemoteFPGATest
- RealTerm
