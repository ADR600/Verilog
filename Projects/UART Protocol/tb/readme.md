
UVM TOPOLOGY

------------------------------------------------------------------
Name                       Type                        Size  Value
------------------------------------------------------------------
uvm_test_top               test                        -     @340 
  envh                     env                         -     @364 
    ragt                   rd_agent                    -     @382 
      drvh                 rd_driver                   -     @518 
        rsp_port           uvm_analysis_port           -     @537 
        seq_item_port      uvm_seq_item_pull_port      -     @527 
      monh                 rd_monitor                  -     @547 
        monitor_port       uvm_analysis_port           -     @556 
      seqrh                uvm_sequencer               -     @566 
        rsp_export         uvm_analysis_export         -     @575 
        seq_item_export    uvm_seq_item_pull_imp       -     @693 
        arbitration_queue  array                       0     -    
        lock_queue         array                       0     -    
        num_last_reqs      integral                    32    'd1  
        num_last_rsps      integral                    32    'd1  
    sb                     scoreboard                  -     @391 
      rfifo                uvm_tlm_analysis_fifo #(T)  -     @459 
        analysis_export    uvm_analysis_imp            -     @508 
        get_ap             uvm_analysis_port           -     @498 
        get_peek_export    uvm_get_peek_imp            -     @478 
        put_ap             uvm_analysis_port           -     @488 
        put_export         uvm_put_imp                 -     @468 
      wfifo                uvm_tlm_analysis_fifo #(T)  -     @400 
        analysis_export    uvm_analysis_imp            -     @449 
        get_ap             uvm_analysis_port           -     @439 
        get_peek_export    uvm_get_peek_imp            -     @419 
        put_ap             uvm_analysis_port           -     @429 
        put_export         uvm_put_imp                 -     @409 
    wagt                   wr_agent                    -     @373 
      drvh                 wr_driver                   -     @711 
        rsp_port           uvm_analysis_port           -     @730 
        seq_item_port      uvm_seq_item_pull_port      -     @720 
      monh                 wr_monitor                  -     @740 
        monitor_port       uvm_analysis_port           -     @749 
      seqrh                uvm_sequencer               -     @759 
        rsp_export         uvm_analysis_export         -     @768 
        seq_item_export    uvm_seq_item_pull_imp       -     @886 
        arbitration_queue  array                       0     -    
        lock_queue         array                       0     -    
        num_last_reqs      integral                    32    'd1  
        num_last_rsps      integral                    32    'd1  
------------------------------------------------------------------
