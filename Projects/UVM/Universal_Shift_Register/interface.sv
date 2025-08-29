interface intf (input bit clock);
  
   logic rst;
   logic [1:0] mode;
   logic [3:0] data_in;
   logic [3:0] data_out;
  
  clocking wdrv @( posedge clock);
    output rst;
  	output mode;
    output data_in;
  endclocking 
  
  clocking wmon@( posedge clock);
    input rst;
  	input mode;
    input data_in;
  endclocking 
  
  clocking rmon@( posedge clock);
    input data_out;
  endclocking 
 
  modport WDRV_MP ( clocking wdrv);
  modport WMON_MP ( clocking wmon);
  modport RMON_MP ( clocking rmon);
    
endinterface 
