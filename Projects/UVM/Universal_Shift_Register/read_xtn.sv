class read_xtn extends uvm_sequence_item;

  	rand logic [3:0] data_out;
	`uvm_object_utils(read_xtn)
	
	function new(string name = "read_xtn");
		super.new(name);
	endfunction
	
	virtual function void do_print (uvm_printer printer);
		super.do_print(printer);
		printer.print_field("Data out", this.data_out , 4, UVM_DEC);
	endfunction 
	
endclass
