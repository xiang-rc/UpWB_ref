//fully pipelined without folding
//width is 16-bit in the i&k direction
//2022-8-13
//remove the pipeline regs
//2022-8-28
//8-bit output is not registered
module PE_MM # (
  parameter n = 8
  )(
  input [n-1:0] A,
  input B,
  input [n-1:0] C_pre,
  input c0_u,
  input [n-1:0] F,
  input R4_M, //add for irregular width
  input Cm_nxt,
  input [1:0] sel0,
  input sel1,
  output wire Cm, 
  output wire c0_broad,
  output wire [n-1:0] C
  );
  
  wire [n-1:0] R1;
  wire [n-1:0] R3;
  //assign R1 = B == 1'b0 ? 'b0 : A;
  assign R1 = {8{B}} & A; 
  wire [n-1:0] R2 = R1 ^ C_pre;
  //wire [n-1:0] R2 = C_pre;

  wire c0 = sel1 == 1'b0 ? c0_u : R2[0]; //R2[0] is c0_self
  assign c0_broad = c0;
  //wire [n-1:0] R3 = c0 == 1'b0 ? 'b0 : F;
  assign R3 = {8{c0}} & F; 
  
  wire [n-1:0] R4 = R3 ^ R2;
  assign Cm = R4[0];
  wire C_mux = sel0 == 2'b00 ? R2[0] : 
               sel0 == 2'b01 ? Cm_nxt : c0_u;
               
  assign C = R4_M == 1'b1 ? {C_mux,R4[n-1:1]} : {4'b0,{C_mux,R4[3:1]}};
//assign C = {(8-W)'b0, {C_mux,R4[W-1:1]}}; //W = 1-8;
endmodule

//module PE_MM_lut();

//endmodule

