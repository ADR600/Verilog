`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:  
// Design Name:   fibonacci_series
// Module Name:   
// Project Name:  fibonacci_series
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fibonacci_series
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fibonacci_series_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [7:0] terms;

	// Outputs
	wire [31:0] series_value;

	// Instantiate the Unit Under Test (UUT)
	fibonacci_series uut (
		.clk(clk),
		.reset(reset),		
		.terms(terms), 
		.series_value(series_value)
	);
	
	parameter cycle = 10;
	
	task number_of_terms(input [7:0] x);
	begin 
		terms = x;
	end
	endtask
	
	task rst();
	begin
		reset=1'b1;
		#2;
		reset=1'b0;
	end
	endtask
	
	task delay();
		#100;
	endtask
	
	always
	#(cycle/2) clk=~clk;
	
	initial 
	begin
	clk=0; //initialise clock
	rst();
	number_of_terms(8'd5);
	delay();
	rst();
	number_of_terms(8'd9);
	delay();
	delay();
	$finish;
	end
      
endmodule
