`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:16:22 04/14/2025 
// Design Name: 
// Module Name:    dual_port_ram 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

// dual port ran allows read or write in one clock not both 


module dual_port_ram(
	clk,
	reset, //asynch reset
	re,
	re_addr,
	din,
	we,
	we_addr,
	dout
    );
	 
	input clk,we,re,reset;
	input [3:0] re_addr,we_addr;
	input [7:0] din;
	output reg [7:0] dout;
	integer i;
	
	//internal memory 
	reg [7:0] mem [15:0];
	
	always@(posedge clk,posedge reset)
	begin 
		if(reset)
		begin
			for(i=0;i<16;i=i+1)
				mem[i] <= 8'd0; //should it reset output also??
			dout <= 8'd0;
		end
		else	
/*			case({we,re})
				2'b10: begin // write only
							mem[we_addr] <= din;
							dout <= 8'dz;
						end
				2'b01: begin //read only
							dout <= mem[re_addr];
						end
				2'b11: begin //both read write
							mem[we_addr] <= din;
							dout <= mem[re_addr];
						 end
				default : dout <= 8'dz;
			endcase
*/		begin 
			if(re)
				dout<= mem[re_addr];
			if(we)
				mem[we_addr] <= din;
		end
end
	


endmodule
