`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/20 11:35:18
// Design Name: 
// Module Name: mult_4
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

module mult_2_GF32(
  input [31:0] a,
  output wire [31:0] b
  );
  
  assign b[0] = a[31];
  assign b[1] = a[0];
  assign b[2] = a[31] ^ a[1];
  assign b[3] = a[31] ^ a[2];
  assign b[7] = a[31] ^ a[6];
  assign b[6:4] = a[5:3];
  assign b[31:8] = a[30:7];
  
endmodule