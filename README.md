# My Project 
Hello visitor !! This is collection of some of my hardware projects that i have implemeneted and tested using verilog and system verilog . To get detailed collection of all my project click  [Project](Projects) .

![image](https://github.com/user-attachments/assets/93364e84-5c28-4498-96c7-7327b9a65749)

---

## HACK Architecture

The **HACK architecture** is a minimalist 16-bit computer system introduced in the book *The Elements of Computing Systems* (*Nand2Tetris*). It serves as an educational platform for understanding the fundamentals of computer architecture from the ground up.For more information [Click](https://github.com/ADR600/Verilog/blob/8aec3fdd99b410b262b0ab4a88e75beb0cd07b17/Projects/CPU/readme.mkd)

###  Key Characteristics

* **16-bit word size**
* **Two-instruction ISA**:

  * `A-instruction`: Load constant/address into the A-register
  * `C-instruction`: Perform computation and control memory/registers
* Simple **ALU** supporting arithmetic and logic
* **Memory-mapped I/O** for basic peripheral interaction (screen & keyboard)
* Clean separation of **instruction memory (ROM)** and **data memory (RAM)**

This project includes a synthesizable Verilog implementation of the HACK CPU, including:

* Instruction decoding
* ALU logic
* Control signals and timing
* HACK Assembly Language
  
![Architecture drawio](https://github.com/user-attachments/assets/e547465a-1a4c-4c86-a4e2-148eb34c25d1)

General architecutre of HACK Computer 
---

## UART (Universal Asynchronous Receiver/Transmitter)

**UART** is a serial communication protocol that transmits data one bit at a time without a clock signal. It is ideal for low-complexity and low-speed communication between devices.For more info [Click](https://github.com/ADR600/Verilog/tree/6a72bcf60e223d0f056dbea5b36ae2417b552284/Projects/UART%20Protocol)

This UART design features:

### Core Components

* **Transmitter (TX)**

  * Converts 8-bit parallel data to serial
  * Uses start bit, data bits, and stop bit format
  * Includes a **TX FIFO** for queuing data, enabling non-blocking transmission

* **Receiver (RX)**

  * Detects and reconstructs serial data into 8-bit parallel format
  * Employs **16x oversampling** for robust bit alignment and noise immunity
  * Stores received bytes in a **RX FIFO**, decoupling timing from the main system

* **Baud Rate Generator**

  * Derives UART tick pulses from a system clock (e.g., 100 MHz)
  * Supports standard baud rates (e.g., 9600, 19200, 115200)
  * Controls timing for both TX and RX based on a divisor (`dvsr`)

---

## Project Highlights

* Full Verilog implementation of HACK CPU and UART communication stack
* FIFO buffering in both TX and RX paths
* Modular, synthesizable, and reusable components
* Self-checking testbenches for verification
* Ready for integration into custom SoC or FPGA-based designs

---


