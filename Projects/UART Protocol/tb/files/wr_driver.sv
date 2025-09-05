`ifndef wr_driver_sv
`define wr_driver_sv

class wr_driver extends uvm_driver #(txn);
  `uvm_component_utils(wr_driver)
  
  virtual UART_Interface.WDRV_MP vif;
  config_obj cfg;
  
  function new (string name = "wr_driver",uvm_component parent);
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
    /////////////////////////////////////////
    vif.wdrv_cb.dvsr <= cfg.dvsr_value;
    `uvm_info(get_name,$sformatf("DVSR value %0d",cfg.dvsr_value),UVM_NONE)
    ////////////////////////////////////////
    vif.wdrv_cb.wr_uart <= 1'b0;
    vif.wdrv_cb.w_data <= 8'd123;
    vif.wdrv_cb.reset <= 1'b1;
    repeat(2)@(vif.wdrv_cb);
    vif.wdrv_cb.reset <= 1'b0;
    @(vif.wdrv_cb);
    
  	forever begin 
      seq_item_port.get_next_item(req);
      `uvm_info(get_name,$sformatf("WRITE DRIVER  %s",req.sprint),UVM_HIGH)
      drive_to_dut(req);
      seq_item_port.item_done;
      `uvm_info(get_name,"WRITE DRIVER DATA ACK SENT", UVM_HIGH)
    end    
  endtask 
  
  task drive_to_dut(txn req);
    
      	wait((vif.wdrv_cb.tx_full==0)&&(vif.wdrv_cb.rx_full==0)) 
   		@(vif.wdrv_cb);
      
     	vif.wdrv_cb.wr_uart <= 1'b1;
    	vif.wdrv_cb.w_data <= req.payload;
    	//vif.wdrv_cb.dvsr <= cfg.dvsr_value;
      	//vif.wdrv_cb.reset <= req.reset;
      
    	@(vif.wdrv_cb);
      	vif.wdrv_cb.wr_uart <= 1'b0;
      	@(vif.wdrv_cb);
    
  endtask 
  
endclass

`endif