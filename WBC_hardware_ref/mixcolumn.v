module xtime(
  input  [7:0] state_i,
  output wire [7:0] state_o
  );
  
  //wire [7:0] mux_i0 = {state_i[6:0],1'b0};
  //wire [7:0] mux_i1 = {mux_i0[7:5],~mux_i0[4],~mux_i0[3],mux_i0[2],~mux_i0[1],1'b1};
  
  //assign state_o = state_i[7] == 1'b0 ? mux_i0 : mux_i1;
  
  assign state_o[0] = state_i[7];
  assign state_o[1] = state_i[0] ^ state_i[7];
  assign state_o[2] = state_i[1];
  assign state_o[3] = state_i[2] ^ state_i[7];
  assign state_o[4] = state_i[3] ^ state_i[7];
  assign state_o[7:5] = state_i[6:4];

endmodule


module mixcolumn_32(
  input [31:0] state_i,
  input mode_enc_dec,
  output wire [31:0] state_o
  );
  
  wire [7:0] x0_o,x1_o,x2_o,x3_o;
  wire [31:0] state_o_tmp0;
  wire [7:0] t0,t1,t2,t3,t4,t5,t6,t7;
  wire [31:0] state_o_tmp1;
  
  wire [7:0] x3_i = state_i[31:24] ^ state_i[7:0]; //s0+s3
  wire [7:0] x2_i = state_i[31:24] ^ state_i[23:16]; //s2+s3
  wire [7:0] x1_i = state_i[23:16] ^ state_i[15:8]; //s1+s2
  wire [7:0] x0_i = state_i[15:8] ^ state_i[7:0]; //s0+s1
  
  wire [7:0] e0 = state_i[15:8] ^ x2_i; //s1+s2+s3
  wire [7:0] e1 = state_i[7:0] ^ x2_i; //s0+s2+s3
  wire [7:0] e2 = x0_i ^ state_i[31:24]; //s0+s1+s3
  wire [7:0] e3 = x0_i ^ state_i[23:16]; //s0+s1+s2
  
  xtime m0(
  .state_i(x0_i),
  .state_o(x0_o)
  );
  
  xtime m1(
  .state_i(x1_i),
  .state_o(x1_o)
  );
  
  xtime m2(
  .state_i(x2_i),
  .state_o(x2_o)
  );
  
  xtime m3(
  .state_i(x3_i),
  .state_o(x3_o)
  );
  
  assign state_o_tmp0[31:24] = x3_o ^ e3;
  assign state_o_tmp0[23:16] = x2_o ^ e2;
  assign state_o_tmp0[15:8] = x1_o ^ e1;
  assign state_o_tmp0[7:0] = x0_o ^ e0;
  
  //s0 * 5
  assign t0 = t4 ^ state_o_tmp0[7:0];
  
  //s2 * 4
  mult_4 m5(
    .b(state_o_tmp0[23:16]),
    .c(t1));
  assign state_o_tmp1[7:0] = t0 ^ t1;
  
  //s1 * 5
  assign t2 = t6 ^ state_o_tmp0[15:8];
  
  //s3 * 4
  mult_4 m7(
    .b(state_o_tmp0[31:24]),
    .c(t3));
  assign state_o_tmp1[15:8] = t2 ^ t3;
  
    //s0 * 4
  mult_4 m8(
    .b(state_o_tmp0[7:0]),
    .c(t4));
    
  //s2 * 5
  assign t5 = t1 ^ state_o_tmp0[23:16];
  assign state_o_tmp1[23:16] = t4 ^ t5;
  
  //s1 * 4
  mult_4 m10(
    .b(state_o_tmp0[15:8]),
    .c(t6));
  assign t7 = t3 ^   state_o_tmp0[31:24];
  assign state_o_tmp1[31:24] = t6 ^ t7;
  
  assign state_o = mode_enc_dec == 1'b0 ? state_o_tmp0 : state_o_tmp1;
endmodule

module mixcolumn_24_enc(
  input [23:0] state_i,
  output wire [23:0] state_o
  );
  
  wire [7:0] t0 = state_i[7:0] ^ state_i[15:8];//s0 + s1
  wire [7:0] t1 = state_i[15:8] ^ state_i[23:16];//s1+s2
  wire [7:0] t2 = state_i[7:0] ^ state_i[23:16];//s0 + s2
  
  wire [7:0] t3,t4,t5;
  
  xtime m0(
  .state_i(t0),
  .state_o(t3)
  );
  
  xtime m1(
  .state_i(t1),
  .state_o(t4)
  );
  
  xtime m2(
  .state_i(state_i[23:16]),
  .state_o(t5)
  );
  
  assign state_o[7:0] = t3 ^ t1;
  assign state_o[15:8] = t4 ^ t2;
  assign state_o[23:16] = t5 ^ t0;
endmodule

module mixcolumn_24_dec(
  input [23:0] state_i,
  output wire [23:0] state_o
  );
  
  wire [7:0] t0,t1,t2,t3,t4,t5,t6;
  
  assign t0 = state_i[7:0] ^ state_i[15:8] ^ state_i[23:16];
  mult_8d m0(
   .b(t0),
   .c(state_o[7:0])
    );
    
  mult_68 m1(
   .b(state_i[7:0]),
   .c(t1)
    );
 mult_d1 m2(
   .b(state_i[15:8]),
   .c(t2)
    );
 
 assign state_o[15:8] = state_o[7:0] ^ t1 ^ t2;
 
 mult_68 m3(
   .b(state_i[15:8]),
   .c(t3)
    );
 mult_d1 m4(
   .b(state_i[7:0]),
   .c(t4)
    );
 
 assign t5 = t1 ^ t3;
 assign state_o[23:16] = t5 ^ t4 ^ state_o[7:0];
