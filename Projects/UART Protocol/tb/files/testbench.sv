`include "uvm_macros.svh"
import uvm_pkg :: *;

`include "interface.sv"
`include "txn.sv"
`include "config_obj.sv"


`include "wr_driver.sv"
`include "wr_monitor.sv"
`include "wr_agent.sv"

`include "rd_driver.sv"
`include "rd_monitor.sv"
`include "rd_agent.sv"

`include "scoreboard.sv"

`include "env.sv"

`include "write_seqs.sv"
`include "read_seqs.sv"

`include "test.sv"

module testbench;
  
  bit clock;
  
  UART_Interface in (clock); 
  
  Transmitter_Receiver
#(
  .DBIT(8),           // no. of data bit
  .SB_TICK (16),       // oversampling - 16 ticks per bit
  .DATA_WIDTH (8),     //bit width
  .ADDR_WIDTH(2)        //depth of fifo
)
  duv
(
  .clk(clock),
  .reset(in.reset),
  .dvsr(in.dvsr),
  .wr_uart(in.wr_uart),
  .w_data(in.w_data),
  .rd_uart(in.rd_uart),
  .rx_empty(in.rx_empty),
  .rx_full(in.rx_full),
  .tx_full(in.tx_full),
  .r_data(in.r_data)
);
  
  always #1 clock = !clock;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, duv); 
  end
  
  initial begin 
    uvm_config_db #(virtual UART_Interface)::set(null,"*","UART_Interface",in);
    run_test("test");
  end
  
endmodule 