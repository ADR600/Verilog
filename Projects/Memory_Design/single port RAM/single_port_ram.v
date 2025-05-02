
/********************************************************************************************
Filename    :	   ram.v   
Description :      Asynchronous Single port Random access memory (16x8)
*********************************************************************************************/

module ram(input we_in,enable_in,
	   input [3:0]addr_in,
	   inout [7:0]data);
					
					 
   //A 8 bit wide memory having 16 locations.
	reg [7:0] mem [15:0] ;

   //Writing data into a memory location 
   always@(data,we_in,enable_in,addr_in)
      if(we_in && !enable_in)
			mem[addr_in]=data;

   //Reading data from a memory location using inout
   assign data= (enable_in && !we_in) ? mem[addr_in] : 8'hzz;

endmodule 

