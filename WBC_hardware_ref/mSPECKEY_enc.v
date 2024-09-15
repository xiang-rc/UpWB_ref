module mSPECKEY_enc
(
    input   [      15:0]  state_2D_in ,
    output  [      15:0]  state_2D_out
);

    wire  [7:0]   Hi ;
    wire  [7:0]   Lo ;
    wire  [7:0]   Th ;
    wire  [7:0]   Tl ;

    assign Hi = {state_2D_in[14:8],state_2D_in[15]};
    assign Lo = {state_2D_in[5:0],state_2D_in[7:6]};

    assign Th = Hi + state_2D_in[7:0];
    assign Tl = Lo ^ Th;
 
    assign state_2D_out = {Th,Tl};

endmodule