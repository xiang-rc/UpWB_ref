`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/20 12:54:27
// Design Name: 
// Module Name: linear_trans_spn32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module linear_trans_spn32(
    input [127:0] a,
    output wire [127:0] b
    );
    
    wire [31:0] a0 = a[31:0];
    wire [31:0] a1 = a[63:32];
    wire [31:0] a2 = a[95:64];
    wire [31:0] a3 = a[127:96];
    
    wire [31:0] b00 = a1 ^ a3;
    wire [31:0] b00_x;
    mult_2_GF32 m0(.a(b00),.b(b00_x));
    wire [31:0] b01 = a2 ^ a3;
    wire [31:0] b01_x_2;
    mult_4_GF32 m1(.a(b01),.b(b01_x_2));
    assign b[31:0] = a0 ^ b00_x ^ b01_x_2;
    
    wire [31:0] b10 = a0 ^ a2;
    wire [31:0] b10_x;
    mult_2_GF32 m2(.a(b10),.b(b10_x));
    //wire [31:0] b11 = a2 ^ a3;
    //wire [31:0] b11_x_2;
    //mult_4_GF32 m3(.a(b11),.b(b11_x_2));
    assign b[63:32] = a1 ^ b10_x ^ b01_x_2;
    
    //wire [31:0] b20 = a1 ^ a3;
    //wire [31:0] b20_x;
    //mult_2_GF32 m4(.a(b20),.b(b20_x));
    wire [31:0] b21 = a0 ^ a1;
    wire [31:0] b21_x_2;
    mult_4_GF32 m5(.a(b21),.b(b21_x_2));
    assign b[95:64] = a2 ^ b00_x ^ b21_x_2;
    
    //wire [31:0] b30 = a0 ^ a2;
    //wire [31:0] b30_x;
    //mult_2_GF32 m6(.a(b30),.b(b30_x));
    //wire [31:0] b31 = a0 ^ a1;
    //wire [31:0] b31_x_2;
    //mult_4_GF32 m7(.a(b31),.b(b31_x_2));
    assign b[127:96] = a3 ^ b10_x ^ b21_x_2;
endmodule