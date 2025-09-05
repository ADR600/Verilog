`ifndef wr_monitor_sv
`define wr_monitor_sv

class wr_monitor extends uvm_monitor ;
  `uvm_component_utils(wr_monitor)
  
  static int count;
  
  virtual UART_Interface.WMON_MP vif;
  config_obj cfg;
  txn mon_data;
  uvm_analysis_port #(txn) monitor_port;
  
  function new (string name = "wr_monitor",uvm_component parent);
    super.new(name,parent);
    monitor_port = new("monitor_port",this);
  endfunction 
  
  function void build_phase (uvm_phase phase);
    if(!uvm_config_db #(config_obj) :: get(this,"","config_obj",cfg))
      `uvm_fatal(get_name,"Failed to get config obj")
  endfunction
  
  function void connect_phase (uvm_phase phase);
  	vif = cfg.vif;
  endfunction 
  
  task run_phase (uvm_phase phase);
  	forever  
      sample_data;    
  endtask 
  
  task sample_data();
    mon_data = txn :: type_id :: create ("mon_data");

    wait(vif.wmon_cb.wr_uart) @(vif.wmon_cb);
    `uvm_info(get_name,"WRITE MONITOR -FINSIHED WAITING FOR WR_UART", UVM_HIGH)
    mon_data.reset = vif.wmon_cb.reset ;  
    mon_data.payload = vif.wmon_cb.w_data;
    
    count++;
    monitor_port.write(mon_data);
    `uvm_info(get_name,$sformatf("Value of wr_uart %0d",vif.wmon_cb.wr_uart),UVM_HIGH)
    `uvm_info(get_name,$sformatf("WRITE MONITOR %s",mon_data.sprint),UVM_HIGH)
    @(vif.wmon_cb);
  endtask 
  
  function void report_phase (uvm_phase phase);
    `uvm_info(get_name,$sformatf("Data sent by write monitor %0d",count),UVM_NONE)
  endfunction
  
endclass

`endif 