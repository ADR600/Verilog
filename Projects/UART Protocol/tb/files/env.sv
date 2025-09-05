`ifndef env_sv
`define env_sv

class env extends uvm_env;
  `uvm_component_utils(env)
  
  wr_agent wagt;
  rd_agent ragt;
  scoreboard sb;
  
  function new (string name = "env", uvm_component parent);
    super.new(name,parent);
  endfunction 
  
	function void build_phase (uvm_phase phase);
    wagt = wr_agent :: type_id :: create ("wagt",this);
    ragt = rd_agent :: type_id :: create ("ragt",this);
    sb = scoreboard :: type_id :: create ("sb",this);
  endfunction 
  
  function void connect_phase (uvm_phase phase);
    wagt.monh.monitor_port.connect(sb.wfifo.analysis_export);
    ragt.monh.monitor_port.connect(sb.rfifo.analysis_export);
  endfunction 
  
endclass
`endif