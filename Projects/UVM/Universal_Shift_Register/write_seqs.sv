class write_seqs extends uvm_sequence #(write_xtn);
	`uvm_object_utils(write_seqs)
  
	function new(string name = "write_seqs");
		super.new(name);
	endfunction
	
  task body();
    repeat(2) 
      begin 
        req = write_xtn :: type_id :: create ("req");
        start_item(req);
        assert(req.randomize with {rst==1;});
        finish_item(req);
      end
    repeat(2) 
      begin 
        req = write_xtn :: type_id :: create ("req");
        start_item(req);
        assert(req.randomize with { rst ==0; mode==3'd10;} );
        finish_item(req);
      end
    repeat(10) 
      begin 
        req = write_xtn :: type_id :: create ("req");
        start_item(req);
        assert(req.randomize with {rst == 0;});
        finish_item(req);
      end
  endtask 
  
endclass
