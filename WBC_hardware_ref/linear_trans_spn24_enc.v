`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/23 11:38:51
// Design Name: 
// Module Name: linear_trans_spn24_enc
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


module linear_trans_spn24_enc(
    input [127:0] a,
    output wire [127:0] b
    );
    
    assign b[127:120] = a[127:120]; 
    wire [23:0] a0 = a[23:0];
    wire [23:0] a1 = a[47:24];
    wire [23:0] a2 = a[71:48];
    wire [23:0] a3 = a[95:72];
    wire [23:0] a4 = a[119:96];
    
    wire [23:0] b00 = a2 ^ a4;
    wire [23:0] b01;
    mult_2_GF24 m0(.a(b00),.b(b01));
    wire [23:0] b02 = a1 ^ a3;
    wire [23:0] b03;
    mult_4_GF24 m1(.a(b02),.b(b03));
    wire [23:0] b04 = b03 ^ a0;
    wire [23:0] b05 = b01 ^ a2 ^ a3;
    assign b[23:0] = b04 ^ b05;
    
    wire [23:0] b10 = a0 ^ a3;
    wire [23:0] b11;
    mult_2_GF24 m2(.a(b10),.b(b11));
    wire [23:0] b12 = a2 ^ a4;
    wire [23:0] b13;
    mult_4_GF24 m3(.a(b12),.b(b13));
    wire [23:0] b14 = b13 ^ a1;
    wire [23:0] b15 = b11 ^ a3 ^ a4;
    assign b[47:24] = b14 ^ b15;
    
    wire [23:0] b20 = a1 ^ a4;
    wire [23:0] b21;
    mult_2_GF24 m4(.a(b20),.b(b21));
    wire [23:0] b22 = a0 ^ a3;
    wire [23:0] b23;
    mult_4_GF24 m5(.a(b22),.b(b23));
    wire [23:0] b24 = b23 ^ a0;
    wire [23:0] b25 = b21 ^ a2 ^ a4;
    assign b[71:48] = b24 ^ b25;
    
    wire [23:0] b30 = a0 ^ a2;
    wire [23:0] b31;
    mult_2_GF24 m6(.a(b30),.b(b31));
    wire [23:0] b32 = a1 ^ a4;
    wire [23:0] b33;
    mult_4_GF24 m7(.a(b32),.b(b33));
    wire [23:0] b34 = b33 ^ a0;
    wire [23:0] b35 = b31 ^ a1 ^ a3;
    assign b[95:72] = b34 ^ b35;
    
    wire [23:0] b40 = a1 ^ a3;
    wire [23:0] b41;
    mult_2_GF24 m8(.a(b40),.b(b41));
    wire [23:0] b42 = a0 ^ a2;
    wire [23:0] b43;
    mult_4_GF24 m9(.a(b42),.b(b43));
    wire [23:0] b44 = b43 ^ a1;
    wire [23:0] b45 = b41 ^ a2 ^ a4;
    assign b[119:96] = b44 ^ b45;
    
endmodule