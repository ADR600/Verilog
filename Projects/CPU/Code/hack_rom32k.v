`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2025 03:37:59 PM
// Design Name: 
// Module Name: hack_rom32k
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

//plug and play rom chip - code burnt into chip
//reset to start executing from instruction 1
module hack_rom32k(
clk,
address,
out
    );
input clk;
input [14:0] address; //15 bits ,cause first bit tells what instruction not required 
output [15:0] out;

reg [15:0] mem [0:32767];//32k location = 32,768 

reg [15:0] out_reg;
assign out = out_reg;

always@(posedge clk)
    out_reg <= mem[address];
    
endmodule
