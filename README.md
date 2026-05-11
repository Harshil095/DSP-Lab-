# FPGA Implementation

This repository contains FPGA implementations of FIR and FFT based digital filters using Verilog  
The project includes multiple FIR architectures, pipelined optimizations, FFT-based filtering, FPGA deployment files, and supporting documentation.

## Implementations Included

### FIR Filters
- Non Pipelined FIR Filter
- Pipelined FIR Filter

### FIR Architectures
Each FIR implementation is designed in multiple ways:
- Direct 
- Generate 
- Optimized 

### FFT
- Pipelined FFT Filter
- Radix-2 FFT Implementation

## FPGA Implementation
All designs were synthesized, compiled, and tested on FPGA hardware.

### Board Used
- Intel/Altera DE10-Nano FPGA Board
- Cyclone V FPGA

## Features
- Fixed-point DSP implementation using Q(2,14) format
- Quartus Prime project files included
- SignalTap waveform analysis
- ROM/IP based input signal generation
- Timing constraints and pin assignments
- Synthesizable RTL modules
- Testbenches and simulation files

