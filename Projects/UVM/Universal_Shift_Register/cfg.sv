class confg extends uvm_object ;
  `uvm_object_utils(confg)
  
	function new(string name = "confg");
		super.new(name);
	endfunction
  
  virtual intf vif;
  
endclass 
