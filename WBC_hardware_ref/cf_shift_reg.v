`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/28 09:35:30
// Design Name: 
// Module Name: cf_shift_reg
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
//extend the en_r
//add the lut output

module cf_shift_reg # (
  parameter n = 8
  )(
    input clk,rst_n,
    //add for exchanging data with reg chain 1
    input sel_reg_chain_1, //1:sel ReC_1
    input [127:0] ReC_1,
    
    input [15:0] EN_R,
    input [2:0] sel0,sel1,sel2,sel3,sel4,sel5,sel6,sel7,
    input [2:0] sel8,sel9,sel10,sel11,sel12,sel13,sel14,sel15,
    input [n-1:0] LUT15_8,
    input [n-1:0] LUT14_16,LUT15_16,
    input [n-1:0] P0,P1,P2,P3,P4,P5,P6,P7,
    input [n-1:0] P8,P9,P10,P11,P12,P13,P14,P15,
    input [n-1:0] NTO0,NTO1,NTO2,NTO3,NTO4,NTO5,NTO6,NTO7,
    input [n-1:0] NTO8,NTO9,NTO10,NTO11,NTO12,NTO13,NTO14,NTO15,
    input [n-1:0] RKO0,RKO1,RKO2,RKO3,RKO4,RKO5,RKO6,RKO7,
    input [n-1:0] RKO8,RKO9,RKO10,RKO11,RKO12,RKO13,RKO14,RKO15,
    input [n-1:0] ReF0,ReF1,ReF2,ReF3,ReF4,ReF5,ReF6,ReF7,
    input [n-1:0] ReF8,ReF9,ReF10,ReF11,ReF12,ReF13,ReF14,ReF15,
    output reg [n-1:0] q0,q1,q2,q3,q4,q5,q6,q7,
    output reg [n-1:0] q8,q9,q10,q11,q12,q13,q14,q15
    );
    
    reg [n-1:0] t0,t1,t2,t3,t4,t5,t6,t7;
    reg [n-1:0] t8,t9,t10,t11,t12,t13,t14,t15;
    
    wire [n-1:0] d0,d1,d2,d3,d4,d5,d6,d7;
    wire [n-1:0] d8,d9,d10,d11,d12,d13,d14,d15;
    
    wire [n-1:0] tt0,tt1,tt2,tt3,tt4,tt5,tt6,tt7;
    wire [n-1:0] tt8,tt9,tt10,tt11,tt12,tt13,tt14,tt15;
    
    assign tt0 = sel_reg_chain_1 == 1'b0 ? t0 : ReC_1[7:0];
    assign tt1 = sel_reg_chain_1 == 1'b0 ? t1 : ReC_1[15:8];
    assign tt2 = sel_reg_chain_1 == 1'b0 ? t2 : ReC_1[23:16];
    assign tt3 = sel_reg_chain_1 == 1'b0 ? t3 : ReC_1[31:24];
    assign tt4 = sel_reg_chain_1 == 1'b0 ? t4 : ReC_1[39:32];
    assign tt5 = sel_reg_chain_1 == 1'b0 ? t5 : ReC_1[47:40];
    assign tt6 = sel_reg_chain_1 == 1'b0 ? t6 : ReC_1[55:48];
    assign tt7 = sel_reg_chain_1 == 1'b0 ? t7 : ReC_1[63:56];
    assign tt8 = sel_reg_chain_1 == 1'b0 ? t8 : ReC_1[71:64];
    assign tt9 = sel_reg_chain_1 == 1'b0 ? t9 : ReC_1[79:72];
    assign tt10 = sel_reg_chain_1 == 1'b0 ? t10 : ReC_1[87:80];
    assign tt11 = sel_reg_chain_1 == 1'b0 ? t11 : ReC_1[95:88];
    assign tt12 = sel_reg_chain_1 == 1'b0 ? t12 : ReC_1[103:96];
    assign tt13 = sel_reg_chain_1 == 1'b0 ? t13 : ReC_1[111:104];
    assign tt14 = sel_reg_chain_1 == 1'b0 ? t14 : ReC_1[119:112];
    assign tt15 = sel_reg_chain_1 == 1'b0 ? t15 : ReC_1[127:120];
    
    assign d0 = EN_R[0] == 0 ? q0 : tt0; 
    assign d1 = EN_R[1] == 0 ? q1 : tt1; 
    assign d2 = EN_R[2] == 0 ? q2 : tt2; 
    assign d3 = EN_R[3] == 0 ? q3 : tt3; 
    assign d4 = EN_R[4] == 0 ? q4 : tt4; 
    assign d5 = EN_R[5] == 0 ? q5 : tt5; 
    assign d6 = EN_R[6] == 0 ? q6 : tt6; 
    assign d7 = EN_R[7] == 0 ? q7 : tt7; 
    assign d8 = EN_R[8] == 0 ? q8 : tt8; 
    assign d9 = EN_R[9] == 0 ? q9 : tt9; 
    assign d10 = EN_R[10] == 0 ? q10 : tt10; 
    assign d11 = EN_R[11] == 0 ? q11 : tt11; 
    assign d12 = EN_R[12] == 0 ? q12 : tt12; 
    assign d13 = EN_R[13] == 0 ? q13 : tt13; 
    assign d14 = EN_R[14] == 0 ? q14 : tt14; 
    assign d15 = EN_R[15] == 0 ? q15 : tt15; 
  
    always@(posedge clk or negedge rst_n)
    begin
      if(!rst_n) begin
        q0 <= 0; q1 <= 0; q2 <= 0; q3 <= 0;
        q4 <= 0; q5 <= 0; q6 <= 0; q7 <= 0;
        q8 <= 0; q9 <= 0; q10 <= 0; q11 <= 0;
        q12 <= 0; q13 <= 0; q14 <= 0; q15 <= 0;
      end
      else begin
        q0 <= d0; q1 <= d1; q2 <= d2; q3 <= d3;
        q4 <= d4; q5 <= d5; q6 <= d6; q7 <= d7;
        q8 <= d8; q9 <= d9; q10 <= d10; q11 <= d11;
        q12 <= d12; q13 <= d13; q14 <= d14; q15 <= d15;
      end
    end
    
    always@(*)
    begin
      case(sel0)
      3'b000: t0 = P0;
      3'b001: t0 = NTO0;
      3'b010: t0 = RKO0;
      3'b011: t0 = q1;
      3'b100: t0 = q2;
      3'b101: t0 = ReF0;
      //3'b110: t0 = LUT0;
      default: t0 = 0;
      endcase
    end
    
    always@(*)
    begin
      case(sel1)
      3'b000: t1 = P1;
      3'b001: t1 = NTO1;
      3'b010: t1 = RKO1;
      3'b011: t1 = q2;
      3'b100: t1 = q3;
      3'b101: t1 = ReF1;
      //3'b110: t1 = LUT1;
      default: t1 = 0;
      endcase
    end
    
    always@(*)
    begin
      case(sel2)
      3'b000: t2 = P2;
      3'b001: t2 = NTO2;
      3'b010: t2 = RKO2;
      3'b011: t2 = q3;
      3'b100: t2 = q4;
      3'b101: t2 = ReF2;
      //3'b110: t2 = LUT2;
      default: t2 = 0;
      endcase
    end
    
    always@(*)
    begin
      case(sel3)
      3'b000: t3 = P3;
      3'b001: t3 = NTO3;
      3'b010: t3 = RKO3;
      3'b011: t3 = q4;
      3'b100: t3 = q5;
      3'b101: t3 = ReF3;
      //3'b110: t3 = LUT3;
      default: t3 = 0;
      endcase
    end
    
    always@(*)
    begin
      case(sel4)
      3'b000: t4 = P4;
      3'b001: t4 = NTO4;
      3'b010: t4 = RKO4;
      3'b011: t4 = q5;
      3'b100: t4 = q6;
      3'b101: t4 = ReF4;
      //3'b110: t4 = LUT4;
      default: t4 = 0;
      endcase
    end
    
    always@(*)
    begin
      case(sel5)
      3'b000: t5 = P5;
      3'b001: t5 = NTO5;
      3'b010: t5 = RKO5;
      3'b011: t5 = q6;
      3'b100: t5 = q7;
      3'b101: t5 = ReF5;
      //3'b110: t5 = LUT5;
      default: t5 = 0;
      endcase
    end
    
    always@(*)
    begin
      case(sel6)
      3'b000: t6 = P6;
      3'b001: t6 = NTO6;
      3'b010: t6 = RKO6;
      3'b011: t6 = q7;
      3'b100: t6 = q8;
      3'b101: t6 = ReF6;
      //3'b110: t6 = LUT6;
      default: t6 = 0;
      endcase
    end
    
    always@(*)
    begin
      case(sel7)
      3'b000: t7 = P7;
      3'b001: t7 = NTO7;
      3'b010: t7 = RKO7;
      3'b011: t7 = q8;
      3'b100: t7 = q9;
      3'b101: t7 = ReF7;
      //3'b110: t7 = LUT7;
      default: t7 = 0;
      endcase
    end
    
    always@(*)
    begin
      case(sel8)
      3'b000: t8 = P8;
      3'b001: t8 = NTO8;
      3'b010: t8 = RKO8;
      3'b011: t8 = q9;
      3'b100: t8 = q10;
      3'b101: t8 = ReF8;
      //3'b110: t8 = LUT8;
      default: t8 = 0;
      endcase
    end
    
    always@(*)
    begin
      case(sel9)
      3'b000: t9 = P9;
      3'b001: t9 = NTO9;
      3'b010: t9 = RKO9;
      3'b011: t9 = q10;
      3'b100: t9 = q11;
      3'b101: t9 = ReF9;
      //3'b110: t9 = LUT9;
      default: t9 = 0;
      endcase
    end
    
    always@(*)
    begin
      case(sel10)
      3'b000: t10 = P10;
      3'b001: t10 = NTO10;
      3'b010: t10 = RKO10;
      3'b011: t10 = q11;
      3'b100: t10 = q12;
      3'b101: t10 = ReF10;
      //3'b110: t10 = LUT10;
      default: t10 = 0;
      endcase
    end
    
    always@(*)
    begin
      case(sel11)
      3'b000: t11 = P11;
      3'b001: t11 = NTO11;
      3'b010: t11 = RKO11;
      3'b011: t11 = q12;
      3'b100: t11 = q13;
      3'b101: t11 = ReF11;
      //3'b110: t11 = LUT11;
      default: t11 = 0;
      endcase
    end
    
    always@(*)
    begin
      case(sel12)
      3'b000: t12 = P12;
      3'b001: t12 = NTO12;
      3'b010: t12 = RKO12;
      3'b011: t12 = q13;
      3'b100: t12 = q14;
      3'b101: t12 = ReF12;
      //3'b110: t12 = LUT12;
      default: t12 = 0;
      endcase
    end
    
    always@(*)
    begin
      case(sel13)
      3'b000: t13 = P13;
      3'b001: t13 = NTO13;
      3'b010: t13 = RKO13;
      3'b011: t13 = q14;
      3'b100: t13 = q15;
      3'b101: t13 = ReF13;
      //3'b110: t13 = LUT13;
      default: t13 = 0;
      endcase
    end
    
    always@(*)
    begin
      case(sel14)
      3'b000: t14 = P14;
      3'b001: t14 = NTO14;
      3'b010: t14 = RKO14;
      3'b011: t14 = q15;
      3'b100: t14 = q1;
      3'b101: t14 = ReF14;
      3'b110: t14 = LUT14_16;
      default: t14 = 0;
      endcase
    end
    
    always@(*)
    begin
      case(sel15)
      3'b000: t15 = P15;
      3'b001: t15 = NTO15;
      3'b010: t15 = RKO15;
      3'b011: t15 = q0;
      3'b100: t15 = q0;
      3'b101: t15 = ReF15;
      3'b110: t15 = LUT15_16;
      3'b111: t15 = LUT15_8;
      //default: t15 = 0;
      endcase
    end
    
endmodule