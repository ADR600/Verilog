`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    
// Module Name:    fibonacci_series 
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
module fibonacci_series(
	input clk,
	input reset,
	input [7:0]terms,
	output [31:0] series_value
    );

reg [7:0] counter;

reg [31:0] previous_term , current_term ; 

assign series_value = current_term ;

always@(posedge clk,posedge reset)
begin 
	if(reset)
	begin
		previous_term <=0;
		current_term <=0; 
		counter <=0;
	end
	else 
	begin
		if((counter == 0) || (counter == 1))
		begin
			previous_term<= 0;
			counter <= counter + 1'b1;
			if(counter ==0)
				current_term <=0;
			if(counter ==1)
				current_term <=1;	
		end
		else if(counter < terms)
		begin 
			previous_term <= current_term ;
			current_term <= previous_term + current_term ;
			counter <= counter + 1'b1;
		end
		else 
		begin
			current_term <= current_term;
			previous_term<= previous_term;
		end
	end
end

endmodule
