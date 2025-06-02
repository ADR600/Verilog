`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2025 03:24:07 PM
// Design Name: 
// Module Name: hack_keyboard_register
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


module hack_keyboard_register(
clk,
load,
in,
out
);
    
input clk,load;
input [15:0] in;
output [15:0] out;

reg [15:0]mem;

always@(posedge clk)
    if(load)
        mem <= in;
        
assign out = mem;

endmodule
