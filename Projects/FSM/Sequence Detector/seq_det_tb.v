
/********************************************************************************************
Filename    :	   seq_det_tb.v   
Description :      Sequence detector Testbench
*********************************************************************************************/

module seq_det_tb();
		
   //Testbench global variables
   reg  din,clock,reset;
   wire dout;
		
   //Parameter constant for CYCLE
   parameter CYCLE = 10;
		
   //DUT Instantiation
   seq_det SQD(.seq_in(din),
	       .clock(clock),
	       .reset(reset),
	       .det_o(dout));

   //  clock gen, using parameter "CYCLE"  
	always
	begin 
	clock=1'b0; #(CYCLE/2);
	clock=1'b1; #(CYCLE/2);
	end
	
   /*task named "initialize" to initialize 
            the input din of sequence detector*/
	task initialize();
	begin 
		din=1'b0;
	end
	endtask
	
   //Delay task
   task delay(input integer i);
      begin
	 #i;
      end
   endtask

   /* a task named "RESET" to reset the design,
            use delay task for adding delays*/
	task RESET();
	begin 
		reset=1'b1;
		delay(5);
		reset=1'b0;
	end
	endtask
	
   /* a task named "stimulus" which provides input to
            design on negedge of clock*/
	task stimulus(input i);
	begin 
		@(negedge clock);
		din=i;
	end
	endtask
	
   //Process to monitor the changes in the variables
   initial 
      $monitor($time,"	Reset=%b, state=%b, Din=%b, Output Dout=%b",
	       reset,SQD.state,din,dout);
								
   /*Process to display a string after the sequence is detected and dout is asserted.
   SQD.state is used here as a path hierarchy where SQD is the instance name acting
   like a handle to access the internal register "state" */
   always@(SQD.state or dout)
      begin
	 if(SQD.state==2'b11 && dout==1)
	    $display("Correct output at state %b", SQD.state);
      end
			
   /*Process to generate stimulus by calling the tasks and 
   passing the sequence in an overlapping mode*/		
   initial
      begin
         initialize;
	 RESET;
	 stimulus(0);
	 stimulus(1);
	 stimulus(0);
	 stimulus(1);
	 stimulus(0);
	 stimulus(1);
	 stimulus(1);
	 RESET;
	 stimulus(1);
	 stimulus(0);
	 stimulus(1);
	 stimulus(1);
	 delay(10);    
	 $finish;
      end
			
   		
endmodule     
