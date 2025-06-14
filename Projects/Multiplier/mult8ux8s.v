//8 clock to get output 
//8 stage pipeline 
//multpilcation fo two numbers n1(11-bit) & n2(8 bit)
////n1 (Partial product ,CX for example) is the multplicand and is signed
//n2 (cos term,CT for example) is signed 
//and multiplier ,from ROM table
//-----------------------------------------
//computing fixed point arithmetic
//-----------------------------------------
module mult8ux8s(
    clk,
    n1,
    n2,
    result
    );

input clk;
input [7:0] n1; //unsigned
input [7:0] n2;

output reg [15:0] result;

wire n1orn2z; // weather 0 or not 
wire [7:0] p1,p2,p3,p4,p5,p6,p7,p8;

wire [6:0] s11a,s12a,s13a,s14a;
wire [2:0] s11b,s12b,s13b,s14b;
wire [9:0] s11,s12,s13,s14;
wire [7:0] s21a,s22a;
wire [2:0] s21b,s22b;
wire [11:0] s21,s22;
wire [8:0] s31a;
wire [4:0] s31b;
wire [15:0] s31;
wire res_sign;
wire [18:0] res;
reg [7:0] n1_mag;
reg [7:0] n2_mag;

reg [7:0] p1_reg1,p2_reg1,p3_reg1,p4_reg1,p5_reg1,p6_reg1,p7_reg1,p8_reg1;
reg [6:0] s11a_reg2,s12a_reg2,s13a_reg2,s14a_reg2;
//reg n1_reg1,n1_reg2,n1_reg3,n1_reg4,n1_reg5,n1_reg6,n1_reg7;
reg n2_reg1,n2_reg2,n2_reg3,n2_reg4,n2_reg5,n2_reg6,n2_reg7;
reg n1orn2z_reg1,n1orn2z_reg2,n1orn2z_reg3,n1orn2z_reg4,n1orn2z_reg5,n1orn2z_reg6,n1orn2z_reg7;
reg [7:0] p1_reg2,p2_reg2,p3_reg2,p4_reg2,p5_reg2,p6_reg2,p7_reg2,p8_reg2;
reg [9:0] s11_reg3,s12_reg3,s13_reg3,s14_reg3;
reg [9:0] s11_reg4,s12_reg4,s13_reg4,s14_reg4;
reg [7:0] s21a_reg4,s22a_reg4;
reg [11:0] s21_reg5,s22_reg5;
reg [11:0] s21_reg6,s22_reg6;
reg [8:0] s31a_reg6;
reg [15:0] s31_reg7;



//n1 unsgined
always@(n1)
    begin
        n1_mag = n1[7:0];
    end
    
