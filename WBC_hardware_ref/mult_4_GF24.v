`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/20 16:20:14
// Design Name: 
// Module Name: mult_4_GF24
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


module mult_4_GF24(
  input [23:0] a,
  output wire [23:0] b
  );

  assign b[0] = a[22];
  assign b[1] = a[22] ^ a[23];
  assign b[2] = a[0] ^ a[23];
  assign b[3] = a[1] ^ a[22];
  assign b[4] = a[2] ^ a[22] ^ a[23];
  assign b[5] = a[3] ^ a[23];
  assign b[23:6] = a[21:4];
endmodule