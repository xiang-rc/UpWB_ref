module mSPECKEY(
  input             mode    ,
  input    [127:0]  state_i ,
  output   [127:0]  state_o
);

  wire     [127:0]  state_enc_o;
  wire     [127:0]  state_dec_o;

  mSPECKEY_enc_warx u_mSPECKEY_enc_warx(.state_i(state_i),.state_o(state_enc_o));
  mSPECKEY_dec_warx u_mSPECKEY_dec_warx(.state_i(state_i),.state_o(state_dec_o));
    
  assign  state_o = (~mode)? state_enc_o : state_dec_o;

endmodule