endmodule

module mixcolumn_24(
  input [23:0] state_i,
  input mode_enc_dec,
  output wire [23:0] state_o
  );
  
  wire [23:0] t0,t1;
  
  mixcolumn_24_enc m0(
  .state_i(state_i),
  .state_o(t0)
  );
  
  mixcolumn_24_dec m1(
  .state_i(state_i),
  .state_o(t1)
  );
  
  assign state_o = mode_enc_dec == 1'b0 ? t0 : t1;
endmodule

module mixcolumn_16(
  input [15:0] state_i,
  input mode_enc_dec,//0: enc & 1:dec
  output wire [15:0] state_o
  );
  
  wire [15:0] state_o_tmp0;
  wire [15:0] state_o_tmp1;
  
  wire [7:0] x0_i = state_i[15:8] ^ state_i[7:0];
  
  wire [7:0] x0_o,x1_o;
  
  xtime m0(
  .state_i(x0_i),
  .state_o(x0_o)
  );
  
  xtime m1(
  .state_i(state_i[15:8]),
  .state_o(x1_o)
  );
  
  assign state_o_tmp0[15:8] = x1_o ^ state_i[7:0];
  assign state_o_tmp0[7:0] = x0_o ^ state_i[15:8];
  
  mult_d1 m2(
    .b(state_o_tmp0[7:0]),
    .c(state_o_tmp1[7:0]));
 
  mult_d1 m3(
    .b(state_o_tmp0[15:8]),
    .c(state_o_tmp1[15:8]));
    
  assign state_o = mode_enc_dec == 1'b0 ? state_o_tmp0 : state_o_tmp1;
endmodule


module mixcolumn_spn16(
  input [127:0] state_i,
  input mode_enc_dec,
  output wire [127:0] state_o
  );

  mixcolumn_16 n0(
  .mode_enc_dec(mode_enc_dec),
  .state_i(state_i[15:0]),
  .state_o(state_o[15:0])
  );
  
  mixcolumn_16 n1(
  .mode_enc_dec(mode_enc_dec),
  .state_i(state_i[31:16]),
  .state_o(state_o[31:16])
  );
  
  mixcolumn_16 n2(
  .mode_enc_dec(mode_enc_dec),
  .state_i(state_i[47:32]),
  .state_o(state_o[47:32])
  );
  
  mixcolumn_16 n3(
  .mode_enc_dec(mode_enc_dec),
  .state_i(state_i[63:48]),
  .state_o(state_o[63:48])
  );
  
  mixcolumn_16 n4(
  .mode_enc_dec(mode_enc_dec),
  .state_i(state_i[79:64]),
  .state_o(state_o[79:64])
  );
  
  mixcolumn_16 n5(
  .mode_enc_dec(mode_enc_dec),
  .state_i(state_i[95:80]),
  .state_o(state_o[95:80])
  );
  
  mixcolumn_16 n6(
  .mode_enc_dec(mode_enc_dec),
  .state_i(state_i[111:96]),
  .state_o(state_o[111:96])
  );
  
  mixcolumn_16 n7(
  .mode_enc_dec(mode_enc_dec),
  .state_i(state_i[127:112]),
  .state_o(state_o[127:112])
  );
 
endmodule

module mixcolumn_spn32(
  input [127:0] state_i,
  input mode_enc_dec,
  output wire [127:0] state_o
  );
  
  mixcolumn_32 m0(
  .mode_enc_dec(mode_enc_dec),
  .state_i(state_i[31:0]),
  .state_o(state_o[31:0])
  );
  
  mixcolumn_32 m1(
  .mode_enc_dec(mode_enc_dec),
  .state_i(state_i[63:32]),
  .state_o(state_o[63:32])
  );
  
  mixcolumn_32 m2(
  .mode_enc_dec(mode_enc_dec),
  .state_i(state_i[95:64]),
  .state_o(state_o[95:64])
  );
  
  mixcolumn_32 m3(
  .mode_enc_dec(mode_enc_dec),
  .state_i(state_i[127:96]),
  .state_o(state_o[127:96])
  );
  
endmodule

module mixcolumn_spn24(
  input [127:0] state_i,
  input mode_enc_dec,
  output wire [127:0] state_o
  );
  
  assign state_o[127:120] = state_i[127:120];
  
  mixcolumn_24 m0(
  .state_i(state_i[23:0]),
  .mode_enc_dec(mode_enc_dec),
  .state_o(state_o[23:0])
  );
  
  mixcolumn_24 m1(
  .state_i(state_i[47:24]),
  .mode_enc_dec(mode_enc_dec),
  .state_o(state_o[47:24])
  );
  
  mixcolumn_24 m2(
  .state_i(state_i[71:48]),
  .mode_enc_dec(mode_enc_dec),
  .state_o(state_o[71:48])
  );
  
  mixcolumn_24 m3(
  .state_i(state_i[95:72]),
  .mode_enc_dec(mode_enc_dec),
  .state_o(state_o[95:72])
  );
  
  mixcolumn_24 m4(
  .state_i(state_i[119:96]),
  .mode_enc_dec(mode_enc_dec),
  .state_o(state_o[119:96])
  );
endmodule
