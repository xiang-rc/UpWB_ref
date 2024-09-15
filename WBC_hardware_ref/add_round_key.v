module add_round_key
# (
    parameter   N   =   128
)
(
    input     [ N-1:0]  RKI_x        ,
    input     [ N-1:0]  RKI_y        ,
    output    [ N-1:0]  RKO
); 

    assign RKO  = RKI_x ^ RKI_y;
 
endmodule