`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2025 03:51:40 PM
// Design Name: 
// Module Name: hack_computer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//refreshing monitor and probing keyboard is mentioned 
// as a part of memory which i have not included
module hack_computer(
    clk,
    reset
    );
    
    input clk,reset;
    
    wire [14:0] addressM,pc;
    wire [15:0] instruction,inM,outM;
    wire writeM;
    hack_cpu CPU(
    .clk(clk),
    .reset(reset), //from user
    .instruction(instruction),//next instruction from instruction memory
    .inM(inM),//value of currently selected data memory
    .outM(outM),//output to data memoru
    .writeM(writeM),//write or not to  data memory
    .addressM(addressM),//where to write to data memory(15 bits , 16 th bit is opcode 0)
    .pc(pc) //to instruction memory- next instruction to execute
    );
    
    
    hack_rom32k ROM32K(
    .clk(clk),
    .address(pc),
    .out(instruction)
    );
    
    hack_memory Memory(
    .clk(clk),
    .in(outM),
    .load(writeM),
    .address(addressM),
    .out(inM)
    );
    
    
endmodule
