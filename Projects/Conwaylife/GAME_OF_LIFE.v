
/*
The "game" is played on a two-dimensional grid of cells, where each cell is either 1 (alive) or 0 (dead). At each time step, each cell changes state depending on how many neighbours it has:

0-1 neighbour: Cell becomes 0.
2 neighbours: Cell state does not change.
3 neighbours: Cell becomes 1.
4+ neighbours: Cell becomes 0.

The 16x16 grid is represented by use of  2D vectors (system verilog).

load: Loads data into q at the next clock edge, for loading initial state.
q: The 16x16 current state of the game, updated every clock cycle.
*/

module top_module(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q ); 
    
    reg [0:15][0:15] vect ;
    assign q = vect;
    
    genvar x,y; 
    reg [3:0] count[0:15][0:15];
    generate
        for(x=0;x<=15;x++) begin:column
            for(y=0;y<=15;y++) begin:row
                //compute alive or dead
                compute_count a (x,y,vect,count[x][y]);
                 end:row
             end:column  
    endgenerate
    
    //seq logic
    integer i,j;
    always@(posedge clk)
        begin 
            if(load)
                vect <= data;
            else //simulation of life
            	begin
                    for(i=0;i<=15;i++)
                        begin
                            for(j=0;j<=15;j++)
                                case(count[i][j])
                                    4'd2: vect[i][j] <= vect[i][j];
                                    4'd3: vect[i][j] <=1'b1;
                                    default: vect[i][j] <=1'b0;
                                endcase
                        end
                end                                   
        end       
endmodule

module compute_count(
    input [3:0] i,j,
    input [0:15][0:15] vect,
    output [3:0]count
);
    assign count = vect[i-1][j-1] + vect[i-1][j] + vect[i-1][j+1] + vect[i][j-1] + vect[i][j+1]+vect[i+1][j-1] + vect[i+1][j] + vect[i+1][j+1];
            
endmodule 
