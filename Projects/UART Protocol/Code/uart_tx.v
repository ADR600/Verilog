// here instead of oversampling we put data on line 
// transmitter wait for 16 ticks and send next bit by shifting 
//internal register , for 8 bits 
//for stop bit based on SB_TICK wait for x ticks

module uart_tx
#(
parameter   DBIT =8,
            SB_TICK = 16
 )
 (
 input  clk,reset,
 input  tx_start,
 s_tick,        // for every s_tick ,send data bit
 input   [7:0] din,
 output  reg tx_done_tick,
 output  tx
 );
 

 parameter  idle=0,
            start=1,
            data=2,
            stop=3;
 
 reg [1:0] state_reg,state_next;
 reg [3:0] s_reg,s_next;      //how many ticks
 reg [2:0] n_reg,n_next;      //no of data bit transmitted , counter to stay in data state
 reg [7:0] b_reg,b_next;      //internal shift register to hold transmitting value
 reg tx_reg,tx_next;
 
always@(posedge clk, posedge reset)
    if(reset)
    begin
        state_reg <= idle;
        s_reg <= 0;
        n_reg <= 0;
        b_reg <= 0;
        tx_reg <= 1'b1;
    end
    else 
    begin
        state_reg <= state_next;
        s_reg <= s_next;
        n_reg <= n_next;
        b_reg <= b_next;
        tx_reg <= tx_next;
    end
    
 always@(*)
 begin
    state_next = state_reg;
    tx_done_tick = 1'b0;
    s_next = s_reg;
    n_next = n_reg;
    b_next = b_reg;
    tx_next =tx_reg;
    case(state_reg)
        idle : 
            begin
                tx_next = 1'b1;
                if(tx_start)                              //move to start state 
                begin
                    state_next = start;
                    s_next = 0;
                    b_next = din;                        //store into internal register  
                end
            end
        start : 
            begin
                tx_next = 1'b0;
                if(s_tick)
                    if(s_reg ==15)                        
                    begin
                        state_next = data;
                        s_next =0;
                        n_next = 0;                     //set n to 0 
                    end
                    else 
                        s_next = s_reg +1;
             end
        data :    
            begin
                tx_next = b_reg[0];
                if(s_tick)
                    if(s_reg ==15)                  //change bit to transmit
                    begin
                        s_next =0;
                        b_next = b_reg >>1;         //shift to send another bit
                        if(n_reg == (DBIT -1))      // all data bit transmitted ??
                            state_next = stop;
                        else 
                            n_next = n_reg + 1;
                     end
                     else 
                        s_next = s_reg + 1;
             end
          stop :
          begin
            tx_next = 1'b1;                         //make bus back to hig
            if(s_tick)
                    if(s_reg ==(SB_TICK -1))        
                    begin
                        state_next = idle;
                        tx_done_tick = 1'b1;        //for one cycle 
                    end
                    else 
                        s_next = s_reg + 1;         // increment till SB_TICK met
    
        end
    endcase
 end
 
 assign tx = tx_reg;    
                        
endmodule
