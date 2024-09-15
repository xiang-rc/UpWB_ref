module mSPECKEY_dec
(
    input   [      15:0]  state_2D_in ,
    output  [      15:0]  state_2D_out
);

    wire  [7:0]   T1 ;
    wire  [7:0]   T2 ;
    wire  [7:0]   Lo ;
    wire  [7:0]   Hi ;

    assign T1 = state_2D_in[15:8] ^ state_2D_in[7:0];
    assign Lo = {T1[1:0],T1[7:2]};
    
    assign T2 = state_2D_in[15:8] - Lo;
    
    assign Hi = {T2[0],T2[7:1]};

    assign state_2D_out = {Hi,Lo};

endmodule