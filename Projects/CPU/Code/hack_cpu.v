`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2025 05:53:59 PM
// Design Name: 
// Module Name: hack_cpu
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

//There are 2 generic instruction
/* A instruction 
------------------------------------------------------------------
decode 16 bit value (opcode=0, A instruction)
store value in A regsiter
and output the value from A register


-------------------------------------------------------------------
*/
/* C instruction  ( opcode =1)
-------------------------------------------------------------------
decode  16 bit value
input should come from ALU output , c instruction


--------------------------------------------------------------------

Alwyas somehting compes inside cpu , some instruction and some inM
*/
module hack_cpu(
    clk,
    reset, //from user
    instruction,//next instruction from instruction memory
    inM,//value of currently selected data memory
    outM,//output to data memoru
    writeM,//write or not to  data memory
    addressM,//where to write to data memory(15 bits , 16 th bit is opcode 0)
    pc //to instruction memory- next instruction to execute
    );
    input clk,reset;
    input [15:0] instruction ,inM;
    
    output writeM;
    output [15:0] outM;
    output [14:0] addressM;
    output reg [14:0] pc;
    
     wire zx,zy,nx,ny,f,no,zr,ng;
         
    //instruction handling 
     // inputs - D_register , and  A/M register 
     //1 11 0 0111111 010 111 - instruction 16 bit
  //(C/A-15)(running Virtual machine-14,13)(A reg or input from data memory (M register)12)(ALU instruction-11,6)(destination bits -3bits,A,D,DataMemory,5,4,3)(jump bits-2,1,0)
    reg [15:0] A_reg,D_reg;
    always@(posedge clk)
        if(reset)
            A_reg <= 16'b0;
        else if(!instruction[15])
            A_reg <= instruction;
        else if(instruction[15] && instruction[5])
            A_reg <= outM; //alu out
        else 
            A_reg <= A_reg;
            
     always@(posedge clk)
        if(reset)
            D_reg <= 16'b0;
        else if(instruction[15] && instruction[4])
            D_reg <= outM;
        else 
            D_reg <= D_reg;
            
     wire [15:0] ALU_in;
     assign ALU_in = (instruction[15] && instruction[12]) ? inM : A_reg ; //a=0 select A register , a=1 select Memeory 
     assign {zx,nx,zy,ny,f,no} = instruction[11:6];
     assign writeM = (instruction[15] && instruction[3]) ? 1'b1 : 1'b0; 
     assign addressM = A_reg;
      hack_alu ALU(
     .x(D_reg),.y(ALU_in),
     .zx(zx),.nx(nx),.zy(zy),.ny(ny),.f(f),.no(no),
     .out(outM),
     .zr(zr),.ng(ng)
     );
     
     //cpu control logic - emit address of next instruction
     //instruction[2:0] = jump bits
     //pc is everyhting in control unit
     //other is based on situation ,part of HACK machine language
     //if all j bits are 0 then increment counter , cause there is no jump
    // if all j bits are 1 then its uncodnitonal goto, set PC to A
    // if 1 or 2 j bits are 1 then conditional goto
    // based on j bits of ALU out ,else PC++
     
     //load = f(jump bits , ALU control output)
     reg load;
     always@(*)
        if(instruction[15] )
            case(instruction[2:0])
                3'b000 : load = 1'b0; //no jump
                3'b001 : if(!zr && !ng) load =1'b1;//JGT
                    else load =1'b0;
                3'b010 : if(zr) load = 1'b1;        //JEQ
                 else load =1'b0;
                3'b011 : if(zr && !ng) load =1'b1;  //JGE
                 else load =1'b0;
                3'b100 : if(ng) load =1'b1;         //JLT
                 else load =1'b0;
                3'b101 : if(!zr) load = 1'b1;       //JNE
                 else load =1'b0;
                3'b110 : if(zr && ng) load =1'b1;   //JLE
                 else load =1'b0;
                3'b111 : load =1'b1;                //uncondtional
            endcase
        else 
            load =1'b0;

   
    always@(posedge clk)
        if(reset)
            pc <= 15'b0;
        else if(load)
            pc <= A_reg;
        else 
            pc <= pc + 1'b1;
            
    
            
endmodule
