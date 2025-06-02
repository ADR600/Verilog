`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2025 12:27:45 PM
// Design Name: 
// Module Name: hack_alu
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


module hack_alu(
     x,y,
     zx,nx,zy,ny,f,no,
     out,
     zr,ng
    );
    input [15:0] x,y;
    input zx,nx,zy,ny,f,no;
    output [15:0] out;
    output zr,ng;
    
    reg [15:0] x1,x2,y1,y2,out1;
    //zx set x=0
    // nx  set x=!x
    // zy set y=0
    //ny set y=!y
    //f out=x+y else out = x&y
    //no then out=!out
    
    always@(*)
        if(zx)
          x1 = 16'b0;
        else
           x1 = x;
           
     always@(*)
        if(zy)
          y1 = 16'b0;
        else
           y1 = y;
           
    always@(*)
        if(nx)
          x2 = ~x1;
        else
          x2 = x1;
          
     always@(*)
        if(ny)
          y2 = ~y1;
        else
          y2 = y1;   
     
     always@(*)
        if(f)
          out1 = x2 + y2;
        else
          out1 = x2 & y2;  
    
    assign out = (no) ? ~out1 : out1;
    assign zr = (!out) ? 1'b1 : 1'b0;
    assign ng =  (out[15]) ? 1'b1 : 1'b0; 
      
endmodule











