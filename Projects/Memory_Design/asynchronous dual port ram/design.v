`timescale 1ns / 1ps

////////////////////////////////////////////////////////
// Create Date:    					//
// Module Name:    dual_port_ram_two_clock 			   //
////////////////////////////////////////////////////////

// asynchronous dual port ram 
// dual port - both read and write same item
//two clock 


module dual_port_ram_two_clock(
	wr_clk,
	we,
	wr_addr,
	din,
	rd_clk,
	re,
	rd_addr,
	dout
    );
	 
	input we,re,wr_clk,rd_clk;
	input [15:0] din;
	input [2:0] wr_addr,rd_addr;
	output reg [15:0] dout;

	
	reg [15:0] mem [7:0];
	
	always@(posedge wr_clk)
	begin 
		if(we)
			mem[wr_addr] <= din;
	end
	
	always@(posedge rd_clk)
	begin 
		if(re)
			dout <= mem[rd_addr];
		else 
			dout <= 16'dz;
	end

	/*always@(posedge wr_clk,posedge rd_clk)
	begin
	
		if(wr_clk) //wr_clk triggered
		begin
			if(we)
				mem[wr_addr] <= din;
		end
		
		if(rd_clk)
		begin
			if(re)
				dout <= mem[rd_addr];
		end
		
	end*/
	
endmodule

