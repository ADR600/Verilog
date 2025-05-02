`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Module Name:    dual_port_ram_tb 
//////////////////////////////////////////////////////////////////////////////////
module dual_port_ram_tb(
    );
	 
	reg clk,we,re,reset;
	reg [3:0] re_addr,we_addr;
	reg [7:0] din;
	wire[7:0] dout;
	integer i,j;
	
	parameter cycle =10;
	
	dual_port_ram dut(
	clk,
	reset,
	re,
	re_addr,
	din,
	we,
	we_addr,
	dout
    );
	 
	 always
	 begin
		clk=1'b0;
		#(cycle/2) 
		clk=1'b1;
		#(cycle/2);
	 end
	 
	 task rst();
	 begin
		#1;
		reset=1'b1;
		#1;
		reset=1'b0;
	 end
	 endtask
	 
	 task stimulus_write(input [3:0]loc, input [7:0] data);
	 begin 
			@(negedge clk);
			we_addr = loc;
			din =data;
	 end
	 endtask
	 
	 task write (input x);
		we = x;
	 endtask 
	 
	 task read (input x);
		re = x;
	 endtask
	 
	 task read_all_loc ();
	 begin
		for(j=0;j<16;j=j+1)
		begin
			@(negedge clk);
			re_addr = j;
		end
	 end
	 endtask
	 
	 task initialise();
	 begin 
		we=0;
		re=0;
		we_addr=0;
		re_addr=0;
		din=0;
	 end
	 endtask
	 
	 task delay();
		#cycle;
	 endtask
	 
	 initial 
	 begin 
		initialise();
		//read(1);
		//re_addr=4'b0100;
		write(1);
		for(i=0;i<16;i=i+1)
		begin 
			stimulus_write(i, $random );
		end
		delay();
		write(0);
		//read(1);
		//for(i=0;i<16;i=i+1)
		//begin 
			//read_loc(i);
			//delay();
		//end
		
	 end
	 
 
initial 
begin 
	rst();

	read(1);
	read_all_loc ();
	delay();
	read_all_loc();
	delay();
	rst();
	read(1);
	delay();
	delay();
	$finish;
end
			
endmodule
