`ifndef txn_sv
`define txn_sv

class txn extends uvm_sequence_item;
  `uvm_object_utils(txn)
  
  bit reset ;
  rand bit [7:0] payload;
  bit [2:0] no_of_cycle;
  
  function new (string name = "txn");
    super.new(name);
  endfunction 
  
  constraint non_zero { payload != 0;}
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
   
    printer.print_field("RESET",this.reset,1,UVM_BIN);
    printer.print_field("PAYLOAD", this.payload, 8, UVM_DEC);
    printer.print_field("NO OF CYCLE",this.no_of_cycle, 6, UVM_DEC);
    
  endfunction 
endclass

`endif