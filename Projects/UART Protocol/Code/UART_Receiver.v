// uart fsm 
//fifo 
//baud generator

module UART_Receiver
#(
parameter   DBIT = 8,           // no. of data bit
            SB_TICK = 16,       // oversampling - 16 ticks per bit
            DATA_WIDTH = 8,     //bit width
            ADDR_WIDTH=2       //depth of fifo
)
(
input clk,reset,
input [10:0] dvsr,
//data to receiver 
input rx,
//read interface
input rd_uart,
output rx_empty,rx_full,         //rx fifo full/empty ??
output [7:0] r_data
);
          
wire s_tick,rx_done_tick;
wire [7:0] dout;
 uart_rx
#(
.DBIT(DBIT),
.SB_TICK(SB_TICK)
 )
 Receiver
 (
 .clk(clk),
 .reset(reset),
 .rx(rx),
 .s_tick(s_tick),
 .rx_done_tick(rx_done_tick),
 .dout(dout)
 );
 
 baud_gen Generator
(
.clk(clk),
.reset(reset),
.dvsr(dvsr),
.tick(s_tick)
);

fifo
#(
.DATA_WIDTH(DATA_WIDTH),
.ADDR_WIDTH(ADDR_WIDTH)
) 
FIFO
(
.clk(clk),
.wr(rx_done_tick),
.rd(rd_uart),
.reset(reset),
.w_data(dout),
.r_data(r_data),
.full(rx_full),
.empty(rx_empty)
);
    
endmodule
