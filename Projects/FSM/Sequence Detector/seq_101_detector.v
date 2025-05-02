module seq_det(seq_in,
	       clock,
	       reset,
	       det_o);
								 
   // states as parameter "IDLE","STATE1","STATE2","STATE3"
	parameter IDLE = 2'b00,
				 STATE1 = 2'b01,
				 STATE2 = 2'b10,
				 STATE3 = 2'b11;
				 
   // ports direction
	input seq_in,clock,reset;
	output det_o;
	
   //Internal registers
   reg [1:0]state,next_state;

   // sequential logic for present state with active high asychronous reset
	always@(posedge clock,posedge reset)
	begin
		if(reset)
			state <= IDLE ;
		else 
			state <= next_state ;
	end
	
   //combinational logic for next state
   always@(state,seq_in)
      begin
		next_state=IDLE;
	 case(state)
	    IDLE   : 
                      if(seq_in) 
		         next_state=STATE1;
	              else
	                 next_state=IDLE;
	    STATE1 : 
                      if(!seq_in)
	                 next_state=STATE2;
	              else
	                 next_state=STATE1;
	    STATE2 :
                      if(seq_in)
	                 next_state=STATE3;
	              else 
	                 next_state=IDLE;
	    STATE3 : 
                      if(seq_in)
	                 next_state=STATE1;
	              else 
	                 next_state=STATE2;
	    default: 
                      next_state=IDLE;
	 endcase
      end

   //logic for Moore output det_o
	assign det_o = (state == STATE3 );
	
endmodule

