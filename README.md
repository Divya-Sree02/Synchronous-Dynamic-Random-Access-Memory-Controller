# Synchronous-Dynamic-Random-Access-Memory-Controller
SDRAM controller in Verilog implementing FSM-based read/write control with timing constraints tRCD, tCAS, and tRP
## SDRAM Controller — Theory & Working

This project implements a simplified SDRAM controller in Verilog using a Finite State Machine (FSM) that models
real SDRAM timing behavior. Unlike standard memory, SDRAM requires specific delays between commands such as row 
activation, read/write access, and precharge operations. The controller includes timing parameters **tRCD**,
**tCAS**,and **tRP** to simulate realistic memory latency and maintain correct command sequencing.

Incoming read and write requests are internally latched and executed through a structured command flow:

ACTIVE → WAIT → READ/WRITE → PRECHARGE → IDLE

A counter is used to generate timing delays between states, ensuring that each SDRAM command follows proper 
timing constraints. During read operations, the `data_valid` signal is asserted only after CAS latency,
representing the moment when memory data becomes available.

This design demonstrates key digital design concepts such as FSM-based control, latency-aware memory access,
and synchronous command scheduling. The controller functionality is verified using RTL simulation with
Icarus Verilog and waveform analysis in GTKWave.
