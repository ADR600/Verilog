`timescale 1ns / 1ps

module toptb;

reg clk,reset;
reg [10:0]dvsr;

reg wr_uart;
reg [7:0] w_data;
reg rd_uart;

wire rx_empty,rx_full;
wire [7:0] r_data;
wire tx_full;

Transmitter_Receiver
#(
          .DBIT (8),           // no. of data bit
            .SB_TICK (16),       // oversampling - 16 ticks per bit
            .DATA_WIDTH (8),     //bit width
            .ADDR_WIDTH (2)        //depth of fifo
)
dut
(
.clk(clk),
.reset(reset),
.dvsr(dvsr),
.wr_uart(wr_uart),
.tx_full(tx_full),
.w_data(w_data),
.rd_uart(rd_uart),
.rx_empty(rx_empty),
.rx_full(rx_full),
.r_data(r_data)
);

always  //clock is 100MHz
    #5  clk = ~clk;
    
task initialise;
input [10:0] x;
begin   
    reset = 1'b0;
    clk = 1'b0;
    dvsr = x;
    w_data = 8'b0;
    wr_uart = 1'b0;
    rd_uart = 1'b0;
    
end
endtask


task rst;
    begin
        @(negedge clk);  
        reset = 1;
        @(negedge clk);
        reset = 0;
        $display("reset done");
    end
endtask

task write;
input [7:0] x;
    begin
        wait(~tx_full)
        @(negedge clk);  
        w_data = x;
        wr_uart = 1'b1;
        @(negedge clk);
        wr_uart = 1'b0;
        $display("write : %b",w_data);
    end
endtask

task read ;
begin
        wait(~rx_empty);
        @(negedge clk);  
        rd_uart = 1'b1;
        @(negedge clk);
        rd_uart = 1'b0; 
        $display("read : %b",r_data);
    end
endtask

initial
    begin
         initialise(11'd650);
        rst;
        
        write(8'b01010101);
        write(8'b11011111);
        write(8'b00000000);
        write(8'b11111111);
        
        #1_041_700 ;        //for first byte to be written to memory  1_041_667
        
        read;
        read;
        read;
        read;
        read;
        $finish;
    end
        
        
endmodule
