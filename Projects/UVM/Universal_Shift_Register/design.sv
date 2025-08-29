//Universal shift register 
// 4 operations
// 	shift left - load 0 right
//	shift right - load 0 left
//	load parallel
//	hold data 
// synchronous active high reset

module shift_register ( 
  clock,
  rst,
  mode,
  data_in,
  data_out);
  
  input wire clock, rst;
  input wire [1:0] mode;
  input wire [3:0] data_in;
  output reg [3:0] data_out;
  
  always_ff@(posedge clock)begin 
    if(rst)
      	data_out <= 4'd0;
    else begin
      	case(mode)
        	2'b00 : begin 
          		data_out [3:1] <= data_out [2:0];
          		data_out [0] <= 1'b0;
        		end
        	2'b01 : begin 
          		data_out [2:0] <= data_out [3:1];
          		data_out [3] <= 1'b0;
        	end
        	2'b10 : 
              	data_out <= data_in;
        	2'b11 : 
              	data_out <= data_out;
      endcase
    end
  end
endmodule
