
// write to transmitter fifo 
//read from receiver fifo 

module Transmitter_Receiver
#(
parameter   DBIT = 8,           // no. of data bit
            SB_TICK = 16,       // oversampling - 16 ticks per bit
            DATA_WIDTH = 8,     //bit width
            ADDR_WIDTH=2        //depth of fifo
)(

input clk,reset,
input [10:0]dvsr,

input wr_uart,
input [7:0] w_data,

input rd_uart,
output rx_empty,rx_full,tx_full,
output [7:0] r_data
);

wire tx_rx;

            
UART_Transmitter
#(
            .DBIT (DBIT),           // no. of data bit
            .SB_TICK (SB_TICK),       // oversampling - 16 ticks per bit
            .DATA_WIDTH (DATA_WIDTH),     //bit width
            .ADDR_WIDTH(ADDR_WIDTH)       //depth of fifo
)
Transmitter
(
.clk(clk),.reset(reset),
.dvsr(dvsr),
.tx(tx_rx),
.wr_uart(wr_uart),
.w_data(w_data),
.tx_full(tx_full)                //tx fifo full/empty ??

);


 UART_Receiver
#(
            .DBIT (DBIT),           // no. of data bit
            .SB_TICK (SB_TICK),       // oversampling - 16 ticks per bit
            .DATA_WIDTH (DATA_WIDTH),     //bit width
            .ADDR_WIDTH(ADDR_WIDTH)       //depth of fifo
)
Receiver
(
.clk(clk),.reset(reset),
.dvsr(dvsr),
.rx(tx_rx),
.rd_uart(rd_uart),
.rx_empty(rx_empty),.rx_full(rx_full),         //rx fifo full/empty ??
.r_data(r_data)
);


endmodule
