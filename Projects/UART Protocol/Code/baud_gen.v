//modulo counter for dvsr+1
// (dvsr +1 )*16 = frequency 
//          f
// v = -----------  -  1
//          16xb
//v is dvsr
//b - baud rate 
//f - frequency 
module baud_gen
(
input  clk,reset,
input  [10:0] dvsr,        //divisor , 11bit for fitting max baud rate 
                                // is value to provide to get exact baud rate 
output  tick
);

reg [10:0] r_reg;
wire [10:0] r_next;

always@(posedge clk,posedge reset)
    if(reset)
        r_reg <= 0;
    else 
        r_reg <= r_next;
        
 assign r_next = (r_reg ==dvsr) ? 0 : r_reg +1;
 
 assign tick = (r_reg==1)? 1'b1 : 1'b0 ;
 
endmodule
