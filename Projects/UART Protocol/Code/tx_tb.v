`timescale 1ns / 1ps


module tx_tb;

reg clk,reset;
reg [10:0] dvsr;
wire  tx;
reg wr_uart;
reg  [7:0] w_data;
wire tx_full ;              


//check ticks
 wire gen_tick ;
 assign gen_tick = dut.Generator.tick;
 wire transmit_done;
 assign transmit_done = dut.Transmitter.tx_done_tick;
 
 
 
UART_Transmitter 
#(
            .DBIT (8),           // no. of data bit
            .SB_TICK (16),       // oversampling - 16 ticks per bit
            .DATA_WIDTH (8),     //bit width
            .ADDR_WIDTH(2)       //depth of fifo
)
dut 
(
.clk(clk),
.reset(reset),
.dvsr(dvsr),
.tx(tx),
.wr_uart(wr_uart),
.w_data(w_data),
.tx_full(tx_full)               
);

parameter   idle=0,
            start=1,
            data=2,
            stop=3;

//fsm state of receiver         
reg [40 : 1] string ;
always@(*)
    case(dut.Transmitter.state_reg)
        idle : string = "idle";
        start : string = "start";
        data : string = "data";
        stop : string = "stop";  
    endcase
        
always  //clock is 100MHz
    #5  clk = ~clk;
    
task initialise;
input [10:0] x;
begin   
    reset = 1'b0;
    clk = 1'b0;
    dvsr = x;
    w_data = 8'b0;
    wr_uart = 1'b0;
end
endtask


task rst;
    begin
        @(negedge clk);  
        reset = 1;
        @(negedge clk);
        reset = 0;
        $display("reset done");
    end
endtask

task send_byte_to_fifo;
input [7:0] data;
begin
    wait(~tx_full);
    @(negedge clk);
    wr_uart =1;
    w_data = data;
    @(negedge clk);
    wr_uart = 0;
end
endtask


//monitor on console
initial 
    begin:monitor_block
        $monitor($time,"    tx_state =%s     internal tx_reg =%b "   ,string,dut.Transmitter.b_reg);
        $monitor($time, "   tx=%b",tx);
       // $monitor($time,"    baud_reg =%0d",generator.r_reg);
       // $monitor($time,"    transmit  done =%b",transmit_done);
    end
  

initial 
begin

    initialise(11'd650);
    
    rst; 
   // $readmemb("tx_fifo_content.mem",dut.FIFO.mem);
    
    send_byte_to_fifo(8'b01111110);
    send_byte_to_fifo(8'b11111111);
    send_byte_to_fifo(8'b01010101);
    send_byte_to_fifo(8'b11010111);
    #1_041_667 ;


    #1_041_667; // ~105k cycles for 1 packet - start _ data_stop 
    #1_041_667 ;
    #1_041_667 ;
    #1_041_667 ;
    #1_041_667 ;

    $finish;
 end
 
endmodule
