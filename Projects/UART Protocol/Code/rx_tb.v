`timescale 1ns / 1ps    

module rx_tb;

//tb internal wires
 reg clk,reset;
 reg rx;
 reg [10:0]dvsr;
 reg rd_uart;
 wire rx_empty,rx_full;
 wire [7:0] r_data;
 
 //check ticks
 wire gen_tick ;
 assign gen_tick = dut.Generator.tick;
 wire receiver_done;
 assign receiver_done = dut.Receiver.rx_done_tick;
 
 integer file ;
 
  UART_Receiver
#(
            .DBIT(8),           // no. of data bit
            .SB_TICK(16),       // oversampling - 16 ticks per bit
            .DATA_WIDTH(8),     //bit width
            .ADDR_WIDTH(2)       //depth of fifo
)
dut
(
.clk(clk),.reset(reset),
.dvsr(dvsr),
.rx(rx),
.rd_uart(rd_uart), 
.rx_empty(rx_empty),.rx_full(rx_full),         
.r_data(r_data)
);

 parameter   idle=0,
            start=1,
            data=2,
            stop=3;

//fsm state of receiver         
reg [40 : 1] string ;
always@(*)
    case(dut.Receiver.state_reg)
        idle : string = "idle";
        start : string = "start";
        data : string = "data";
        stop : string = "stop";  
    endcase
        
always  //clock is 100MHz
    #5  clk = ~clk;
    
task initialise;
input [10:0] x;
begin   
    reset =0;
    clk=0;
    dvsr = x;
    rx =1;
    rd_uart =0;
end
endtask

task rst;
    begin
        @(negedge clk);  
        reset = 1;
        @(negedge clk);
        reset = 0;
    end
endtask

task send_bits_to_receiver;
input [7:0] data;
integer i;
begin
    @(negedge clk);
    rx =0; //start bit 
    repeat(16)@(posedge gen_tick) ; // wait for 16 ticks 
    for(i=0;i<8; i=i+1)
        begin
            rx = data[i];
            repeat(16)@(posedge gen_tick); //16 ticks for 1 bit 
        end
     rx = 1; //stop bit 
     repeat(16)@(posedge gen_tick);
end
endtask

task read_fifo;
begin
    wait(~rx_empty);
    @(negedge clk);
    rd_uart = 1;
    @(negedge clk);
    rd_uart = 0;
    $display("out of fifo %b",r_data);
    $display("fifo empty %b",rx_empty);
end
endtask


//monitor on console
initial 
    begin:monitor_block
        $monitor($time,"    rx_state =%s",string);
        $monitor($time, "   internal register =%b",dut.Receiver.b_reg);
       // $monitor($time,"    baud_reg =%0d",generator.r_reg);
        $monitor($time,"    receive done =%b",receiver_done);
    end
  

initial 
begin

    initialise(11'd650);
    
    rst; 
    
    send_bits_to_receiver(8'b01111110);
    send_bits_to_receiver(8'b11111111);
    send_bits_to_receiver(8'b10000001);
    send_bits_to_receiver(8'b10101010);
    #50;
    
    $writememb("outputfile.mem",dut.FIFO.mem);
    file = $fopen("outputfile.mem","a");
    $fdisplay(file,"content of receiver fifo ");
    $fclose(file);
   
    read_fifo;
    read_fifo;
    read_fifo;
    read_fifo;
   // #1_041_667 // ~105k cycles for 1 packet - start _ data_stop 
   
    $finish;
 end
 

endmodule
