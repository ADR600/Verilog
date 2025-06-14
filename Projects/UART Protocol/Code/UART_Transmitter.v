//transmitter fsm
//baud rate geenrator 
//fifo 
module UART_Transmitter
#(
parameter   DBIT = 8,           // no. of data bit
            SB_TICK = 16,       // oversampling - 16 ticks per bit
            DATA_WIDTH = 8,     //bit width
            ADDR_WIDTH=2       //depth of fifo
)
(
input clk,reset,
input [10:0] dvsr,
//data bit  to send 
output  tx,
//write interface
input wr_uart,
input  [7:0] w_data,
output tx_full                //tx fifo full/empty ??

);

     
wire s_tick,tx_done_tick;
wire [7:0] r_data;

wire tx_empty ;

reg  tx_fifo_not_empty ;
always@(posedge  clk, posedge  reset)
    if(reset)
        tx_fifo_not_empty <= 0;
    else 
        tx_fifo_not_empty <= ~ tx_empty;

 uart_tx
#(
.DBIT(DBIT),
.SB_TICK(SB_TICK)
 )
 Transmitter 
 (
 .clk(clk),
 .reset(reset),
 .tx(tx),
 .tx_start(tx_fifo_not_empty),
 .s_tick(s_tick),
 .tx_done_tick(tx_done_tick),
 .din(r_data)
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
.wr(wr_uart),
.rd(tx_done_tick),
.reset(reset),
.w_data(w_data),
.r_data(r_data),
.full(tx_full),
.empty(tx_empty)
);
   

endmodule
