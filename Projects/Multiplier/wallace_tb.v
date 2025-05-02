`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Create Date:  
// Design Name:   multiplier4_bit
// Module Name:  
// Project Name:  multiplier
// Verilog Test Fixture created by ISE for module: multiplier4_bit
////////////////////////////////////////////////////////////////////////////////

module multiplier4_bit_tb;

	// Inputs
	reg [3:0] a;
	reg [3:0] b;

	// Outputs
	wire [7:0] product;

	// Instantiate the Unit Under Test (UUT)
	multiplier4_bit uut (
		.a(a), 
		.b(b), 
		.product(product)
	);
	
	task inputs ( input [3:0] x,y);
	begin 
		a=x;
		b=y;
	end
	endtask
	
	task delay(input integer x); 
		#x;
	endtask
	
	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		#100;
        
		inputs(2,5);
		delay(20);
		
		inputs(7,14);
		delay(20);
		
		inputs(0,0);
		delay(20);
		
		inputs(15,15);
		delay(20);
		

	end
	
	initial 
	$monitor($time, "	a=%d,	b=%d,	product=%d",a,b,product);
      
endmodule
