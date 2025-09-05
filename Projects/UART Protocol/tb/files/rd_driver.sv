`ifndef rd_driver_sv
`define rd_driver_sv

class rd_driver extends uvm_driver #(txn);
  `uvm_component_utils(rd_driver)
  
  virtual UART_Interface.RDRV_MP vif;
  config_obj cfg;
  
  function new (string name = "rd_driver",uvm_component parent);
    super.new(name,parent);
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
      seq_item_port.get_next_item(req);
      `uvm_info(get_name,$sformatf("READ DRIVER  %s",req.sprint),UVM_HIGH)
      drive_to_dut(req);
      seq_item_port.item_done;
      `uvm_info(get_name,"READ DRIVER DATA ACK SENT", UVM_HIGH)
    end    
  endtask 
  
  task drive_to_dut(txn req);
  vif.rdrv_cb.rd_uart <= 1'b0;
    wait(!vif.rdrv_cb.rx_empty) @(vif.rdrv_cb);
    //repeat(req.no_of_cycle) @(vif.rdrv_cb);
    
    vif.rdrv_cb.rd_uart <= 1'b1;
    @(vif.rdrv_cb);
    vif.rdrv_cb.rd_uart <= 1'b0;
    @(vif.rdrv_cb);
  endtask 
  
endclass

`endif