always@(n2)
    begin
        if(n2[7]==1'b0)
            n2_mag = n2[7:0];
        else 
            n2_mag = ~n2[7:0] + 1;
    end
    
//if any number zero ?
assign n1orn2z = ((n1==8'b0)||(n2==7'b0)) ? 1'b1 : 1'b0;

// computing partial product
//multplicand is shifted and multplied with multplier  
// using bitwise and
assign p1 = n1_mag[7:0] & {8{n2_mag[0]}}; 
assign p2 = n1_mag[7:0] & {8{n2_mag[1]}};
assign p3 = n1_mag[7:0] & {8{n2_mag[2]}};
assign p4 = n1_mag[7:0] & {8{n2_mag[3]}};
assign p5 = n1_mag[7:0] & {8{n2_mag[4]}};
assign p6 = n1_mag[7:0] & {8{n2_mag[5]}};
assign p7 = n1_mag[7:0] & {8{n2_mag[6]}};
assign p8 = n1_mag[7:0] & {8{n2_mag[7]}};

//-------------------------------------------
// first stage pipeline 
// register parital product and sign bits 
//-------------------------------------------
always@(posedge clk)
    begin
        p1_reg1 <=p1;
        p2_reg1 <=p2;
        p3_reg1 <=p3;
        p4_reg1 <=p4;
        p5_reg1 <=p5;
        p6_reg1 <=p6;
        p7_reg1 <=p7;
        p8_reg1 <=p8;
    
        //n1_reg1 <= n1[10]; // sign bit
        n2_reg1 <= n2[7]; //sign bit
        n1orn2z_reg1 <= n1orn2z;
    end
 
assign s11a[6:0] = p1_reg1[6:1] + p2_reg1[5:0]; //LSB is added here 
assign s12a[6:0] = p3_reg1[6:1] + p4_reg1[5:0]; // left shift  
assign s13a[6:0] = p5_reg1[6:1] + p6_reg1[5:0];
assign s14a[6:0] = p7_reg1[6:1] + p8_reg1[5:0];

//-------------------------------------------
// first stage pipeline 
// store lsb result and msb bit received ie msb of partial prodcut
//also register 0th bits of partial product and sign bits
//-------------------------------------------

always@(posedge clk)
    begin
        
        //lsb parital sum 
        s11a_reg2 <= s11a;
        s12a_reg2 <= s12a;
        s13a_reg2 <= s13a;
        s14a_reg2 <= s14a;
        
        //store msb partial product (p1,.....p8)
        p1_reg2[7] <= p1_reg1[7];
        p2_reg2[7:6] <= p2_reg1[7:6];
        p3_reg2[7] <= p3_reg1[7];
        p4_reg2[7:6] <= p4_reg1[7:6];
        p5_reg2[7] <= p5_reg1[7];
        p6_reg2[7:6] <= p6_reg1[7:6];
        p7_reg2[7] <= p7_reg1[7];
        p8_reg2[7:6] <= p8_reg1[7:6];
        
        //store 0 th bit 
        p1_reg2[0] <= p1_reg1[0];
        p3_reg2[0] <= p3_reg1[0];
        p5_reg2[0] <= p5_reg1[0];
        p7_reg2[0] <= p7_reg1[0];
        
        //sign bits
        //n1_reg2 <= n1_reg1;
        n2_reg2 <= n2_reg1;
        
        n1orn2z_reg2 <= n1orn2z_reg1;     
    end
    
//msb is added along with carry to get msb part of result
assign s11b[2:0] = {1'b0 , p1_reg2[7] }+ p2_reg2[7:6] + s11a_reg2[6];
assign s12b[2:0] = {1'b0 , p3_reg2[7] }+ p4_reg2[7:6] + s12a_reg2[6];
assign s13b[2:0] = {1'b0 , p5_reg2[7] }+ p6_reg2[7:6] + s13a_reg2[6];
assign s14b[2:0] = {1'b0 , p7_reg2[7] }+ p8_reg2[7:6] + s14a_reg2[6];

// concatinate lsb and msb to get first
//set of partial product sum
assign s11[9:0] = {s11b,s11a_reg2[5:0],p1_reg2[0]};
assign s12[9:0] = {s12b,s12a_reg2[5:0],p3_reg2[0]};
assign s13[9:0] = {s13b,s13a_reg2[5:0],p5_reg2[0]};
assign s14[9:0] = {s14b,s14a_reg2[5:0],p7_reg2[0]};

//--------------------------------------------
// third stage 
//store first stage result, sign bit and  0 result
//--------------------------------------------
always@(posedge clk)
    begin
        s11_reg3 <= s11;
        s12_reg3 <= s12;
        s13_reg3 <= s13;
        s14_reg3 <= s14;
        
        //n1_reg3 <= n1_reg2;
        n2_reg3 <= n2_reg2;
        
        n1orn2z_reg3 <= n1orn2z_reg2;
    end

// next stage lsb sum 
assign s21a[7:0] = s11_reg3[8:2] + s12_reg3[6:0] ;
assign s22a[7:0] = s13_reg3[8:2] + s14_reg3[6:0] ;


//--------------------------------------------------
// foruth stage pipeling
//-------------------------------------------------------
always@(posedge clk)
     begin  
     //store msb
        s11_reg4[9] <= s11_reg3[9];
        s11_reg4[1:0] <= s11_reg3[1:0];
        s12_reg4[9:7] <= s12_reg3[9:7];
        s13_reg4[9] <= s13_reg3[9];
        s13_reg4[1:0] <= s13_reg3[1:0];
        s14_reg4[9:7] <= s14_reg3[9:7];
        
        //store lsb partial sum result
        s21a_reg4 <= s21a;
        s22a_reg4 <= s22a;
        
       // n1_reg4 <= n1_reg3;
        n2_reg4 <= n2_reg3;
        n1orn2z_reg4 <= n1orn2z_reg3;
      end

//add second stage msb and carry 
assign s21b[2:0] = {2'b0 , s11_reg4[9]} + s12_reg4[9:7] + s21a_reg4[7];
assign s22b[2:0] = {2'b0 , s13_reg4[9]} + s14_reg4[9:7] + s22a_reg4[7];
assign s21[11:0] = {s21b[2:0] , s21a_reg4[6:0],s11_reg4[1:0]};

//result will never effect s21b[6]
//which is always 0
assign s22[11:0] = {s22b[2:0],s22a_reg4[6:0],s13_reg4[1:0]};

//----------------------------------------
// fifth stage pipeline
// save second stage sum result , save sign bits
//----------------------------------------

always @(posedge clk)
    begin
        //save parital sum result
        s21_reg5 <= s21;
        s22_reg5 <= s22;
        
        //n1_reg5 <= n1_reg4;
        n2_reg5 <= n2_reg4;
        n1orn2z_reg5 <= n1orn2z_reg4;
    end
    
// 3rd stage lsb computation
assign s31a[8:0] =s21_reg5[11:4] + s22_reg5[7:0];

// sixth stage pipeline
always@(posedge  clk)
    begin
       // s21_reg6[14:12] <= s21_reg5[14:12];
        s22_reg6[11:8] <= s22_reg5[11:8];
        s21_reg6[3:0] <= s21_reg5[3:0];
        s31a_reg6 <= s31a;
        
        //n1_reg6 <= n1_reg5;
        n2_reg6 <= n2_reg5;
        n1orn2z_reg6 <= n1orn2z_reg5;
    end
 
 //third stage msb computation   
assign s31b[4:0] = //{4'b0, s21_reg6[14:12]} +
                    s22_reg6[11:8] + s31a_reg6[8];
assign s31[15:0] = {s31b[2:0] ,s31a_reg6[7:0],s21_reg6[3:0]};
//3rd stage result will never effect s31b[6:5],which is 0

//---------------------------
//seventh pipeline
//---------------------------
always@(posedge clk)
    begin
        //n1_reg7 <= n1_reg6;
        n2_reg7 <= n2_reg6;
        //result of 3rd stage
        s31_reg7 <= s31;
        
        n1orn2z_reg7 <= n1orn2z_reg6;
    end
    
assign res_sign = n2_reg7; // check result is negative

//assign same number if result posiitve else
//assign twos complement
assign res[15:0] = (res_sign) ? {1'b1,(~s31_reg7+1'b1)}: {1'b0,s31_reg7};

//-----------------------------------------------
//eighth stage pipelining
//-----------------------------------------------
always@(posedge  clk)
    begin
        if(n1orn2z_reg7 == 1'b1)
            result[15:0] <= 16'b0;
        else 
            result [15:0] <= res ;
    end
    
endmodule