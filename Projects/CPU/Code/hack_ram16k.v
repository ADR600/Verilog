module hack_ram16k(
clk,
in,
load,
address,
out
);
input [15:0] in;
input [13:0] address;
input load,clk;
output [15:0] out;

reg [15:0] out_reg ;
assign out = out_reg;

reg [15:0] mem [0: 16383]; // 16k = 16384 units
always@(posedge clk)
    begin
        if(load)
            mem[address] <= in;
        else 
            out_reg <= mem[address];
    end
    
endmodule