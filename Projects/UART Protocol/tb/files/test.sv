`ifndef test_sv
`define test_sv

class test extends uvm_test;
  `uvm_component_utils(test)
  
  env envh;
  write_seqs wseqh;
  max_min_seqs mseqh;
  read_seqs rseqh;
  config_obj cfg;
  uvm_event ev;
  
  ////////////////////////////////////////////////////////
  int packets_to_send = 10; //minimum value 4
  bit [10:0] dvsr = 9600;
  bit testing =0;
  //////////////////////////////////////////////////////////
  
  
  function new (string name = "test", uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  function void build_phase (uvm_phase phase);
    cfg = config_obj :: type_id :: create("cfg");
    if(!uvm_config_db#(virtual UART_Interface) :: get(this,"","UART_Interface",cfg.vif))
      `uvm_fatal(get_name,"Failed to get VIF in test")
      ev = cfg.event_pool.get("done");
      
      cfg.dvsr_value = dvsr;
      cfg.packets_to_send = packets_to_send;
      
      uvm_config_db #(config_obj) :: set(this,"*","config_obj",cfg);
    envh = env :: type_id :: create("envh",this);
  endfunction 
 
 function void start_of_simulation_phase (uvm_phase phase);
    if(testing)  
        uvm_top.set_report_verbosity_level(UVM_HIGH);
    else 
        uvm_top.set_report_verbosity_level(UVM_NONE);
    uvm_top.print_topology;
 endfunction 
 
  task run_phase (uvm_phase phase);
    wseqh = write_seqs :: type_id :: create ("wseqh");
    mseqh = max_min_seqs :: type_id :: create ("mseqh");
    rseqh = read_seqs :: type_id :: create ("rseqh");
    phase.raise_objection(this,"objection raised ");
    fork 
        begin
    	   wseqh.start(envh.wagt.seqrh);
    	   mseqh.start(envh.wagt.seqrh);
        end
      	rseqh.start(envh.ragt.seqrh);
    join_none  
    
    ev.wait_trigger;
    phase.drop_objection(this,"objection dropped");
    
  endtask 
    
endclass

`endif