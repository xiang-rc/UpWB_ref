`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/13 17:30:41
// Design Name: 
// Module Name: cf_shift_reg_1
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


module cf_shift_reg_1(
    input clk,rst_n,
    input EN_R_1,
    input [2:0] sel_1,
    input [127:0] ReF,
    input [127:0] ReC,
    output reg [127:0] q_1
    );
    
    reg [127:0] t;
    
    wire [127:0] d;
    
    assign d = EN_R_1 == 0 ? q_1 : t;
  
    always@(posedge clk or negedge rst_n)
    begin
      if(!rst_n) begin
        q_1 <= 128'b0;
      end
      else begin
        q_1 <= d;
      end
    end
    
    always@(*)
    begin
      case(sel_1)
      3'b000: t = ReC;
      3'b001: t = ReF;
      3'b010: t = {q_1[7:0],q_1[127:8]};//shift-by-1B
      3'b011: t = {q_1[15:0],q_1[127:16]};//shift-by-2B
      3'b100: t = {q_1[23:0],q_1[119:24]};//shift-by-3B
      3'b101: t = {q_1[31:0],q_1[127:32]};//shift-by-4B
      default: t = 0;
      endcase
    end
endmodule