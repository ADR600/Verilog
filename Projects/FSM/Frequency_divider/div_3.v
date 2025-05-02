`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Create Date:    13:54:36 04/18/2025 
// Design Name: 
// Module Name:    div_3 
 //////////////////////////////////////////////////////////////////////////////////

module div_3(
    input clk,reset,in,
    output [1:0] rem,
	 output div
    );
	 
	parameter R0=2'b00,
				 R1=2'b01,
				 R2=2'b10;
	
	reg [1:0] state,next_state;
	
	//present state logic-seq
	always@(posedge clk,posedge reset)
	begin
		if(reset)
			state <= R0;
		else 
			state <= next_state;
	end
	
	//next state decoder-combo
	always@(state,in)
	begin 
		next_state = R0;
		case(state)
			R0: begin
					if(in) next_state = R1;
					else next_state = R0;
				 end
		   R1: begin 
					if(in) next_state = R0;
			      else next_state = R2;
				 end
		   R2: begin 
					if(in) next_state = R2;
					else next_state = R1;
				 end
			default : next_state = R0;
		endcase
	end
	
	//output logic -combo
	assign rem = state;
	assign div = (state==R0);
	
	
endmodule
