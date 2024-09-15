module s_box_16
(
    input                mode  ,
    input      [127:0]   RKO   ,
    output     [127:0]   SBO
);
  
    wire       [127:0]   temp_in      ;
    wire       [127:0]   temp_out     ;

    genvar i;
    generate 
    for(i=0;i<16;i=i+1)
        begin:SBOX
            assign temp_in[8*i+7:8*i] = RKO[8*i+7:8*i];

            s_box_lut u_s_box_lut(.s_i(temp_in[8*i+7:8*i]),.s_o(temp_out[8*i+7:8*i]),.mode(mode));

            assign SBO[8*i+7:8*i] = temp_out[8*i+7:8*i];
        end
    endgenerate

endmodule