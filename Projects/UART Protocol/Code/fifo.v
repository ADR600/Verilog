module fifo
#(
 parameter    DATA_WIDTH = 8,
              ADDR_WIDTH = 2
) 
(
input  clk,wr ,rd,reset,
input  [DATA_WIDTH-1:0] w_data,
output  reg [DATA_WIDTH-1:0] r_data,
output  full,empty
);
 
 reg [ADDR_WIDTH : 0] rd_ptr,wr_ptr;
 reg [DATA_WIDTH-1 :0] mem [0:((2**ADDR_WIDTH) -1) ];
 integer i;
 
 assign full = ((rd_ptr[ADDR_WIDTH]!=wr_ptr[ADDR_WIDTH])&&(rd_ptr[ADDR_WIDTH-1 :0] == wr_ptr[ADDR_WIDTH-1 :0]));
 assign empty = (rd_ptr==wr_ptr);
 
 always@(posedge  clk,posedge reset)
    begin
        if(reset)
        begin
            wr_ptr <= 0;
            rd_ptr <=0;
            r_data <=0;
            for(i=0;i<(2**ADDR_WIDTH);i=i+1)
                mem[i] <= 0;
        end
        else 
        begin
            if(wr && !full)
                begin
                    wr_ptr <= wr_ptr + 1'b1;
                    mem[wr_ptr[ADDR_WIDTH -1 :0]] <= w_data;
                end
             if(rd && ! empty)
                begin
                    rd_ptr <= rd_ptr + 1'b1;
                    r_data <= mem[rd_ptr[ADDR_WIDTH -1 :0]] ;
                end
         end
     end
     
     
endmodule
