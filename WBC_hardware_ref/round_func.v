`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/13 22:29:33
// Design Name: 
// Module Name: round_func
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


module round_func(
    input clk,rst_n,
    input [2:0] alg_mode,
    //input start,
    input ACC_src_x,
    input [1:0] ACC_src_y,
    input ReF_en,
    input [15:0] EN_R,
    input [63:0] MDS, //16*4-bit
    input [47:0] sel,
    input sel_reg_chain_1,//add for reg chain 1
    input [127:0] P,
    input [127:0] RKI,
    input mode_enc_dec,
    input [2:0] mode_ref,
    input [3:0] outer_round,
    input [7:0] LUT15_16,LUT14_16,LUT15_8,
    input sel_op,
    //add for reg chain 1
    input EN_R_1,
    input [2:0] sel_1,
    output wire [127:0] ReC_o_1,
    
    output wire [7:0] q0,q1,
    output wire [127:0] ReC_o,
    output wire [127:0] ReF
    );
   
   wire [127:0] ReC;
   wire [127:0] ReC_1;//add for reg chain 1
   wire [127:0] RKO;
   wire [127:0] NTO;
   
   assign ReC_o = ReC;
   assign ReC_o_1 = ReC_1;//add for reg chain 1
   assign q0 = ReC[7:0];
   assign q1 = ReC[15:8];
   
   (*DONT_TOUCH = "true"*)
   linear_trans m_lt(
    .clk(clk),.rst_n(rst_n),
    .alg_mode(alg_mode),
    .outer_round(outer_round),
    .mode_ref(mode_ref),
    .mode_enc_dec(mode_enc_dec),
    .P(P),
    //.start(start), //start linear trans.
    .ACC_src_y(ACC_src_y),
    .ACC_src_x(ACC_src_x),
    .ReF_en(ReF_en),
    .sel_op(sel_op),
    .MDS(MDS),
    .ReC_0(ReC),
    .ReC_1(ReC_1), //change for reg chain 1
    .ReF(ReF));
   
   (*DONT_TOUCH = "true"*)
   none_linear_trans m_nlt(
    .clk(clk),.rst_n(rst_n), //add for pipeline
    .mode_enc_dec(mode_enc_dec),
    .RKI(RKI),
    .ReC(ReC),
    .alg_mode(alg_mode), //ctrl
    .RKO(RKO),
    .NTO(NTO));
    
    (*DONT_TOUCH = "true"*)
    cf_shift_reg m_reg_chain(
    .clk(clk),.rst_n(rst_n),
    .EN_R(EN_R),
    .sel_reg_chain_1(sel_reg_chain_1), //1:sel ReC_1
    .ReC_1(ReC_1),
    .LUT15_16(LUT15_16),.LUT14_16(LUT14_16),.LUT15_8(LUT15_8),
    .ReF0(ReF[7:0]),.ReF1(ReF[15:8]),.ReF2(ReF[23:16]),.ReF3(ReF[31:24]),.ReF4(ReF[39:32]),.ReF5(ReF[47:40]),.ReF6(ReF[55:48]),.ReF7(ReF[63:56]),
    .ReF8(ReF[71:64]),.ReF9(ReF[79:72]),.ReF10(ReF[87:80]),.ReF11(ReF[95:88]),.ReF12(ReF[103:96]),.ReF13(ReF[111:104]),.ReF14(ReF[119:112]),.ReF15(ReF[127:120]),
    .sel0(sel[2:0]),.sel1(sel[5:3]),.sel2(sel[8:6]),.sel3(sel[11:9]),.sel4(sel[14:12]),
    .sel5(sel[17:15]),.sel6(sel[20:18]),.sel7(sel[23:21]),.sel8(sel[26:24]),
    .sel9(sel[29:27]),.sel10(sel[32:30]),.sel11(sel[35:33]),.sel12(sel[38:36]),
    .sel13(sel[41:39]),.sel14(sel[44:42]),.sel15(sel[47:45]),
    .P0(P[7:0]),.P1(P[15:8]),.P2(P[23:16]),.P3(P[31:24]),.P4(P[39:32]),.P5(P[47:40]),.P6(P[55:48]),.P7(P[63:56]),
    .P8(P[71:64]),.P9(P[79:72]),.P10(P[87:80]),.P11(P[95:88]),.P12(P[103:96]),.P13(P[111:104]),.P14(P[119:112]),.P15(P[127:120]),
    .NTO0(NTO[7:0]),.NTO1(NTO[15:8]),.NTO2(NTO[23:16]),.NTO3(NTO[31:24]),.NTO4(NTO[39:32]),.NTO5(NTO[47:40]),.NTO6(NTO[55:48]),.NTO7(NTO[63:56]),
    .NTO8(NTO[71:64]),.NTO9(NTO[79:72]),.NTO10(NTO[87:80]),.NTO11(NTO[95:88]),.NTO12(NTO[103:96]),.NTO13(NTO[111:104]),.NTO14(NTO[119:112]),.NTO15(NTO[127:120]),
    .RKO0(RKO[7:0]),.RKO1(RKO[15:8]),.RKO2(RKO[23:16]),.RKO3(RKO[31:24]),.RKO4(RKO[39:32]),.RKO5(RKO[47:40]),.RKO6(RKO[55:48]),.RKO7(RKO[63:56]),
    .RKO8(RKO[71:64]),.RKO9(RKO[79:72]),.RKO10(RKO[87:80]),.RKO11(RKO[95:88]),.RKO12(RKO[103:96]),.RKO13(RKO[111:104]),.RKO14(RKO[119:112]),.RKO15(RKO[127:120]),
    .q0(ReC[7:0]),.q1(ReC[15:8]),.q2(ReC[23:16]),.q3(ReC[31:24]),.q4(ReC[39:32]),.q5(ReC[47:40]),.q6(ReC[55:48]),.q7(ReC[63:56]),
    .q8(ReC[71:64]),.q9(ReC[79:72]),.q10(ReC[87:80]),.q11(ReC[95:88]),.q12(ReC[103:96]),.q13(ReC[111:104]),.q14(ReC[119:112]),.q15(ReC[127:120])
    );
    
    cf_shift_reg_1 m_reg_chain_1(
    .clk(clk),
    .rst_n(rst_n),
    .EN_R_1(EN_R_1),
    .sel_1(sel_1),
    .ReF(ReF),
    .ReC(ReC),
    .q_1(ReC_1)
    );
endmodule