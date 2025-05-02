
`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////  
// Design Name:   FIFO   
// Project Name:  synchronous_FIFO
/////////////////////////////////////////////////////////////////////////////

module FIFO_tb;

	// Inputs
	reg clock;
	reg reset_n;
	reg [7:0] data_in;
	reg read_n;
	reg write_n;

	// Outputs
	wire [7:0] data_out;
	wire full;
	wire empty;
	integer i;
	// Instantiate the Unit Under Test (UUT)
	FIFO uut (
		.clk(clock), 
		.rst(reset_n), 
		.data_in(data_in), 
		.re(read_n), 
		.we(write_n), 
		.data_out(data_out), 
		.full(full), 
		.empty(empty)
	);

	always
	#5 clock=~clock;
	
	task initialise();
	begin 
		clock=1'b0;
		reset_n=1'b0;
		read_n=1'b1;
		write_n=1'b1;
		#2;
		reset_n=1'b1;
	end
	endtask
	
	task write_fifo();
	begin 
		write_n=1'b0;
		for(i=0;i<16;i=i+1)
			begin
				data_in = i;
				@(negedge clock);
			end
		delay(10);
		write_n=1'b1;
	 end
	 endtask
	 
	task delay(input x);
		#x;
	endtask
	
	task read_fifo();
	begin
		read_n=1'b0;
		repeat(16)@(posedge clock)
		delay(10);
		read_n=1'b1;
	end
	endtask
	
	initial
	begin
		initialise();
		write_fifo();
		delay(5);
		read_fifo();
		//write_fifo();
		read_fifo();
		$finish;
	end
	
	initial
	begin
		#180;
		write_fifo();
	end
	
	initial
	$monitor($time," dout=%b,	counter=%d,	write pointer=%b,	read pointer=%b",data_out,uut.count,uut.write_pointer,uut.read_pointer);
endmodule

