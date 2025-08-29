class virtual_sequence extends uvm_sequence #(write_xtn);
  `uvm_object_utils(virtual_sequence)
  
  virtual_sequencer vseqr;
  uvm_sequencer #(write_xtn) seqr;
  write_seqs seqh;
  
  function new (string name = "virtual_sequence");
    super.new(name);
  endfunction 
  
  task body();
    if(!$cast(vseqr,m_sequencer))
      `uvm_fatal(get_name,"Dynmaic casting failed")
      
    seqr = vseqr.seqr;
    
    seqh = write_seqs :: type_id :: create ("seqh");
    seqh.start(seqr);
  endtask 
endclass 
