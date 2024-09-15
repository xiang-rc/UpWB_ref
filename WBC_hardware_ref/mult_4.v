module mult_4
(
    input        [      7:0]  b ,
    output wire  [      7:0]  c
);

   assign c[0] = b[6];
   assign c[1] = b[6] ^ b[7];
   assign c[2] = b[0] ^ b[7];
   assign c[3] = b[1] ^ b[6];
   assign c[4] = c[1] ^ b[2];
   assign c[5] = b[3] ^ b[7];
   assign c[6] = b[4];
   assign c[7] = b[5];
   
endmodule