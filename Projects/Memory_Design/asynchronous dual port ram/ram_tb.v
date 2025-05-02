
`timescale 1ns / 1ps

/////////////////////////////////////////////////////////////////
// Create Date:    			//
// Module Name:    dual_port_ram_dual_clock_tb 						//
/////////////////////////////////////////////////////////////////

module dual_port_ram_dual_clock_tb(
    );
	reg we,re,wr_clk,rd_clk;
	reg [15:0] din;
	reg [2:0] wr_addr,rd_addr;
	wire [15:0] dout;
	
	dual_port_ram_two_clock dut(
	wr_clk,
	we,
	wr_addr,
	din,
	rd_clk,
	re,
	rd_addr,
	dout
    );
	parameter read_cycle = 20,
				 write_cycle= 10;
	integer i,j;
	
	always
	#(read_cycle/2) rd_clk=~rd_clk;
	 
	always
	#(write_cycle/2) wr_clk=~wr_clk;

	task write( );
	begin 
		we=1;
		for(i=0;i<8;i=i+1)
		begin
			@(negedge wr_clk);
			wr_addr = i;
			din = i;
		end
		#write_cycle;
		we=0;
		wr_addr=0;
		
	end
	endtask
	
	task read_all();
	begin 
		re=1;
		for(j=0;j<8;j=j+1)
		begin
			@(negedge rd_clk);
			rd_addr=j;
		end
		#read_cycle;
		re=0;
	end
	endtask
	
	initial
	begin
		wr_clk=0;
		write();
		#20;
	end
	
	initial
	begin
		rd_clk=0;
		read_all();
		read_all();
		$finish;
	end
	
endmodule
