class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
  uvm_sequencer #(write_xtn) seqr;
  
  `uvm_component_utils(virtual_sequencer)
  
  function new (string name = "virtual_sequencer",uvm_component parent);
    super.new(name,parent);
  endfunction 
  
endclass
