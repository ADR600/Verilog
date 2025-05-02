`timescale 1ns / 1ps

/////////////////////////////////////////////////////////////////////////////////
// Module Name:    multiplier32_bit 
/////
/////////////////////////////////////////////////////////////////////////////

// wallace tree apporach 
// 1. partial product generation
// 2. partial product reduction-using HA and FA
// 3. carry propogation addition CPA

module multiplier4_bit_wallace_tree(
	a,
	b,
	product
    );
	input [3:0] a,b;
	output [7:0] product;
	
	wire a0b0,a0b1,a0b2,a0b3;
	wire a1b0,a1b1,a1b2,a1b3;
	wire a2b0,a2b1,a2b2,a2b3;
	wire a3b0,a3b1,a3b2,a3b3;
	
	assign a0b0 = a[0] & b[0];
	assign a0b1 = a[0] & b[1];
	assign a0b2 = a[0] & b[2];
	assign a0b3 = a[0] & b[3];
	
	assign a1b0 = a[1] & b[0];
	assign a1b1 = a[1] & b[1];
	assign a1b2 = a[1] & b[2];
	assign a1b3 = a[1] & b[3];
	
	assign a2b0 = a[2] & b[0];
	assign a2b1 = a[2] & b[1];
	assign a2b2 = a[2] & b[2];
	assign a2b3 = a[2] & b[3];
	
	assign a3b0 = a[3] & b[0];
	assign a3b1 = a[3] & b[1];
	assign a3b2 = a[3] & b[2];
	assign a3b3 = a[3] & b[3];

	wire x1c,x2s,x2c,x31s,x31c,x41s,x41c;
	wire v1,v2,v3,v4,v5,v6,v7;
	
	assign product[0] = a0b0;
	
	//wallace treee implementation using adders
	
	half_adder H1(a1b0,a0b1,product[1],x1c);
	
	full_adder F21(a0b2,a1b1,a2b0,x2s,x2c);
	half_adder H22(x1c,x2s,product[2],v1);
	
	full_adder F31(a3b0,a1b2,a2b1,x31s,x31c);
	full_adder F32(x31s,a0b3,x2c,v2,v3);
	
	half_adder H41(a3b1,a2b2,x41s,x41c);	
	full_adder F42(a1b3,x41s,x31c,v4,v5);
	
	full_adder F51(a3b2,a2b3,x41c,v6,v7);
	
	
	//vector merging portion 
	wire [3:0] prod1, prod2;
	assign prod1 = {v7,v5,v3,v1};
	assign prod2 = {a3b3,v6,v4,v2};
	
	ripple_carry_adder RCA1(.a(prod1),.b(prod2),.cin(1'b0),.sum(product[6:3]),.carry(product[7]));
	

endmodule
