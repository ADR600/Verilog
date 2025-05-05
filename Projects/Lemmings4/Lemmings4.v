module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
	
    parameter LEFT=0,RIGHT=1,FALL_L=2,FALL_R=3,DIG_L=4,DIG_R=5,SPLATTER=6;
    reg [2:0] state,next_state;
    
    reg [7:0] count;
    
    always@(posedge clk,posedge areset)
        begin
            if(areset)
                state <=LEFT;
            else
                state <= next_state;
        end
    
    always@(*)
        begin
            case(state)
                LEFT : begin
                    if(!ground)
                        next_state = FALL_L; 
                    else if(dig)
                        next_state = DIG_L;
                    else if(bump_left)
                        next_state = RIGHT;
                    else 
                        next_state = LEFT;
                end
                RIGHT : begin
                    if(!ground)
                        next_state = FALL_R;
                    else if(dig)
                        next_state = DIG_R;
                    else if(bump_right)
                        next_state = LEFT;
                    else 
                        next_state = RIGHT;
                end
                FALL_L : begin
                    if(ground)
                         begin
                             if(count <=19)
                        		next_state = LEFT;
                            else 
                                next_state = SPLATTER;
                          end
                    else
                        next_state = FALL_L;
                end
                 FALL_R : begin
                    if(ground)
                        begin
                            if(count <=19)
                        		next_state = RIGHT;
                            else 
                                next_state = SPLATTER;
                         end
                    else 
                        next_state = FALL_R;
                end
                 DIG_L : begin
                     if(!ground)
                        next_state = FALL_L;
                    else 
                        next_state = DIG_L;
                end
                DIG_R : begin
                     if(!ground)
                        next_state = FALL_R;
                    else 
                        next_state = DIG_R;
                end
                SPLATTER : begin
                     next_state <= SPLATTER;
                end            
            endcase
        end
    
    always@(posedge clk,posedge areset)
        begin
            if(areset)
                count <=8'd0;
            else if((state==FALL_L)||(state==FALL_R))
                count <= count + 1'b1;
            else 
                count <= 8'd0;
        end
    
    assign walk_left = (state==LEFT);
    assign walk_right = (state==RIGHT);
    assign aaah = ((state==FALL_L)||(state==FALL_R));
    assign digging = ((state==DIG_L)||(state==DIG_R));
    
endmodule
