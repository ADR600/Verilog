class write_driver extends uvm_driver #(write_xtn);
  `uvm_component_utils(write_driver)
  
  confg cfg;
  virtual intf.WDRV_MP vif;
  
  function new (string name = "write_driver", uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  function void build_phase (uvm_phase phase);
    if(!uvm_config_db #(confg) :: get (this,"","confg",cfg))
      `uvm_fatal(get_name,"Failed to get config in write driver")
      vif = cfg.vif;
  endfunction
  
  task drive_data (write_xtn req);
    @(vif.wdrv); 
    vif.wdrv.rst <= req.rst;
    vif.wdrv.mode <= req.mode;
    vif.wdrv.data_in <= req.data_in;
    //@(vif.wdrv);
    //vif.wdrv.mode <= 2'b11;
    //vif.wdrv.data_in <= 4'd0;
  endtask 
  
  task run_phase (uvm_phase phase);
    forever begin  
      	seq_item_port.get_next_item(req);
    	drive_data(req);
    	seq_item_port.item_done;
    end
  endtask 
endclass 

////////////////////////////////////////////////////////////////////////////////////////////////////



class write_monitor extends uvm_monitor;
  `uvm_component_utils(write_monitor)
  
  confg cfg;
  virtual intf.WMON_MP vif;
  write_xtn mon_data;
  uvm_analysis_port #(write_xtn) monitor_port;
  
  function new (string name = "write_monitor", uvm_component parent);
    super.new(name,parent);
    monitor_port = new("monitor_port",this);
  endfunction 
  
  function void build_phase (uvm_phase phase);
    if(!uvm_config_db #(confg) :: get (this,"","confg",cfg))
      `uvm_fatal(get_name,"Failed to get config in write monitor ")
      vif = cfg.vif;
  endfunction
  
  task sample_data ();
    mon_data = write_xtn :: type_id :: create ("mon_data");
    @(vif.wmon); 
    mon_data.rst = vif.wmon.rst;
    mon_data.mode =vif.wmon.mode;
    mon_data.data_in =vif.wmon.data_in;
  endtask 
  
  task run_phase (uvm_phase phase);
    forever  begin 
    	sample_data();
      `uvm_info(get_name,$sformatf("Write monitor data %s",mon_data.sprint),UVM_NONE)
      monitor_port.write(mon_data);
    end
  endtask 
endclass


////////////////////////////////////////////////////////////////////////////////////////////////////


class write_agent extends uvm_agent;
  uvm_sequencer #(write_xtn) seqr;
  write_driver drv;
  write_monitor mon;
  `uvm_component_utils(write_agent)
  
  function new (string name = "write_agent", uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  function void build_phase (uvm_phase phase);
    mon = write_monitor :: type_id :: create ("mon",this);
    drv = write_driver :: type_id :: create ("drv",this);
    seqr = uvm_sequencer #(write_xtn) :: type_id :: create ("seqr",this);
  endfunction 
  
  function void connect_phase (uvm_phase phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction 
  
endclass 
