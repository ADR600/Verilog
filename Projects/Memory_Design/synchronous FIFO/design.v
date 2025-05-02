`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// Create Date: 
// Design Name: 
// Module Name:    FIFO
//////////////////////////////////////////////////////////////////////////////////

module FIFO(
	clock,
	reset_n, //asynchronous active low
	data_in,
	read_n,
	write_n,
	data_out,
	full,
	empty
    );
	 
	input clock,reset_n,read_n,write_n;
	input [7:0] data_in;
	output reg [7:0] data_out;
	output full,empty;
	
	reg [7:0] mem [15:0];
	integer i;
	reg [4:0] count; //count how many location in fifo is full (0 to 16)
	reg [3:0]  rd_ptr , wr_ptr;
	
	//read write logic
	always@(posedge clock or negedge reset_n)
	begin 
		if(!reset_n) //async reset active low
		begin
			rd_ptr  <=4'b000;
			wr_ptr  <=4'b000;
			data_out<= 4'b000;
			//count   <= 5'b00000;
			for(i=0;i<16;i=i+1) 
				mem[i] <= 8'b00000000;
		end	
		else
			begin 
				if(!read_n && !empty) //read and not empty
				begin 
					data_out <=mem[rd_ptr];
					rd_ptr <= rd_ptr +1'b1;
					//count <= count - 1'b1;
				end
				if(!write_n && !full) // write and not full
				begin
					mem[wr_ptr] <= data_in;
					wr_ptr <= wr_ptr +1'b1;
					//count <= count + 1'b1;
				end		
			end
		end
	 
		// count logic 
		always@(posedge clock or negedge reset_n)
		begin 
			if(!reset_n)
				count <= 5'b00000;
			else
			begin 
			case({write_n,read_n})
				2'b00 : count <= count ;
				2'b01 : count <= count + 1'b1 ;
				2'b10 : count <= count - 1'b1 ;
				2'b11 : count <= count ;
			   default: count <= count;
			endcase
			end
		end
		
		
		assign full  = (count== 5'b10000);
		assign empty = (count==5'b00000);
		
		
endmodule
