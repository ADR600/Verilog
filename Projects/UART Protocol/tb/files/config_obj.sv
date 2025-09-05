`ifndef config_obj_sv
`define config_obj_sv

class config_obj extends uvm_sequence_item;
  `uvm_object_utils(config_obj)
  
    int packets_to_send;
	virtual UART_Interface vif;
  	bit [10:0] dvsr_value;
    uvm_event_pool event_pool = uvm_event_pool :: get_global_pool();
  
  function new (string name = "config_obj");
    super.new(name);
  endfunction 
  
endclass
`endif