`ifndef wr_agent_sv
`define wr_agent_sv

class wr_agent extends uvm_agent;
  `uvm_component_utils(wr_agent)
  
  wr_driver drvh;
  wr_monitor monh;
  uvm_sequencer #(txn) seqrh;
  
  function new (string name="wr_agent",uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  function void build_phase (uvm_phase phase);
    drvh = wr_driver :: type_id :: create ("drvh",this);
    monh = wr_monitor :: type_id :: create ("monh",this);
    seqrh = uvm_sequencer #(txn) :: type_id :: create ("seqrh",this);
  endfunction 
  
  function void connect_phase (uvm_phase phase);
    drvh.seq_item_port.connect(seqrh.seq_item_export);
  endfunction 
  
endclass

`endif