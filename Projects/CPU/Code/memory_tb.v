`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2025 06:24:09 PM
// Design Name: 
// Module Name: memory_tb
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


module memory_tb(

    );

reg clk,load;
reg [15:0] in;
wire [15:0] out;
reg [14:0] address;

wire [15:0] out_ram16k,out_ram8k,out_keyboard;

assign out_ram16k = DUT.out_ram16k;
assign out_ram8k = DUT.out_ram8k;
assign out_keyboard = DUT.out_keyboard;

hack_memory DUT(
clk,
in,
load,
address,
out );
 
always #5 clk=~clk;



initial 
    begin
        clk=0;
        in=16'hFFFF;
        
        @(negedge clk);
        load=1;
        address = 75;// ram16k
        
        @(negedge clk);
        address = 24576;//keyboard
        
        @(negedge clk);
        address = 24000; // screen
        
        @(negedge clk);
        load=0;
        address = 75;
        
        @(negedge clk);
        address = 24000;
        
        @(negedge clk);
        address = 24576;
        
        @(negedge clk);
        
        $finish;     
    end
    
    initial 
    $monitor($time, "Address=%0d, Value=%0h",address,out);
   
    
endmodule
