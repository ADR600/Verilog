`ifndef scoreboard_sv
`define scoreboard_sv

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  uvm_tlm_analysis_fifo #(txn) wfifo,rfifo;
  txn wr_data,rd_data;
  uvm_event ev;
  config_obj cfg;
  static int data_verified, data_missmatch;
  
  covergroup wcov ;
  DATA_SENT : coverpoint wr_data.payload {
                                            bins zero = {0};
                                            bins small_data = {[1:80]};
                                            bins medium_data = {[81:160]};
                                            bins large_data = { [161:254]};
                                            bins max_data = {255};
                                            }
  endgroup 
  
  covergroup rcov ;
  DATA_SENT : coverpoint rd_data.payload {
                                            bins zero = {0};
                                            bins small_data = {[1:80]};
                                            bins medium_data = {[81:160]};
                                            bins large_data = { [161:254]};
                                            bins max = {255};
                                            }
  endgroup
  
  
  function new (string name="rd_agent",uvm_component parent);
    super.new(name,parent);
    wfifo = new("wfifo",this);
    rfifo = new("rfifo",this);
    wcov = new;
    rcov = new;
  endfunction 
  
  function void build_phase (uvm_phase phase);
    if(!uvm_config_db #(config_obj) :: get(this,"","config_obj",cfg))
      `uvm_fatal(get_name,"Failed to get config obj")
      ev = cfg.event_pool.get("done");
  endfunction
  
  task run_phase (uvm_phase phase);
    rfifo.get(rd_data); // fifo initial dummy value
    forever 
    begin
      	wfifo.get(wr_data);
      	wcov.sample;
   		rfifo.get(rd_data);
   		rcov.sample;
        if(rd_data.payload!=wr_data.payload)begin 
          data_missmatch++;
          `uvm_error("SCOREBOARD",$sformatf("Data missmatch write data %s, read data %s",wr_data.sprint,rd_data.sprint))
        end
      	else begin
      		data_verified++;
          `uvm_info("SCOREBOARD",$sformatf("Data match write data %s, read data %s",wr_data.sprint,rd_data.sprint),UVM_NONE)
      	end  
      	if(data_missmatch + data_verified == cfg.packets_to_send)
      	 ev.trigger;   
    end
  endtask 
  
  function void report_phase (uvm_phase phase);
    `uvm_info("SCOREBOARD",$sformatf("Data Verified %0d",data_verified),UVM_NONE)
    `uvm_info("SCOREBOARD",$sformatf("Data Missmatch %0d",data_missmatch),UVM_NONE)
    `uvm_info("SCOREBOARD",$sformatf("Write Coverage %0f",wcov.get_coverage),UVM_NONE)
    `uvm_info("SCOREBOARD",$sformatf("Read Coverage %0f",rcov.get_coverage),UVM_NONE)
  endfunction 
  
endclass

`endif