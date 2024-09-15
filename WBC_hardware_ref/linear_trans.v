`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/13 15:08:17
// Design Name: 
// Module Name: linear_trans
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

//update to remove reg chain
module linear_trans(
    input clk,rst_n,
    input [2:0] alg_mode,
    input [3:0] outer_round,
    //input CMI_src_x,CMI_src_y,
    //input start,
    input [1:0] ACC_src_y,
    input ACC_src_x,
    input ReF_en,
    input [63:0] MDS, //16*4-bit
    input sel_op,
    //conf_reg
    //input [15:0] EN_R,
    //input [47:0] sel,
    //input [127:0] P,
    input [127:0] ReC_0,
    input [127:0] ReC_1,
    input [127:0] P,
    input mode_enc_dec,
    input [2:0] mode_ref,
    output wire [127:0] ReF
    );
    
    wire [127:0] CMO;
    //wire [63:0] CMI_x = start == 1'b0 ? 64'd0 : MDS;//16*4-bit
    wire [63:0] CMI_x = MDS;//16*4-bit
    //wire [127:0] CMI_y = start == 1'b0 ? 128'd0 : ReC;//no need here
    wire [127:0] CMI_y = ReC_1;//no need here
    
    wire [127:0] ACCI_x = ACC_src_x == 1'b0 ? CMO : ReF;
    reg  [127:0] ACCI_y;
    wire [127:0] ACCO;
    wire [127:0] RDC;
    
    //add for seperate lt
    wire [127:0] LT_24_o;
    wire [127:0] LT_32_o;
    wire [127:0] lt_32_a;
    wire [127:0] lt_32_b;
    wire [127:0] LT_24_o_ReF;
    wire [127:0] LT_32_o_ReF;
    wire [127:0] LT_32_ReF;

    linear_trans_spn24_enc lt_24_enc(
    .a(ReC_0),
    .b(LT_24_o)
    );

    assign LT_24_o_ReF = LT_24_o ^ RDC;

    linear_trans_spn32 lt_32(
    .a(lt_32_a),
    .b(lt_32_b)
    );
   
    assign lt_32_a = (~mode_enc_dec)? ReC_0 : LT_32_o_ReF;
    assign LT_32_o = (~mode_enc_dec)? lt_32_b : ReC_0;

    assign LT_32_o_ReF = LT_32_o ^ RDC;
    assign LT_32_ReF = (~mode_enc_dec)? LT_32_o_ReF : lt_32_b;
 
    always@(*)
    begin
      case(ACC_src_y)
      2'b00: ACCI_y = 128'd0;
      2'b01: ACCI_y = ReF;
      2'b10: ACCI_y = RDC;
      default:ACCI_y = 128'd0;
      endcase
    end
    
    assign ACCO = ACCI_x ^ ACCI_y;
    
    (*DONT_TOUCH = "true"*)
    reg_file m_reg_file (
     .clk(clk),.rst_n(rst_n),
     .en_ReF(ReF_en),
     .mode_ref(mode_ref),
     .LT_24_o_ReF(LT_24_o_ReF),
     .LT_32_o_ReF(LT_32_ReF),
     .P(P),
     .ReC_0(ReC_0),
     .ReC_1(ReC_1),
     .d(ACCO),
     .ReF(ReF)
    ); 
    
    (*DONT_TOUCH = "true"*)
    rdc_gen m_rdc_gen(
      .outer_round(outer_round),
      .alg_mode(alg_mode),
      .RDC0(RDC[7:0]),.RDC1(RDC[15:8]),.RDC2(RDC[23:16]),.RDC3(RDC[31:24]), 
      .RDC4(RDC[39:32]),.RDC5(RDC[47:40]),.RDC6(RDC[55:48]),.RDC7(RDC[63:56]), 
      .RDC8(RDC[71:64]),.RDC9(RDC[79:72]),.RDC10(RDC[87:80]),.RDC11(RDC[95:88]), 
      .RDC12(RDC[103:96]),.RDC13(RDC[111:104]),.RDC14(RDC[119:112]),.RDC15(RDC[127:120])
       );
    
    (*DONT_TOUCH = "true"*)
    PE_MM_array_fold m_conf_mult_fold(
      .clk(clk),//for folding
      .rst_n(rst_n),//for folding
      .A(CMI_y),
      .sel_op(sel_op),//for folding
      .alg_mode(alg_mode),
      .B(CMI_x), //MDS 64-bit
      .C(CMO)
      );
endmodule

module reg_file # (
  parameter N = 128
  )(
   input clk,rst_n,
   input en_ReF,
   input [2:0] mode_ref, //0 receive d ; 1 recieve ReC ; 2 receive P
   input [N-1:0] LT_24_o_ReF,
   input [N-1:0] LT_32_o_ReF,
   input [N-1:0] ReC_0,
   input [N-1:0] ReC_1,
   input [N-1:0] d,
   input [N-1:0] P,
   output reg [N-1:0] ReF
    );
    
    wire [N-1:0] t1;
    reg  [N-1:0] t0;
    //assign t0 = mode_ref == 2'd0 ? d : 
                //mode_ref == 2'd1 ? ReC : P;
    always@(*) 
    begin
      case(mode_ref)
      3'b000:t0 = d;
      3'b001:t0 = ReC_1;
      3'b010:t0 = P;
      3'b011:t0 = LT_24_o_ReF;
      3'b100:t0 = LT_32_o_ReF;
      3'b101:t0 = ReC_0;
      default:t0 = 'b0;
      endcase
    end           
    
    assign t1 = en_ReF == 1'b0 ? ReF : t0;
    
    always@(posedge clk or negedge rst_n )
    begin
      if(!rst_n)
        ReF <= 'b0;
      else
        ReF <= t1;
    end
    
endmodule