module PE_MM_row # (
  parameter n = 8,
  parameter col = 4 //fold is n otherwise 2*n
  )(
  input clk,rst_n,
  input [2:0] alg_mode,
  input sel_op,
  input [n-1:0] A_row, F_row,
  input [3:0] B_row,
  input [col-1:0] c0_u,
  input [n-1:0] C_pre_row, //������������
  input [col-1:0] Cm_nxt_row, //��������PE������������������
  input [1:0] sel0_row,
  input sel1_row,
  input R4_M, //add for irregular width
  output wire [col-1:0] Cm_row,  //������PE������������������
  output wire [col-1:0] c0_broad, //������������
  output wire [n-1:0] C_aft_row //������������
  );
  
  wire [n-1:0] C_aft_row_0,C_aft_row_1,C_aft_row_2,C_aft_row_3;
  //wire [n-1:0] C_aft_row_4,C_aft_row_5,C_aft_row_6,C_aft_row_7;
  //wire [n-1:0] C_aft_row_8,C_aft_row_9,C_aft_row_10,C_aft_row_11;
  //wire [n-1:0] C_aft_row_12,C_aft_row_13,C_aft_row_14,C_aft_row_15;

  //wire [n-1:0] C_aft_row_7_q,C_aft_row_15_q;
  //wire [n-1:0] A_row_q;
  //wire [15:8]  B_row_q;
  //wire [n-1:0] C_aft_row_7_q;
  wire [n-1:0] C_aft_row_3_q;
  wire [n-1:0] C_pre_row_tmp = sel_op == 1'b0 ? C_pre_row : C_aft_row_3_q;
  
  PE_MM m0 (.A(A_row),.B(B_row[0]),.F(F_row),.R4_M(R4_M),.C_pre(C_pre_row_tmp),.c0_u(c0_u[0]),.Cm_nxt(Cm_nxt_row[0]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[0]),.Cm(Cm_row[0]),.C(C_aft_row_0));
  
  PE_MM m1 (.A(A_row),.B(B_row[1]),.F(F_row),.R4_M(R4_M),.C_pre(C_aft_row_0),.c0_u(c0_u[1]),.Cm_nxt(Cm_nxt_row[1]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[1]),.Cm(Cm_row[1]),.C(C_aft_row_1));
			
  PE_MM m2 (.A(A_row),.B(B_row[2]),.F(F_row),.R4_M(R4_M),.C_pre(C_aft_row_1),.c0_u(c0_u[2]),.Cm_nxt(Cm_nxt_row[2]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[2]),.Cm(Cm_row[2]),.C(C_aft_row_2));
			
  PE_MM m3 (.A(A_row),.B(B_row[3]),.F(F_row),.R4_M(R4_M),.C_pre(C_aft_row_2),.c0_u(c0_u[3]),.Cm_nxt(Cm_nxt_row[3]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[3]),.Cm(Cm_row[3]),.C(C_aft_row_3));
  
  DFF dcc(.clk(clk),.rst_n(rst_n),.d(C_aft_row_3),.q(C_aft_row_3_q));
                                                    
                                                    //add ff
  /*PE_MM m4 (.A(A_row),.B(B_row[4]),.F(F_row),.C_pre(C_aft_row_3_q),.c0_u(c0_u[4]),.Cm_nxt(Cm_nxt_row[4]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[4]),.Cm(Cm_row[4]),.C(C_aft_row_4));
  
  PE_MM m5 (.A(A_row),.B(B_row[5]),.F(F_row),.C_pre(C_aft_row_4),.c0_u(c0_u[5]),.Cm_nxt(Cm_nxt_row[5]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[5]),.Cm(Cm_row[5]),.C(C_aft_row_5));
			
  PE_MM m6 (.A(A_row),.B(B_row[6]),.F(F_row),.C_pre(C_aft_row_5),.c0_u(c0_u[6]),.Cm_nxt(Cm_nxt_row[6]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[6]),.Cm(Cm_row[6]),.C(C_aft_row_6));
			
  PE_MM m7 (.A(A_row),.B(B_row[7]),.F(F_row),.C_pre(C_aft_row_6),.c0_u(c0_u[7]),.Cm_nxt(Cm_nxt_row[7]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[7]),.Cm(Cm_row[7]),.C(C_aft_row_7));
  
  DFF dc(.clk(clk),.rst_n(rst_n),.d(C_aft_row_7),.q(C_aft_row_7_q));
  //DFF da(.clk(clk),.rst_n(rst_n),.d(A_row),.q(A_row_q));
  //DFF db(.clk(clk),.rst_n(rst_n),.d(B_row[15:8]),.q(B_row_q));

  PE_MM m8 (.A(A_row),.B(B_row[8]),.F(F_row),.C_pre(C_aft_row_7),.c0_u(c0_u[8]),.Cm_nxt(Cm_nxt_row[8]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[8]),.Cm(Cm_row[8]),.C(C_aft_row_8));
  PE_MM m9 (.A(A_row),.B(B_row[9]),.F(F_row),.C_pre(C_aft_row_8),.c0_u(c0_u[9]),.Cm_nxt(Cm_nxt_row[9]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[9]),.Cm(Cm_row[9]),.C(C_aft_row_9));
  PE_MM m10 (.A(A_row),.B(B_row[10]),.F(F_row),.C_pre(C_aft_row_9),.c0_u(c0_u[10]),.Cm_nxt(Cm_nxt_row[10]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[10]),.Cm(Cm_row[10]),.C(C_aft_row_10));
  PE_MM m11 (.A(A_row),.B(B_row[11]),.F(F_row),.C_pre(C_aft_row_10),.c0_u(c0_u[11]),.Cm_nxt(Cm_nxt_row[11]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[11]),.Cm(Cm_row[11]),.C(C_aft_row_11));
  PE_MM m12 (.A(A_row),.B(B_row[12]),.F(F_row),.C_pre(C_aft_row_11),.c0_u(c0_u[12]),.Cm_nxt(Cm_nxt_row[12]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[12]),.Cm(Cm_row[12]),.C(C_aft_row_12));
  PE_MM m13 (.A(A_row),.B(B_row[13]),.F(F_row),.C_pre(C_aft_row_12),.c0_u(c0_u[13]),.Cm_nxt(Cm_nxt_row[13]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[13]),.Cm(Cm_row[13]),.C(C_aft_row_13));
  PE_MM m14 (.A(A_row),.B(B_row[14]),.F(F_row),.C_pre(C_aft_row_13),.c0_u(c0_u[14]),.Cm_nxt(Cm_nxt_row[14]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[14]),.Cm(Cm_row[14]),.C(C_aft_row_14));
  PE_MM m15 (.A(A_row),.B(B_row[15]),.F(F_row),.C_pre(C_aft_row_14),.c0_u(c0_u[15]),.Cm_nxt(Cm_nxt_row[15]),
            .sel0(sel0_row),.sel1(sel1_row),.c0_broad(c0_broad[15]),.Cm(Cm_row[15]),.C(C_aft_row_15));*/
            
  //DFF dcc(.clk(clk),.rst_n(rst_n),.d(C_aft_row_15),.q(C_aft_row_15_q));
  //assign C_aft_row = alg_mode == 3'd0 ? C_aft_row_7 : C_aft_row_15;
  assign C_aft_row = C_aft_row_3_q; //with FF
