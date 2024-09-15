module keccak_statepermute
(
    input               clk       ,
    input               rst_n     ,
    input     [   2:0]  alg_mode  ,
    input               mode      , // 1:init 0:squ
    input               mode_enc_dec,
    input               d_i_vld   ,
    input     [1599:0]  d_i       ,
    input               load_rk   ,
    input               init_en   ,
    output        reg   d_o_vld   ,
    output    [  15:0]  RK0       ,
    output    [  31:0]  RK1
);

    wire      [  23:0]   f_cnt      ;
    reg       [  23:0]   f_cnt_r    ;
    wire                 f_func_run ;

    reg       [ 543:0]   key_init   ;
    wire      [ 543:0]   data_k     ;
    reg       [ 543:0]   data_k_sft ;

    reg       [1599:0]   s_i        ;
    wire      [1599:0]   s          ;
    reg       [1599:0]   s_r        ;
    wire      [  63:0]   rc_0       ;

    assign f_cnt =  (!rst_n)? 24'd0 : 
                   (d_i_vld)? 24'd1 : (f_cnt_r << 1);

    assign f_func_run = (f_cnt != 24'd0)? 1'b1 : 1'b0;

    always @(posedge clk or negedge rst_n) begin
      if(!rst_n)
          f_cnt_r  <= 24'd0;
      else
          f_cnt_r  <= f_cnt;
    end

    always @(posedge clk or negedge rst_n) begin
      if(!rst_n)
          d_o_vld <= 1'b0;
      else if(~mode_enc_dec&f_cnt[23])
          d_o_vld <= 1'b1;
      else if(mode_enc_dec&f_cnt_r[23])
          d_o_vld <= 1'b1;
    end

    always @(*) begin
      if(d_i_vld & mode)
         s_i = d_i;
      else
         s_i = s_r;
    end

    always @(posedge clk) if(f_func_run) s_r <= s;

    always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
          key_init <= 544'b0;
      end
      else if(f_cnt[23]) begin
           case(alg_mode)
           3'b000:   key_init <= {24'b0,s[519:0]}  ;         //spnbox8
           3'b001:   key_init <= {16'b0,s[527:0]}  ;         //spnbox16
           3'b010:   key_init <=  s[543:0]         ;         //spnbox32
           3'b011:   key_init <= {144'b0,s[399:0]} ;         //warx
           3'b100:   key_init <= {40'b0,s[503:0]}  ;         //spnbox24
           default:  key_init <=  s[543:0]         ;
           endcase
      end
    end

    assign data_k = (init_en)? key_init : data_k_sft;

    always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
          data_k_sft <= 544'b0;
      end
      else if(~mode_enc_dec)begin
        case(alg_mode)
        3'b000:  data_k_sft <= {24'b0,data_k[7:0],data_k[519:8]};
        3'b001:  data_k_sft <= {16'b0,data_k[15:0],data_k[527:16]};
        3'b010:  data_k_sft <= {data_k[31:0],data_k[543:32]};
        3'b011:  data_k_sft <= {144'b0,data_k[15:0],data_k[399:16]};
        3'b100:  data_k_sft <= {40'b0,data_k[23:0],data_k[503:24]};
        default: data_k_sft <= {data_k[31:0],data_k[543:32]};
        endcase
      end
      else begin
        case(alg_mode)
        3'b000:  data_k_sft <= {24'b0,data_k[511:0],data_k[519:512]};
        3'b001:  data_k_sft <= {16'b0,data_k[511:0],data_k[527:512]};
        3'b010:  data_k_sft <= {data_k[511:0],data_k[543:512]};
        3'b011:  data_k_sft <= {144'b0,data_k[383:0],data_k[399:384]};
        3'b100:  data_k_sft <= {40'b0,data_k[479:0],data_k[503:480]};
        default: data_k_sft <= {data_k[511:0],data_k[543:512]};
        endcase
      end
    end

    assign RK0 = data_k[15:0];
    assign RK1 = data_k[31:0];

    rconst u_rconst_0 (.i(f_cnt<<0),.rc(rc_0)); 
    round  u_round_0  (.in(s_i),.rconst(rc_0),.out(s));

