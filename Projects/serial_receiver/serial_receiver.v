module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
);  
parameter start=0,first=1,second=2,third=3,fourth=4,fifth=5,sixth=6,seventh=7,eighth=8,parity=9,stop=10,idle=11,discard=12;
reg [3:0] state,next_state;
reg[8:0] store_value;
    
    //next state logic
    always@(state,in)
        begin
            next_state = idle;
            case(state)
                idle : if(!in) next_state=start;
                else next_state = idle;
                start :  next_state = first;
                first :  next_state = second;
                second :  next_state = third;
                third :  next_state = fourth;
                fourth :  next_state = fifth;
                fifth :  next_state = sixth;
                sixth :  next_state = seventh;
                seventh :  next_state = eighth;
                eighth : next_state = parity;
                parity : if(in) next_state = stop;
                else next_state = discard;
                stop : if(!in) next_state = start;
                else next_state = idle;
                discard : if(in) next_state = idle;
                else next_state = discard;
            endcase
        end  
    
    //present state logic 
    always@(posedge clk)
        begin 
            if(reset)
                state <= idle;
            else
                state <= next_state;
        end
    
    //data path
     always@(posedge clk)
        begin 
            if(reset)
                begin
                	store_value <= 9'h00;
                    //count <=4'd0;
                end
            else 
				begin 
                    if((state==start)||(state == first )||(state == second )||(state == third )||(state == fourth )||(state == fifth )||(state == sixth )||(state == seventh )||(state==eighth))
                        begin 
                            store_value[8] <= in;
                            store_value[7:0] <= store_value[8:1];
                        end
                   
                    else 
                        store_value <= store_value;
                end
        end
    // reg parity_check
   // always@(store_value)
       // begin
           // parity_check = ^store_value;
       // end
    
    assign out_byte = (done==1) ? store_value[7:0] : 8'hxx;
    assign done = ((state == stop)  && ^store_value) ;
endmodule
