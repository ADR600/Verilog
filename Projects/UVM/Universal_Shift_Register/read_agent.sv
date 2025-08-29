

class read_monitor extends uvm_monitor;
  `uvm_component_utils(read_monitor)
  
  confg cfg;
  virtual intf.RMON_MP vif;
  read_xtn mon_data;
  uvm_analysis_port #(read_xtn) monitor_port;
  
  function new (string name = "read_monitor", uvm_component parent);
    super.new(name,parent);
    monitor_port = new("monitor_port",this);
  endfunction 
  
  function void build_phase (uvm_phase phase);
    if(!uvm_config_db #(confg) :: get (this,"","confg",cfg))
      `uvm_fatal(get_name,"Failed to get config in read  monitor ")
      vif = cfg.vif;
  endfunction
  
  task sample_data ();
    mon_data = read_xtn :: type_id :: create ("mon_data");
    @(vif.rmon); 
    mon_data.data_out =vif.rmon.data_out;
  endtask 
  
  task run_phase (uvm_phase phase);
   // @(vif.rmon);
    forever  begin 
    	sample_data();
      `uvm_info(get_name,$sformatf("Read monitor data %s",mon_data.sprint),UVM_NONE)
      monitor_port.write(mon_data);
    end
  endtask 
endclass


////////////////////////////////////////////////////////////////////////////////////////////////////


class read_agent extends uvm_agent;
  read_monitor mon;
  `uvm_component_utils(read_agent)
  
  function new (string name = "read_agent", uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  function void build_phase (uvm_phase phase);
    mon = read_monitor :: type_id :: create ("mon",this);
  endfunction 
  
endclass 
