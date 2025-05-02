
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Create Date:    
// Design Name: 
// Module Name:    multiplier_shift_add 
//////////////////////////////////////////////////////////////////////////////////
`define WORD_SIZE 32
module multiplier_shift_add(
    input [`WORD_SIZE - 1:0] a,b,
    output reg [(`WORD_SIZE *2) -1:0] product
    );
	 
integer i;

always@(a,b)
begin 
	product = 00;
	for(i=0;i<`WORD_SIZE;i=i+1)
	begin 
		if(b[i])
			product = product + (a<< i) ;
	end
end
		

endmodule
