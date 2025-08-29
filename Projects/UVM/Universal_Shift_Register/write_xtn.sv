class write_xtn extends uvm_sequence_item;
	rand bit rst;
  	rand bit [3:0] data_in;
  	rand bit [1:0] mode;
	`uvm_object_utils(write_xtn)
	
	function new(string name = "write_xtn");
		super.new(name);
	endfunction
	
	virtual function void do_print (uvm_printer printer);
		super.do_print(printer);
      	printer.print_field("Reset", this.rst , 1, UVM_DEC);
		printer.print_field("Data in", this.data_in , 4, UVM_DEC);
		printer.print_field("Mode ", this.mode , 2, UVM_DEC);
	endfunction 
	
endclass
