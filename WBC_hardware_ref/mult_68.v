module mult_68
(
    input   [      7:0]  b ,
    output  [      7:0]  c
);

    wire  a0,a1,a2,a3,a4,a5,a6;
    wire  b0,b1,b2,b3,b4,b5,b6,b7;
    wire  c0,c1,c2,c3,c4,c5,c6,c7;

    assign b0 = b[0];
    assign b1 = b[1];
    assign b2 = b[2];
    assign b3 = b[3];
    assign b4 = b[4];
    assign b5 = b[5];
    assign b6 = b[6];
    assign b7 = b[7];
    
    assign c[0] = c0;
    assign c[1] = c1;
    assign c[2] = c2;
    assign c[3] = c3;
    assign c[4] = c4;
    assign c[5] = c5;
    assign c[6] = c6;
    assign c[7] = c7;
   
    assign a0 = b2 ^ b3;
    assign a1 = b2 ^ b4;
    assign a2 = b5 ^ b6;
    assign a3 = b5 ^ b7;
    assign a4 = b0 ^ b4;
    assign a5 = b0 ^ b5;
    assign a6 = b1 ^ b3;

    assign c0 = a0 ^ a2;
    assign c1 = a1 ^ a3;
    assign c2 = b3 ^ a2;
    assign c3 = a0 ^ a3 ^ a4;
    assign c4 = b1 ^ a1;
    assign c5 = a0 ^ a5;
    assign c6 = b6 ^ a4 ^ a6;
    assign c7 = b1 ^ a1 ^ a3;

endmodule