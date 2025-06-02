`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2025 09:13:26 PM
// Design Name: 
// Module Name: HACK_tb
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


module HACK_tb(

    );
    reg clk,reset;
    
    hack_computer uut(
    .clk(clk),
    .reset(reset)
    );
    
    wire [14:0] pc,addressM;
    wire [15:0] inM,outM,Areg,Dreg,instruction;
    wire writeM;
    
    assign writeM = uut.CPU.writeM;
    assign Dreg = uut.CPU.D_reg;
    assign Areg=uut.CPU.A_reg;
    assign inM = uut.CPU.inM;
    assign outM = uut.CPU.outM;
    assign pc = uut.CPU.pc;
    assign instruction= uut.CPU.instruction;
    assign addressM = uut.CPU.addressM;
    always #5 clk=~clk;
    
    task initialise;
       begin
            clk=0;
            reset=0;
        end
    endtask
    
    task rst;
        begin
            @(negedge clk);
            reset=1;
            #27;
            $readmemb("ROM_file.mem", uut.ROM32K.mem);
            //$readmemb("ram_init.mem",uut.Memory.RAM16K.mem);
            @(negedge clk);
            reset=0;
        end
    endtask
    
    initial
        begin
            initialise;
            rst;
            $strobe($time," Value of RAM[0]at begening =%0d",uut.Memory.RAM16K.mem[0]);
            #500;
            $display($time,"    Value of RAM[0] =%0d",uut.Memory.RAM16K.mem[0]);
            $display($time,"    Value of RAM[1] =%0d",uut.Memory.RAM16K.mem[1]);
            $display($time,"    Value of RAM[2] =%0d",uut.Memory.RAM16K.mem[2]);
            $display($time,"    Value of RAM[3] =%0d",uut.Memory.RAM16K.mem[3]);
            $display($time,"    Value of RAM[4] =%0d",uut.Memory.RAM16K.mem[4]);
            $display($time,"    Value of RAM[5] =%0d",uut.Memory.RAM16K.mem[5]);
            $display($time,"    Value of RAM[6] =%0d",uut.Memory.RAM16K.mem[6]);
            $display($time,"    Value of RAM[7] =%0d",uut.Memory.RAM16K.mem[7]);
            $display($time,"    Value of RAM[8] =%0d",uut.Memory.RAM16K.mem[8]);
            $display($time,"    Value of RAM[9] =%0d",uut.Memory.RAM16K.mem[9]);
            $display($time,"    Value of RAM[10] =%0d",uut.Memory.RAM16K.mem[10]);
            
            $finish;
        end
        
    initial 
        $monitor($time,"    A Register = %0d, D Register = %0d,   PC Value =%0d",uut.CPU.A_reg,uut.CPU.D_reg,uut.CPU.pc);
        
endmodule
