module none_linear_trans
#(
    parameter   n         =   8        ,
    parameter   N         =   128      ,
    parameter   ALG_MODE  =   2
)
(
    input               clk          ,
    input               rst_n        ,
    input     [ N-1:0]  RKI          ,
    input     [ N-1:0]  ReC          ,
    input               mode_enc_dec ,
    input     [   2:0]  alg_mode     , //ctrl
    output    [ N-1:0]  RKO          ,
    output    [ N-1:0]  NTO
);
  
    wire      [ N-1:0]  rkx0_i       ;
    wire      [ N-1:0]  rky0_i       ;
    wire      [ N-1:0]  rk0_o        ;
    wire      [ N-1:0]  sbox_i       ;
    wire      [ N-1:0]  sbox_o       ;
    wire      [ N-1:0]  mspk_i       ;
    wire      [ N-1:0]  mspk_o       ;
    wire      [ N-1:0]  mc_i         ;
    wire      [ N-1:0]  mc_o         ;
    wire      [ N-1:0]  NTO_tmp      ;
    wire      [ N-1:0]  rkx_i        ;
    wire      [ N-1:0]  rky_i        ;
    wire      [ N-1:0]  rk_o         ;

    assign rkx0_i = RKI;
    assign rky0_i = ReC;

    add_round_key m0 (.RKI_x(rkx0_i[127:0]),.RKI_y(rky0_i[127:0]),.RKO(rk0_o[127:0]));

    assign sbox_i = (~mode_enc_dec)?      ReC   :
                    (alg_mode == 3'b000)? rk0_o : mc_o;

    s_box_16 m1 (.mode(mode_enc_dec),.RKO(sbox_i[127:0]),.SBO(sbox_o[127:0]));

    assign mspk_i = (~mode_enc_dec)? ReC : rk0_o;

    mSPECKEY m2 (.mode(mode_enc_dec),.state_i(mspk_i[127:0]),.state_o(mspk_o[127:0]));
 
    assign mc_i = (~mode_enc_dec)? sbox_o : rk0_o;
    
    generate
        case(ALG_MODE)
        1:  mixcolumn_spn16 m3_spn16(.mode_enc_dec(mode_enc_dec),.state_i(mc_i),.state_o(mc_o));
        4:  mixcolumn_spn24 m3_spn24(.mode_enc_dec(mode_enc_dec),.state_i(mc_i),.state_o(mc_o));
        2:  mixcolumn_spn32 m3_spn32(.mode_enc_dec(mode_enc_dec),.state_i(mc_i),.state_o(mc_o));
        default: mixcolumn_spn16 m3_spn16(.mode_enc_dec(mode_enc_dec),.state_i(mc_i),.state_o(mc_o));
        endcase
    endgenerate

    assign NTO_tmp = (alg_mode == 3'b0) ? sbox_o : 
                     (alg_mode == 3'b011) ? mspk_o : mc_o;
 
    assign rkx_i = RKI;
    assign rky_i = (~mode_enc_dec)? NTO_tmp : sbox_o;

    add_round_key m4 (.RKI_x(rkx_i[127:0]),.RKI_y(rky_i[127:0]),.RKO(rk_o[127:0]));

    assign RKO = rk0_o;

    assign NTO = (~mode_enc_dec)?    rk_o   : 
                 (alg_mode == 3'b011)? mspk_o : sbox_o;

endmodule