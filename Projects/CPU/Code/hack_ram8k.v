`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2025 03:02:54 PM
// Design Name: 
// Module Name: hack_ram8k
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


module hack_ram8k(
clk,
in,
load,
address,
out
);

input clk,load;
input [15:0] in;
output [15:0] out;
input [12:0] address;

reg [15:0] out_reg ;
assign out = out_reg;

reg [15:0] mem [0: 8191 ]; // 8k = 8192  units
always@(posedge clk)
    begin
        if(load)
            mem[address] <= in;
        else 
            out_reg <= mem[address];
    end
    
endmodule
