`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Create Date:   14:17:19 04/18/2025
// Design Name:   div_3
// Module Name:  
// Project Name:  divisible_by_3
////////////////////////////////////////////////////////////////////////////////

module div_3_tb;

	// Inputs
	reg clk;
	reg reset;
	reg in;

	// Outputs
	wire [1:0] rem;
	wire div;
	
	reg[11:0] val;
	integer i;
	
	// Instantiate the Unit Under Test (UUT)
	div_3 uut (
		.clk(clk), 
		.reset(reset), 
		.in(in), 
		.rem(rem), 
		.div(div)
	);
	
	always
	#5 clk=~clk;
	
	task stimulus(input x);
	begin 
		@(negedge clk);
		in=x;
	end
	endtask
	
	task delay(input x);
		#x;
	endtask
	
	initial begin
		// Initialize Inputs
		val=12'b01101010101;
		clk = 0;
		reset = 0;
		in = 0;
		delay(17);
		reset=1;
		delay(1);
		reset=0;
		
		for(i=0;i<12;i=i+1)
		begin 
			stimulus(val[i]);
			//$display($time,"	in=%b,	rem=%d,	div=%b",val[i:0],uut.state,div);
		end
        
		$finish;

	end
	
      
endmodule
