`ifndef write_seqs_sv
`define write_seqs_sv

class write_seqs extends uvm_sequence #(txn);
  `uvm_object_utils(write_seqs)
  config_obj cfg;
  function new (string name = "write_seqs");
    super.new(name);
  endfunction 
  
  task body(); 
  
    if(!uvm_config_db #(config_obj) :: get(null,get_full_name,"config_obj",cfg))
      `uvm_fatal(get_full_name,"Failed to get config")
      
      repeat(cfg.packets_to_send - 4 ) begin // 2 min , 2 max sequences
      req = txn :: type_id :: create("req");
      start_item(req);
      assert(req.randomize with {payload>0; payload <255;});
      req.reset=0;
      finish_item(req);
    end
    `uvm_warning("WRITE SEQS","FINISHED BASE WRITE SEQS")
  endtask 
  
endclass 

class max_min_seqs extends uvm_sequence #(txn);
  `uvm_object_utils(max_min_seqs)
  config_obj cfg;
  function new (string name = "max_min_seqs");
    super.new(name);
  endfunction 
  
  task body();  
 
       repeat(2) begin
        req = txn :: type_id :: create("req");
        start_item(req);
        req.payload =0;
        req.reset=0;
        finish_item(req);
    end
    
    repeat(2) begin
        req = txn :: type_id :: create("req");
        start_item(req);
        req.payload =255;
        req.reset=0;
        finish_item(req);
    end 
   `uvm_warning("WRITE SEQS","FINISHED MAX-MIN SEQS") 
  endtask 
  
endclass 

`endif