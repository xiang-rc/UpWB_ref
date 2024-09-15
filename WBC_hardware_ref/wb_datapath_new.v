`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/17 14:45:21
// Design Name: 
// Module Name: wb_datapath
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


module wb_datapath(
    input clk,rst_n,
    input [2:0] alg_mode,
    //input start_lt,
    input ACC_src_x,
    input [1:0] ACC_src_y,
    input ReF_en,//pace with folding
    input [15:0] EN_R,
    input [47:0] sel,
    input [127:0] P,//plaintext
    input [127:0] MK,//master key
    input [3:0] outer_round,
    input sel_op, //add for folding
    input mode_enc_dec,//0: enc & 1:dec
    input [2:0] mode_ref,
    //add for reg chain 1
    input sel_reg_chain_1,
    input EN_R_1,
    input [2:0] sel_1,
    output wire [127:0] ReC_o_1,
    //ram sig.
    input [1:0] WEN,REN,EN,//[0]:lut [1]: mds_bank
    input [4:0] MDS_addr,//read mds data
    input [31:0] ram_MDS_i,//write initial MDS into 32-bit width bank
    //keccak
    input mode,// 1:init 0:squ
    input d_i_vld,
  //  input [1:0] mode_reg,
    input load_rk,
    input init_en,
    //data gen
    input mode_wbc, //0: gen lut 1: normal op
    input start_lut_gen,
    output wire done_gen, 
    output wire d_o_vld,
    output wire [127:0] ReF
    );
    
    //reg [127:0] P;//plaintext
    //reg [127:0] MK;//master key
    //wire [127:0] ReF;
    
    wire [127:0] RKI;
    wire [31:0] ram_MDS_o;//change to 32-bit  
    wire [63:0] MDS; //after extension
    wire [7:0] q0,q1;
    wire [12:0] WB_addr;
    wire [127:0] LUT_o;
    wire [7:0] LUT15_16,LUT14_16,LUT15_8;
    wire [127:0] ReC_o;
    //keccak
    wire [15:0] RK0;
    wire [31:0] RK1;
    wire [1599:0] d_i;
    //data_gen
    wire [12:0] addr_gen;
    wire [127:0] P_gen;
    
    wire [127:0] P_reg_i = mode_wbc == 1'b0 ? P_gen : P; // 0 gen lut 1 external p
    
    round_func m_rf(
    .clk(clk),.rst_n(rst_n),
    .alg_mode(alg_mode),
    //.start(start_lt),
    .ACC_src_x(ACC_src_x),
    .ACC_src_y(ACC_src_y),
    .ReF_en(ReF_en),
    .EN_R(EN_R),
    .MDS(MDS),
    .sel(sel),
    .P(P_reg_i),
    .RKI(RKI),
    .mode_enc_dec(mode_enc_dec),
    .mode_ref(mode_ref),
    .q0(q0),.q1(q1),
    .LUT15_16(LUT15_16),.LUT14_16(LUT14_16),.LUT15_8(LUT15_8),
    .sel_op(sel_op),
    .outer_round(outer_round),
    .ReF(ReF),
    .ReC_o(ReC_o),
    //add for reg chain 1
    .EN_R_1(EN_R_1),
    .sel_1(sel_1),
    .sel_reg_chain_1(sel_reg_chain_1),
    .ReC_o_1(ReC_o_1)
    );
    
   rk_bus m_rk_bus(
    .rk0(RK0),
    .rk1(RK1),
    .alg_mode(alg_mode),
    .rk_ext(RKI));
  
   //mds_bank m_mds_bank(
   // .clk(clk),
   // .A(MDS_addr),
   // .D(ram_MDS_i),
   // .WEN(WEN[1]),
   // .REN(REN[1]),
   // .EN(EN[1]),
   // .Q(ram_MDS_o));

  TS5N28HPCPHVTA32X32M2FWBSO m_mds_bank(
  .CLK(clk),
  .A(MDS_addr),
  .D(ram_MDS_i), // ReC_o is generated data from reg chain
  .CEB(~EN[1]),
  .WEB(~WEN[1]),
  .BWEB({32{1'b1}}),
  .Q(ram_MDS_o));

  mds_bus m_mds_bus(
    //.alg_mode(alg_mode),
    .ram_data(ram_MDS_o),
    .MDS(MDS));
    
  lut_bus_in m_lut_bus_in(
     .old_rd_addr({q1,q0}),
     .addr_gen(addr_gen),
     .alg_mode(alg_mode),
     .mode_wbc(mode_wbc),
     .new_rd_addr(WB_addr));
  
  //wb_bank m_wb_bank(
  //  .clk(clk),
  //  .A(WB_addr),
  //  .D(ReC_o), // ReC_o is generated data from reg chain
  //  .WEN(WEN[0]),
  //  .REN(REN[0]),
  //  .EN(EN[0]),
  //  .Q(LUT_o));
  
  TS1N28HPCPHVTB8192X128M4SWBASO m_wb_bank(
    .CLK(clk),
    .A(WB_addr),
    .D(ReC_o), // ReC_o is generated data from reg chain
    .CEB(~EN[0]),
    .WEB(~WEN[0]),
    .BWEB({128{1'b1}}),
    .Q(LUT_o));
    
  lut_bus_out m_lut_bus_out(
    .clk(clk),.rst_n(rst_n),
    .new_rd_addr_bs(q0[3:0]),
    .ram_data(LUT_o),
    .alg_mode(alg_mode),
    .reg_data_i1({LUT15_16,LUT14_16}),
    .reg_data_i0(LUT15_8));
  
  lut_gen m_lut_gen(
    .clk(clk),
    .rst_n(rst_n),
    .start_lut_gen(start_lut_gen),
    .alg_mode(alg_mode),
    .addr_gen(addr_gen),
    .done_gen(done_gen),
    .P_gen(P_gen));
    
  keccak_statepermute m_shake128 (
    .clk(clk),
    .rst_n(rst_n),
    .alg_mode(alg_mode),
    .mode(mode), // 1:init 0:squ
    .mode_enc_dec(mode_enc_dec),
    .d_i_vld(d_i_vld),
    .d_i(d_i),
    .load_rk(load_rk),
   // .mode_reg(mode_reg),
    .init_en(init_en),
    .d_o_vld(d_o_vld),
    .RK0(RK0),
    .RK1(RK1));
  
  //pad the key
  //assign d_i = {MK,4'b1111,1'b1,1210'b0,1'b1};  
  assign d_i = {256'b0,8'h80,56'b0,1088'b0,56'b0,8'h1F,MK};

endmodule