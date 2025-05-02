`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Create Date:   
// Design Name:
// Module Name:   
// Project Name:  multiplier
// Verilog Test Fixture created by ISE for module: multiplier8_bit
////////////////////////////////////////////////////////////////////////////////

module multiplier_tb;

	// Inputs
	reg [31:0] a;
	reg [31:0] b;

	// Outputs
	wire [63:0] product;

	// Instantiate the Unit Under Test (UUT)
	multiplier_shift_add uut (
		.a(a), 
		.b(b), 
		.product(product)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		#10;  
		// Add stimulus here
		a=10;
		b=7;
		#10;
		
		a=15;
		b=15;
		#10;
		
		a=12;
		b=3;
		#10;
		
		a=4294967295;
		b=4294967295;
		#10;
		
		$finish;
		
	end
	
	initial
	$monitor($time,"	a=%0d,	b=%d,	product=%0d,	product=%0b ",a,b,product,product);
	
      
endmodule
