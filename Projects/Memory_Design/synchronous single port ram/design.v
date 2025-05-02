
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Create Date:    
// Design Name: 
// Module Name:    synch_single_port_ram 
//////////////////////////////////////////////////////////////////////////////////

module synch_single_port_ram(
    input clk,
    input reset,
    input we,
    input re,
    input [3:0] addr,
    inout [7:0] data
    );
	 
	reg [7:0] mem [15:0] ;
	reg [7:0] dout; // for inout port
	integer i;
	
	always@( posedge clk or posedge reset)
	begin 
		if(reset)
			begin 
				for(i=0;i<16;i=i+1) 
					mem[i] <= 8'd000;
				dout <= 8'd0;
			end
		else
			begin //paralelly check both - one port so either read or write 
				if(we && !re)
					mem[addr] <= data;
				if(!we && re)
					dout <= mem[addr];	// using temp for reg
		   end	
	end
	
	assign data = (re && !we)| (reset)? dout : 8'dz ; // ? least priority no need ()

		
endmodule
