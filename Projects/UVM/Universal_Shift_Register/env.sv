class env extends uvm_env;
  `uvm_component_utils(env)
  write_agent wagt;
  read_agent ragt;
  scoreboard sb;
  virtual_sequencer vseqr;
  
  function new (string name = "env", uvm_component parent);
    super.new(name,parent);
  endfunction 
  function void build_phase (uvm_phase phase);
    wagt = write_agent :: type_id :: create ("wagt",this);
    ragt = read_agent :: type_id :: create ("ragt",this);
    sb = scoreboard :: type_id :: create ("sb",this);
    vseqr = virtual_sequencer:: type_id :: create ("vseqr",this);
  endfunction 
  function void connect_phase (uvm_phase phase);
    wagt.mon.monitor_port.connect(sb.wfifo.analysis_export);
    ragt.mon.monitor_port.connect(sb.rfifo.analysis_export);
    vseqr.seqr = wagt.seqr;
  endfunction 
endclass 
