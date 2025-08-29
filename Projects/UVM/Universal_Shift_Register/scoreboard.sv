class scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(scoreboard)
  
  uvm_tlm_analysis_fifo #(write_xtn) wfifo;
  uvm_tlm_analysis_fifo #(read_xtn) rfifo;
  
  write_xtn write_data;
  read_xtn read_data;
  
  reg [3:0] ref_data;
  static int data_verified, data_missmatch, data_total;
  
  covergroup write_cov ;
  	MODES : coverpoint write_data.mode ;
  DATA_INPUT : coverpoint write_data.data_in { bins SMALL = {[0:4]};
                                              bins MEDIUM = {[5:9]};
                                              bins LARGE = {[10:15]};}
  endgroup 
  
  
  covergroup read_cov ;
  DATA_INPUT : coverpoint read_data.data_out { bins SMALL = {[0:4]};
                                              bins MEDIUM = {[5:9]};
                                              bins LARGE = {[10:15]};}
  endgroup
  
  
  function new (string name = "scoreboard", uvm_component parent);
    super.new(name,parent);
    wfifo = new("wfifo",this);
    rfifo = new("rfifo",this);
    read_cov = new;
    write_cov = new;
  endfunction 
  
  task update_ref (write_xtn wdata);
    if(wdata.rst)
      ref_data <= 4'd0;
    else 
    case(wdata.mode) 
      2'b00 : begin 
          ref_data [3:1] <= ref_data [2:0];
          ref_data [0] <= 1'b0;
        end
        2'b01 : begin 
          ref_data [2:0] <= ref_data [3:1];
          ref_data [3] <= 1'b0;
        end
        2'b10 : ref_data <= wdata.data_in;
        2'b11 : ref_data <= ref_data;
    endcase 
  endtask 
  
  function void check_data(read_xtn data);
    
    if(data.data_out===ref_data ||($isunknown(data.data_out)&&$isunknown(ref_data))) begin
      data_verified ++;
      `uvm_info("SCOREBOARD",$sformatf("Data Verified ,ref value %0d , read packet data %0d ",ref_data,data.data_out),UVM_NONE)
    end
    else  begin 
      data_missmatch ++;
      `uvm_error("SCOREBOARD",$sformatf("Data Missmatch ,ref value %0d , read packet data %0d",ref_data,data.data_out))
    end
    data_total++;
  endfunction 
  
  task run_phase (uvm_phase phase);
    forever begin
      fork 
        begin 
     		wfifo.get(write_data);
          	write_cov.sample();
        	update_ref(write_data);
      	end
        begin 
        	rfifo.get(read_data);
          	read_cov.sample;
        end
      join
    	check_data(read_data);
    end
  endtask 
  
  function void report_phase (uvm_phase phase);
    `uvm_info("SCOREBOARD",$sformatf("Data verified %0d",data_verified),UVM_NONE)
    `uvm_info("SCOREBOARD",$sformatf("Data missmatch %0d",data_missmatch),UVM_NONE)
    `uvm_info("SCOREBOARD",$sformatf("Data total %0d",data_total),UVM_NONE)
    `uvm_info("SCOREBOARD",$sformatf("WRITE COVERAGE %0F",write_cov.get_coverage),UVM_NONE)
    `uvm_info("SCOREBOARD",$sformatf("READ COVERAGE %0F",read_cov.get_coverage),UVM_NONE)
  endfunction 
endclass 
