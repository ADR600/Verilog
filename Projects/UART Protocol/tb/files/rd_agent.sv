`ifndef rd_agent_sv
`define rd_agent_sv

class rd_agent extends uvm_agent;
  `uvm_component_utils(rd_agent)
  
  rd_driver drvh;
  rd_monitor monh;
  uvm_sequencer #(txn) seqrh;
  
  function new (string name="rd_agent",uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  function void build_phase (uvm_phase phase);
    drvh = rd_driver :: type_id :: create ("drvh",this);
    monh = rd_monitor :: type_id :: create ("monh",this);
    seqrh = uvm_sequencer #(txn) :: type_id :: create ("seqrh",this);
  endfunction 
  
  function void connect_phase (uvm_phase phase);
    drvh.seq_item_port.connect(seqrh.seq_item_export);
  endfunction 
  
endclass

`endif