endmodule

module rconst
(
    input     [  23:0]  i         ,
    output    [  63:0]  rc
);

    assign rc[00] = |{i[22],i[20],i[15:12],i[10],i[7:4],i[0]};
    assign rc[01] = |{i[19:18],i[16:15],i[13:11],i[8],i[4],i[2:1]};
    assign rc[03] = |{i[23],i[19:18],i[14:7],i[4],i[2]};
    assign rc[07] = |{i[21:20],i[17],i[14:12],i[9:8],i[6],i[4],i[2:1]};
    assign rc[15] = |{i[23],i[21:20],i[18],i[16:14],i[12],i[10],i[7:6],i[4:1]};
    assign rc[31] = |{i[23:22],i[20:19],i[12:10],i[6:5],i[3]};
    assign rc[63] = |{i[23],i[21:19],i[17:13],i[7:6],i[3:2]};

    assign {rc[62:32],rc[30:16],rc[14:8],rc[6:4],rc[2]} = 57'd0;

endmodule

module round
(
    input     [1599:0]  in        ,
    input     [  63:0]  rconst    ,
    output    [1599:0]  out
);

    wire [63:0] A [0:4];
    wire [63:0] B [0:4];

    wire [63:0] C [0:24];
    wire [63:0] D [0:24];

    wire [63:0] Si [0:24];
    wire [63:0] So [0:24];

    genvar i;

    generate
    for(i=0;i<25;i=i+1) begin:L0
        assign Si[i] = in[64*i+:64];
        assign out[64*i+:64] = So[i];
    end
    endgenerate
    
    //Theta 1
    assign A[0] = Si[00] ^ Si[05] ^ Si[10] ^ Si[15] ^ Si[20];
    assign A[1] = Si[01] ^ Si[06] ^ Si[11] ^ Si[16] ^ Si[21];
    assign A[2] = Si[02] ^ Si[07] ^ Si[12] ^ Si[17] ^ Si[22];
    assign A[3] = Si[03] ^ Si[08] ^ Si[13] ^ Si[18] ^ Si[23];
    assign A[4] = Si[04] ^ Si[09] ^ Si[14] ^ Si[19] ^ Si[24];

    //Theta 2
    assign B[0] = A[4] ^ {A[1][62:0],A[1][63]};
    assign B[1] = A[0] ^ {A[2][62:0],A[2][63]};
    assign B[2] = A[1] ^ {A[3][62:0],A[3][63]};
    assign B[3] = A[2] ^ {A[4][62:0],A[4][63]};
    assign B[4] = A[3] ^ {A[0][62:0],A[0][63]};

    //Theta 3
    assign C[00] = B[0] ^ Si[00];
    assign C[01] = B[1] ^ Si[06];
    assign C[02] = B[2] ^ Si[12];
    assign C[03] = B[3] ^ Si[18];
    assign C[04] = B[4] ^ Si[24];
    assign C[05] = B[3] ^ Si[03];
    assign C[06] = B[4] ^ Si[09];
    assign C[07] = B[0] ^ Si[10];
    assign C[08] = B[1] ^ Si[16];
    assign C[09] = B[2] ^ Si[22];
    assign C[10] = B[1] ^ Si[01];
    assign C[11] = B[2] ^ Si[07];
    assign C[12] = B[3] ^ Si[13];
    assign C[13] = B[4] ^ Si[19];
    assign C[14] = B[0] ^ Si[20];
    assign C[15] = B[4] ^ Si[04];
    assign C[16] = B[0] ^ Si[05];
    assign C[17] = B[1] ^ Si[11];
    assign C[18] = B[2] ^ Si[17];
    assign C[19] = B[3] ^ Si[23];
    assign C[20] = B[2] ^ Si[02];
    assign C[21] = B[3] ^ Si[08];
    assign C[22] = B[4] ^ Si[14];
    assign C[23] = B[0] ^ Si[15];
    assign C[24] = B[1] ^ Si[21];

    //Rho & Pi
    assign D[00] = {            C[00][63:00]};
    assign D[01] = {C[01][19:0],C[01][63:20]};
    assign D[02] = {C[02][20:0],C[02][63:21]};
    assign D[03] = {C[03][42:0],C[03][63:43]};
    assign D[04] = {C[04][49:0],C[04][63:50]};
    assign D[05] = {C[05][35:0],C[05][63:36]};
    assign D[06] = {C[06][43:0],C[06][63:44]};
    assign D[07] = {C[07][60:0],C[07][63:61]};
    assign D[08] = {C[08][18:0],C[08][63:19]};
    assign D[09] = {C[09][02:0],C[09][63:03]};
    assign D[10] = {C[10][62:0],C[10][63:63]};
    assign D[11] = {C[11][57:0],C[11][63:58]};
    assign D[12] = {C[12][38:0],C[12][63:39]};
    assign D[13] = {C[13][55:0],C[13][63:56]};
    assign D[14] = {C[14][45:0],C[14][63:46]};
    assign D[15] = {C[15][36:0],C[15][63:37]};
    assign D[16] = {C[16][27:0],C[16][63:28]};
    assign D[17] = {C[17][53:0],C[17][63:54]};
    assign D[18] = {C[18][48:0],C[18][63:49]};
    assign D[19] = {C[19][07:0],C[19][63:08]};
    assign D[20] = {C[20][01:0],C[20][63:02]};
    assign D[21] = {C[21][08:0],C[21][63:09]};
    assign D[22] = {C[22][24:0],C[22][63:25]};
    assign D[23] = {C[23][22:0],C[23][63:23]};
    assign D[24] = {C[24][61:0],C[24][63:62]};

    //chi & Iota
    assign So[00] = D[00] ^ ((~D[01]) & D[02]) ^ rconst;
    assign So[01] = D[01] ^ ((~D[02]) & D[03]);
    assign So[02] = D[02] ^ ((~D[03]) & D[04]);
    assign So[03] = D[03] ^ ((~D[04]) & D[00]);
    assign So[04] = D[04] ^ ((~D[00]) & D[01]);
    assign So[05] = D[05] ^ ((~D[06]) & D[07]);
    assign So[06] = D[06] ^ ((~D[07]) & D[08]);
    assign So[07] = D[07] ^ ((~D[08]) & D[09]);
    assign So[08] = D[08] ^ ((~D[09]) & D[05]);
    assign So[09] = D[09] ^ ((~D[05]) & D[06]);
    assign So[10] = D[10] ^ ((~D[11]) & D[12]);
    assign So[11] = D[11] ^ ((~D[12]) & D[13]);
    assign So[12] = D[12] ^ ((~D[13]) & D[14]);
    assign So[13] = D[13] ^ ((~D[14]) & D[10]);
    assign So[14] = D[14] ^ ((~D[10]) & D[11]);
    assign So[15] = D[15] ^ ((~D[16]) & D[17]);
    assign So[16] = D[16] ^ ((~D[17]) & D[18]);
    assign So[17] = D[17] ^ ((~D[18]) & D[19]);
    assign So[18] = D[18] ^ ((~D[19]) & D[15]);
    assign So[19] = D[19] ^ ((~D[15]) & D[16]);
    assign So[20] = D[20] ^ ((~D[21]) & D[22]);
    assign So[21] = D[21] ^ ((~D[22]) & D[23]);
    assign So[22] = D[22] ^ ((~D[23]) & D[24]);
    assign So[23] = D[23] ^ ((~D[24]) & D[20]);
    assign So[24] = D[24] ^ ((~D[20]) & D[21]);

endmodule