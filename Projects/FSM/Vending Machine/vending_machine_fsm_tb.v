`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Create Date:  
// Design Name:   vending_machine_fsm
// Module Name:  
// Project Name:  vending_machine
////////////////////////////////////////////////////////////////////////////////

module vending_machine_fsm_tb;

	// Inputs
	reg clock;
	reg reset;
	reg [1:0] coin_in;

	// Outputs
	wire [1:0] coin_out;
	wire product_out;

	// Instantiate the Unit Under Test (UUT)
	vending_machine_fsm uut (
		.clock(clock), 
		.reset(reset), 
		.coin_in(coin_in), 
		.coin_out(coin_out), 
		.product_out(product_out)
	);

	task coin_input(input [1:0] x);
	begin
		@(negedge clock);
		coin_in = x;
		@(negedge clock);
		coin_in = 2'b00;
	end
	endtask
	
	task delay(input integer x);
		#x;
	endtask
	
	task rst();
	begin
		reset = 1;
		delay(3);
		reset = 0;
	end
	endtask
	
	always
	begin 
		clock=1'b0;
		delay(5);
		clock=1'b1;
		delay(5);
	end
	
	
	initial 
	begin 
		rst();
		coin_input(2); //10= one rupee
		delay(30);
		coin_input(3);
		delay(50);
		coin_input(3);
		delay(50);
		coin_input(3);
		delay(50);
      coin_input(2);
		delay(50);
		coin_input(2);
		delay(50);
		$finish;
	end
	initial
	$monitor($time,"	Coin input =%b,	state=%d,	product=%b,	coin return=%b",coin_in,uut.state,product_out,coin_out);
	
endmodule
