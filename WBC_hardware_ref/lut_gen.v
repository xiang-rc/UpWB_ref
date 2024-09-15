`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/21 09:21:53
// Design Name: 
// Module Name: lut_gen
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


module lut_gen(
    input clk,
    input rst_n,
    input start_lut_gen,
    input [2:0] alg_mode,
    output wire [12:0] addr_gen,
    output wire done_gen,
    output wire [127:0] P_gen
    );
    wire [12:0] end_num = alg_mode == 3'b000 ? 13'd15 : 13'd8191;
    wire [12:0] cnt_r;
    wire [12:0] t = start_lut_gen == 1'b0 ? cnt_r : cnt_r + 1;
    wire [12:0] d = cnt_r == end_num ? 13'd0 : t;
    assign done_gen = cnt_r == end_num ? 1'b1 : 1'b0;
    DFF #(.data_width(4'd13)) cnt_reg(.clk(clk),.rst_n(rst_n),.d(d),.q(cnt_r));

    wire [16:0] cnt_r0_spn8 = (cnt_r << 4) + 4'd0;
    wire [16:0] cnt_r1_spn8 = (cnt_r << 4) + 4'd1;
    wire [16:0] cnt_r2_spn8 = (cnt_r << 4) + 4'd2;
    wire [16:0] cnt_r3_spn8 = (cnt_r << 4) + 4'd3;
    wire [16:0] cnt_r4_spn8 = (cnt_r << 4) + 4'd4;
    wire [16:0] cnt_r5_spn8 = (cnt_r << 4) + 4'd5;
    wire [16:0] cnt_r6_spn8 = (cnt_r << 4) + 4'd6;
    wire [16:0] cnt_r7_spn8 = (cnt_r << 4) + 4'd7;
    wire [16:0] cnt_r8_spn8 = (cnt_r << 4) + 4'd8;
    wire [16:0] cnt_r9_spn8 = (cnt_r << 4) + 4'd9;
    wire [16:0] cnt_r10_spn8 = (cnt_r << 4) + 4'd10;
    wire [16:0] cnt_r11_spn8 = (cnt_r << 4) + 4'd11;
    wire [16:0] cnt_r12_spn8 = (cnt_r << 4) + 4'd12;
    wire [16:0] cnt_r13_spn8 = (cnt_r << 4) + 4'd13;
    wire [16:0] cnt_r14_spn8 = (cnt_r << 4) + 4'd14;
    wire [16:0] cnt_r15_spn8 = (cnt_r << 4) + 4'd15;
    
    wire [127:0] P_mux0 = {cnt_r0_spn8[7:0],cnt_r1_spn8[7:0],cnt_r2_spn8[7:0],cnt_r3_spn8[7:0],
                           cnt_r4_spn8[7:0],cnt_r5_spn8[7:0],cnt_r6_spn8[7:0],cnt_r7_spn8[7:0],
                           cnt_r8_spn8[7:0],cnt_r9_spn8[7:0],cnt_r10_spn8[7:0],cnt_r11_spn8[7:0],
                           cnt_r12_spn8[7:0],cnt_r13_spn8[7:0],cnt_r14_spn8[7:0],cnt_r15_spn8[7:0]};
                           
    wire [15:0] cnt_r0_spn16 = (cnt_r << 3) + 4'd0;
    wire [15:0] cnt_r1_spn16 = (cnt_r << 3) + 4'd1;
    wire [15:0] cnt_r2_spn16 = (cnt_r << 3) + 4'd2;
    wire [15:0] cnt_r3_spn16 = (cnt_r << 3) + 4'd3;
    wire [15:0] cnt_r4_spn16 = (cnt_r << 3) + 4'd4;
    wire [15:0] cnt_r5_spn16 = (cnt_r << 3) + 4'd5;
    wire [15:0] cnt_r6_spn16 = (cnt_r << 3) + 4'd6;
    wire [15:0] cnt_r7_spn16 = (cnt_r << 3) + 4'd7;
    
    wire [127:0] P_mux1 = {cnt_r0_spn16,cnt_r1_spn16,cnt_r2_spn16,cnt_r3_spn16,
                           cnt_r4_spn16,cnt_r5_spn16,cnt_r6_spn16,cnt_r7_spn16};
    assign P_gen = alg_mode == 3'b000 ? P_mux0 : P_mux1;
    assign addr_gen = cnt_r;
endmodule

module DFF #(parameter data_width = 8)(
    input               clk,rst_n,//low
    input      [data_width-1:0] d,
    output reg [data_width-1:0] q 
    );
    always@(posedge clk or negedge rst_n)
    begin
      if(!rst_n)
        q <= 'b0;
      else
        q <= d;
    end
endmodule