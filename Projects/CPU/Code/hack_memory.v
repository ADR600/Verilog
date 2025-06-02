`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2025 02:58:19 PM
// Design Name: 
// Module Name: hack_memory
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


module hack_memory(
clk,
in,
load,
address,
out
    );
input clk,load;
input [15:0] in;
input [14:0] address; //15 bit address

output [15:0] out;

// 0-1683 ram16k
//1684-24575 ram8k
//24576 keyboard register

wire load_ram16k,load_ram8k,load_keyboard;
wire [15:0] out_ram16k,out_ram8k,out_keyboard;
reg [15:0] out_reg;

assign load_ram16k = (!address[14]) ? load : 1'b0;
assign load_ram8k = (address[14:13]==2'b10 )? load : 1'b0;
assign load_keyboard = (address == 15'd24576) ? load : 1'b0;

always@(*)
    if(~address[14])
        out_reg = out_ram16k;
    else if(address >= 15'd16384 && address <= 15'd24575)
        out_reg = out_ram8k;
   else if(address == 15'd24576)
        out_reg = out_keyboard;
    else 
        out_reg = 16'hzzzz;
        
assign out = out_reg;

hack_ram16k RAM16K(
    .clk(clk),
    .in(in),
    .load(load_ram16k),
    .address(address[13:0]),
    .out(out_ram16k)
    );
hack_ram8k RAM8K(
    .clk(clk),
    .in(in),
    .load(load_ram8k),
    .address(address[12:0]),
    .out(out_ram8k)
    );
hack_keyboard_register Keyboard(
    .clk(clk),
    .load(load_keyboard),
    .in(in),
    .out(out_keyboard)
    );
    
    
endmodule
