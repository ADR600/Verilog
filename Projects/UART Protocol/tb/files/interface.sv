
`ifndef interface_sv
`define interface_sv

interface UART_Interface (input bit clock);
  
  logic reset;
  logic [10:0]dvsr;

  logic wr_uart;
  logic [7:0] w_data;

  logic rd_uart;
  logic rx_empty,rx_full,tx_full;
  logic [7:0] r_data;
  
  clocking wdrv_cb @(posedge clock);
    default input #1 output #1;
    output reset,dvsr,wr_uart,w_data;
    input tx_full,rx_full;
  endclocking
  
  clocking wmon_cb @(posedge clock);
    default input #1 output #1;
    input reset,dvsr,wr_uart,w_data;
    input tx_full;
  endclocking
  
  clocking rdrv_cb @(posedge clock);
    default input #1 output #1;
    output rd_uart;
    input rx_empty,r_data;
  endclocking
  
  clocking rmon_cb @(posedge clock);
    default input #1 output #1;
    input rd_uart,r_data;
    input rx_empty;
  endclocking
             
  modport WDRV_MP (clocking wdrv_cb);
  modport WMON_MP (clocking wmon_cb);
  modport RDRV_MP (clocking rdrv_cb);
  modport RMON_MP (clocking rmon_cb);
          
endinterface

`endif