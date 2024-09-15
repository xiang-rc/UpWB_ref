module mult_2_GF24(
  input [23:0] a,
  output wire [23:0] b
  );

  assign b[0] = a[23];
  assign b[1] = a[0] ^ a[23];
  assign b[2] = a[1];
  assign b[3] = a[2] ^ a[23];
  assign b[4] = a[3] ^ a[23];
  assign b[23:5] = a[22:4];
endmodule