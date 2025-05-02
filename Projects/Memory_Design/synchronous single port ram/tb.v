
`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Create Date:   
// Design Name:   synch_single_port_ram
// Module Name: 
// Project Name:  synch_single_port_ram
////////////////////////////////////////////////////////////////////////////////

module synch_single_port_ram_tb;

	// Inputs
	reg clk;
	reg reset;
	reg we;
	reg re;
	reg [3:0] addr;

	// Bidirs
	wire [7:0] data;
	reg [7:0] regd;
	integer i;
	
	//for using inout as input
	assign data = (we && !re) ? regd : 8'dzz;

	// Instantiate the Unit Under Test (UUT)
	synch_single_port_ram uut (
		.clk(clk), 
		.reset(reset), 
		.we(we), 
		.re(re), 
		.addr(addr), 
		.data(data)
	);

	//tasks for stimulus
	task read();
	begin 
		we=0;
		re=1;
	end
	endtask
	
	task write();
	begin
		we=1;
		re=0;
	end
	endtask
	
	task initialise();
	begin 
		clk = 0;
		reset = 0;
		we = 0;
		re = 0;
		addr = 0;
		regd=0;
	end
	endtask
	
	task stimulus(input [3:0]x,input [7:0] y);
	begin 
		@(negedge clk);
		addr=x;
		regd=y;
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
		#10;
	endtask
	
	always
	#5 clk=~clk;
	
	initial 
	begin
		initialise();
		rst(); // reset all locations to 0
		addr=3;
		delay();
		addr=10;
		delay();
		
		//write into memory 
		write();
		for(i=0;i<16;i=i+1)
			stimulus(i,i);
		delay();
		
		//read from memeory 
		read();
		for(i=0;i<16;i=i+1)
			stimulus(i,i);
		delay();

		write();
		stimulus(15,78);
		delay();
		rst();
		read();
		stimulus(15,75);
		delay();
		
		$finish;

	end
   initial
		$monitor($time,"	value in dout=%d",uut.dout);
endmodule

