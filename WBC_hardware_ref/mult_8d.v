`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/25 19:23:44
// Design Name: 
// Module Name: mult_8d
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


/*module mult_8b(
   input        [      7:0]  b ,
   output wire  [      7:0]  c
    );
    
   wire t0 = b[5] ^ b[7];
   assign c[7] = b[0] ^ t0;
   assign c[6] = b[4] ^ b[5] ^ b[6];
   assign c[5] = b[3] ^ b[4];
   wire t1 = b[2] ^ b[3];
   assign c[4] = t0 ^ t1;
   wire t2 = b[2] ^ b[6];
   wire t3 = b[0] ^ b[1];
   assign c[3] = t2 ^ t3 ^ b[4];
   assign c[2] = b[1] ^ b[3] ^ b[7];
   wire t4 = b[0] ^ b[7];
   assign c[1] = t2 ^ t4;
   assign c[0] = t3 ^ b[6];
endmodule*/

module mult_8d(
   input        [      7:0]  b ,
   output wire  [      7:0]  c
    );
    
    assign c[7] = b[0];
    assign c[6] = b[7];
    assign c[5] = b[6];
    assign c[4] = b[5];
    assign c[3] = b[0] ^ b[4];
    assign c[2] = b[0] ^ b[3];
    assign c[1] = b[2];
    assign c[0] = b[0] ^ b[1];
endmodule