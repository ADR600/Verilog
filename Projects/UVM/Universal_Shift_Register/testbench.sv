// Code your testbench here
// or browse Examples

`include "uvm_macros.svh"
import uvm_pkg :: *;

`include "interface.sv"

`include "write_xtn.sv"
`include "read_xtn.sv"
`include "write_seqs.sv"

`include "cfg.sv"

`include "write_agent.sv"
`include "read_agent.sv"
`include "scoreboard.sv"
`include "virtual_sequencer.sv"
`include "env.sv"

`include "virtual_sequence.sv"
`include "test.sv"

module tb;
  
  bit clock,rst;
  
  intf in(.clock(clock));
  
  shift_register duv ( 
    .clock(clock),
    .rst(in.rst),
    .mode(in.mode),
    .data_in(in.data_in),
    .data_out(in.data_out)
  );
  
  initial 
  forever begin 
    clock = 0;
    #5;
    clock = 1;
  end
  
  initial 
    begin 
      uvm_config_db #(virtual intf) :: set (null,"*","intf",in);
      run_test("test");
    end
endmodule
