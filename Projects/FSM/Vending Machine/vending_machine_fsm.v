
`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////// 
// Create Date:    
// Design Name: 
// Module Name:    vending_machine 
//////////////////////////////////////////////////////////////////////////////////

module vending_machine_fsm(
    input clock,reset,
	 input [1:0] coin_in,
    output [1:0] coin_out,
	 output product_out
    );
	 
	parameter IDLE = 3'b000,
				 STATE1 = 3'b001,
				 STATE2 = 3'b010,
				 STATE3 = 3'b011,
				 STATE4 = 3'b100;
				 
	reg [2:0] state,next_state;
	
	//present state logic-seq
	always@(posedge clock,posedge reset)
	begin
		if(reset)
			state <= IDLE;
		else
			state <= next_state;
	end
	
	//next state decoder-combo
	always@(state,coin_in)
	begin
		next_state = IDLE;
		case(state)
			IDLE : case(coin_in)
						2'b00 : next_state = IDLE;    //NO COIN
						2'b01 : next_state = IDLE;    // NO COIN
						2'b10 : next_state = STATE1;  // ONE RUPEE COIN
						2'b11 : next_state = STATE2;  // TWO RUPEE COIN
					 endcase
		  STATE1 : case(coin_in)
						2'b00 : next_state = STATE1;
						2'b01 : next_state = STATE1;
						2'b10 : next_state = STATE2;
						2'b11 : next_state = STATE3;
					 endcase
		  STATE2 : case(coin_in)
						2'b00 : next_state = STATE2;
						2'b01 : next_state = STATE2;
						2'b10 : next_state = STATE3;
						2'b11 : next_state = STATE4;
					 endcase
		 STATE3 : next_state = IDLE;
		 STATE4 : next_state = IDLE;
		 default: next_state = IDLE;
		endcase
	end
	
	assign product_out = (( state == STATE3) |(state == STATE4)) ? 1'b1 : 1'b0;
	assign coin_out    = (state == STATE4) ? 2'b10 : 2'b00; //10=one rupee coin
	
	
endmodule