endmodule


module PE_MM_array_fold # (
  parameter N = 128,
  parameter n = 8,
  parameter row = 16
  )(
  input clk,rst_n,
  input [N-1:0] A,
  input sel_op,
  input [2:0] alg_mode,
  //input [N-1:0] B, //������B���������������� folding also halves the width of B
  input [63:0] B,
  output wire [N-1:0] C
  );
  //spnbox-8 f(x) = x^8 + x^4 + x^3 + x + 1; f8 = 0001_1011 = 27
  //spnbox-16 & warx f(x) = x^16 + x^5 + x^3 + x + 1; f16 = 0000_0000_0010_1011 = 43
  //spnbox-24 f(x) = x^24 + x^4 + x^3 + x + 1; f24 = 0000_0000_0000_0000_0001_1011 = 27
  //spnbox-32 f(x) = x^32 + x^7 + x^3 + x^2 + 1; f32 = 0000_0000_0000_0000_0000_0000_1000_1101 = 141
  //yoroi-16/32 f(x) = x^4 + x + 1; f4 = 0011 = 3;
  
  localparam f4 = 8'b0000_0011;
  localparam f8 = 8'b0001_1011;
  localparam f16 = 8'b0010_1011;
  localparam f24 = 8'b0001_1011;
  localparam f32 = 8'b1000_1101;
  
  //wire [63:0] B_q;
  //DFF #(.data_width('d64)) cnt_reg(.clk(clk),.rst_n(rst_n),.d(B),.q(B_q));
  
  reg [N-1:0] F;
  reg [row-1:0]   sel1;
  reg [2*row-1:0] sel0;
  reg [15:0] RM;
  
  //decode alg_mode for 128-bit F, 32-bit sel0, 16-bit sel1;
  always@(*)
  begin
    case(alg_mode)
    3'b000: begin F = {16{f8}}; sel0 = {16{2'b00}}; sel1 = {16{1'b1}}; RM = {16{1'b1}}; end //spn8
    3'b001: begin F = {8{8'b0,f16}}; sel0 = {8{4'b1001}}; sel1 = {8{2'b01}}; RM = {16{1'b1}}; end //spn16
    3'b010: begin F = {4{24'b0,f32}}; sel0 = {4{8'b10010101}}; sel1 = {4{4'b0001}}; RM = {16{1'b1}}; end //spn32
    3'b011: begin F = {8{8'b0,f16}}; sel0 = {8{4'b1001}}; sel1 = {8{2'b01}}; RM = {16{1'b1}}; end //warx
    3'b100: begin F = {8'b0,{5{16'b0,f24}}}; sel0 = {2'b00,{5{6'b100101}}}; sel1 = {1'b0,{5{3'b001}}}; RM = {16{1'b1}}; end //spn24_dec
    3'b101: begin F = {8{8'b0,f4}}; sel0 = {16{2'b00}}; sel1 = {16{1'b1}}; RM = {16{1'b0}}; end //yoroi16
    3'b110: begin F = {4{24'b0,f4}}; sel0 = {16{2'b00}}; sel1 = {16{1'b1}}; RM = {16{1'b0}}; end //yoroi32
    default: begin F = 128'b0; sel0 = 32'b0; sel1 = 16'b0; RM = 16'b0; end
    endcase
  end
  
  wire [n/2-1:0] c0_broad_row0,c0_broad_row1,c0_broad_row2, c0_broad_row3, c0_broad_row4, c0_broad_row5, c0_broad_row6, c0_broad_row7;
  wire [n/2-1:0] c0_broad_row8,c0_broad_row9,c0_broad_row10,c0_broad_row11,c0_broad_row12,c0_broad_row13,c0_broad_row14,c0_broad_row15;

  wire [n/2-1:0] Cm_row0,Cm_row1,Cm_row2, Cm_row3, Cm_row4, Cm_row5, Cm_row6, Cm_row7;
  wire [n/2-1:0] Cm_row8,Cm_row9,Cm_row10,Cm_row11,Cm_row12,Cm_row13,Cm_row14,Cm_row15;		

  //����������generate������
  PE_MM_row r0 (.alg_mode(alg_mode),.A_row(A[7:0]),.B_row(B[3:0]),.F_row(F[7:0]),.c0_u(4'b0),.C_pre_row(8'b0),
                .Cm_nxt_row(Cm_row1),.sel0_row(sel0[1:0]), .sel1_row(sel1[0]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n), 
                .Cm_row(Cm_row0), .c0_broad(c0_broad_row0), .R4_M(RM[0]), .C_aft_row(C[7:0]));

  PE_MM_row r1 (.alg_mode(alg_mode),.A_row(A[15:8]),.B_row(B[7:4]),.F_row(F[15:8]),.c0_u(c0_broad_row0),.C_pre_row(8'b0),
                .Cm_nxt_row(Cm_row2),.sel0_row(sel0[3:2]), .sel1_row(sel1[1]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n), 
                .Cm_row(Cm_row1), .c0_broad(c0_broad_row1), .R4_M(RM[1]), .C_aft_row(C[15:8]));

  PE_MM_row r2 (.alg_mode(alg_mode),.A_row(A[23:16]),.B_row(B[11:8]),.F_row(F[23:16]),.c0_u(c0_broad_row1),.C_pre_row(8'b0),
                .Cm_nxt_row(Cm_row3),.sel0_row(sel0[5:4]), .sel1_row(sel1[2]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n), 
                .Cm_row(Cm_row2), .c0_broad(c0_broad_row2), .R4_M(RM[2]), .C_aft_row(C[23:16]));

  PE_MM_row r3 (.alg_mode(alg_mode),.A_row(A[31:24]),.B_row(B[15:12]),.F_row(F[31:24]),.c0_u(c0_broad_row2),.C_pre_row(8'b0),
                .Cm_nxt_row(Cm_row4),.sel0_row(sel0[7:6]), .sel1_row(sel1[3]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n),  
                .Cm_row(Cm_row3), .c0_broad(c0_broad_row3), .R4_M(RM[3]), .C_aft_row(C[31:24]));

  PE_MM_row r4 (.alg_mode(alg_mode),.A_row(A[39:32]),.B_row(B[19:16]),.F_row(F[39:32]),.c0_u(c0_broad_row3),.C_pre_row(8'b0),
                .Cm_nxt_row(Cm_row5),.sel0_row(sel0[9:8]), .sel1_row(sel1[4]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n), 
                .Cm_row(Cm_row4), .c0_broad(c0_broad_row4), .R4_M(RM[4]), .C_aft_row(C[39:32]));

  PE_MM_row r5 (.alg_mode(alg_mode),.A_row(A[47:40]),.B_row(B[23:20]),.F_row(F[47:40]),.c0_u(c0_broad_row4),.C_pre_row(8'b0),
                .Cm_nxt_row(Cm_row6),.sel0_row(sel0[11:10]), .sel1_row(sel1[5]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n), 
                .Cm_row(Cm_row5), .c0_broad(c0_broad_row5), .R4_M(RM[5]), .C_aft_row(C[47:40]));

  PE_MM_row r6 (.alg_mode(alg_mode),.A_row(A[55:48]),.B_row(B[27:24]),.F_row(F[55:48]),.c0_u(c0_broad_row5),.C_pre_row(8'b0),
                .Cm_nxt_row(Cm_row7),.sel0_row(sel0[13:12]), .sel1_row(sel1[6]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n), 
                .Cm_row(Cm_row6), .c0_broad(c0_broad_row6), .R4_M(RM[6]), .C_aft_row(C[55:48]));

  PE_MM_row r7 (.alg_mode(alg_mode),.A_row(A[63:56]),.B_row(B[31:28]),.F_row(F[63:56]),.c0_u(c0_broad_row6),.C_pre_row(8'b0),
                .Cm_nxt_row(Cm_row8),.sel0_row(sel0[15:14]), .sel1_row(sel1[7]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n), 
                .Cm_row(Cm_row7), .c0_broad(c0_broad_row7), .R4_M(RM[7]), .C_aft_row(C[63:56]));

  PE_MM_row r8 (.alg_mode(alg_mode),.A_row(A[71:64]),.B_row(B[35:32]),.F_row(F[71:64]),.c0_u(c0_broad_row7),.C_pre_row(8'b0),
                .Cm_nxt_row(Cm_row9),.sel0_row(sel0[17:16]), .sel1_row(sel1[8]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n), 
                .Cm_row(Cm_row8), .c0_broad(c0_broad_row8), .R4_M(RM[8]), .C_aft_row(C[71:64]));

  PE_MM_row r9 (.alg_mode(alg_mode),.A_row(A[79:72]),.B_row(B[39:36]),.F_row(F[79:72]),.c0_u(c0_broad_row8),.C_pre_row(8'b0),
                .Cm_nxt_row(Cm_row10),.sel0_row(sel0[19:18]), .sel1_row(sel1[9]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n), 
                .Cm_row(Cm_row9), .c0_broad(c0_broad_row9), .R4_M(RM[9]), .C_aft_row(C[79:72]));

  PE_MM_row r10 (.alg_mode(alg_mode),.A_row(A[87:80]),.B_row(B[43:40]),.F_row(F[87:80]),.c0_u(c0_broad_row9),.C_pre_row(8'b0),
                .Cm_nxt_row(Cm_row11),.sel0_row(sel0[21:20]), .sel1_row(sel1[10]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n),  
                .Cm_row(Cm_row10), .c0_broad(c0_broad_row10), .R4_M(RM[10]), .C_aft_row(C[87:80]));

  PE_MM_row r11 (.alg_mode(alg_mode),.A_row(A[95:88]),.B_row(B[47:44]),.F_row(F[95:88]),.c0_u(c0_broad_row10),.C_pre_row(8'b0),
                .Cm_nxt_row(Cm_row12),.sel0_row(sel0[23:22]), .sel1_row(sel1[11]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n),  
                .Cm_row(Cm_row11), .c0_broad(c0_broad_row11), .R4_M(RM[11]), .C_aft_row(C[95:88]));

  PE_MM_row r12 (.alg_mode(alg_mode),.A_row(A[103:96]),.B_row(B[51:48]),.F_row(F[103:96]),.c0_u(c0_broad_row11),.C_pre_row(8'b0),
                .Cm_nxt_row(Cm_row13),.sel0_row(sel0[25:24]), .sel1_row(sel1[12]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n), 
                .Cm_row(Cm_row12), .c0_broad(c0_broad_row12), .R4_M(RM[12]), .C_aft_row(C[103:96]));

  PE_MM_row r13 (.alg_mode(alg_mode),.A_row(A[111:104]),.B_row(B[55:52]),.F_row(F[111:104]),.c0_u(c0_broad_row12),.C_pre_row(8'b0),
                .Cm_nxt_row(Cm_row14),.sel0_row(sel0[27:26]), .sel1_row(sel1[13]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n), 
                .Cm_row(Cm_row13), .c0_broad(c0_broad_row13), .R4_M(RM[13]), .C_aft_row(C[111:104]));

  PE_MM_row r14 (.alg_mode(alg_mode),.A_row(A[119:112]),.B_row(B[59:56]),.F_row(F[119:112]),.c0_u(c0_broad_row13),.C_pre_row(8'b0),
                .Cm_nxt_row(Cm_row15),.sel0_row(sel0[29:28]), .sel1_row(sel1[14]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n), 
                .Cm_row(Cm_row14), .c0_broad(c0_broad_row14), .R4_M(RM[14]), .C_aft_row(C[119:112]));

  PE_MM_row r15 (.alg_mode(alg_mode),.A_row(A[127:120]),.B_row(B[63:60]),.F_row(F[127:120]),.c0_u(c0_broad_row14),.C_pre_row(8'b0),
                 //Cm_row16 = 0
                .Cm_nxt_row(4'b0),.sel0_row(sel0[31:30]), .sel1_row(sel1[15]),.sel_op(sel_op),.clk(clk),.rst_n(rst_n), 
                .Cm_row(Cm_row15), .c0_broad(c0_broad_row15), .R4_M(RM[15]), .C_aft_row(C[127:120])); 
endmodule


/*module DFF #(parameter data_width = 8)(
    input               clk,rst_n,//low
    input      [data_width-1:0] d,
    output reg [data_width-1:0] q 
    );
    always@(posedge clk or negedge rst_n)
    begin
      if(!rst_n)
        q <= 0;
      else
        q <= d;
    end
endmodule*/