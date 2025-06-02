`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2025 01:08:08 PM
// Design Name: 
// Module Name: alu_tb
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


module alu_tb(

    );
    
    reg [15:0] x,y;
    reg zx,nx,zy,ny,f,no;
    wire [15:0] out;
    wire zr,ng;
    
    hack_alu uut(
     x,y,
     zx,nx,zy,ny,f,no,
     out,
     zr,ng
    );
    
    task op;
    input [5:0] o;
    input [15:0]a,b;
    begin   
        {zx,nx,zy,ny,f,no}=o;
        x=a;
        y=b;
        #20;
        $display($time,"  x=%0d,y=%0d,out = %0d",x,y,out);
    end
    endtask
    
    initial 
        begin
            op(6'b000111,-2,-3); //y-x
            op(6'b010011,-2,-3); //x-y
            op(6'b000010,-2,-3);//x+y
            op(6'b000010,3,-3);//x+y
            #20;
            $finish;
        end
        
endmodule
