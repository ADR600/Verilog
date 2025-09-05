`ifndef read_seqs_sv
`define read_seqs_sv

class read_seqs extends uvm_sequence #(txn);
  `uvm_object_utils(read_seqs)
  config_obj cfg;
  function new (string name = "txn");
    super.new(name);
  endfunction 
  
  task body(); 
  if(!uvm_config_db #(config_obj) :: get(null,get_full_name,"config_obj",cfg))
      `uvm_fatal(get_full_name,"Failed to get config")
      
      repeat(cfg.packets_to_send + 1) begin
      req = txn :: type_id :: create("req");
      start_item(req);
      assert(req.randomize);
      finish_item(req);
    end
    `uvm_warning("READ SEQS","FINISHED READ SEQS")
  endtask 
  
endclass
`endif