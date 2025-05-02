/*
resets the clock to 12:00 AM.
pm=0 // AM
pm=1 // PM
synchronous reset
*/
module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
	
    wire [5:1] enab;
    wire [5:1] reset_count;
    reg [3:0] load_in_hour, load_in_10hour;
    
    //seconds    
    assign enab[1] = (ena==1'b1) &&(ss[3:0] ==4'd9) ? 1'b1 : 1'b0;
    assign reset_count[1] = (reset==1'b1) ||(ss[7:4] == 4'd5 && ss[3:0] == 4'd9)? 1'b1: 1'b0;
    bcd_counter counter0 (clk,reset,ena,ss[3:0]);
    bcd_counter counter1 (clk,reset_count[1],enab[1],ss[7:4]);
    
    //minutes
    assign enab[2] = (ena==1'b1) &&(ss[3:0] ==4'd9 && ss[7:4] ==4'd5) ? 1'b1 : 1'b0;
    assign enab[3] = (ena==1'b1) &&(mm[3:0] == 4'd9 && ss[3:0] ==4'd9 && ss[7:4] ==4'd5) ? 1'b1 : 1'b0;
    assign reset_count[3] = (reset==1'b1) ||(mm[7:4]==4'd5 && mm[3:0] == 4'd9 && ss[3:0] ==4'd9 && ss[7:4] ==4'd5)? 1'b1: 1'b0;
    bcd_counter counter2 (clk,reset,enab[2],mm[3:0]);
    bcd_counter counter3 (clk,reset_count[3],enab[3],mm[7:4]);
    
    //hours
    assign enab[4] = (ena==1'b1) &&(mm[7:4]==4'd5 && mm[3:0] == 4'd9 && ss[3:0] ==4'd9 && ss[7:4] ==4'd5) ? 1'b1 : 1'b0;
    assign enab[5] = (ena==1'b1) &&(hh[3:0]==4'd9 && mm[7:4]==4'd5 && mm[3:0] == 4'd9 && ss[3:0] ==4'd9 && ss[7:4] ==4'd5) ? 1'b1 : 1'b0;
    assign reset_count[5:4] = (reset==1'b1) ||(hh[7:4]==4'd1 && hh[3:0]==4'd2 && mm[7:4]==4'd5 && mm[3:0] == 4'd9 && ss[3:0] ==4'd9 && ss[7:4] ==4'd5)? 2'b11: 2'b0;
    
    //assign load_in_hour = (reset==1'b1) ? 4'd2 : 4'd0;
    always@(ss,mm,hh,reset)
        begin
            if(reset)
                begin
                	load_in_hour = 4'd2;
                    load_in_10hour = 4'd1;
                end
            else if( hh[7:4]==4'd1 && hh[3:0]==4'd2 && mm[7:4]==4'd5 && mm[3:0] == 4'd9 && ss[3:0] ==4'd9 && ss[7:4] ==4'd5)
                begin
                	load_in_hour = 4'd1;
                    load_in_10hour = 4'd0;
                end
        end
    
    
    //assign load_in_10hour = (reset==1'b1) ? 4'd1 : 4'd0;
    bcd_counter_for_hours counter4_hour (clk,enab[4],reset_count[4],load_in_hour,hh[3:0]);
    bcd_counter_for_hours counter5_10hours (clk,enab[5],reset_count[5],load_in_10hour,hh[7:4]);
    
    //pm 
    reg pm_reg;
    assign pm= pm_reg;
    always @(posedge clk ,posedge reset)
        begin 
            if(reset)
                pm_reg <= 1'b0;
            else if(hh[7:4]==4'd1 && hh[3:0]==4'd1 && mm[7:4]==4'd5 && mm[3:0] == 4'd9 && ss[3:0] ==4'd9 && ss[7:4] ==4'd5)
            	pm_reg <= ~pm_reg;
            else
                pm_reg <= pm_reg;
        end
                    
endmodule

module bcd_counter(
    input clk,
    input reset,
    input ena,
    output [3:0]bcd_out
);
    always@(posedge clk)
        begin 
            if(reset)
                bcd_out <= 4'b0000;
            else if (ena)
                begin 
                    if(bcd_out == 4'd9)
                        bcd_out <= 4'b0;
                    else 
                        bcd_out <= bcd_out +1'b1;
                end
            else 
                bcd_out <= bcd_out ;
        end
endmodule
module bcd_counter_for_hours(
    input clk,
    input ena,
    input reset,
    input [3:0] load_data,
    output [3:0]bcd_out
);
    always@(posedge clk)
        begin 
            if(reset)
                bcd_out <= load_data;
            else if (ena)
                begin 
                    if(bcd_out == 4'd9)
                        bcd_out <= 4'b0;
                    else 
                        bcd_out <= bcd_out +1'b1;
                end
            else 
                bcd_out <= bcd_out ;
        end
endmodule
