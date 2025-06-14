`timescale 1ns / 1ps



module baud_gen_tb;

reg  clk,reset;
reg  [10:0] dvsr;                                    
wire  tick;

baud_gen dut
(
clk,
reset,
dvsr,  
tick
);

always #1 clk = ~ clk;

initial 
    begin 
        dvsr = 11'd651; 
        clk=1'b0;
        reset = 1'b0;
        
        @(negedge clk);
        reset =1'b1;
        @(negedge clk);
        reset =1'b0;
        
        #5000;
        $finish;
     end
     
initial 
    begin
        $monitor($time,"    tick =%0d",tick);
        $monitor($time,"    r_reg =%0d",dut.r_reg);
    end
endmodule
