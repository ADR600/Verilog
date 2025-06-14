//monitor rx  
//based on s_tick sample and shift the shidt register
module uart_rx
#(
parameter   DBIT =8,
            SB_TICK = 16
 )
 (
 input wire clk,reset,
 input wire rx,s_tick,
 output reg rx_done_tick,
 output  wire [7:0] dout
 );
 
 localparam  idle=0,
            start=1,
            data=2,
            stop=3;
 
 reg [1:0] state_reg,state_next;
 reg [3:0] s_reg,s_next;      //how many ticks s=7(start bit sample),s=15(data bit),s=SB_TICK(stop bit) 
 reg [2:0] n_reg,n_next;      //no of data bit transmitted , counter to stay in data state
 reg [7:0] b_reg,b_next;      //internal shift register of receiver 
 
always@(posedge clk, posedge reset)
    if(reset)
    begin
        state_reg <= idle;
        s_reg <= 0;
        n_reg <= 0;
        b_reg <= 0;
    end
    else 
    begin
        state_reg <= state_next;
        s_reg <= s_next;
        n_reg <= n_next;
        b_reg <= b_next;
    end
    
 always@(*)
 begin
    state_next = state_reg;
    rx_done_tick = 1'b0;
    s_next = s_reg;
    n_next = n_reg;
    b_next = b_reg;
    case(state_reg)
        idle : 
            if(~rx)
            begin
                state_next = start;
                s_next = 0;
            end
        start : 
            if(s_tick)
                if(s_reg ==7)                       //sample start bit 
                begin
                    state_next = data;
                    s_next =0;
                    n_next = 0;                     //set n to 0 
                end
                else 
                    s_next = s_reg +1;
        data :    
                if(s_tick)
                    if(s_reg ==15)                  // middle  of that data bit 
                    begin
                        s_next =0;
                        b_next = {rx,b_reg[7:1]};   //sample the bit and shift in register
                        if(n_reg == (DBIT -1))      // all data bit transmitted ??
                            state_next = stop;
                        else 
                            n_next = n_reg + 1;
                     end
                     else 
                        s_next = s_reg + 1;
          stop : if(s_tick)
                    if(s_reg ==(SB_TICK -1))        //sample stop bit 
                    begin
                        state_next = idle;
                        rx_done_tick = 1'b1;        //for one cycle 
                    end
                    else 
                        s_next = s_reg + 1;         // increment till SB_TICK met
    endcase
 end
 
 assign dout = b_reg;    
                        
endmodule