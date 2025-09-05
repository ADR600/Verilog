`ifndef rd_monitor_sv
`define rd_monitor_sv

class rd_monitor extends uvm_monitor;
  `uvm_component_utils(rd_monitor)
  
  static int count;
  
  virtual UART_Interface.RMON_MP vif;
  
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
  	forever begin 
      sample_data;
    end    
  endtask 
  
  task sample_data();
    
    mon_data = txn :: type_id :: create ("mon_data");
    `uvm_info(get_name,"READ MONITOR PROCESS START", UVM_HIGH)
    
    wait(vif.rmon_cb.rd_uart) @(vif.rmon_cb);
    `uvm_info(get_name,"READ MONITOR -FINSIHED WAITING FOR RD_UART", UVM_HIGH)
    //@(vif.rmon_cb); ///checking
    mon_data.payload = vif.rmon_cb.r_data;
    
    count++;
    monitor_port.write(mon_data);
    
    `uvm_info(get_name,$sformatf("Value of rd_uart %0d",vif.rmon_cb.rd_uart),UVM_HIGH)
    `uvm_info(get_name,$sformatf("Value of r_data %0d",vif.rmon_cb.r_data),UVM_HIGH)
    `uvm_info(get_name,$sformatf("READ MONITOR %s",mon_data.sprint),UVM_HIGH)
    
    @(vif.rmon_cb);
    `uvm_info(get_name,$sformatf("Value of rd_uart %0d",vif.rmon_cb.rd_uart),UVM_HIGH)
    `uvm_info(get_name,$sformatf("Value of r_data %0d",vif.rmon_cb.r_data),UVM_HIGH)
    
  endtask 
  
  function void report_phase (uvm_phase phase);
    `uvm_info(get_name,$sformatf("Data sent by read monitor %0d",count),UVM_NONE)
  endfunction 
  
endclass
`endif