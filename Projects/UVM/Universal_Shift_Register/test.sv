class test extends uvm_test;
  `uvm_component_utils(test)
  confg cfg;
  virtual_sequence seqh;
  env envh;
  
  function new (string name = "test", uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  function void build_phase (uvm_phase phase);
    cfg = confg :: type_id :: create("cfg");
    if(!uvm_config_db #(virtual intf) :: get(this,"","intf",cfg.vif))
      `uvm_fatal(get_name,"Failed to get config in test")
      uvm_config_db #(confg) :: set (this,"*","confg",cfg);
    envh = env :: type_id :: create ("envh",this);
  endfunction 
  
  task run_phase (uvm_phase phase);
    phase.raise_objection(this);
    seqh = virtual_sequence :: type_id :: create ("seqh");
    seqh.start(envh.vseqr);
    phase.drop_objection(this);
  endtask 
  
endclass 
