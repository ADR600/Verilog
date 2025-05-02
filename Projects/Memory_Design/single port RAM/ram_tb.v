/********************************************************************************************
Webpage     :      www.maven-silicon.com
Filename    :	   ram_tb.v   
Description :      Testbench for Single Port RAM
*********************************************************************************************/

module ram_tb;
   wire [7:0] data;
   reg  [3:0] addr;
   reg  we,enable;
   reg  [7:0] tempd; //for using inout port as input we create temp reg

   integer l;

   //Instantiating the RAM module and connecting port
	ram dut(.we_in(we),.enable_in(enable),.addr_in(addr),.data(data));
	
   //assign tempd to data under write condition
   assign data=(we && !enable) ? tempd : 8'hzz;

    //Tasks for Initialising the inputs
   task initialize();
      begin
			we=1'b0; enable=1'b0; tempd=8'h00;
      end
   endtask

   
	task stimulus(input [3:0]i , input [7:0]j);
	begin
		addr  = i;
		tempd = j;
	end
	endtask
	
   //Tasks used in this testbench
   task write();
   begin
		we=1'b1;
		enable=1'b0;
   end
   endtask

   task read();
   begin
		we=1'b0;
		enable=1'b1;
   end
   endtask

   task delay;
		begin
			#10;
		end
	endtask
		
   //Process to generate stimulus using for loop
   initial
      begin
			initialize;
			delay;
			write;
			for(l=0;l<16;l=l+1)
				begin
					 stimulus(l,l);
					 delay;
				end
			initialize;
			delay;
			read;
			for(l=0;l<16;l=l+1)
				begin
					 stimulus(l,l); //tempd not used 
					 delay;
				end
			delay;
			$finish;
      end

endmodule
